CREATE OR REPLACE PACKAGE SICAS_OC.OC_SESASCOLECTIVO IS
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
    nComisionDirecta2   NUMBER;
    nMontoReclamo       NUMBER := NULL;
    vl_StatusSin        VARCHAR2(15);
    vl_Total1           NUMBER;
    vl_Contado          NUMBER := 1;
    vl_Total2           NUMBER;
END OC_SESASCOLECTIVO;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SESASCOLECTIVO IS

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
      --
        nCodCia2          SICAS_OC.SESAS_DATGEN.CODCIA%TYPE;
        nCodEmpresa2      SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE;
        nIdPoliza         SICAS_OC.SESAS_DATGEN.IDPOLIZA%TYPE;
        nIDetPol          SICAS_OC.SESAS_DATGEN.IDETPOL%TYPE;
        nComisionDirecta  SICAS_OC.SESAS_DATGEN.COMISIONDIRECTA%TYPE;
        nCantCertificados SICAS_OC.SESAS_DATGEN.CANTCERTIFICADOS%TYPE;
        cFormaVta         SICAS_OC.SESAS_DATGEN.FORMAVTA%TYPE;

        CURSOR c_Llenado IS
        SELECT CODCIA,CODEMPRESA,CODREPORTE,CODUSUARIO,NUMPOLIZA,IDPOLIZA,COUNT(1) TOTAL
        FROM SICAS_OC.SESAS_DATGEN
        WHERE CODCIA = nCodCia
            AND CODEMPRESA = nCodEmpresa
            AND CODREPORTE = cCodReporteProces
            AND CODUSUARIO = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0'
        GROUP BY CODCIA,CODEMPRESA,CODREPORTE,CODUSUARIO,NUMPOLIZA,IDPOLIZA;

    TYPE rec_sesaslleno IS RECORD (
        CODCIA          NUMBER,
        CODEMPRESA      NUMBER,
        CODREPORTE      VARCHAR2(40),
        CODUSUARIO      VARCHAR2(40),
        NUMPOLIZA       VARCHAR2(30),
        IDPOLIZA        NUMBER,
        TOTAL           NUMBER);

        TYPE type_sesaslleno IS TABLE OF rec_sesaslleno  INDEX BY PLS_INTEGER ;
        
        obj_sesaslleno   type_sesaslleno;

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
            D.FecIniVig                                                                                                           FecAltCert
		   --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta) 										FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, XX.FecAnulExclu,dFecDesde, dFecHasta,'VIG')            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(XX.Cod_Asegurado,D.Cod_Asegurado) )  			StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, XX.FecAnulExclu, dFecHasta,
                                                    XX.ESTADO, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1','3')                                                                                                           FormaPago,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, 'VII')                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, D.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTORESCATE(D.CodCia, D.IdPoliza)                                                        MontoRescate,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            'IND'                                                                                                                 TipoDetalle,
            NVL(D.CantAsegModelo, 0)                                                                                              CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            0                                                                                                                     IdEndoso
        FROM SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA           D ON D.IDPOLIZA = P.IDPOLIZA 
                    AND D.CodCia = P.CodCia
                                                    AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX 
                ON XX.CodCia = D.CodCia
                AND XX.IdPoliza = D.IdPoliza
                AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A 
                ON A.Cod_Asegurado = XX.Cod_Asegurado
            INNER JOIN SICAS_OC.AGENTES                  AA ON AA.COD_AGENTE = P.COD_AGENTE
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob

		/*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg
			AND CAS.PLANCOB 			    = PC.PLANCOB*/
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        WHERE
                P.CodEmpresa = nCodEmpresa
            AND P.CodCia = nCodCia
                AND (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)


            AND ( PC.CodTipoPlan IN ( '012', '013' )
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
                            SICAS_OC.COBERTURA_ASEG X
                        WHERE
                                X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQC' ) )
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
            AND ( ( D.IndAsegModelo = 'S'
                    AND NOT EXISTS (
                SELECT
                    'N'
                FROM
                    SICAS_OC.ENDOSOS
                WHERE
                        IdPoliza = D.IdPoliza
                    AND CodEmpresa = D.CodEmpresa
                    AND CodCia = D.CodCia
                    AND IDetPol = D.IDetPol
                    AND TipoEndoso = 'ESV'
                    AND MotivAnul = 'CONSAS'
            ) )
                  OR ( D.IndAsegModelo = 'N' ) )
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
        CURSOR C_POL_COL_Q IS
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
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, P.IdPoliza)                                                    TipoSeguro,
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
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta) 										FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, XX.FecAnulExclu, dFecDesde, dFecHasta,'VIG')            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  P.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(XX.Cod_Asegurado,D.Cod_Asegurado) )  			StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, XX.FecAnulExclu, dFecHasta,
                                                    XX.ESTADO, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob)*/ PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1',  '3')  FormaPago,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, 'VII')                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, D.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTORESCATE(D.CodCia, D.IdPoliza)                                                        MontoRescate,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            'COL'                                                                                                                 TipoDetalle,
            NVL(D.CantAsegModelo, 0)                                                                                              CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            0                                                                                                                     IdEndoso
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA           D ON D.IDPOLIZA = P.IDPOLIZA
            AND D.CodCia = P.CodCia
                                                    AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.CodCia = D.CodCia
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.PlanCob = D.PlanCob
   /* INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg
			AND CAS.PLANCOB 			= PC.PLANCOB*/
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                            AND XX.IdPoliza = D.IdPoliza
                                                            AND XX.IDetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = XX.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
        WHERE
           /* ( ( D.FecFinVig BETWEEN dvarFecDesde AND dvarFecHasta  )
              OR ( D.FecIniVig BETWEEN dvarFecDesde AND dvarFecHasta
                   AND P.FecEmision <= dvarFecHasta)
            )*/
        /*AND (PC.CodTipoPlan  = '012'

            OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '010'  AND PC.IdTipoSeg  IN ('PPAQC')))*/

             (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)
            AND ( PC.CodTipoPlan IN ( '012', '013' )
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
                            SICAS_OC.COBERTURA_ASEG X
                        WHERE
                                X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQC' ) )
            AND P.CodEmpresa = nCodEmpresa
            AND P.CodCia = nCodCia
            AND P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
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
        CURSOR C_POL_IND_MOV_Q IS
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
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta) 										FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, XX.FecAnulExclu, dFecDesde, dFecHasta,'VIG')            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  P.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(XX.Cod_Asegurado,D.Cod_Asegurado) )  			StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, XX.FecAnulExclu, dFecHasta,
                                                    XX.ESTADO, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob)*/ PlanPoliza,
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
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, 'VII')                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, D.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTORESCATE(D.CodCia, D.IdPoliza)                                                        MontoRescate,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            'IND'                                                                                                                 TipoDetalle,
            NVL(D.CantAsegModelo, 0)                                                                                              CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            0                                                                                                                     IdEndoso
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA           D ON D.IDPOLIZA = P.IDPOLIZA
                    AND D.CodCia = P.CodCia
                                                    AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.CodCia = D.CodCia
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.PlanCob = D.PlanCob

      /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg
			AND CAS.PLANCOB 			= PC.PLANCOB*/
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                            AND XX.IdPoliza = D.IdPoliza
                                                            AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = XX.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        WHERE /*(PC.CodTipoPlan ='012'

            OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '010'  AND PC.IdTipoSeg  IN ('PPAQC')))*/

            ( PC.CodTipoPlan IN ( '012', '013' )
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
                            SICAS_OC.COBERTURA_ASEG X
                        WHERE
                                X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                   AND PC.CodTipoPlan = '099'
                   AND PC.IdTipoSeg = 'PPAQC' ) )
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(D.CodCia, D.IdPoliza, D.IDetPol, 0) = 'N'
            AND EXISTS (
                SELECT
                    'S'
                FROM
                         SICAS_OC.TRANSACCION T
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT ON DT.IdTransaccion = T.IdTransaccion
                                                                  AND DT.CodCia = T.CodCia
                WHERE
                        DT.Valor1 = D.IdPoliza
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'ESVTL', 'PAG', 'EMIPRD', 'PAGPRD',
                                                  'APLPRD', 'ANUPRD', 'REVPPD' )
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso != 6
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND P.CodEmpresa = nCodEmpresa
            AND P.CodCia = nCodCia
            AND P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
            AND D.IDetPol > 0
            AND D.FecFinVig < dvarFecDesde
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
        CURSOR C_POL_COL_MOV_Q IS
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(AC.IdPoliza, 8, '0'))
                || TRIM(LPAD(AC.IDetPol, 2, '0'))
                || TRIM(LPAD(AC.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
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
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta) 										FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, AC.FecAnulExclu, dFecDesde, dFecHasta,'VIG')            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(AC.Cod_Asegurado,D.Cod_Asegurado) )  			StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, AC.FecAnulExclu, dFecHasta,
                                                    AC.ESTADO, D.FecIniVig, D.FecFinVig, NVL(AC.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob)*/                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1', '3') FormaPago,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, 'VII')                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, D.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTORESCATE(D.CodCia, D.IdPoliza)                                                        MontoRescate,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(AC.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            'COL'                                                                                                                 TipoDetalle,
            NVL(D.CantAsegModelo, 0)                                                                                              CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            AC.IdEndoso                                                                                                           IdEndoso
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA                  D ON D.IDPOLIZA = P.IDPOLIZA
                    AND D.CodCia = P.CodCia
                     AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    AC ON AC.CodCia = D.CodCia
                                                            AND AC.IDetPol = D.IDetPol
                                                            AND AC.IdPoliza = D.IdPoliza
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = AC.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
                                                               AND PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
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
        WHERE
            P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
       /*AND (PC.CodTipoPlan  ='012'

            OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '010'  AND PC.IdTipoSeg  IN ('PPAQC')))*/
            AND ( PC.CodTipoPlan IN ( '012', '013' )
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
                            SICAS_OC.COBERTURA_ASEG X
                        WHERE
                                X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQC' ) )
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.FecFinVig < dvarFecDesde
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND EXISTS (
                SELECT
                    'S'
                FROM
                         SICAS_OC.TRANSACCION T
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT ON DT.CodCia = T.CodCia
                                                                  AND DT.IdTransaccion = T.IdTransaccion
                WHERE
                        DT.Valor1 = D.IdPoliza
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'ESVTL', 'PAG', 'EMIPRD', 'PAGPRD',
                                                  'APLPRD', 'ANUPRD', 'REVPPD' )
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso != 6
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
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
            ) ) )
        MINUS
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(AC.IdPoliza, 8, '0'))
                || TRIM(LPAD(AC.IDetPol, 2, '0'))
                || TRIM(LPAD(AC.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
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
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta) 										FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, AC.FecAnulExclu, dFecDesde, dFecHasta,'VIG')            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(AC.Cod_Asegurado,D.Cod_Asegurado) )  			StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, AC.FecAnulExclu, dFecHasta,
                                                    AC.ESTADO, D.FecIniVig, D.FecFinVig, NVL(AC.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob)*/                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1', '3')                                                                                                           FormaPago,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, 'VII')                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, D.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTORESCATE(D.CodCia, D.IdPoliza)                                                        MontoRescate,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(AC.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            'COL'                                                                                                                 TipoDetalle,
            NVL(D.CantAsegModelo, 0)                                                                                              CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            AC.IdEndoso                                                                                                           IdEndoso
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.IdPoliza = P.IdPoliza
                                             AND D.CodCia = P.CodCia
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    AC ON AC.CodCia = D.CodCia
                                                            AND AC.IdPoliza = D.IdPoliza
                                                            AND AC.IDetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = AC.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
                                                               AND PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
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
			AND CAS.PLANCOB 			    = PC.PLANCOB*/
        WHERE
            P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
        /*AND (PC.CodTipoPlan  ='012'
                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '010'  AND PC.IdTipoSeg  IN ('PPAQC')))*/

            AND ( PC.CodTipoPlan IN ( '012', '013' )
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
                            SICAS_OC.COBERTURA_ASEG X
                        WHERE
                                X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQC' ) )
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)
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

        TYPE rec_sesasdatgen IS RECORD (
            CODCIA           NUMBER,
            CODEMPRESA       NUMBER,
            CODREPORTE       VARCHAR2(30),
            CODUSUARIO       VARCHAR2(30),
            NUMPOLIZA        VARCHAR2(40),
            NUMCERTIFICADO   VARCHAR2(30),
            TIPOSEGURO       VARCHAR2(10),
            MONEDA           VARCHAR2(10),
            ENTIDADASEGURADO VARCHAR2(10),
            FECINIVIG        DATE,
            FECFINVIG        DATE,
            FECALTCERT       DATE,
            FECBAJCERT       DATE,
            FECNACIM         DATE,
            FECEMISION       DATE,
            SEXO             VARCHAR2(10),
            STATUSCERT       VARCHAR2(10),
        --FORMAVTA	VARCHAR2(2 ),
            TIPODIVIDENDO    VARCHAR2(10),
            PLANPOLIZA       VARCHAR2(10),
            MODALIDADPOLIZA  VARCHAR2(10),
            FORMAPAGO        VARCHAR2(10),
            PLAZOPAGOPRIMA   NUMBER,
            COASEGURO        VARCHAR2(10),
            EMISION          VARCHAR2(10),
            PRIMACEDIDA      NUMBER,
            SDOFONINV        NUMBER,
            SDOFONADM        NUMBER,
            MONTODIVIDENDO   NUMBER,
            MONTORESCATE     NUMBER,
            IDPOLIZA         NUMBER,
            IDETPOL          NUMBER,
            Cod_Asegurado    NUMBER,
            TIPODETALLE      VARCHAR2(10),
            CantAsegModelo   NUMBER,
            PolConcentrada   VARCHAR2(200),
            IndAsegModelo    VARCHAR2(10),
            IdEndoso         NUMBER
        );
        TYPE type_sesasdatgen IS TABLE OF rec_sesasdatgen;
        obj_sesasdatgen   type_sesasdatgen;
    BEGIN

EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.LOGERRORES_SESAS');
/*
        DELETE SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'--(SELECT MIN(NUMPOLIZA) FROM SESAS_DATGEN)
            AND NUMCERTIFICADO >= '0'--(SELECT MIN(NUMCERTIFICADO) FROM SESAS_DATGEN);
;
        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuariO
            AND IDSECUENCIA>=0;
*/
        
        
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');

      --Inicializo variables de Afinación
        nCodCia2 := 0;
        nCodEmpresa2 := 0;
        nIdPoliza := 0;
        nIDetPol := 0;
        nComisionDirecta := 0;
        nCantCertificados := 0;
        cFormaVta := NULL;
      --

        OPEN C_POL_IND_Q;
        LOOP
            FETCH C_POL_IND_Q
            BULK COLLECT INTO obj_sesasdatgen;

     --FORALL x IN 1 .. obj_sesasdatgen.COUNT SAVE EXCEPTIONS

            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
                IF nCodCia2 <> obj_sesasdatgen(x).CodCia OR nCodEmpresa2 <> obj_sesasdatgen(x).CodEmpresa OR nIdPoliza <> obj_sesasdatgen(x).IdPoliza OR nIDetPol <> obj_sesasdatgen(x).IDetPol THEN
                    nCodCia2 := obj_sesasdatgen(x).CodCia;
                    nCodEmpresa2 := obj_sesasdatgen(x).CodEmpresa;
                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).IdPoliza, dFecDesde, dFecHasta);

                    nCantCertificados := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).IdPoliza, obj_sesasdatgen(x).IDetPol, obj_sesasdatgen(x).IndAsegModelo, obj_sesasdatgen(x).CantAsegModelo, obj_sesasdatgen( x).PolConcentrada, obj_sesasdatgen(x).IdEndoso);

                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).IdPoliza);

                END IF;


              --Inserto lo que antes era el cursor: POL_IND_Q
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
                        TipoDividendo,
                        PlanPoliza,
                        ModalidadPoliza,
                        FormaPago,
                        PlazoPagoPrima,
                        Coaseguro,
                        Emision,
                        NUMASEGPOL,
                        PrimaCedida,
                        ComisionDirecta,
                        SdoFonInv,
                        SdoFonAdm,
                        MontoDividendo,
                        MontoRescate,
                        IdPoliza,
                        IDetPol,
                        CodAsegurado,
                        TipoDetalle
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        NVL(obj_sesasdatgen(x).EntidadAsegurado,'09'),
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        cFormaVta,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).FormaPago,
                        (
                            CASE obj_sesasdatgen(x).FormaPago
                                WHEN '1' THEN
                                    1
                                ELSE
                                    obj_sesasdatgen(x).PlazoPagoPrima
                            END
                        ),
                        obj_sesasdatgen(x).Coaseguro,
                        obj_sesasdatgen(x).Emision,
                        nCantCertificados,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta, 2),
                        obj_sesasdatgen(x).SdoFonInv,
                        obj_sesasdatgen(x).SdoFonAdm,
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).MontoRescate,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).Cod_Asegurado,
                        obj_sesasdatgen(x).TipoDetalle
                    );


                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_IND_Q;
        

    /*
      FOR x IN C_POL_IND_Q LOOP
          --Afinación
          IF nCodCia2 <> x.CodCia OR nCodEmpresa2 <> x.CodEmpresa OR nIdPoliza <> x.IdPoliza OR nIDetPol <> x.IDetPol THEN
             nCodCia2           := x.CodCia;
             nCodEmpresa2       := x.CodEmpresa;
             nIdPoliza          := x.IdPoliza;
             nIDetPol           := x.IDetPol;
             nComisionDirecta   := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP( x.CodCia, x.CodEmpresa, x.IdPoliza, dFecDesde, dFecHasta );
             nCantCertificados  := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS( x.CodCia, x.CodEmpresa, x.IdPoliza, x.IDetPol, x.IndAsegModelo, x.CantAsegModelo, x.PolConcentrada, x.IdEndoso );
             cFormaVta          := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA( x.CodCia, x.IdPoliza );
          END IF;

          BEGIN
              --
              --Inserto lo que antes era el cursor: POL_IND_Q
              INSERT INTO SICAS_OC.SESAS_DATGEN
                 ( CodCia         , CodEmpresa, CodReporte     , CodUsuario    , NumPoliza     , NumCertificado, TipoSeguro, Moneda          , EntidadAsegurado,
                   FecIniVig      , FecFinVig , FecAltCert     , FecBajCert    , FecNacim      , FecEmision    , Sexo      , StatusCert      , FormaVta        ,
                   TipoDividendo  , PlanPoliza, ModalidadPoliza, FormaPago     , PlazoPagoPrima, Coaseguro     , Emision   , CantCertificados, PrimaCedida     ,
                   ComisionDirecta, SdoFonInv , SdoFonAdm      , MontoDividendo, MontoRescate  , IdPoliza      , IDetPol   , CodAsegurado    , TipoDetalle )
              VALUES ( x.CodCia        , x.CodEmpresa, x.CodReporte     , x.CodUsuario    , x.NumPoliza     , x.NumCertificado, x.TipoSeguro, x.Moneda         , x.EntidadAsegurado,
                       x.FecIniVig     , x.FecFinVig , x.FecAltCert     , x.FecBajCert    , x.FecNacim      , x.FecEmision    , x.Sexo      , x.StatusCert     , cFormaVta         ,
                       x.TipoDividendo , x.PlanPoliza, x.ModalidadPoliza, x.FormaPago     , x.PlazoPagoPrima, x.Coaseguro     , x.Emision   , nCantCertificados, x.PrimaCedida     ,
                       nComisionDirecta, x.SdoFonInv , x.SdoFonAdm      , x.MontoDividendo, x.MontoRescate  , x.IdPoliza      , x.IDetPol   , x.Cod_Asegurado  , x.TipoDetalle );
            
        EXCEPTION
            WHEN OTHERS THEN
                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(x.CodCia,x.CodEmpresa,x.CodUsuario,x.CodReporte, x.NumPoliza,x.NumCertificado,SQLCODE,SQLERRM);
        END;
      END LOOP;*/
      --

      --Inicializo variables de Afinación
        nCodCia2 := 0;
        nCodEmpresa2 := 0;
        nIdPoliza := 0;
        nIDetPol := 0;
        nComisionDirecta := 0;
        nCantCertificados := 0;
        cFormaVta := NULL;
      --

        OPEN C_POL_COL_Q;
        LOOP
            FETCH C_POL_COL_Q
            BULK COLLECT INTO obj_sesasdatgen;
        --FORALL x IN 1 .. obj_sesasdatgen.COUNT SAVE EXCEPTIONS

            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
                IF nCodCia2 <> obj_sesasdatgen(x).CodCia OR nCodEmpresa2 <> obj_sesasdatgen(x).CodEmpresa OR nIdPoliza <> obj_sesasdatgen(x).IdPoliza OR nIDetPol <> obj_sesasdatgen(x).IDetPol THEN
                    nCodCia2 := obj_sesasdatgen(x).CodCia;
                    nCodEmpresa2 := obj_sesasdatgen(x).CodEmpresa;
                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).IdPoliza, dFecDesde, dFecHasta);

                    nCantCertificados := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).IdPoliza, obj_sesasdatgen(x).IDetPol, obj_sesasdatgen(x).IndAsegModelo,
                                                                                      obj_sesasdatgen(x).CantAsegModelo, obj_sesasdatgen(
                                                                                      x).PolConcentrada, obj_sesasdatgen(x).IdEndoso);

                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).IdPoliza);

                END IF;


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
                        TipoDividendo,
                        PlanPoliza,
                        ModalidadPoliza,
                        FormaPago,
                        PlazoPagoPrima,
                        Coaseguro,
                        Emision,
                        NUMASEGPOL,
                        PrimaCedida,
                        ComisionDirecta,
                        SdoFonInv,
                        SdoFonAdm,
                        MontoDividendo,
                        MontoRescate,
                        IdPoliza,
                        IDetPol,
                        CodAsegurado,
                        TipoDetalle
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        NVL(obj_sesasdatgen(x).EntidadAsegurado,'09'),
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        cFormaVta,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).FormaPago,
                        (
                            CASE obj_sesasdatgen(x).FormaPago
                                WHEN '1' THEN
                                    1
                                ELSE
                                    obj_sesasdatgen(x).PlazoPagoPrima
                            END
                        ),
                        obj_sesasdatgen(x).Coaseguro,
                        obj_sesasdatgen(x).Emision,
                        nCantCertificados,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta, 2),
                        obj_sesasdatgen(x).SdoFonInv,
                        obj_sesasdatgen(x).SdoFonAdm,
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).MontoRescate,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).Cod_Asegurado,
                        obj_sesasdatgen(x).TipoDetalle
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_COL_Q;
        

    /*
      FOR x IN C_POL_COL_Q LOOP
          --Afinación
          IF nCodCia2 <> x.CodCia OR nCodEmpresa2 <> x.CodEmpresa OR nIdPoliza <> x.IdPoliza OR nIDetPol <> x.IDetPol THEN
             nCodCia2           := x.CodCia;
             nCodEmpresa2       := x.CodEmpresa;
             nIdPoliza          := x.IdPoliza;
             nIDetPol           := x.IDetPol;
             nComisionDirecta   := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP( x.CodCia, x.CodEmpresa, x.IdPoliza, dFecDesde, dFecHasta );
             nCantCertificados  := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS( x.CodCia, x.CodEmpresa, x.IdPoliza, x.IDetPol, x.IndAsegModelo, x.CantAsegModelo, x.PolConcentrada, x.IdEndoso );
             cFormaVta          := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA( x.CodCia, x.IdPoliza );
          END IF;
          --
          BEGIN
              --Inserto lo que antes era el cursor: POL_COL_Q
              INSERT INTO SICAS_OC.SESAS_DATGEN
                 ( CodCia         , CodEmpresa, CodReporte     , CodUsuario    , NumPoliza     , NumCertificado, TipoSeguro, Moneda          , EntidadAsegurado,
                   FecIniVig      , FecFinVig , FecAltCert     , FecBajCert    , FecNacim      , FecEmision    , Sexo      , StatusCert      , FormaVta        ,
                   TipoDividendo  , PlanPoliza, ModalidadPoliza, FormaPago     , PlazoPagoPrima, Coaseguro     , Emision   , CantCertificados, PrimaCedida     ,
                   ComisionDirecta, SdoFonInv , SdoFonAdm      , MontoDividendo, MontoRescate  , IdPoliza      , IDetPol   , CodAsegurado    , TipoDetalle )
              VALUES ( x.CodCia        , x.CodEmpresa, x.CodReporte     , x.CodUsuario    , x.NumPoliza     , x.NumCertificado, x.TipoSeguro, x.Moneda         , x.EntidadAsegurado,
                       x.FecIniVig     , x.FecFinVig , x.FecAltCert     , x.FecBajCert    , x.FecNacim      , x.FecEmision    , x.Sexo      , x.StatusCert     , cFormaVta         ,
                       x.TipoDividendo , x.PlanPoliza, x.ModalidadPoliza, x.FormaPago     , x.PlazoPagoPrima, x.Coaseguro     , x.Emision   , nCantCertificados, x.PrimaCedida     ,
                       nComisionDirecta, x.SdoFonInv , x.SdoFonAdm      , x.MontoDividendo, x.MontoRescate  , x.IdPoliza      , x.IDetPol   , x.Cod_Asegurado  , x.TipoDetalle );

        EXCEPTION
            WHEN OTHERS THEN
                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(x.CodCia,x.CodEmpresa,x.CodUsuario,x.CodReporte, x.NumPoliza,x.NumCertificado,SQLCODE,SQLERRM);
        END;
      END LOOP;
      --
      */
      --Inicializo variables de Afinación
        nCodCia2 := 0;
        nCodEmpresa2 := 0;
        nIdPoliza := 0;
        nIDetPol := 0;
        nComisionDirecta := 0;
        nCantCertificados := 0;
        cFormaVta := NULL;
        OPEN C_POL_IND_MOV_Q;
        LOOP
            FETCH C_POL_IND_MOV_Q
            BULK COLLECT INTO obj_sesasdatgen;
        --FORALL x IN 1 .. obj_sesasdatgen.COUNT SAVE EXCEPTIONS

            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
                IF nCodCia2 <> obj_sesasdatgen(x).CodCia OR nCodEmpresa2 <> obj_sesasdatgen(x).CodEmpresa OR nIdPoliza <> obj_sesasdatgen(x).IdPoliza OR nIDetPol <> obj_sesasdatgen(x).IDetPol THEN
                    nCodCia2 := obj_sesasdatgen(x).CodCia;
                    nCodEmpresa2 := obj_sesasdatgen(x).CodEmpresa;
                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).IdPoliza, dFecDesde, dFecHasta);

                    nCantCertificados := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).IdPoliza, obj_sesasdatgen(x).IDetPol, obj_sesasdatgen(x).IndAsegModelo,
                                                                                      obj_sesasdatgen(x).CantAsegModelo, obj_sesasdatgen(x).PolConcentrada, obj_sesasdatgen(x).IdEndoso);

                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).IdPoliza);

                END IF;


              --Inserto lo que antes era el cursor: POL_IND_MOV_Q
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
                        TipoDividendo,
                        PlanPoliza,
                        ModalidadPoliza,
                        FormaPago,
                        PlazoPagoPrima,
                        Coaseguro,
                        Emision,
                        NUMASEGPOL,
                        PrimaCedida,
                        ComisionDirecta,
                        SdoFonInv,
                        SdoFonAdm,
                        MontoDividendo,
                        MontoRescate,
                        IdPoliza,
                        IDetPol,
                        CodAsegurado,
                        TipoDetalle
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        NVL(obj_sesasdatgen(x).EntidadAsegurado,'09'),
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        cFormaVta,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).FormaPago,
                        (
                            CASE obj_sesasdatgen(x).FormaPago
                                WHEN '1' THEN
                                    1
                                ELSE
                                    obj_sesasdatgen(x).PlazoPagoPrima
                            END
                        ),
                        obj_sesasdatgen(x).Coaseguro,
                        obj_sesasdatgen(x).Emision,
                        nCantCertificados,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta,2),
                        obj_sesasdatgen(x).SdoFonInv,
                        obj_sesasdatgen(x).SdoFonAdm,
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).MontoRescate,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).Cod_Asegurado,
                        obj_sesasdatgen(x).TipoDetalle
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_IND_MOV_Q;
        
        /*
      FOR x IN C_POL_IND_MOV_Q LOOP
          --Afinación
          IF nCodCia2 <> x.CodCia OR nCodEmpresa2 <> x.CodEmpresa OR nIdPoliza <> x.IdPoliza OR nIDetPol <> x.IDetPol THEN
             nCodCia2           := x.CodCia;
             nCodEmpresa2       := x.CodEmpresa;
             nIdPoliza          := x.IdPoliza;
             nIDetPol           := x.IDetPol;
             nComisionDirecta   := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP( x.CodCia, x.CodEmpresa, x.IdPoliza, dFecDesde, dFecHasta );
             nCantCertificados  := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS( x.CodCia, x.CodEmpresa, x.IdPoliza, x.IDetPol, x.IndAsegModelo, x.CantAsegModelo, x.PolConcentrada, x.IdEndoso );
             cFormaVta          := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA( x.CodCia, x.IdPoliza );
          END IF;
          --
          BEGIN
              --Inserto lo que antes era el cursor: POL_IND_MOV_Q
              INSERT INTO SICAS_OC.SESAS_DATGEN
                 ( CodCia         , CodEmpresa, CodReporte     , CodUsuario    , NumPoliza     , NumCertificado, TipoSeguro, Moneda          , EntidadAsegurado,
                   FecIniVig      , FecFinVig , FecAltCert     , FecBajCert    , FecNacim      , FecEmision    , Sexo      , StatusCert      , FormaVta        ,
                   TipoDividendo  , PlanPoliza, ModalidadPoliza, FormaPago     , PlazoPagoPrima, Coaseguro     , Emision   , CantCertificados, PrimaCedida     ,
                   ComisionDirecta, SdoFonInv , SdoFonAdm      , MontoDividendo, MontoRescate  , IdPoliza      , IDetPol   , CodAsegurado    , TipoDetalle )
              VALUES ( x.CodCia        , x.CodEmpresa, x.CodReporte     , x.CodUsuario    , x.NumPoliza     , x.NumCertificado, x.TipoSeguro, x.Moneda         , x.EntidadAsegurado,
                       x.FecIniVig     , x.FecFinVig , x.FecAltCert     , x.FecBajCert    , x.FecNacim      , x.FecEmision    , x.Sexo      , x.StatusCert     , cFormaVta         ,
                       x.TipoDividendo , x.PlanPoliza, x.ModalidadPoliza, x.FormaPago     , x.PlazoPagoPrima, x.Coaseguro     , x.Emision   , nCantCertificados, x.PrimaCedida     ,
                       nComisionDirecta, x.SdoFonInv , x.SdoFonAdm      , x.MontoDividendo, x.MontoRescate  , x.IdPoliza      , x.IDetPol   , x.Cod_Asegurado  , x.TipoDetalle );
                
        EXCEPTION
            WHEN OTHERS THEN
                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(x.CodCia,x.CodEmpresa,x.CodUsuario,x.CodReporte, x.NumPoliza,x.NumCertificado,SQLCODE,SQLERRM);
        END;
      END LOOP;
      */


      --
      --Inicializo variables de Afinación
        nCodCia2 := 0;
        nCodEmpresa2 := 0;
        nIdPoliza := 0;
        nIDetPol := 0;
        nComisionDirecta := 0;
        nCantCertificados := 0;
        cFormaVta := NULL;
      --

        OPEN C_POL_COL_MOV_Q;
        LOOP
            FETCH C_POL_COL_MOV_Q
            BULK COLLECT INTO obj_sesasdatgen;

        --FORALL x IN 1 .. obj_sesasdatgen.COUNT SAVE EXCEPTIONS
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
                IF nCodCia2 <> obj_sesasdatgen(x).CodCia OR nCodEmpresa2 <> obj_sesasdatgen(x).CodEmpresa OR nIdPoliza <> obj_sesasdatgen(x).IdPoliza OR nIDetPol <> obj_sesasdatgen(x).IDetPol THEN
                    nCodCia2 := obj_sesasdatgen(x).CodCia;
                    nCodEmpresa2 := obj_sesasdatgen(x).CodEmpresa;
                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).IdPoliza, dFecDesde, dFecHasta);

                    nCantCertificados := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).IdPoliza, obj_sesasdatgen(x).IDetPol, obj_sesasdatgen(x).IndAsegModelo,obj_sesasdatgen(x).CantAsegModelo, obj_sesasdatgen(x).PolConcentrada, obj_sesasdatgen(x).IdEndoso);

                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).IdPoliza);

                END IF;

          --Inserto lo que antes era el cursor: POL_COL_MOV_Q
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
                        TipoDividendo,
                        PlanPoliza,
                        ModalidadPoliza,
                        FormaPago,
                        PlazoPagoPrima,
                        Coaseguro,
                        Emision,
                        NUMASEGPOL,
                        PrimaCedida,
                        ComisionDirecta,
                        SdoFonInv,
                        SdoFonAdm,
                        MontoDividendo,
                        MontoRescate,
                        IdPoliza,
                        IDetPol,
                        CodAsegurado,
                        TipoDetalle
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        NVL(obj_sesasdatgen(x).EntidadAsegurado,'09'),
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        cFormaVta,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).FormaPago,
                        (
                            CASE obj_sesasdatgen(x).FormaPago
                                WHEN '1' THEN
                                    1
                                ELSE
                                    obj_sesasdatgen(x).PlazoPagoPrima
                            END
                        ),
                        obj_sesasdatgen(x).Coaseguro,
                        obj_sesasdatgen(x).Emision,
                        nCantCertificados,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta,2),
                        obj_sesasdatgen(x).SdoFonInv,
                        obj_sesasdatgen(x).SdoFonAdm,
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).MontoRescate,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).Cod_Asegurado,
                        obj_sesasdatgen(x).TipoDetalle
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_COL_MOV_Q;
        

         /*
      FOR x IN C_POL_COL_MOV_Q LOOP
          --Afinación
          IF nCodCia2 <> x.CodCia OR nCodEmpresa2 <> x.CodEmpresa OR nIdPoliza <> x.IdPoliza OR nIDetPol <> x.IDetPol THEN
             nCodCia2           := x.CodCia;
             nCodEmpresa2       := x.CodEmpresa;
             nIdPoliza          := x.IdPoliza;
             nIDetPol           := x.IDetPol;
             nComisionDirecta   := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP( x.CodCia, x.CodEmpresa, x.IdPoliza, dFecDesde, dFecHasta );
             nCantCertificados  := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS( x.CodCia, x.CodEmpresa, x.IdPoliza, x.IDetPol, x.IndAsegModelo, x.CantAsegModelo, x.PolConcentrada, x.IdEndoso );
             cFormaVta          := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA( x.CodCia, x.IdPoliza );
          END IF;
          --
          BEGIN
          --Inserto lo que antes era el cursor: POL_COL_MOV_Q
              INSERT INTO SICAS_OC.SESAS_DATGEN
                 ( CodCia         , CodEmpresa, CodReporte     , CodUsuario    , NumPoliza     , NumCertificado, TipoSeguro, Moneda          , EntidadAsegurado,
                   FecIniVig      , FecFinVig , FecAltCert     , FecBajCert    , FecNacim      , FecEmision    , Sexo      , StatusCert      , FormaVta        ,
                   TipoDividendo  , PlanPoliza, ModalidadPoliza, FormaPago     , PlazoPagoPrima, Coaseguro     , Emision   , CantCertificados, PrimaCedida     ,
                   ComisionDirecta, SdoFonInv , SdoFonAdm      , MontoDividendo, MontoRescate  , IdPoliza      , IDetPol   , CodAsegurado    , TipoDetalle )
              VALUES ( x.CodCia        , x.CodEmpresa, x.CodReporte     , x.CodUsuario    , x.NumPoliza     , x.NumCertificado, x.TipoSeguro, x.Moneda         , x.EntidadAsegurado,
                       x.FecIniVig     , x.FecFinVig , x.FecAltCert     , x.FecBajCert    , x.FecNacim      , x.FecEmision    , x.Sexo      , x.StatusCert     , cFormaVta         ,
                       x.TipoDividendo , x.PlanPoliza, x.ModalidadPoliza, x.FormaPago     , x.PlazoPagoPrima, x.Coaseguro     , x.Emision   , nCantCertificados, x.PrimaCedida     ,
                       nComisionDirecta, x.SdoFonInv , x.SdoFonAdm      , x.MontoDividendo, x.MontoRescate  , x.IdPoliza      , x.IDetPol   , x.Cod_Asegurado  , x.TipoDetalle );

            
            EXCEPTION
                WHEN OTHERS THEN
                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(x.CodCia,x.CodEmpresa,x.CodUsuario,x.CodReporte,x.NumPoliza,x.NumCertificado,SQLCODE,SQLERRM); 
            END;
      END LOOP;
      --
      */
BEGIN
     OPEN c_Llenado;
        LOOP
            FETCH c_Llenado
            BULK COLLECT INTO obj_sesaslleno;
            FORALL x IN 1..obj_sesaslleno.COUNT --LOOP

                UPDATE SICAS_OC.SESAS_DATGEN
                SET COMISIONDIRECTA = ROUND( COMISIONDIRECTA / obj_sesaslleno(x).TOTAL,2),
                    FECHAINSERT = SYSDATE
                WHERE CODCIA = obj_sesaslleno(x).CodCia
                    AND CODEMPRESA = obj_sesaslleno(x).CodEmpresa
                    AND CODREPORTE = obj_sesaslleno(x).CodReporte
                    AND CODUSUARIO = obj_sesaslleno(x).CodUsuario
                    AND NUMPOLIZA = obj_sesaslleno(x).NUMPOLIZA
                    AND IDPOLIZA = obj_sesaslleno(x).IDPOLIZA;

            --END LOOP;

            EXIT WHEN obj_sesaslleno.COUNT = 0;
        END LOOP;

        CLOSE c_Llenado;
    EXCEPTION
        WHEN OTHERS THEN
            COMMIT;
    END;

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
      --
        nIdPoliza          SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE;
        nIDetPol           SICAS_OC.DETALLE_POLIZA.IDETPOL%TYPE;
        nCod_Asegurado     SICAS_OC.DETALLE_POLIZA.COD_ASEGURADO%TYPE;
        dFecIniVig         SICAS_OC.DETALLE_POLIZA.FECINIVIG%TYPE;
        dFecFinVig         SICAS_OC.DETALLE_POLIZA.FECFINVIG%TYPE;
        nIdPolizaProc      SICAS_OC.POLIZAS.IdPoliza%TYPE;
        nIDetPolProc       SICAS_OC.DETALLE_POLIZA.IDetPol%TYPE;
        nIdPolizaProcCalc  SICAS_OC.POLIZAS.IdPoliza%TYPE := 0;
        nIdPolizaCalc      SICAS_OC.POLIZAS.IdPoliza%TYPE := 0;
        cStatus1           VARCHAR2(6);
        cStatus2           VARCHAR2(6);
        cStatus3           VARCHAR2(6);
        cStatus4           VARCHAR2(6);
        cStatus5           VARCHAR2(6) := 'SOL';
        cStatus6           VARCHAR2(6) := 'SOLICI';
        cCodCobert         SICAS_OC.COBERTURAS_DE_SEGUROS.CodCobert%TYPE;
        nPrimaMonedaTotPol SICAS_OC.POLIZAS.PrimaNeta_Moneda%TYPE;
        cTodasAnuladas     VARCHAR2(1);
        nPrima_Moneda      SICAS_OC.COBERT_ACT.Prima_Moneda%TYPE;
        cRecalculoPrimas   VARCHAR2(1);
        nIdTarifa          SICAS_OC.TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
        cSexo              SICAS_OC.PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
        cRiesgo            SICAS_OC.ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
        cCodActividad      SICAS_OC.PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
        nEdad              NUMBER(5);
        nTasa              NUMBER;
        nPeriodoEspCob     SICAS_OC.COBERTURAS_DE_SEGUROS.PeriodoEsperaMeses%TYPE;
        cTipoSumaSeg       VARCHAR2(1);
        nCodAseguradoAfina SICAS_OC.ASEGURADO.COD_ASEGURADO%TYPE;
        nDiasRenta         NUMBER;
      --
        CURSOR cPolizas_DatGen IS
        SELECT
            IdPoliza,
            IDetPol,
            CodAsegurado,
            FecIniVig,
            FecFinVig,
            FecBajcert,
            TipoDetalle,
            NumPoliza,
            NumCertificado
        FROM SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = 'SESADATVIG'
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'--(SELECT MIN(NUMPOLIZA) FROM SESAS_DATGEN)
            AND NUMCERTIFICADO >= '0'--(SELECT MIN(NUMCERTIFICADO) FROM SESAS_DATGEN);
;
        TYPE rec_sesasdatgen IS RECORD (
            IDPOLIZA       NUMBER,
            IDETPOL        NUMBER,
            CodAsegurado   NUMBER,
            FECINIVIG      DATE,
            FECFINVIG      DATE,
            FecBajcert     DATE,
            TIPODETALLE    VARCHAR2(5),
            NUMPOLIZA      VARCHAR2(30),
            NUMCERTIFICADO VARCHAR2(30)
        );
        TYPE type_sesasdatgen IS
            TABLE OF rec_sesasdatgen;
        obj_sesasdatgen    type_sesasdatgen;
        CURSOR POL_Q IS
        SELECT
            P.IdPoliza,
            P.StsPoliza,
            P.TipoAdministracion,
            D.IdTipoSeg,
            D.PlanCob,
            D.FecIniVig
        FROM  SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.IdPoliza = P.IdPoliza 
                                                    AND D.CodCia = P.CodCia
                                                    AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IdPoliza AND CODCIA = P.CodCia)
        WHERE
                P.CodCia = nCodCia
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
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA D 
            ON D.IdPoliza = P.IdPoliza
            AND D.CodCia = P.CodCia
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IdPoliza AND CODCIA = P.CodCia)
        WHERE P.CodCia = nCodCia
            AND P.IdPoliza NOT IN (SELECT IDPOLIZA FROM SICAS_OC.POLIZAS WHERE IDPOLIZA = nIdPolizaProc AND ROWNUM <= 1) -- != nIdPolizaProc
            AND P.StsPoliza NOT IN ( 'SOL', 'PRE' )
            AND D.IDetPol = nIDetPolProc
            AND P.NumPolUnico IN (
                SELECT  NumPolUnico
                FROM SICAS_OC.POLIZAS
                WHERE  CodCia = nCodCia
                    AND IdPoliza = nIdPolizaProc
            )
            AND ( D.MotivAnul IS NULL
                  OR NVL(D.MotivAnul, 'NULL') IS NOT NULL
                  AND D.FecAnul BETWEEN dvarFecDesde AND dvarFecHasta
                  OR P.StsPoliza = 'ANU'
                  AND P.FecSts BETWEEN dvarFecDesde AND dvarFecHasta );

        TYPE rec_sesasdatgen2 IS RECORD (
            IDPOLIZA           NUMBER,
            StsPoliza          VARCHAR2(5),
            TipoAdministracion VARCHAR2(10),
            IdTipoSeg          VARCHAR2(15),
            PlanCob            VARCHAR2(15),
            FecIniVig          DATE
        );
        TYPE type_sesasdatgen2 IS
            TABLE OF rec_sesasdatgen2;
        obj_sesasdatgen2   type_sesasdatgen2;
        TYPE rec_sesasdatgen4 IS RECORD (
            CodCobert     VARCHAR2(10),
            OrdenSESAS    NUMBER,
            PeriodoEspera NUMBER,
            ClaveSESAS    VARCHAR2(5),
            Suma_Moneda   NUMBER,
            Prima_Moneda  NUMBER
        );
        TYPE type_sesasdatgen4 IS
            TABLE OF rec_sesasdatgen4;
        obj_sesasdatgen4   type_sesasdatgen4;
        CURSOR COBERT_Q IS
        SELECT
            C.CodCobert,
            NVL(OrdenSESAS, 0)         OrdenSESAS,
            NVL(PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(CLAVESESASNEW, '99')   ClaveSESAS,
            (
                CASE NVL(CLAVESESASNEW, '99')
                    WHEN '10' THEN
                        0.0
                    ELSE
                        SUM(SumaAseg_Moneda)
                END
            )                          Suma_Moneda,
            SUM(C.Prima_Moneda)        Prima_Moneda
        FROM
                 SICAS_OC.COBERT_ACT C
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
                                                            AND CS.CodCia = C.CodCia
        WHERE
                C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND C.StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 )
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
            NVL(CLAVESESASNEW, '99')   ClaveSESAS,
            (
                CASE NVL(CLAVESESASNEW, '99')
                    WHEN '10' THEN
                        0.0
                    ELSE
                        SUM(SumaAseg_Moneda)
                END
            )                          Suma_Moneda,
            SUM(C.Prima_Moneda)        Prima_Moneda
        FROM
                 SICAS_OC.COBERT_ACT_ASEG C
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
                                                            AND CS.CodCia = C.CodCia
        WHERE
                C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND C.StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 )
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
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
            ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
                                                            AND CS.CodCia = C.CodCia
        WHERE
                C.CodCia = nCodCia
            AND C.IdPoliza = nIdPolizaCalc
            AND C.IDetPol > 0
            AND C.SumaAseg_Moneda > 0
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
                C.CodCia = nCodCia
            AND C.IdPoliza = nIdPolizaCalc
            AND C.IDetPol > 0
            AND C.SumaAseg_Moneda > 0;

        TYPE rec_sesasdatgen3 IS RECORD (
            Cod_Asegurado   NUMBER,
            SumaAseg_Moneda NUMBER,
            CodCobert       VARCHAR2(6),
            Tasa            NUMBER,
            Porc_Tasa       NUMBER,
            CodTarifa       VARCHAR2(30),
            IdTipoSeg       VARCHAR2(6),
            PlanCob         VARCHAR2(15),
            FactorTasa      NUMBER,
            Prima_Cobert    NUMBER
        );
        TYPE type_sesasdatgen3 IS
            TABLE OF rec_sesasdatgen3;
        obj_sesasdatgen3   type_sesasdatgen3;      

      --
        CURSOR COB_CALC_Q IS
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
                C.CodCia = nCodCia
            AND C.IdPoliza = nIdPoliza
            AND C.IDetPol = nIDetPol
            AND C.CodCobert = cCodCobert
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.SumaAseg_Moneda > 0
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
                C.CodCia = nCodCia
            AND C.IdPoliza = nIdPoliza
            AND C.IDetPol = nIDetPol
            AND C.CodCobert = cCodCobert
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.SumaAseg_Moneda > 0;

        nPrimaDevengada    NUMBER;
    BEGIN

EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
/*
        DELETE SICAS_OC.SESAS_EMISION
        WHERE  CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario;

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
*/
        

        /*Ejecuta datos generales ya que emision depende de el*/
        SICAS_OC.OC_SESASCOLECTIVO.DATGEN_VI(nCodCia, nCodEmpresa, dFecDesde, dFecHasta, cCodUsuario, 'SESADATVIG', 'SESADATVIG'/*cCodReporteProces*/, cFiltrarPolizas);
      --

        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY')  || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        OPEN cPolizas_DatGen;
        LOOP
            FETCH cPolizas_DatGen
            BULK COLLECT INTO obj_sesasdatgen ;
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
                nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                nIDetPol := obj_sesasdatgen(x).IDetPol;
                nCod_Asegurado := obj_sesasdatgen(x).CodAsegurado;
                dFecIniVig := obj_sesasdatgen(x).FecIniVig;
                dFecFinVig := obj_sesasdatgen(x).FecFinVig;
                nIdPolizaProc := obj_sesasdatgen(x).IdPoliza;
                nIDetPolProc := obj_sesasdatgen(x).IDetPol;
                nMtoAsistLocal := 0;
                nPmaEmiCob := 0;
              --
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
                    OPEN POL_Q;
                    LOOP
                        FETCH POL_Q
                        BULK COLLECT INTO obj_sesasdatgen2 ;
                        FOR z IN 1..obj_sesasdatgen2.COUNT LOOP

                --FOR z IN POL_Q LOOP
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
                        --
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

                            ELSIF cTodasAnuladas = 'S'  AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza THEN
                                SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                INTO nPrimaMonedaTotPol
                                FROM SICAS_OC.COBERT_ACT
                                WHERE CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;
                        --
                                SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                INTO nPrimaMonedaTotPol
                                FROM SICAS_OC.ASISTENCIAS_DETALLE_POLIZA
                                WHERE  CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;
                        --
                                SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                INTO nPrimaMonedaTotPol
                                FROM SICAS_OC.COBERT_ACT_ASEG
                                WHERE  CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;
                        --
                                SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                INTO nPrimaMonedaTotPol
                                FROM SICAS_OC.ASISTENCIAS_ASEGURADO
                                WHERE  CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;

                            END IF;
                        END LOOP;

                        EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                    END LOOP;

                    CLOSE POL_Q;
                    cRecalculoPrimas := 'N';
                 --
                    IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                        cRecalculoPrimas := 'S';
                    --
                    BEGIN
                        OPEN POL_Q;
                        LOOP
                            FETCH POL_Q
                            BULK COLLECT INTO obj_sesasdatgen2  ;
                            FOR z IN 1..obj_sesasdatgen2.COUNT LOOP
                    --FOR z IN POL_Q LOOP
                                nIdPolizaCalc := obj_sesasdatgen2(z).IdPoliza;


                                    nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen2( z).IdTipoSeg, obj_sesasdatgen2(z).PlanCob, obj_sesasdatgen2(z).FecIniVig);

                        --
                                nCodAseguradoAfina := NULL;
                                OPEN CALC_Q;
                                LOOP
                                    FETCH CALC_Q
                                    BULK COLLECT INTO obj_sesasdatgen3  ;
                                    FOR w IN 1..obj_sesasdatgen3.COUNT LOOP
                            --FOR w IN CALC_Q LOOP
                                        IF obj_sesasdatgen3(w).Tasa > 0 THEN
                                            nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( obj_sesasdatgen3(w).SumaAseg_Moneda *obj_sesasdatgen3(w).Tasa );

                                        ELSIF obj_sesasdatgen3(w).CodTarifa IS NULL THEN
                                            IF NVL(obj_sesasdatgen3(w).Prima_Cobert, 0) != 0 THEN
                                                nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + NVL(obj_sesasdatgen3(w).Prima_Cobert,0);

                                            ELSE
                                                nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( obj_sesasdatgen3(w).SumaAseg_Moneda *obj_sesasdatgen3(w).Porc_Tasa / 1000 );
                                            END IF;
                                        ELSE
                               --Afinación para no obtener N veces la mismsa información cuando se trata del mismo asegurado
                                            IF nCodAseguradoAfina IS NULL OR nCodAseguradoAfina <> obj_sesasdatgen3(w).Cod_Asegurado THEN
                                                nCodAseguradoAfina := obj_sesasdatgen3(w).Cod_Asegurado;
                                                SICAS_OC.OC_PROCESOSSESAS.DATOSASEGURADO(nCodCia, nCodEmpresa, obj_sesasdatgen3(w).Cod_Asegurado,dFecIniVig, cSexo,nEdad, cCodActividad, cRiesgo);

                                            END IF;
                               --
                                            IF nEdad = 0 THEN

                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS(nCodCia, nCodEmpresa,obj_sesasdatgen3(w).IdTipoSeg, obj_sesasdatgen3(w).PlanCob, obj_sesasdatgen3(w).CodCobert,nEdad, cSexo, cRiesgo,nIdTarifa);



                                            ELSE
                                                BEGIN
                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, obj_sesasdatgen3(w).IdTipoSeg, obj_sesasdatgen3(w).PlanCob, obj_sesasdatgen3(w).CodCobert,nEdad, cSexo, cRiesgo, nIdTarifa,NULL);

                                                EXCEPTION
                                                    WHEN OTHERS THEN

                                                            nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS(nCodCia, nCodEmpresa,obj_sesasdatgen3(w).IdTipoSeg, obj_sesasdatgen3(w).PlanCob, obj_sesasdatgen3(w).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);


                                                END;
                                            END IF;
                               --
                                            nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( obj_sesasdatgen3(w).SumaAseg_Moneda *
                                            nTasa / obj_sesasdatgen3(w).FactorTasa );

                                        END IF;
                                    END LOOP;

                                    EXIT WHEN obj_sesasdatgen3.COUNT = 0;
                                END LOOP;

                                CLOSE CALC_Q;
                            END LOOP;

                            EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                        END LOOP;

                        CLOSE POL_Q;

                    EXCEPTION
                        WHEN OTHERS THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-GT_TARIFA_CONTROL_VIGENCIAS: ' || nCod_Asegurado, SQLCODE, SQLERRM);
                    END;

                    --END LOOP;
                    END IF;
                 --
                    IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                        nPrimaMonedaTotPol := 1;
                    END IF;
                END IF;

                OPEN POL_Q;
                LOOP
                    FETCH POL_Q
                    BULK COLLECT INTO obj_sesasdatgen2  ;
                    FOR z IN 1..obj_sesasdatgen2.COUNT LOOP
                --FOR z IN POL_Q LOOP
                        IF
                            cTodasAnuladas = 'N'
                            AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza
                        THEN
                            BEGIN
                                nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen2(z).IdTipoSeg, obj_sesasdatgen2(z).PlanCob, obj_sesasdatgen2(z).FecIniVig);
                            EXCEPTION
                                WHEN OTHERS THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-GT_TARIFA_CONTROL_VIGENCIAS: ' || nCod_Asegurado, SQLCODE, SQLERRM);
                            END;
                         --
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

                        ELSIF
                            cTodasAnuladas = 'S'
                            AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza
                        THEN
                            BEGIN
                                nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen2(z).IdTipoSeg, obj_sesasdatgen2(z).PlanCob, obj_sesasdatgen2(z).FecIniVig);
                            EXCEPTION
                                WHEN OTHERS THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-GT_TARIFA_CONTROL_VIGENCIAS: ' || nCod_Asegurado, SQLCODE, SQLERRM);
                            END;

                            cStatus1 := ' ';
                            cStatus2 := ' ';
                            cStatus3 := ' ';
                            cStatus4 := ' ';
                        END IF;
                    END LOOP;

                    EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                END LOOP;

                CLOSE POL_Q;
                IF obj_sesasdatgen(x).TipoDetalle = 'IND' THEN
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
                        AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );

                ELSE
                    SELECT
                        NVL(SUM(MontoAsistLocal), 0)
                    INTO nMtoAsistLocal
                    FROM
                        SICAS_OC.ASISTENCIAS_ASEGURADO
                    WHERE
                            CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa
                        AND IdPoliza = nIdPoliza
                        AND IDetPol = nIDetPol
                        AND Cod_Asegurado = nCod_Asegurado
                        AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );

                END IF;
--cStatus2 :='A';
                OPEN COBERT_Q;
                LOOP
                    FETCH COBERT_Q
                    BULK COLLECT INTO obj_sesasdatgen4 ; 
                    FOR w IN 1..obj_sesasdatgen4.COUNT LOOP  
                --FOR w IN COBERT_Q LOOP
                        IF cRecalculoPrimas = 'N' THEN
                            nPrima_Moneda := NVL(obj_sesasdatgen4(w).Prima_Moneda, 0);
                        ELSE
                            IF NVL(obj_sesasdatgen4(w).Prima_Moneda, 0) > 0 THEN
                                nPrima_Moneda := NVL(obj_sesasdatgen4(w).Prima_Moneda, 0);
                            ELSE
                                cCodCobert := obj_sesasdatgen4(w).CodCobert;
                        --
                                nCodAseguradoAfina := NULL;
                                OPEN COB_CALC_Q;
                                LOOP
                                    FETCH COB_CALC_Q
                                    BULK COLLECT INTO obj_sesasdatgen3  ;
                                    FOR r IN 1..obj_sesasdatgen3.COUNT LOOP
                            --FOR r IN COB_CALC_Q LOOP
                                        IF obj_sesasdatgen3(r).Tasa > 0 THEN
                                            nPrima_Moneda := obj_sesasdatgen3(r).SumaAseg_Moneda * obj_sesasdatgen3(r).Tasa;
                                        ELSIF obj_sesasdatgen3(r).CodTarifa IS NULL THEN
                                            IF NVL(obj_sesasdatgen3(r).Prima_Cobert, 0) != 0 THEN
                                                nPrima_Moneda := NVL(obj_sesasdatgen3(r).Prima_Cobert, 0);
                                            ELSE
                                                nPrima_Moneda := obj_sesasdatgen3(r).SumaAseg_Moneda * obj_sesasdatgen3(r).Porc_Tasa /1000;
                                            END IF;
                                        ELSE
                                            BEGIN
                                                nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen3(r).IdTipoSeg, obj_sesasdatgen3(r).PlanCob, dFecIniVig);
                                            EXCEPTION
                                                WHEN OTHERS THEN
                                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-GT_TARIFA_CONTROL_VIGENCIAS: ' || nCod_Asegurado, SQLCODE, SQLERRM);
                                            END;
                               --
                               --Afinación para no obtener N veces la mismsa información cuando se trata del mismo asegurado
                                            IF nCodAseguradoAfina IS NULL OR nCodAseguradoAfina <> obj_sesasdatgen3(r).Cod_Asegurado THEN
                                                nCodAseguradoAfina := obj_sesasdatgen3(r).Cod_Asegurado;
                                                SICAS_OC.OC_PROCESOSSESAS.DATOSASEGURADO(nCodCia, nCodEmpresa, obj_sesasdatgen3(r).Cod_Asegurado, dFecIniVig, cSexo,nEdad, cCodActividad, cRiesgo);

                                            END IF;
                               --
                                BEGIN
                                            IF nEdad = 0 THEN

                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS(nCodCia, nCodEmpresa, obj_sesasdatgen3(r).IdTipoSeg, obj_sesasdatgen3(r).PlanCob, obj_sesasdatgen3(r).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);

                                            ELSE
                                                BEGIN
                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, obj_sesasdatgen3(r).IdTipoSeg, obj_sesasdatgen3(r).PlanCob, obj_sesasdatgen3(r).CodCobert,nEdad, cSexo, cRiesgo, nIdTarifa,NULL);

                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        BEGIN
                                                            nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS(nCodCia, nCodEmpresa,obj_sesasdatgen3(r).IdTipoSeg, obj_sesasdatgen3(r).PlanCob, obj_sesasdatgen3( r).CodCobert,nEdad, cSexo, cRiesgo,nIdTarifa);

                                                        EXCEPTION
                                                            WHEN OTHERS THEN
                                                                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, nIdPolizaCalc,'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' ||obj_sesasdatgen3(r).Cod_Asegurado,SQLCODE, SQLERRM);
                                                        END;
                                                END;
                                            END IF;
                               EXCEPTION
                                    WHEN OTHERS THEN
                                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, nIdPolizaCalc,'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' ||obj_sesasdatgen3(r).Cod_Asegurado,SQLCODE, SQLERRM);
                                END;
                                            nPrima_Moneda := obj_sesasdatgen3(r).SumaAseg_Moneda * nTasa / obj_sesasdatgen3(r).FactorTasa;

                                        END IF;
                                    END LOOP;

                                    EXIT WHEN obj_sesasdatgen3.COUNT = 0;
                                END LOOP;

                                CLOSE COB_CALC_Q;
                            END IF;
                        END IF;
                  --
                  --IF obj_sesasdatgen4(w).PeriodoEspera > NVL(nPeriodoEspCob, 0) THEN
                  --   nPeriodoEspCob := obj_sesasdatgen4(w).PeriodoEspera;
                  --END IF; 
                  --
                        nPmaEmiCob := NVL(nPrima_Moneda, 0);
                  --
                        IF obj_sesasdatgen4(w).OrdenSESAS = 1 THEN
                            nPmaEmiCob := NVL(nPmaEmiCob, 0) + NVL(nMtoAsistLocal, 0);
                            nMtoAsistLocal := 0;
                        END IF;

                        cTipoSumaSeg := SICAS_OC.OC_PROCESOSSESAS.GETTIPOSUMASEG(nCodCia, LPAD(obj_sesasdatgen4(w).ClaveSESAS, 2, '0'),'VIDA');
                  --Inserto Emisión/Coberturas
                        nPrimaDevengada := SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(nidPoliza, nPmaEmiCob, dFecHasta, dFecIniVig, dFecFinVig);

                        IF obj_sesasdatgen(x).Fecbajcert < dvarFecDesde THEN
                            nPmaEmiCob := 0;
                        END IF;
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
                                obj_sesasdatgen4(w).OrdenSESAS
                            );

                        EXCEPTION
                            WHEN DUP_VAL_ON_INDEX THEN
                                UPDATE SICAS_OC.SESAS_EMISION
                                SET PrimaEmitida = NVL(PrimaEmitida, 0) + NVL(nPmaEmiCob, 0),
                                    SumaAsegurada = NVL(SumaAsegurada, 0) + NVL(NVL(obj_sesasdatgen4(w).Suma_Moneda, 0), 0),
                                    primadevengada = primadevengada + nPrimaDevengada,
                                            fechainsert = sysdate
                                WHERE
                                        CodCia = nCodCia
                                    AND CodEmpresa = nCodEmpresa
                                    AND CodReporte = cCodReporteProces
                                    AND CodUsuario = cCodUsuario
                                    AND NumPoliza = obj_sesasdatgen(x).NumPoliza
                                    AND NumCertificado = obj_sesasdatgen(x).NumCertificado
                                    AND Cobertura = LPAD(obj_sesasdatgen4(w).ClaveSESAS, 2, '0');
                          --AND  OrdenSesas     = nOrdenSesas;
                              
                            WHEN OTHERS THEN
                                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, obj_sesasdatgen(x).NumPoliza,obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                        END;

                    END LOOP;

                    EXIT WHEN obj_sesasdatgen4.COUNT = 0;
                END LOOP;

                CLOSE COBERT_Q;
            END LOOP;



            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
        


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
                    WHERE IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol
                        AND CODCIA = nCodCia;

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
                                                    fechainsert = sysdate
                        WHERE  CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMCERTIFICADO = TRIM(LPAD(obj_sesasdatgen(x).IdPoliza, 8, '0')) ||TRIM(LPAD(obj_sesasdatgen(x).IDetPol, 2, '0')) ||TRIM(LPAD(obj_sesasdatgen(x).CodAsegurado, 10, '0'))
            AND COBERTURA = COBERTURA;

                    END IF;
                END IF;

                END LOOP;
            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
             
    /*
    FOR x IN cPolizas_DatGen LOOP
        nIdPoliza      := x.IdPoliza;
        nIDetPol       := x.IDetPol;
        nCod_Asegurado := x.CodAsegurado;
        dFecIniVig     := x.FecIniVig;
        nIdPolizaProc  := x.IdPoliza;
        nIDetPolProc   := x.IDetPol;
        nMtoAsistLocal := 0;
        nPmaEmiCob     := 0;
          --
        IF NVL(nIdPolizaProcCalc, 0) != NVL(nIdPoliza, 0) THEN
            nIdPolizaProcCalc    := nIdPoliza;
            nPrimaMonedaTotPol   := 0;
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
                    IF Z.StsPoliza IN ('EMI','REN') THEN
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
                    SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                    INTO   nPrimaMonedaTotPol
                    FROM   COBERT_ACT
                    WHERE  CodCia         = nCodCia
                        AND  IdPoliza       = z.IdPoliza
                        AND  StsCobertura NOT IN (cStatus1, cStatus2, cStatus5);
                    --
                    SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                    INTO   nPrimaMonedaTotPol
                    FROM   ASISTENCIAS_DETALLE_POLIZA
                    WHERE  CodCia          = nCodCia
                        AND  IdPoliza        = z.IdPoliza
                        AND  StsAsistencia NOT IN (cStatus3, cStatus4, cStatus6);
                    --
                    SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                    INTO   nPrimaMonedaTotPol
                    FROM   COBERT_ACT_ASEG
                    WHERE  CodCia         = nCodCia
                        AND  IdPoliza       = z.IdPoliza
                        AND  StsCobertura NOT IN (cStatus1, cStatus2, cStatus5);
                    --
                    SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                    INTO   nPrimaMonedaTotPol
                    FROM   ASISTENCIAS_ASEGURADO
                    WHERE  CodCia          = nCodCia
                        AND  IdPoliza        = z.IdPoliza
                        AND  StsAsistencia NOT IN (cStatus3, cStatus4, cStatus6);
                ELSIF cTodasAnuladas = 'S' AND nIdPolizaProcCalc = z.IdPoliza THEN
                    SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                    INTO   nPrimaMonedaTotPol
                    FROM   COBERT_ACT
                    WHERE  CodCia   = nCodCia
                        AND  IdPoliza = z.IdPoliza;
                    --
                    SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                    INTO   nPrimaMonedaTotPol
                    FROM   ASISTENCIAS_DETALLE_POLIZA
                    WHERE  CodCia   = nCodCia
                        AND  IdPoliza = z.IdPoliza;
                    --
                    SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                    INTO   nPrimaMonedaTotPol
                    FROM   COBERT_ACT_ASEG
                    WHERE  CodCia   = nCodCia
                        AND  IdPoliza = z.IdPoliza;
                    --
                    SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                    INTO   nPrimaMonedaTotPol
                    FROM   ASISTENCIAS_ASEGURADO
                    WHERE  CodCia   = nCodCia
                        AND  IdPoliza = z.IdPoliza;
                END IF;
            END LOOP; 
             --
            cRecalculoPrimas := 'N';
             --
            IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                cRecalculoPrimas := 'S';
                --
                FOR z IN POL_Q LOOP
                    nIdPolizaCalc := z.IdPoliza;
                    nIdTarifa     := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE( nCodCia, nCodEmpresa, z.IdTipoSeg, z.PlanCob, z.FecIniVig );
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
                                OC_PROCESOSSESAS.DATOSASEGURADO( nCodCia, nCodEmpresa, w.Cod_Asegurado, dFecIniVig, cSexo, nEdad, cCodActividad, cRiesgo );
                            END IF;
                           --
                            IF nEdad = 0 THEN
                                BEGIN
                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS( nCodCia, nCodEmpresa, w.IdTipoSeg, w.PlanCob, w.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL );
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        RAISE_APPLICATION_ERROR(-20200, SQLERRM || 'POLIZA: ' || nIdPolizaCalc || ' cod_asegurado: ' || w.Cod_Asegurado);
                                END;
                            ELSE
                                BEGIN
                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA( nCodCia, nCodEmpresa, w.IdTipoSeg, w.PlanCob, w.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL );
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        BEGIN
                                            nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS( nCodCia, nCodEmpresa, w.IdTipoSeg, w.PlanCob, w.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL );
                                        EXCEPTION
                                            WHEN OTHERS THEN
                                                RAISE_APPLICATION_ERROR(-20200,SQLERRM || 'POLIZA: ' || nIdPolizaCalc || ' cod_asegurado: ' || w.Cod_Asegurado);
                                        END;
                                END;
                            END IF;
                           --
                            nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol,0) + ( w.SumaAseg_Moneda * nTasa / w.FactorTasa );
                        END IF;
                    END LOOP;
                END LOOP;
             END IF;
             --
            IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                    nPrimaMonedaTotPol := 1;
            END IF;
        END IF;

        FOR z IN POL_Q LOOP
            IF cTodasAnuladas = 'N' AND nIdPolizaProcCalc = z.IdPoliza THEN
                 nIdTarifa := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE( nCodCia, nCodEmpresa, z.IdTipoSeg, z.PlanCob, z.FecIniVig );
                 --
                IF z.StsPoliza IN ('EMI','REN') THEN
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
            ELSIF cTodasAnuladas = 'S' AND nIdPolizaProcCalc = z.IdPoliza THEN
                nIdTarifa := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE( nCodCia, nCodEmpresa, z.IdTipoSeg, z.PlanCob, z.FecIniVig );
                cStatus1  := ' ';
                cStatus2  := ' ';
                cStatus3  := ' ';
                cStatus4  := ' ';
            END IF;
        END LOOP;
          --
        IF x.TipoDetalle = 'IND' THEN
            SELECT NVL(SUM(MontoAsistLocal), 0)
            INTO   nMtoAsistLocal
            FROM   ASISTENCIAS_DETALLE_POLIZA
            WHERE  CodCia          = nCodCia
                AND  CodEmpresa      = nCodEmpresa
                AND  IdPoliza        = nIdPoliza
                AND  IDetPol         = nIDetPol
                AND  StsAsistencia NOT IN (cStatus3, cStatus4, cStatus6);
        ELSE
            SELECT NVL(SUM(MontoAsistLocal), 0)
            INTO   nMtoAsistLocal
            FROM   ASISTENCIAS_ASEGURADO
            WHERE  CodCia          = nCodCia
                AND  CodEmpresa      = nCodEmpresa
                AND  IdPoliza        = nIdPoliza
                AND  IDetPol         = nIDetPol
                AND  Cod_Asegurado   = nCod_Asegurado
                AND  StsAsistencia NOT IN (cStatus3, cStatus4, cStatus6);
        END IF;
          --
        FOR w IN COBERT_Q LOOP
            IF cRecalculoPrimas = 'N' THEN
                nPrima_Moneda := NVL(w.Prima_Moneda, 0);
            ELSE
                IF NVL(w.Prima_Moneda, 0) > 0 THEN
                    nPrima_Moneda := NVL(w.Prima_Moneda, 0);
                ELSE
                    cCodCobert := w.CodCobert;
                    --
                    nCodAseguradoAfina := NULL;
                    FOR r IN COB_CALC_Q LOOP
                        IF r.Tasa > 0 THEN
                           nPrima_Moneda := r.SumaAseg_Moneda * r.Tasa;
                        ELSIF r.CodTarifa IS NULL THEN
                           IF NVL(r.Prima_Cobert, 0) != 0 THEN
                              nPrima_Moneda := NVL(r.Prima_Cobert, 0);
                           ELSE
                              nPrima_Moneda := r.SumaAseg_Moneda * r.Porc_Tasa / 1000;
                           END IF;
                        ELSE
                           nIdTarifa := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE( nCodCia, nCodEmpresa, r.IdTipoSeg, r.PlanCob, dFecIniVig );
                           --
                           --Afinación para no obtener N veces la mismsa información cuando se trata del mismo asegurado
                           IF nCodAseguradoAfina IS NULL OR nCodAseguradoAfina <> r.Cod_Asegurado THEN
                              nCodAseguradoAfina := r.Cod_Asegurado; 
                              OC_PROCESOSSESAS.DATOSASEGURADO( nCodCia, nCodEmpresa, r.Cod_Asegurado, dFecIniVig, cSexo, nEdad, cCodActividad, cRiesgo );
                           END IF;
                           --
                           IF nEdad = 0 THEN
                              nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS( nCodCia, nCodEmpresa, r.IdTipoSeg, r.PlanCob, r.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL );
                           ELSE
                              BEGIN
                                 nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA( nCodCia, nCodEmpresa, r.IdTipoSeg, r.PlanCob, r.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL );
                              EXCEPTION
                              WHEN OTHERS THEN
                                   BEGIN
                                      nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS( nCodCia, nCodEmpresa, r.IdTipoSeg, r.PlanCob, r.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL );
                                   EXCEPTION
                                   WHEN OTHERS THEN
                                        RAISE_APPLICATION_ERROR(-20200, SQLERRM);
                                   END;
                              END;
                           END IF;
                           --
                           nPrima_Moneda := r.SumaAseg_Moneda * nTasa / r.FactorTasa;
                        END IF;
                    END LOOP;
                 END IF;
              END IF;
              --
              --IF w.PeriodoEspera > NVL(nPeriodoEspCob, 0) THEN
              --   nPeriodoEspCob := w.PeriodoEspera;
              --END IF; 
              --
              nPmaEmiCob     := NVL(nPrima_Moneda, 0);
              --
              IF w.OrdenSESAS = 1 THEN
                 nPmaEmiCob     := NVL(nPmaEmiCob, 0) + NVL(nMtoAsistLocal, 0);
                 nMtoAsistLocal := 0;
              END IF;
                cTipoSumaSeg := SICAS_OC.OC_PROCESOSSESAS.GETTIPOSUMASEG(nCodCia,LPAD(w.ClaveSESAS, 2, '0'),'VIDA');
              --Inserto Emisión/Coberturas
              OC_PROCESOSSESAS.INSERTAEMISION( nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, x.NumPoliza, x.NumCertificado, LPAD(w.ClaveSESAS, 2, '0'), cTipoSumaSeg, w.PeriodoEspera, NVL(w.Suma_Moneda, 0), nPmaEmiCob, NULL, NULL, NULL, w.OrdenSESAS );

        END LOOP;
    END LOOP;
    */


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

        dFecConSin        SICAS_OC.SESAS_SINIESTROS.FECCONSIN%TYPE;
        dFecPagSin        SICAS_OC.SESAS_SINIESTROS.FECPAGSIN%TYPE;
        nMontoPagSin      SICAS_OC.SESAS_SINIESTROS.MONTOPAGSIN%TYPE;
        nNumAprobacion    APROBACIONES.NUM_APROBACION%TYPE;
        nIdTransaccion    APROBACIONES.IDTRANSACCION%TYPE;
        cTipAprobacion    NUMBER;
        vl_TipoMovReclamo VARCHAR2(1);
        nMontoVencimiento NUMBER;
        nMontoRecRea      NUMBER;
        nMontoReclamado   NUMBER;

      --
        CURSOR cSiniestros IS
        SELECT
            P.NumPolUnico                                                                                                           NumPoliza,
            TRIM(LPAD(S.IdPoliza, 8, '0'))
            || TRIM(LPAD(S.IDetPol, 2, '0'))
            || TRIM(LPAD(S.Cod_Asegurado, 10, '0'))                                                                                 NumCertificado,
            S.IdSiniestro    /*SICAS_OC.OC_PROCESOSSESAS.GETNUMSINIESTRO() */                                                                                                           NumSiniestro,
            S.Fec_Ocurrencia                                                                                                        FecOcuSin,
            S.Fec_Notificacion                                                                                                      FecRepSin,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(S.CodPaisOcurr, S.CodProvOcurr, PN.CODPAISRES, PN.CODPROVRES, S.IdPoliza) EntOcuSin,
            /*SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(S.CodCia, S.IdPoliza, S.IdSiniestro, S.Sts_Siniestro,((
                CASE WHEN R.TIPO_MOVIMIENTO IN('PAGOS') THEN R.IMPTE_MOVIMIENTO *( CASE WHEN R.SIGNO = '-' THEN - 1 ELSE 1 END ) ELSE  0 END ) +(
                CASE WHEN R.TIPO_MOVIMIENTO IN('DESPAG', 'DESCUE', 'DEDUC') THEN R.IMPTE_MOVIMIENTO *( CASE WHEN R.SIGNO = '-' THEN - 1 ELSE 1 END ) ELSE 0 END )), (
                CASE WHEN R.TIPO_MOVIMIENTO IN('ESTINI', 'AJUMAS', 'AJUMEN') THEN R.IMPTE_MOVIMIENTO *( CASE WHEN R.SIGNO = '-' THEN  - 1 ELSE 1 END ) ELSE 0 END ), 'SINVIG') StatusReclamacion,*/
            CASE WHEN LENGTH(NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)) = 3 THEN S.Motivo_De_Siniestro || 'X'
                ELSE NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro) END     CausaSiniestro,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                          Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOMOVRECLAMO()                                                                           TipMovRec,
            PN.FecNacimiento                                                                                                        FecNacim,
            0                                                                                                                       MontoVencimiento   --Default 0
            ,
            0                                                                                                                       MontoRecRea        --Default 0
                  --, S.Monto_Pago_Moneda /*validar con reporte de operaciones*/
                  --, S.Monto_Reserva_Moneda
            /*,
            ( CASE WHEN R.TIPO_MOVIMIENTO IN ( 'PAGOS' ) THEN R.IMPTE_MOVIMIENTO * ( CASE WHEN R.SIGNO = '-' THEN - 1  ELSE  1 END ) ELSE 0 END
            ) + (
            CASE WHEN R.TIPO_MOVIMIENTO IN ( 'DESPAG', 'DESCUE', 'DEDUC' ) THEN R.IMPTE_MOVIMIENTO * ( CASE WHEN R.SIGNO = '-' THEN - 1 ELSE  1 END  )  ELSE 0  END ) Monto_Pago_Moneda,

            CASE WHEN R.TIPO_MOVIMIENTO IN ( 'ESTINI', 'AJUMAS', 'AJUMEN' ) THEN R.IMPTE_MOVIMIENTO * ( CASE WHEN R.SIGNO = '-' THEN - 1 ELSE 1 END )  ELSE 0 END Monto_Reserva_Moneda,
            */
            ,S.IdPoliza,
            S.IDetPol,
            S.Cod_Asegurado,
            NVL(P.MONTODEDUCIBLE, 0)                                                                                                MONTODEDUCIBLE
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA           D
            ON D.IdPoliza = P.IdPoliza
            AND D.CODCIA = P.CODCIA
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IdPoliza AND CODCIA = P.CodCia)
        INNER JOIN SICAS_OC.SINIESTRO                S 
            ON S.IDetPol = D.IDetPol
            AND S.IdPoliza = D.IdPoliza
        INNER JOIN SICAS_OC.ASEGURADO                CL 
            ON CL.Cod_Asegurado = S.Cod_Asegurado
        INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN
            ON PN.Num_Doc_Identificacion = CL.Num_Doc_Identificacion
            AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
        INNER JOIN SICAS_OC.SINIESTRO                S 
            ON S.IDetPol = D.IDetPol
            AND S.IdPoliza = D.IdPoliza
        INNER JOIN SICAS_OC.RESERVA_DET              R ON R.ID_SINIESTRO = S.IDSINIESTRO
                                                 AND R.ID_POLIZA = S.IDPOLIZA
                                                 AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE  /*S.Fec_Notificacion        BETWEEN dvarFecDesde AND dvarFecHasta
               AND */
                S.Sts_Siniestro != 'SOL'
            AND D.IdTipoSeg IN (
                SELECT PC.IdTipoSeg
                FROM SICAS_OC.PLAN_COBERTURAS PC
                                                   /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  CAS
                                                    ON CAS.IDTIPOSEG = PC.IDTIPOSEG
                                                    AND CAS.PLANCOB = PC.PLANCOB*/
                WHERE  /*(PC.CodTipoPlan = '012'
                                                            OR (PC.CodTipoPlan ='099' AND CAS.IDRAMOREAL =  '010'  AND PC.IdTipoSeg  IN ('PPAQC')))*/
                    ( PC.CodTipoPlan IN ( '012', '013' )
                      OR ( EXISTS ( SELECT 'S'
                        FROM SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                        WHERE CAS.CODCIA = D.CodCia
                            AND CAS.CodEmpresa = D.CodEmpresa
                            AND CAS.IDTIPOSEG = D.IdTipoSeg
                            AND CAS.PLANCOB = D.PLANCOB
                            AND CAS.IDRAMOREAL = '010'
                            AND CAS.CODCOBERT IN (
                                SELECT CODCOBERT
                                FROM SICAS_OC.COBERTURA_ASEG X
                                WHERE X.IDPOLIZA = D.IDPOLIZA
                                    AND X.IDETPOL = D.IDETPOL
                                    AND D.IDTIPOSEG = X.IDTIPOSEG )
                    )
                           AND PC.CodTipoPlan = '099'
                           AND PC.IdTipoSeg = 'PPAQC' ) )
            )
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND ( EXISTS (
                SELECT 'S'
                FROM SICAS_OC.APROBACION_ASEG A
                INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B 
                    ON B.NumTransaccion = A.IdTransaccion
                WHERE A.IdSiniestro = S.IdSiniestro 
                                /*AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            ) OR EXISTS (
                SELECT 'S'
                FROM SICAS_OC.APROBACIONES A
                    INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B 
                        ON B.NumTransaccion = A.IdTransaccion
                WHERE A.IdSiniestro = S.IdSiniestro 
                               /* AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )
                  OR R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta 
                  )

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
            ) ) )
        UNION
        SELECT
            P.NumPolUnico                                                                                                           NumPoliza,
            NVL(TRIM(LPAD(S.IdPoliza, 8, '0'))
                || TRIM(LPAD(S.IDetPol, 2, '0'))
                || TRIM(LPAD(S.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                         || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                         || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                                NumCertificado,
            S.IdSiniestro    /*SICAS_OC.OC_PROCESOSSESAS.GETNUMSINIESTRO() */                                                                                                           NumSiniestro
                  /*COBERTURA*/,
            S.Fec_Ocurrencia                                                                                                        FecOcuSin,
            S.Fec_Notificacion                                                                                                      FecRepSin,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(S.CODPAISOCURR, S.CODPROVOCURR, PN.CODPAISRES, PN.CODPROVRES, S.IDPOLIZA) EntOcuSin,
            /*SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(S.CodCia, S.IdPoliza, S.IdSiniestro, S.Sts_Siniestro,((
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
            )),(
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
            ), 'SINVII')                                                                                                            StatusReclamacion,*/
            CASE
                WHEN LENGTH(NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)) = 3 THEN
                    S.Motivo_De_Siniestro || 'X'
                ELSE
                    NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)
            END                                                                                                                     CausaSiniestro,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                          Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOMOVRECLAMO()                                                                           TipMovRec,
            PN.FecNacimiento                                                                                                        FecNacim,
            0                                                                                                                       MontoVencimiento   --Default 0
            ,
            0                                                                                                                       MontoRecRea        --Default 0
                  --, S.Monto_Pago_Moneda
                  --, S.Monto_Reserva_Moneda
            /*,
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
           */ ,S.IdPoliza,
            S.IDetPol,
            S.Cod_Asegurado,
            NVL(P.MONTODEDUCIBLE, 0)                                                                                                MONTODEDUCIBLE
        FROM SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D 
                ON D.IdPoliza = P.IdPoliza
                AND D.CODCIA = P.CODCIA
                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IdPoliza AND CODCIA = P.CodCia)
            INNER JOIN SICAS_OC.SINIESTRO                S 
                ON S.IDetPol = D.IDetPol
                AND S.IdPoliza = D.IdPoliza
            INNER JOIN SICAS_OC.ASEGURADO                CL 
                ON CL.Cod_Asegurado = S.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN 
                ON PN.Num_Doc_Identificacion = CL.Num_Doc_Identificacion
                AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.RESERVA_DET              R ON R.ID_SINIESTRO = S.IDSINIESTRO
                                                 AND R.ID_POLIZA = S.IDPOLIZA
                                                 AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE  /*S.Fec_Notificacion        BETWEEN dvarFecDesde AND dvarFecHasta
               AND*/
                S.Sts_Siniestro != 'SOL'
                AND P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
            AND ( EXISTS (
                SELECT 'S'
                FROM SICAS_OC.APROBACION_ASEG A
                INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B ON B.NumTransaccion = A.IdTransaccion
                WHERE A.IdSiniestro = S.IdSiniestro 
                                /*AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            ) OR EXISTS (
                SELECT 'S'
                FROM SICAS_OC.APROBACIONES A
                INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B 
                    ON B.NumTransaccion = A.IdTransaccion
                WHERE A.IdSiniestro = S.IdSiniestro 
                               /* AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )
                  OR R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta 
                  )
            AND D.IdTipoSeg IN (
                SELECT
                    PC.IdTipoSeg IdTipoSeg
                FROM
                    SICAS_OC.PLAN_COBERTURAS PC
                                                   /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  CAS
                                                    ON CAS.IDTIPOSEG = PC.IDTIPOSEG
                                                    AND CAS.PLANCOB = PC.PLANCOB*/
                WHERE  /*(PC.CodTipoPlan ='012'

                                                        OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '010'  AND PC.IdTipoSeg  IN ('PPAQC')))*/
                     ( PC.CodTipoPlan IN ( '012', '013' )
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
                                    SICAS_OC.COBERTURA_ASEG X
                                WHERE
                                        X.IDPOLIZA = D.IDPOLIZA
                                    AND X.IDETPOL = D.IDETPOL
                                    AND D.IDTIPOSEG = X.IDTIPOSEG
                            )
                    )
                           AND PC.CodTipoPlan = '099'
                           AND PC.IdTipoSeg = 'PPAQC' ) )
            )
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
        CURSOR cCoberturas (
            nIdPoliza    SINIESTRO.IdPoliza%TYPE,
            nIdSiniestro SINIESTRO.IdSiniestro%TYPE
        ) IS
        SELECT  NVL(CS.CLAVESESASNEW, '1') ClaveSesas,
                1 OrdenSesas--NVL(CS.OrdenSesas, 0)      OrdenSesas
                   -- , CS.CodCobert
            , SUM(  R.MONTO_RESERVADO_MONEDA *( CASE WHEN T.SIGNO = '-' THEN -1 ELSE 1 END ) )  MontoReclamado,
            NVL(SUM( R.MONTO_PAGADO_MONEDA   *( CASE WHEN T.SIGNO = '-' THEN -1 ELSE 1 END ) ), 0)  MontoPagado

        FROM SICAS_OC.SINIESTRO S
        INNER JOIN SICAS_OC.DETALLE_POLIZA        D 
            ON D.IDetPol = S.IDetPol
            AND D.IdPoliza = S.IdPoliza
            AND D.CODCIA = S.CODCIA
        INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
            ON CS.PlanCob = D.PlanCob
            AND CS.IdTipoSeg = D.IdTipoSeg
            AND CS.CodEmpresa = D.CodEmpresa
            AND CS.CodCia = D.CodCia

        INNER JOIN SICAS_OC.COBERTURA_SINIESTRO_ASEG           R 
            ON R.IDSINIESTRO = S.IDSINIESTRO
            AND R.IDPOLIZA = S.IDPOLIZA
            AND R.CodCobert = Cs.CodCobert
            AND R.FECRES BETWEEN dvarFecDesde AND dvarFecHasta

        INNER JOIN SICAS_OC.CONFIG_TRANSAC_SINIESTROS T
            ON T.CODTRANSAC = R.CODTRANSAC
        WHERE S.IdSiniestro = nIdSiniestro
            AND S.IdPoliza = nIdPoliza
            AND R.CodCobert = Cs.CodCobert
            AND R.FECRES BETWEEN dvarFecDesde AND dvarFecHasta
            AND NVL(Cs.IDRAMOREAL, '010') <> '030'
            AND R.FECRES BETWEEN dvarFecDesde AND dvarFecHasta
        GROUP BY NVL(CS.CLAVESESASNEW, '1'), NVL(CS.OrdenSesas, 0)--, CS.CodCobert
            ;
            /*
          SELECT NVL(CS.ClaveSesasNEW, '1')      ClaveSesas
               , NVL(CS.OrdenSesas, 0)        OrdenSesas
               , CS.CodCobert
               , ((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )))  MontoReclamado
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
          GROUP BY NVL(CS.ClaveSesasNEW, '1'), NVL(CS.OrdenSesas, 0), CS.CodCobert,((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )))
          UNION
          SELECT NVL(CS.ClaveSesasNEW, '1')      ClaveSesas
               , NVL(CS.OrdenSesas, 0)        OrdenSesas
               , CS.CodCobert
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
          GROUP BY NVL(CS.ClaveSesasNEW, '1'), NVL(CS.OrdenSesas, 0), CS.CodCobert,((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )));

        */
    BEGIN

EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.LOGERRORES_SESAS');
/*
        DELETE SICAS_OC.SESAS_SINIESTROS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario;

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
*/
        
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY')|| ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY')|| ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        FOR x IN cSiniestros LOOP
            FOR y IN cCoberturas(x.IdPoliza, x.NumSiniestro) LOOP
                dFecConSin := NULL;
                dFecPagSin := NULL;
                nMontoPagSin := NULL;
                nNumAprobacion := NULL;
                nIdTransaccion := NULL;
                SICAS_OC.OC_PROCESOSSESAS.DATOSSINIESTROS(nCodCia, nCodEmpresa, x.IdPoliza, x.NumSiniestro, ''/*y.CodCobert*/,
                                                         dFecPagSin, nMontoPagSin, dFecConSin);

             /* IF dFecPagSin < dFecDesde OR dFecPagSin > dFecHasta THEN
                dFecPagSin := NULL;
            ELSIF dFecPagSin IS NULL THEN

            END IF;*/

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

              /*
              BEGIN
                 SELECT deducible_moneda
                 INTO   nMontoDeducible
                 FROM   SICAS_OC.COBERT_ACT_ASEG
                 WHERE  CodCia        = nCodCia
                   AND  IdPoliza      = x.IdPoliza
                   AND  IdetPol       = x.IdetPol
                   AND  Cod_Asegurado = x.Cod_Asegurado
                   AND  CodCobert     = y.CodCobert;

              EXCEPTION
                WHEN OTHERS THEN
                 BEGIN
                     SELECT deducible_moneda
                        INTO   nMontoDeducible
                         FROM   SICAS_OC.COBERT_ACT
                         WHERE  CodCia        = nCodCia
                           AND  IdPoliza      = x.IdPoliza
                           AND  IdetPol       = x.IdetPol
                           AND  Cod_Asegurado = x.Cod_Asegurado
                           AND  CodCobert     = y.CodCobert;
                 EXCEPTION
                    WHEN OTHERS THEN
                        BEGIN   
                            SELECT MONTODEDUCIBLE
                            INTO nMontoDeducible
                            FROM SICAS_OC.POLIZAS
                            WHERE IdPoliza      = x.IdPoliza;
                        EXCEPTION
                            WHEN OTHERS THEN
                                nMontoDeducible:= 0;
                        END;
                END;
              END;
              */
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
                        NULL/*cNumReclamacion*/,
                        x.FecOcuSin,
                        x.FecRepSin,
                        dFecConSin,
                        dFecPagSin,
                        '',--x.StatusReclamacion,
                        x.EntOcuSin,
                        y.ClaveSesas,
                        nMontoReclamo,
                        x.CausaSiniestro,
                        NVL(x.MONTODEDUCIBLE, 0),
                        NULL/*nMontoCoaseguro*/,
                        NVL(y.MontoPagado, 0),
                        NVL(x.MontoRecRea, 0),
                        NULL/*nMontoDividendo*/,
                        x.TipMovRec,
                        NVL(x.MontoVencimiento, 0),
                        NULL/*nMontoRescate*/,
                        NULL/*cTipoGasto*/,
                        NULL/*PeriodoEspera*/,
                        NULL/*cTipoPago*/,
                        x.Sexo,
                        x.FecNacim,
                        y.OrdenSesas
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        UPDATE SICAS_OC.SESAS_SINIESTROS
                        SET    MontoReclamado   = NVL(MontoReclamado  , 0) + NVL(nMontoReclamo  , 0)
                          /*,    MontoDeducible   = NVL(MontoDeducible  , 0) + NVL(NULL/*nMontoDeducible  , 0)
                          ,  */
                            ,MontoCoaseguro = NVL(MontoCoaseguro, 0) + NVL(NULL/*nMontoCoaseguro*/, 0)
                          ,    MontoPagSin      = MontoPagSin + NVL(y.MontoPagado, 0)

                           , MontoRecRea = NVL(MontoRecRea, 0) + NVL(nMontoRecRea, 0),
                            MontoDividendo = NVL(MontoDividendo, 0) + NVL(NULL/*nMontoDividendo*/, 0),
                            MontoVencimiento = NVL(MontoVencimiento, 0) + NVL(nMontoVencimiento, 0),
                            MontoRescate = NVL(MontoRescate, 0) + NVL(NULL/*nMontoRescate */, 0),
                                            fechainsert = sysdate
                        WHERE CodCia = nCodCia
                            AND CodEmpresa = nCodEmpresa
                            AND CodReporte = cCodReporteProces
                            AND CodUsuario = cCodUsuario
                            AND NumPoliza = x.NumPoliza
                            --AND NumCertificado = x.NumCertificado
                            AND NumSiniestro = x.NumSiniestro

                            AND Cobertura = y.ClaveSesas;

                    
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, x.NumPoliza,x.NumCertificado, SQLCODE, SQLERRM);
                END;

                BEGIN
                    SELECT MAX(FECRES)
                    INTO dFecPagSin
                    FROM SICAS_OC.COBERTURA_SINIESTRO_ASEG
                    WHERE IDPOLIZA = x.IdPoliza
                        AND IDSINIESTRO = x.NumSiniestro
                        AND Cod_Asegurado = x.Cod_Asegurado;

                EXCEPTION
                    WHEN OTHERS THEN
                        dFecPagSin := NULL;
                END;

                UPDATE SICAS_OC.SESAS_SINIESTROS
                SET STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINVII(nCodCia, x.IdPoliza, x.NumSiniestro, '', NVL(y.MontoPagado, 0), nMontoReclamo, 'SINVIG'),
                    FECPAGSIN = dFecPagSin,
                                            fechainsert = sysdate
                WHERE NUMPOLIZA = x.NumPoliza
                    AND NUMSINIESTRO = x.NumSiniestro;--OrdeSesas


            END LOOP;
        END LOOP;

        UPDATE SICAS_OC.SESAS_SINIESTROS
        SET STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINVII(CodCia, NULL, NumSiniestro, StatusReclamacion, MONTOPAGSIN, MONTORECLAMADO, 'SINVIG'),
            FECPAGSIN = CASE WHEN MONTOPAGSIN = 0 THEN NULL ELSE FECPAGSIN END,
                                            fechainsert = sysdate
        WHERE
                NUMPOLIZA = NumPoliza
            AND NUMSINIESTRO = NumSiniestro;--OrdeSesas

        
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
      --
        nCodCia2          SICAS_OC.SESAS_DATGEN.CODCIA%TYPE;
        nCodEmpresa2      SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE;
        nIdPoliza         SICAS_OC.SESAS_DATGEN.IDPOLIZA%TYPE;
        nIDetPol          SICAS_OC.SESAS_DATGEN.IDETPOL%TYPE;
        nComisionDirecta  SICAS_OC.SESAS_DATGEN.COMISIONDIRECTA%TYPE;
        nCantCertificados SICAS_OC.SESAS_DATGEN.CANTCERTIFICADOS%TYPE;
        cFormaVta         SICAS_OC.SESAS_DATGEN.FORMAVTA%TYPE;
      --
      CURSOR c_Llenado IS
       SELECT CODCIA,CODEMPRESA,CODREPORTE,CODUSUARIO,NUMPOLIZA NUMPOLIZA,IDPOLIZA,COUNT(1) TOTAL
        FROM SICAS_OC.SESAS_DATGEN
        WHERE CODCIA = nCodCia
            AND CODEMPRESA = nCodEmpresa
            AND CODREPORTE = cCodReporteProces
            AND CODUSUARIO = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0'
            GROUP BY CODCIA,CODEMPRESA,CODREPORTE,CODUSUARIO,NUMPOLIZA;


    TYPE rec_sesaslleno IS RECORD (
        CODCIA          NUMBER,
        CODEMPRESA      NUMBER,
        CODREPORTE      VARCHAR2(40),
        CODUSUARIO      VARCHAR2(40),
        NUMPOLIZA       VARCHAR2(30),
        IDPOLIZA        NUMBER,
        TOTAL           NUMBER);

    TYPE type_sesaslleno IS TABLE OF rec_sesaslleno  INDEX BY PLS_INTEGER ;
        obj_sesaslleno   type_sesaslleno;

        TYPE rec_sesasdatgen IS RECORD (
            CODCIA           NUMBER,
            CODEMPRESA       NUMBER,
            CODREPORTE       VARCHAR2(40),
            CODUSUARIO       VARCHAR2(40),
            NUMPOLIZA        VARCHAR2(340),
            NUMCERTIFICADO   VARCHAR2(40),
            TIPOSEGURO       VARCHAR2(4),
            MONEDA           VARCHAR2(4),
            ENTIDADASEGURADO VARCHAR2(4),
            FECINIVIG        DATE,
            FECFINVIG        DATE,
            FECALTCERT       DATE,
            FECBAJCERT       DATE,
            FECNACIM         DATE,
            FECEMISION       DATE,
            SEXO             VARCHAR2(4),
            STATUSCERT       VARCHAR2(4),
            SUBTIPOSEG       VARCHAR2(4),
            TIPODIVIDENDO    VARCHAR2(4),
            ANIOPOLIZA       NUMBER,
            OCUPACION        VARCHAR2(8),
            TIPORIESGO       VARCHAR2(8),
            PRIMACEDIDA      NUMBER,
            MONTODIVIDENDO   NUMBER,
            IDPOLIZA         NUMBER,
            IDETPOL          NUMBER,
            Cod_Asegurado    NUMBER,
            CantAsegModelo   NUMBER,
            PolConcentrada   VARCHAR2(80),
            IndAsegModelo    VARCHAR2(5),
            IdEndoso         NUMBER,
            PLANPOLIZA       VARCHAR2(8),
            MODALIDADPOLIZA  VARCHAR2(9),
            PLAZOPAGOPRIMA   NUMBER,
            COASEGURO        VARCHAR2(5),
            EMISION          VARCHAR2(5),
            SDOFONINV        NUMBER,
            SDOFONADM        NUMBER
        );
        TYPE type_sesasdatgen IS TABLE OF rec_sesasdatgen;
        obj_sesasdatgen   type_sesasdatgen;

        CURSOR C_POL_IND_Q IS
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))
                || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))|| TRIM(LPAD(D.IDetPol, 2, '0'))|| TRIM(LPAD(D.Cod_Asegurado, 10, '0')))           NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, P.IdPoliza)                                                    TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20','30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta)                                     FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, XX.FecAnulExclu, dFecDesde, dFecHasta)            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(XX.Cod_Asegurado,D.Cod_Asegurado)  )          StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERTAP(D.CodCia, D.IdPoliza, D.IDETPOL, XX.FecAnulExclu, dFecHasta, XX.ESTADO, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            /*(
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )    */CASE WHEN NVL(P.NumRenov,0) = 0 THEN  SICAS_OC.OC_PROCESOSSESAS.GETANIOPOLIZA(P.NUMPOLUNICO)  ELSE  P.NumRenov + 1 END    AnioPoliza,
            SICAS_OC.OC_PROCESOSSESAS.GETOCUPACIONAP(PN.CodActividad,'APC')                                                                          Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            0                                                                                                                     PrimaCedida      --Por Default
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo   --Por Default
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            D.CantAsegModelo CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            0                                                                                                                     IdEndoso,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            (  CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END  )                                                                                                                     PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, NULL)                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA           D ON  D.IdPoliza = P.IdPoliza 
                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                AND D.CodCia = P.CodCia
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg

            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                            AND XX.IdPoliza = D.IdPoliza
                                                            AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = XX.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        WHERE (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)
            /*( ( D.FecFinVig BETWEEN dvarFecDesde AND dvarFecHasta  )
              OR ( D.FecIniVig BETWEEN dvarFecDesde AND dvarFecHasta
                   AND P.FecEmision <= dvarFecHasta )
                OR ( P.FECEMISION BETWEEN dvarFecDesde AND dvarFecHasta ) )*/

            AND ( PC.CodTipoPlan IN ( '032', '033' )
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
                            SICAS_OC.COBERTURA_ASEG X
                        WHERE
                                X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQC' ) )
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND P.CodEmpresa = nCodEmpresa
            AND P.CodCia = nCodCia
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND ( ( D.IndAsegModelo = 'S'
                    AND NOT EXISTS (
                SELECT
                    'N'
                FROM
                    SICAS_OC.ENDOSOS
                WHERE
                        IdPoliza = D.IdPoliza
                    AND CodEmpresa = D.CodEmpresa
                    AND CodCia = D.CodCia
                    AND IDetPol = D.IDetPol
                    AND TipoEndoso = 'ESV'
                    AND MotivAnul = 'CONSAS'
            ) )
                  OR ( D.IndAsegModelo = 'N' ) )
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

        CURSOR C_POL_COL_Q IS
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(AC.IdPoliza, 8, '0'))
                || TRIM(LPAD(AC.IDetPol, 2, '0'))
                || TRIM(LPAD(AC.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, P.IdPoliza)                                                    TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20',
                   '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta)                                     FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, AC.FecAnulExclu,dFecDesde,  dFecHasta)            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL, D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(AC.Cod_Asegurado,D.Cod_Asegurado) )          StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERTAP(D.CodCia, D.IdPoliza, D.IDETPOL, AC.FecAnulExclu, dFecHasta,
                                                    AC.ESTADO, D.FecIniVig, D.FecFinVig, NVL(AC.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            /*(
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            ) */CASE WHEN NVL(P.NumRenov,0) = 0 THEN  SICAS_OC.OC_PROCESOSSESAS.GETANIOPOLIZA(P.NUMPOLUNICO)  ELSE  P.NumRenov + 1 END     AnioPoliza,
            SICAS_OC.OC_PROCESOSSESAS.GETOCUPACIONAP(PN.CodActividad,'APC')                                                                          Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            0                                                                                                                     PrimaCedida      --Por Default
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo   --Por Default
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(AC.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            D.CantAsegModelo CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            0                                                                                                                     IdEndoso,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, NULL)                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA           D ON D.IdPoliza = P.IdPoliza
                                                    AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                                                    AND D.CodCia = P.CodCia
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    AC ON AC.CodCia = D.CodCia
                                                            AND AC.IdPoliza = D.IdPoliza
                                                            AND AC.IDetPol = D.IDetPol
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = AC.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
        /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg
			AND CAS.PLANCOB 			= PC.PLANCOB*/
        WHERE (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)
            /*( ( D.FecFinVig BETWEEN dvarFecDesde AND dvarFecHasta )
              OR ( D.FecIniVig BETWEEN dvarFecDesde AND dvarFecHasta
                   AND P.FecEmision <= dvarFecHasta  )
            OR ( P.FECEMISION BETWEEN dvarFecDesde AND dvarFecHasta ))*/

            AND ( PC.CodTipoPlan IN ( '032', '033' )
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
                        FROM SICAS_OC.COBERTURA_ASEG X
                        WHERE X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )  )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQC' ) )
            AND P.CodEmpresa = nCodEmpresa
            AND P.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
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

        CURSOR C_POL_IND_MOV_Q IS
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
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, P.IdPoliza)                                                    TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20',
                   '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta)                                     FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, XX.FecAnulExclu, dFecDesde, dFecHasta)            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig ,NVL(XX.Cod_Asegurado,D.Cod_Asegurado) )          StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERTAP(D.CodCia, D.IdPoliza, D.IDETPOL, XX.FecAnulExclu, dFecHasta,
                                                    XX.ESTADO, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            /*(
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )*/CASE WHEN NVL(P.NumRenov,0) = 0 THEN  SICAS_OC.OC_PROCESOSSESAS.GETANIOPOLIZA(P.NUMPOLUNICO)  ELSE  P.NumRenov + 1 END   AnioPoliza,
            SICAS_OC.OC_PROCESOSSESAS.GETOCUPACIONAP(PN.CodActividad,'APC')                                                                          Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            0                                                                                                                     PrimaCedida      --Por Default
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo   --Por Default
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            D.CantAsegModelo  CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            0                                                                                                                     IdEndoso,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, NULL)                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm
        FROM
                 SICAS_OC.POLIZAS P
                 INNER JOIN SICAS_OC.DETALLE_POLIZA D
            ON D.IdPoliza = P.IdPoliza
                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                AND D.CodCia = P.CodCia                                     
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
       /* INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg
			AND CAS.PLANCOB 			= PC.PLANCOB*/
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                            AND XX.IdPoliza = D.IdPoliza
                                                            AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = XX.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        WHERE  /*(PC.CodTipoPlan = '033'

                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQC')))*/
            D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND ( PC.CodTipoPlan IN ( '032', '033' )
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
                        FROM SICAS_OC.COBERTURA_ASEG X
                        WHERE X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                   AND PC.CodTipoPlan = '099'
                   AND PC.IdTipoSeg = 'PPAQC' ) )
           /* AND NOT EXISTS (SELECT 'N'
                            FROM   SICAS_OC.ASEGURADO_CERTIFICADO
                            WHERE  CodCia        = D.CodCia
                                AND  IdPoliza      = D.IdPoliza
                                AND  IdetPol       = D.IDetPol
                                AND  Cod_Asegurado = D.Cod_Asegurado ) */
            AND EXISTS (
                SELECT  'S'
                FROM SICAS_OC.TRANSACCION T
                INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT 
                    ON DT.IdTransaccion = T.IdTransaccion
                    AND DT.CodCia = T.CodCia
                    AND DT.CodEmpresa = T.CodEmpresa
                WHERE DT.Valor1 = D.IdPoliza
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'ESVTL', 'PAG', 'EMIPRD', 'PAGPRD',
                                                  'APLPRD', 'ANUPRD', 'REVPPD' )
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso != 6
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND P.CodEmpresa = nCodEmpresa
            AND P.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND D.FecFinVig < dvarFecDesde
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND P.IdPoliza IN (
                SELECT IdPoliza
                FROM SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) );

        CURSOR C_POL_COL_MOV_Q IS
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(AC.IdPoliza, 8, '0'))
                || TRIM(LPAD(AC.IDetPol, 2, '0'))
                || TRIM(LPAD(AC.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, P.IdPoliza)                                                    TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20', '30')                                                                    Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta)                                     FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, AC.FecAnulExclu, dFecDesde, dFecHasta)            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(AC.Cod_Asegurado,D.Cod_Asegurado) )          StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERTAP(D.CodCia, D.IdPoliza, D.IDETPOL, AC.FecAnulExclu, dFecHasta,
                                                    AC.ESTADO, D.FecIniVig, D.FecFinVig, NVL(AC.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            /*( CASE WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN  1
                    ELSE CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END ) */
            CASE WHEN NVL(P.NumRenov,0) = 0 THEN  SICAS_OC.OC_PROCESOSSESAS.GETANIOPOLIZA(P.NUMPOLUNICO)  ELSE  P.NumRenov + 1 END    AnioPoliza,
            SICAS_OC.OC_PROCESOSSESAS.GETOCUPACIONAP(PN.CodActividad,'APC')                                                                          Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            0                                                                                                                     PrimaCedida      --Por Default
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo   --Por Default
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(AC.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            D.CantAsegModelo CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            0                                                                                                                     IdEndoso,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            ( CASE WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN 1
                    ELSE CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) END )                                              PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, NULL)                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm
        FROM SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA    D             
            ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            AND D.CodCia = P.CodCia

            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    AC ON AC.CodCia = D.CodCia
                                                            AND AC.IDetPol = D.IDetPol
                                                            AND AC.IdPoliza = D.IdPoliza
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = AC.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
        /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg
			AND CAS.PLANCOB 			= PC.PLANCOB*/
        WHERE  /*(PC.CodTipoPlan = '033'

                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQC')))*/
            ( PC.CodTipoPlan IN ( '032', '033' )
              OR ( EXISTS (
                SELECT  'S'
                FROM  SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                WHERE CAS.CODCIA = D.CodCia
                    AND CAS.CodEmpresa = D.CodEmpresa
                    AND CAS.IDTIPOSEG = D.IdTipoSeg
                    AND CAS.PLANCOB = D.PLANCOB
                    AND CAS.IDRAMOREAL = '030'
                    AND CAS.CODCOBERT IN (
                        SELECT  CODCOBERT
                        FROM SICAS_OC.COBERTURA_ASEG X
                        WHERE  X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                   AND PC.CodTipoPlan = '099'
                   AND PC.IdTipoSeg = 'PPAQC' ) )
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.FecFinVig < dvarFecDesde
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND EXISTS (
                SELECT  'S'
                FROM SICAS_OC.TRANSACCION T
                INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT 
                    ON DT.IdTransaccion = T.IdTransaccion
                    AND DT.CodCia = T.CodCia
                WHERE DT.Valor1 = D.IdPoliza
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'ESVTL', 'PAG', 'EMIPRD', 'PAGPRD', 'APLPRD', 'ANUPRD', 'REVPPD' )
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso != 6
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND P.IdPoliza IN (
                SELECT IdPoliza
                FROM SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE  CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) )
        MINUS
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(AC.IdPoliza, 8, '0'))
                || TRIM(LPAD(AC.IDetPol, 2, '0'))
                || TRIM(LPAD(AC.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, P.IdPoliza)                                                    TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20',
                   '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert
           --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT( D.IdPoliza, D.FecIniVig ,D.FecFinVig,P.FecAnul,dFecHasta)                                     FecBajCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, AC.FecAnulExclu, dFecDesde, dFecHasta)            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
           --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT( D.CodCia, D.IdPoliza,D.IDETPOL,  D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(AC.Cod_Asegurado,D.Cod_Asegurado) )          StatusCert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERTAP(D.CodCia, D.IdPoliza, D.IDETPOL, AC.FecAnulExclu, dFecHasta,
                                                    AC.ESTADO, D.FecIniVig, D.FecFinVig, NVL(AC.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            /*( CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            ) */CASE WHEN NVL(P.NumRenov,0) = 0 THEN  SICAS_OC.OC_PROCESOSSESAS.GETANIOPOLIZA(P.NUMPOLUNICO)  ELSE  P.NumRenov + 1 END   AnioPoliza,
            SICAS_OC.OC_PROCESOSSESAS.GETOCUPACIONAP(PN.CodActividad,'APC')                                                                          Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            0                                                                                                                     PrimaCedida      --Por Default
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo   --Por Default
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(AC.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            D.CantAsegModelo        CantAsegModelo,
            DECODE(NVL(P.IndConcentrada, 'N'), 'N', 0, 1)                                                                         PolConcentrada,
            D.IndAsegModelo                                                                                                       IndAsegModelo,
            0                                                                                                                     IdEndoso,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */        PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            ( CASE WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN 1
                    ELSE CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) END )                                              PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, NULL)                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, D.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, D.IdPoliza)                                                          SdoFonAdm
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA D
            ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            AND D.CodCia = P.CodCia
        INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    AC 
            ON AC.CodCia = D.CodCia
            AND AC.IdPoliza = D.IdPoliza
            AND AC.IDetPol = D.IDetPol
        INNER JOIN SICAS_OC.ASEGURADO                A 
            ON A.Cod_Asegurado = AC.Cod_Asegurado
        INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN 
            ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
            AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC 
            ON PC.IdTipoSeg = D.IdTipoSeg
            AND PC.CodEmpresa = D.CodEmpresa
            AND PC.CodCia = D.CodCia
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
        WHERE   /*(PC.CodTipoPlan = '033'

                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQC')))*/
            D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND ( PC.CodTipoPlan IN ( '032', '033' )
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
                            SICAS_OC.COBERTURA_ASEG X
                        WHERE
                                X.IDPOLIZA = D.IDPOLIZA
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                   AND PC.CodTipoPlan = '099'
                   AND PC.IdTipoSeg = 'PPAQC' ) )
           /* AND ( ( D.FecFinVig BETWEEN dvarFecDesde AND dvarFecHasta  )
                  OR ( D.FecIniVig BETWEEN dvarFecDesde AND dvarFecHasta
                       AND P.FecEmision <= dvarFecHasta)
               )*/
            AND (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)
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

    BEGIN
EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.LOGERRORES_SESAS');
/*
        DELETE SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'--(SELECT MIN(NUMPOLIZA) FROM SESAS_DATGEN)
            AND NUMCERTIFICADO >= '0'--(SELECT MIN(NUMCERTIFICADO) FROM SESAS_DATGEN)
            ;

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;

        */

        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');

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
            BULK COLLECT INTO obj_sesasdatgen;
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
            
            nCantCertificados := CASE WHEN NVL(obj_sesasdatgen(x).IndAsegModelo, 'N') = 'S' THEN SICAS_OC.OC_PROCESOSSESAS.GETCANTASEGAPC( obj_sesasdatgen(x).CodCia,obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).Cod_Asegurado,obj_sesasdatgen(x).CantAsegModelo) ELSE  1 END;
            
                IF nCodCia2 <> obj_sesasdatgen(x).CodCia OR nCodEmpresa2 <> obj_sesasdatgen(x).CodEmpresa OR nIdPoliza <> obj_sesasdatgen(x).IdPoliza OR nIDetPol <> obj_sesasdatgen(x).IDetPol THEN
                    nCodCia2 := obj_sesasdatgen(x).CodCia;
                    nCodEmpresa2 := obj_sesasdatgen(x).CodEmpresa;
                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).IdPoliza, dFecDesde, dFecHasta);

                    --nCantCertificados := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS_2(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x). CodEmpresa, obj_sesasdatgen(x).IdPoliza, obj_sesasdatgen(x).IDetPol, obj_sesasdatgen(x).IndAsegModelo, obj_sesasdatgen(x).CantAsegModelo, obj_sesasdatgen(x).PolConcentrada, obj_sesasdatgen(x).IdEndoso);

                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).IdPoliza);

                END IF;
/*
               BEGIN
                    SELECT SUM(PRIMANETA_MONEDA)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol;

                    SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMANETA_MONEDA) *(ROUND((nComisionDirecta / 100), 10)), 0)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol
                        AND COD_ASEGURADO = obj_sesasdatgen(x).Cod_Asegurado;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN 
                        BEGIN                        
                            SELECT SUM(PRIMA_MONEDA)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL >= 0;

                            SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMA_MONEDA) *(ROUND((nComisionDirecta / 100),10)), 0)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL = obj_sesasdatgen(x).IDetPol
                                AND COD_ASEGURADO = obj_sesasdatgen(x).Cod_Asegurado;
                        EXCEPTION
                            WHEN OTHERS THEN 
                                nComisionDirecta2 := nComisionDirecta;
                        END;
                    WHEN OTHERS THEN
                        nComisionDirecta2 := nComisionDirecta;
                END;
*/
          --Inserto lo que antes era el cursor: POL_IND_Q
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
                        NUMASEGPOL,
                        PlanPoliza,
                        ModalidadPoliza,
                        PlazoPagoPrima,
                        Coaseguro,
                        Emision,
                        SdoFonInv,
                        SdoFonAdm
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        NVL(obj_sesasdatgen(x).EntidadAsegurado,'09'),
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        cFormaVta,
                        obj_sesasdatgen(x).SubTipoSeg,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).AnioPoliza,
                        obj_sesasdatgen(x).Ocupacion,
                        obj_sesasdatgen(x).TipoRiesgo,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta, 2),
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).Cod_Asegurado,
                        nCantCertificados,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).PlazoPagoPrima,
                        obj_sesasdatgen(x).Coaseguro,
                        obj_sesasdatgen(x).Emision,
                        obj_sesasdatgen(x).SdoFonInv,
                        obj_sesasdatgen(x).SdoFonAdm
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen( x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen( x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_IND_Q;
        
      /*
      FOR x IN C_POL_IND_Q LOOP
          --Afinación
          IF nCodCia2 <> x.CodCia OR nCodEmpresa2 <> x.CodEmpresa OR nIdPoliza <> x.IdPoliza OR nIDetPol <> x.IDetPol THEN
             nCodCia2           := x.CodCia;
             nCodEmpresa2       := x.CodEmpresa;
             nIdPoliza          := x.IdPoliza;
             nIDetPol           := x.IDetPol;
             nComisionDirecta   := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP( x.CodCia, x.CodEmpresa, x.IdPoliza, dFecDesde, dFecHasta );
             nCantCertificados  := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS_2( x.CodCia, x.CodEmpresa, x.IdPoliza, x.IDetPol, x.IndAsegModelo, x.CantAsegModelo, x.PolConcentrada, x.IdEndoso );
             cFormaVta          := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA( x.CodCia, x.IdPoliza );
          END IF;
          --
          --Inserto lo que antes era el cursor: POL_IND_Q
          INSERT INTO SICAS_OC.SESAS_DATGEN
             ( CodCia    , CodEmpresa   , CodReporte, CodUsuario, NumPoliza , NumCertificado, TipoSeguro     , Moneda        , EntidadAsegurado,
               FecIniVig , FecFinVig    , FecAltCert, FecBajCert, FecNacim  , FecEmision    , Sexo           , StatusCert    , FormaVta        ,
               SubTipoSeg, TipoDividendo, AnioPoliza, Ocupacion , TipoRiesgo, PrimaCedida   , ComisionDirecta, MontoDividendo, IdPoliza        ,
               IDetPol   , CodAsegurado , CantCertificados,PlanPoliza, ModalidadPoliza, PlazoPagoPrima, Coaseguro, Emision, SdoFonInv, SdoFonAdm )
          VALUES ( x.CodCia    , x.CodEmpresa   , x.CodReporte, x.CodUsuario, x.NumPoliza , x.NumCertificado, x.TipoSeguro    , x.Moneda        , x.EntidadAsegurado,
                   x.FecIniVig , x.FecFinVig    , x.FecAltCert, x.FecBajCert, x.FecNacim  , x.FecEmision    , x.Sexo          , x.StatusCert    , cFormaVta         ,
                   x.SubTipoSeg, x.TipoDividendo, x.AnioPoliza, x.Ocupacion , x.TipoRiesgo, x.PrimaCedida   , nComisionDirecta, x.MontoDividendo, x.IdPoliza        ,
                   x.IDetPol   , x.Cod_Asegurado, nCantCertificados , x.PlanPoliza, x.ModalidadPoliza, x.PlazoPagoPrima, x.Coaseguro, x.Emision, x.SdoFonInv, x.SdoFonAdm );
      END LOOP;
      */

      --Inicializo variables de Afinación
        nCodCia2 := 0;
        nCodEmpresa2 := 0;
        nIdPoliza := 0;
        nIDetPol := 0;
        nComisionDirecta := 0;
        nCantCertificados := 0;
        cFormaVta := NULL;
        OPEN C_POL_COL_Q;
        LOOP
            FETCH C_POL_COL_Q
            BULK COLLECT INTO obj_sesasdatgen;
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
                
                nCantCertificados := CASE WHEN NVL(obj_sesasdatgen(x).IndAsegModelo, 'N') = 'S' THEN SICAS_OC.OC_PROCESOSSESAS.GETCANTASEGAPC( obj_sesasdatgen(x).CodCia,obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).Cod_Asegurado,obj_sesasdatgen(x).CantAsegModelo) ELSE  1 END;
                
                IF nCodCia2 <> obj_sesasdatgen(x).CodCia OR nCodEmpresa2 <> obj_sesasdatgen(x).CodEmpresa OR nIdPoliza <> obj_sesasdatgen(x).IdPoliza OR nIDetPol <> obj_sesasdatgen(x).IDetPol THEN
                    nCodCia2 := obj_sesasdatgen(x).CodCia;
                    nCodEmpresa2 := obj_sesasdatgen(x).CodEmpresa;
                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa,
                    obj_sesasdatgen(x).IdPoliza, dFecDesde, dFecHasta);

                    --nCantCertificados := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS_2(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).IdPoliza, obj_sesasdatgen(x).IDetPol, obj_sesasdatgen(x).IndAsegModelo,obj_sesasdatgen(x).CantAsegModelo, obj_sesasdatgen(x).PolConcentrada, obj_sesasdatgen(x).IdEndoso);
                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).IdPoliza);

                END IF;
/*
                BEGIN
                    SELECT SUM(PRIMANETA_MONEDA)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol;

                    SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMANETA_MONEDA) *(ROUND((nComisionDirecta / 100), 10)), 0)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol
                        AND COD_ASEGURADO = obj_sesasdatgen(x).Cod_Asegurado;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN 
                        BEGIN                        
                            SELECT SUM(PRIMA_MONEDA)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL >= 1
                                AND CODCIA = obj_sesasdatgen(x).CodCia ;

                            SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMA_MONEDA) *(ROUND((nComisionDirecta / 100),10)), 0)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL = obj_sesasdatgen(x).IDetPol
                                AND COD_ASEGURADO = obj_sesasdatgen(x).Cod_Asegurado;
                        EXCEPTION
                            WHEN OTHERS THEN 
                                nComisionDirecta2 := nComisionDirecta;
                        END;
                    WHEN OTHERS THEN
                        nComisionDirecta2 := nComisionDirecta;
                END;
*/
          --Inserto lo que antes era el cursor: POL_COL_Q
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
                        NUMASEGPOL,
                        PlanPoliza,
                        ModalidadPoliza,
                        PlazoPagoPrima,
                        Coaseguro,
                        Emision,
                        SdoFonInv,
                        SdoFonAdm
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        NVL(obj_sesasdatgen(x).EntidadAsegurado,'09'),
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        cFormaVta,
                        obj_sesasdatgen(x).SubTipoSeg,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).AnioPoliza,
                        obj_sesasdatgen(x).Ocupacion,
                        obj_sesasdatgen(x).TipoRiesgo,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta, 2),
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).Cod_Asegurado,
                        nCantCertificados,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).PlazoPagoPrima,
                        obj_sesasdatgen(x).Coaseguro,
                        obj_sesasdatgen(x).Emision,
                        obj_sesasdatgen(x).SdoFonInv,
                        obj_sesasdatgen(x).SdoFonAdm
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_COL_Q;
        
      /*
      FOR x IN C_POL_COL_Q LOOP
          --Afinación
          IF nCodCia2 <> x.CodCia OR nCodEmpresa2 <> x.CodEmpresa OR nIdPoliza <> x.IdPoliza OR nIDetPol <> x.IDetPol THEN
             nCodCia2           := x.CodCia;
             nCodEmpresa2       := x.CodEmpresa;
             nIdPoliza          := x.IdPoliza;
             nIDetPol           := x.IDetPol;
             nComisionDirecta   := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP( x.CodCia, x.CodEmpresa, x.IdPoliza, dFecDesde, dFecHasta );
             nCantCertificados  := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS_2( x.CodCia, x.CodEmpresa, x.IdPoliza, x.IDetPol, x.IndAsegModelo, x.CantAsegModelo, x.PolConcentrada, x.IdEndoso );
             cFormaVta          := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA( x.CodCia, x.IdPoliza );
          END IF;
          --
          --Inserto lo que antes era el cursor: POL_COL_Q
          INSERT INTO SICAS_OC.SESAS_DATGEN
             ( CodCia    , CodEmpresa   , CodReporte, CodUsuario, NumPoliza , NumCertificado, TipoSeguro     , Moneda        , EntidadAsegurado,
               FecIniVig , FecFinVig    , FecAltCert, FecBajCert, FecNacim  , FecEmision    , Sexo           , StatusCert    , FormaVta        ,
               SubTipoSeg, TipoDividendo, AnioPoliza, Ocupacion , TipoRiesgo, PrimaCedida   , ComisionDirecta, MontoDividendo, IdPoliza        ,
               IDetPol   , CodAsegurado , CantCertificados, PlanPoliza, ModalidadPoliza, PlazoPagoPrima , Coaseguro, Emision, SdoFonInv, SdoFonAdm )
          VALUES ( x.CodCia    , x.CodEmpresa   , x.CodReporte, x.CodUsuario, x.NumPoliza , x.NumCertificado, x.TipoSeguro    , x.Moneda        , x.EntidadAsegurado,
                   x.FecIniVig , x.FecFinVig    , x.FecAltCert, x.FecBajCert, x.FecNacim  , x.FecEmision    , x.Sexo          , x.StatusCert    , cFormaVta         ,
                   x.SubTipoSeg, x.TipoDividendo, x.AnioPoliza, x.Ocupacion , x.TipoRiesgo, x.PrimaCedida   , nComisionDirecta, x.MontoDividendo, x.IdPoliza        ,
                   x.IDetPol   , x.Cod_Asegurado, nCantCertificados, x.PlanPoliza, x.ModalidadPoliza, x.PlazoPagoPrima, x.Coaseguro, x.Emision, x.SdoFonInv, x.SdoFonAdm  );
      END LOOP;
      */
      --
      --Inicializo variables de Afinación
        nCodCia2 := 0;
        nCodEmpresa2 := 0;
        nIdPoliza := 0;
        nIDetPol := 0;
        nComisionDirecta := 0;
        nCantCertificados := 0;
        cFormaVta := NULL;
        OPEN C_POL_IND_MOV_Q;
        LOOP
            FETCH C_POL_IND_MOV_Q
            BULK COLLECT INTO obj_sesasdatgen;
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
            
                nCantCertificados := CASE WHEN NVL(obj_sesasdatgen(x).IndAsegModelo, 'N') = 'S' THEN SICAS_OC.OC_PROCESOSSESAS.GETCANTASEGAPC( obj_sesasdatgen(x).CodCia,obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).Cod_Asegurado,obj_sesasdatgen(x).CantAsegModelo) ELSE  1 END;
                
                IF nCodCia2 <> obj_sesasdatgen(x).CodCia OR nCodEmpresa2 <> obj_sesasdatgen(x).CodEmpresa OR nIdPoliza <> obj_sesasdatgen(x).IdPoliza OR nIDetPol <> obj_sesasdatgen(x).IDetPol THEN
                    nCodCia2 := obj_sesasdatgen(x).CodCia;
                    nCodEmpresa2 := obj_sesasdatgen(x).CodEmpresa;
                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa,
                    obj_sesasdatgen(x).IdPoliza, dFecDesde, dFecHasta);

                    --nCantCertificados := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS_2(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).IdPoliza, obj_sesasdatgen(x).IDetPol, obj_sesasdatgen(x).IndAsegModelo,obj_sesasdatgen(x).CantAsegModelo, obj_sesasdatgen(x).PolConcentrada, obj_sesasdatgen(x).IdEndoso);
                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).IdPoliza);

                END IF;
/*
                BEGIN
                    SELECT SUM(PRIMANETA_MONEDA)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol;

                    SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMANETA_MONEDA) *(ROUND((nComisionDirecta / 100), 10)), 0)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol
                        AND COD_ASEGURADO = obj_sesasdatgen(x).Cod_Asegurado;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN 
                        BEGIN                        
                            SELECT SUM(PRIMA_MONEDA)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL >= 1;

                            SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMA_MONEDA) *(ROUND((nComisionDirecta / 100),10)), 0)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL = obj_sesasdatgen(x).IDetPol
                                AND COD_ASEGURADO = obj_sesasdatgen(x).Cod_Asegurado;
                        EXCEPTION
                            WHEN OTHERS THEN 
                                nComisionDirecta2 := nComisionDirecta;
                        END;
                    WHEN OTHERS THEN
                        nComisionDirecta2 := nComisionDirecta;
                END;
*/
                --Inserto lo que antes era el cursor: POL_IND_MOV_Q
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
                        NUMASEGPOL,
                        PlanPoliza,
                        ModalidadPoliza,
                        PlazoPagoPrima,
                        Coaseguro,
                        Emision,
                        SdoFonInv,
                        SdoFonAdm
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        NVL(obj_sesasdatgen(x).EntidadAsegurado,'09'),
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        cFormaVta,
                        obj_sesasdatgen(x).SubTipoSeg,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).AnioPoliza,
                        obj_sesasdatgen(x).Ocupacion,
                        obj_sesasdatgen(x).TipoRiesgo,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta, 2),
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).Cod_Asegurado,
                        nCantCertificados,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).PlazoPagoPrima,
                        obj_sesasdatgen(x).Coaseguro,
                        obj_sesasdatgen(x).Emision,
                        obj_sesasdatgen(x).SdoFonInv,
                        obj_sesasdatgen(x).SdoFonAdm
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_IND_MOV_Q;
        

      /*
      FOR x IN C_POL_IND_MOV_Q LOOP
          --Afinación
          IF nCodCia2 <> x.CodCia OR nCodEmpresa2 <> x.CodEmpresa OR nIdPoliza <> x.IdPoliza OR nIDetPol <> x.IDetPol THEN
             nCodCia2           := x.CodCia;
             nCodEmpresa2       := x.CodEmpresa;
             nIdPoliza          := x.IdPoliza;
             nIDetPol           := x.IDetPol;
             nComisionDirecta   := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP( x.CodCia, x.CodEmpresa, x.IdPoliza, dFecDesde, dFecHasta );
             nCantCertificados  := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS_2( x.CodCia, x.CodEmpresa, x.IdPoliza, x.IDetPol, x.IndAsegModelo, x.CantAsegModelo, x.PolConcentrada, x.IdEndoso );
             cFormaVta          := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA( x.CodCia, x.IdPoliza );
          END IF;
          --
          --Inserto lo que antes era el cursor: POL_IND_MOV_Q
          INSERT INTO SICAS_OC.SESAS_DATGEN
             ( CodCia    , CodEmpresa   , CodReporte, CodUsuario, NumPoliza , NumCertificado, TipoSeguro     , Moneda        , EntidadAsegurado,
               FecIniVig , FecFinVig    , FecAltCert, FecBajCert, FecNacim  , FecEmision    , Sexo           , StatusCert    , FormaVta        ,
               SubTipoSeg, TipoDividendo, AnioPoliza, Ocupacion , TipoRiesgo, PrimaCedida   , ComisionDirecta, MontoDividendo, IdPoliza        ,
               IDetPol   , CodAsegurado , CantCertificados, PlanPoliza, ModalidadPoliza, PlazoPagoPrima, Coaseguro, Emision, SdoFonInv, SdoFonAdm  )
          VALUES ( x.CodCia    , x.CodEmpresa   , x.CodReporte, x.CodUsuario, x.NumPoliza , x.NumCertificado, x.TipoSeguro    , x.Moneda        , x.EntidadAsegurado,
                   x.FecIniVig , x.FecFinVig    , x.FecAltCert, x.FecBajCert, x.FecNacim  , x.FecEmision    , x.Sexo          , x.StatusCert    , cFormaVta         ,
                   x.SubTipoSeg, x.TipoDividendo, x.AnioPoliza, x.Ocupacion , x.TipoRiesgo, x.PrimaCedida   , nComisionDirecta, x.MontoDividendo, x.IdPoliza        ,
                   x.IDetPol   , x.Cod_Asegurado, nCantCertificados, x.PlanPoliza, x.ModalidadPoliza, x.PlazoPagoPrima, x.Coaseguro, x.Emision, x.SdoFonInv, x.SdoFonAdm );
      END LOOP;
      */
      --
      --Inicializo variables de Afinación
        nCodCia2 := 0;
        nCodEmpresa2 := 0;
        nIdPoliza := 0;
        nIDetPol := 0;
        nComisionDirecta := 0;
        nCantCertificados := 0;
        cFormaVta := NULL;
        OPEN C_POL_COL_MOV_Q;
        LOOP
            FETCH C_POL_COL_MOV_Q
            BULK COLLECT INTO obj_sesasdatgen;
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
                
                nCantCertificados := CASE WHEN NVL(obj_sesasdatgen(x).IndAsegModelo, 'N') = 'S' THEN SICAS_OC.OC_PROCESOSSESAS.GETCANTASEGAPC( obj_sesasdatgen(x).CodCia,obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).Cod_Asegurado,obj_sesasdatgen(x).CantAsegModelo) ELSE  1 END;
                
                IF nCodCia2 <> obj_sesasdatgen(x).CodCia OR nCodEmpresa2 <> obj_sesasdatgen(x).CodEmpresa OR nIdPoliza <> obj_sesasdatgen(x).IdPoliza OR nIDetPol <> obj_sesasdatgen(x).IDetPol THEN
                    nCodCia2 := obj_sesasdatgen(x).CodCia;
                    nCodEmpresa2 := obj_sesasdatgen(x).CodEmpresa;
                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa,obj_sesasdatgen(x).IdPoliza, dFecDesde, dFecHasta);

                    /*nCantCertificados := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS_2(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).IdPoliza, obj_sesasdatgen(x).IDetPol, obj_sesasdatgen(x).IndAsegModelo,
                                                                                        obj_sesasdatgen(x).CantAsegModelo, obj_sesasdatgen(x).PolConcentrada, obj_sesasdatgen(x).IdEndoso);
*/
                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).IdPoliza);

                END IF;

                --Inserto lo que antes era el cursor: POL_COL_MOV_Q
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
                        NUMASEGPOL,
                        PlanPoliza,
                        ModalidadPoliza,
                        PlazoPagoPrima,
                        Coaseguro,
                        Emision,
                        SdoFonInv,
                        SdoFonAdm
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        NVL(obj_sesasdatgen(x).EntidadAsegurado,'09'),
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        cFormaVta,
                        obj_sesasdatgen(x).SubTipoSeg,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).AnioPoliza,
                        obj_sesasdatgen(x).Ocupacion,
                        obj_sesasdatgen(x).TipoRiesgo,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta, 2),
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).Cod_Asegurado,
                        nCantCertificados,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).PlazoPagoPrima,
                        obj_sesasdatgen(x).Coaseguro,
                        obj_sesasdatgen(x).Emision,
                        obj_sesasdatgen(x).SdoFonInv,
                        obj_sesasdatgen(x).SdoFonAdm
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_COL_MOV_Q;
        

      /*
      FOR x IN C_POL_COL_MOV_Q LOOP
          --Afinación
          IF nCodCia2 <> x.CodCia OR nCodEmpresa2 <> x.CodEmpresa OR nIdPoliza <> x.IdPoliza OR nIDetPol <> x.IDetPol THEN
             nCodCia2           := x.CodCia;
             nCodEmpresa2       := x.CodEmpresa;
             nIdPoliza          := x.IdPoliza;
             nIDetPol           := x.IDetPol;
             nComisionDirecta   := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP( x.CodCia, x.CodEmpresa, x.IdPoliza, dFecDesde, dFecHasta );
             nCantCertificados  := SICAS_OC.OC_PROCESOSSESAS.GETCANTCERTIFICADOS_2( x.CodCia, x.CodEmpresa, x.IdPoliza, x.IDetPol, x.IndAsegModelo, x.CantAsegModelo, x.PolConcentrada, x.IdEndoso );
             cFormaVta          := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA( x.CodCia, x.IdPoliza );
          END IF;
          --
          --Inserto lo que antes era el cursor: POL_COL_MOV_Q
          INSERT INTO SICAS_OC.SESAS_DATGEN
             ( CodCia    , CodEmpresa   , CodReporte, CodUsuario, NumPoliza , NumCertificado, TipoSeguro     , Moneda        , EntidadAsegurado,
               FecIniVig , FecFinVig    , FecAltCert, FecBajCert, FecNacim  , FecEmision    , Sexo           , StatusCert    , FormaVta        ,
               SubTipoSeg, TipoDividendo, AnioPoliza, Ocupacion , TipoRiesgo, PrimaCedida   , ComisionDirecta, MontoDividendo, IdPoliza        ,
               IDetPol   , CodAsegurado , CantCertificados, PlanPoliza, ModalidadPoliza, PlazoPagoPrima, Coaseguro, Emision, SdoFonInv, SdoFonAdm  )
          VALUES ( x.CodCia    , x.CodEmpresa   , x.CodReporte, x.CodUsuario, x.NumPoliza , x.NumCertificado, x.TipoSeguro    , x.Moneda        , x.EntidadAsegurado,
                   x.FecIniVig , x.FecFinVig    , x.FecAltCert, x.FecBajCert, x.FecNacim  , x.FecEmision    , x.Sexo          , x.StatusCert    , cFormaVta         ,
                   x.SubTipoSeg, x.TipoDividendo, x.AnioPoliza, x.Ocupacion , x.TipoRiesgo, x.PrimaCedida   , nComisionDirecta, x.MontoDividendo, x.IdPoliza        ,
                   x.IDetPol   , x.Cod_Asegurado, nCantCertificados, x.PlanPoliza, x.ModalidadPoliza, x.PlazoPagoPrima, x.Coaseguro, x.Emision, x.SdoFonInv, x.SdoFonAdm  );
      END LOOP;
*/

BEGIN
     OPEN c_Llenado;
        LOOP
            FETCH c_Llenado
            BULK COLLECT INTO obj_sesaslleno;
            FOR x IN 1..obj_sesaslleno.COUNT LOOP

                UPDATE SICAS_OC.SESAS_DATGEN
                SET COMISIONDIRECTA = ROUND(COMISIONDIRECTA / obj_sesaslleno(x).TOTAL,2),
                    FECHAINSERT = SYSDATE
                WHERE CODCIA = obj_sesaslleno(x).CodCia
                    AND CODEMPRESA = obj_sesaslleno(x).CodEmpresa
                    AND CODREPORTE = obj_sesaslleno(x).CodReporte
                    AND CODUSUARIO = obj_sesaslleno(x).CodUsuario
                    AND NUMPOLIZA = obj_sesaslleno(x).NUMPOLIZA
                    AND IDPOLIZA = obj_sesaslleno(x).IDPOLIZA;

            END LOOP;

            EXIT WHEN obj_sesaslleno.COUNT = 0;
        END LOOP;

        CLOSE c_Llenado;
        
EXCEPTION
        WHEN OTHERS THEN
            COMMIT;
    END;
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
        cTipoExtraPrima    VARCHAR2(1);
      --
        TYPE rec_sesasdatgen IS RECORD (
            IDPOLIZA       NUMBER,
            IDETPOL        NUMBER,
            CodAsegurado   NUMBER,
            FECINIVIG      DATE,
            FECFINVIG      DATE,
            FecBajcert     DATE,
            TIPODETALLE    VARCHAR2(3),
            NUMPOLIZA      VARCHAR2(30),
            NUMCERTIFICADO VARCHAR2(30)
        );
        TYPE type_sesasdatgen IS
            TABLE OF rec_sesasdatgen;
        obj_sesasdatgen    type_sesasdatgen;
        CURSOR cPolizas_DatGen IS
        SELECT
            IdPoliza,
            IDetPol,
            CodAsegurado,
            FecIniVig,
            FecFinVig,
            FecBajcert,
            TipoDetalle,
            NumPoliza,
            NumCertificado
        FROM SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = 'SESADATAPC'
            AND CodUsuario = cCodUsuario
            AND NUMCERTIFICADO = TRIM(LPAD(IdPoliza, 8, '0')) || TRIM(LPAD(IDetPol, 2, '0'))
                || TRIM(LPAD(CodAsegurado, 10, '0'))
            AND NUMPOLIZA >= '0'--(SELECT MIN(NUMPOLIZA) FROM SESAS_DATGEN)
            AND NUMCERTIFICADO >= '0'--(SELECT MIN(NUMCERTIFICADO) FROM SESAS_DATGEN);
;
        TYPE rec_sesasdatgen2 IS RECORD (
            IDPOLIZA           NUMBER,
            StsPoliza          VARCHAR2(3),
            TipoAdministracion VARCHAR2(6),
            IdTipoSeg          VARCHAR2(6),
            PlanCob            VARCHAR2(15),
            FecIniVig          DATE
        );
        TYPE type_sesasdatgen2 IS
            TABLE OF rec_sesasdatgen2;
        obj_sesasdatgen2   type_sesasdatgen2;
        CURSOR POL_Q IS
        SELECT
            P.IdPoliza,
            P.StsPoliza,
            P.TipoAdministracion,
            D.IdTipoSeg,
            D.PlanCob,
            P.FecIniVig
        FROM SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.IdPoliza = P.IdPoliza
                                                    AND D.CodCia = P.CodCia
                                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
        WHERE
                P.CodCia = nCodCia
            AND P.IdPoliza = nIdPolizaProc
            AND P.StsPoliza NOT IN ( 'SOL', 'PRE' )
            AND ( P.MotivAnul IS NULL
                  OR NVL(P.MotivAnul, 'NULL') IS NOT NULL
                  AND P.FecSts BETWEEN dvarFecDesde AND dvarFecHasta )
        UNION
        SELECT
            D.IdPoliza,
            P.StsPoliza,
            P.TipoAdministracion,
            D.IdTipoSeg,
            D.PlanCob,
            P.FecIniVig
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.IdPoliza = P.IdPoliza
                                                    AND D.CodCia = P.CodCia
                                                    AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
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
      --
        TYPE rec_sesasdatgen4 IS RECORD (
            CodCobert     VARCHAR2(6),
            OrdenSESAS    NUMBER,
            PeriodoEspera NUMBER,
            ClaveSESAS    VARCHAR2(3),
           -- NumDiasRenta     NUMBER,
            Suma_Moneda   NUMBER,
            Prima_Moneda  NUMBER
        );
        TYPE type_sesasdatgen4 IS
            TABLE OF rec_sesasdatgen4;
        obj_sesasdatgen4   type_sesasdatgen4;
        CURSOR COBERT_Q IS
        SELECT
            C.CodCobert,
            NVL(CS.OrdenSESAS, 0)         OrdenSESAS,
            NVL(CS.PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(CS.CLAVESESASNEW, '99')   ClaveSESAS
                  --, NVL(CS.NumDiasRenta      ,    0) NumDiasRenta   --hacer funcion para retornar 90
            ,
            SUM(SumaAseg_Moneda)          Suma_Moneda,
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
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND CS.CLAVESESASNEW <> '10'
        GROUP BY
            C.CodCobert,
            NVL(OrdenSESAS, 0),
            NVL(PeriodoEsperaMeses, 0),
            NVL(CLAVESESASNEW, '99')--, NVL(NumDiasRenta, 0)

        UNION ALL
        SELECT
            C.CodCobert,
            NVL(CS.OrdenSESAS, 0)         OrdenSESAS,
            NVL(CS.PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(CS.CLAVESESASNEW, '99')   ClaveSESAS
                 -- , NVL(CS.NumDiasRenta      ,    0) NumDiasRenta   --hacer funcion para retornar 90
            ,
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
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND CS.CLAVESESASNEW = '10'
        GROUP BY
            C.CodCobert,
            NVL(OrdenSESAS, 0),
            NVL(PeriodoEsperaMeses, 0),
            NVL(CLAVESESASNEW, '99')--, NVL(NumDiasRenta, 0)

        UNION ALL
        SELECT
            C.CodCobert,
            NVL(OrdenSESAS, 0)         OrdenSESAS,
            NVL(PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(CLAVESESASNEW, '99')   ClaveSESAS
                  --, NVL(NumDiasRenta      ,    0) NumDiasRenta
            ,
            SUM(SumaAseg_Moneda)       Suma_Moneda,
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
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND CS.CLAVESESASNEW <> '10'
        GROUP BY
            C.CodCobert,
            NVL(OrdenSESAS, 0),
            NVL(PeriodoEsperaMeses, 0),
            NVL(CLAVESESASNEW, '99')--, NVL(NumDiasRenta, 0)

        UNION ALL
        SELECT
            C.CodCobert,
            NVL(OrdenSESAS, 0)         OrdenSESAS,
            NVL(PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(CLAVESESASNEW, '99')   ClaveSESAS
                  --, NVL(NumDiasRenta      ,    0) NumDiasRenta
            ,
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
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND CS.CLAVESESASNEW = '10'
        GROUP BY
            C.CodCobert,
            NVL(OrdenSESAS, 0),
            NVL(PeriodoEsperaMeses, 0),
            NVL(CLAVESESASNEW, '99')/*, NVL(NumDiasRenta, 0)*/;
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
            AND C.IDetPol > 0
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
            AND C.IDetPol > 0
            AND C.CodCia = nCodCia
            AND C.IdPoliza = nIdPolizaCalc;
      --

        TYPE rec_sesasdatgen3 IS RECORD (
            Cod_Asegurado   NUMBER,
            SumaAseg_Moneda NUMBER,
            CodCobert       VARCHAR2(6),
            Tasa            NUMBER,
            Porc_Tasa       NUMBER,
            CodTarifa       VARCHAR2(30),
            IdTipoSeg       VARCHAR2(6),
            PlanCob         VARCHAR2(15),
            FactorTasa      NUMBER,
            Prima_Cobert    NUMBER
        );
        TYPE type_sesasdatgen3 IS
            TABLE OF rec_sesasdatgen3;
        obj_sesasdatgen3   type_sesasdatgen3;
        CURSOR COB_CALC_Q IS
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
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.CodCia = nCodCia
            AND C.IdPoliza = nIdPoliza
            AND C.CodCobert = cCodCobert
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
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.CodCia = nCodCia
            AND C.IdPoliza = nIdPoliza
            AND C.CodCobert = cCodCobert;

        nDiasRenta         NUMBER;
    BEGIN

EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
/*
       DELETE SICAS_OC.SESAS_EMISION
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario;

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
*/
        

        SICAS_OC.OC_SESASCOLECTIVO.DATGEN_AP(nCodCia, nCodEmpresa, dFecDesde, dFecHasta, cCodUsuario,'SESADATAPC', 'SESADATAPC'/*cCodReporteProces*/, cFiltrarPolizas);

        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY')|| ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY')|| ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
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
                    OPEN POL_Q;
                    LOOP
                        FETCH POL_Q
                        BULK COLLECT INTO obj_sesasdatgen2;
                        FOR z IN 1..obj_sesasdatgen2.COUNT LOOP
             --FOR z IN POL_Q LOOP
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
                    --
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
                                WHERE  CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza
                                    AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );
                    --
                                SELECT  NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                INTO nPrimaMonedaTotPol
                                FROM SICAS_OC.COBERT_ACT_ASEG
                                WHERE CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza
                                    AND StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 );
                    --
                                SELECT  NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                INTO nPrimaMonedaTotPol
                                FROM  SICAS_OC.ASISTENCIAS_ASEGURADO
                                WHERE CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza
                                    AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );

                            ELSIF cTodasAnuladas = 'S' AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza  THEN
                                SELECT  NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
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
                                SELECT  NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                INTO nPrimaMonedaTotPol
                                FROM  SICAS_OC.COBERT_ACT_ASEG
                                WHERE  CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;
                    --
                                SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                INTO nPrimaMonedaTotPol
                                FROM SICAS_OC.ASISTENCIAS_ASEGURADO
                                WHERE CodCia = nCodCia
                                    AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;

                            END IF;
                 --

--                 SELECT /*+ INDEX(T SYS_C0032162) */ NVL(SUM(DF.Monto_Det_Moneda), 0) + NVL(nPrimaContable,0)
/*                 INTO   nPrimaContable
                 FROM   DETALLE_FACTURAS DF, FACTURAS F, TRANSACCION T
                 WHERE  T.FechaTransaccion >= dFecDesde
                   AND  T.FechaTransaccion <= dFecHasta
                   AND  T.CodCia            = F.CodCia
                   AND  T.IdTransaccion     = F.IdTransaccion
                   AND  F.CodCia            = nCodCia
                   AND  F.IdPoliza          = Z.IdPoliza
                   AND  DF.CodCpto         IN ( SELECT CodConcepto 
                                                FROM   CATALOGO_DE_CONCEPTOS 
                                                WHERE  IndCptoPrimas   = 'S' 
                                                   OR  IndCptoServicio = 'S'
                                                   OR  IndCptoFondo    = 'S'
                                                GROUP BY CodConcepto )
                   AND  DF.IdFactura        = F.IdFactura;
                 --
                 SELECT NVL(SUM(DF.Monto_Det_Moneda), 0) + NVL(nPrimaContableAnu,0)
                 INTO   nPrimaContableAnu
                 FROM   DETALLE_FACTURAS DF, FACTURAS F
                 WHERE  F.FecSts           >= dFecDesde
                   AND  F.FecSts           <= dFecHasta
                   AND  F.CodCia            = nCodCia
                   AND  F.IdPoliza          = Z.IdPoliza
                   AND  DF.CodCpto         IN ( SELECT CodConcepto 
                                                FROM CATALOGO_DE_CONCEPTOS 
                                                WHERE IndCptoPrimas   = 'S' 
                                                   OR IndCptoServicio = 'S'
                                                   OR IndCptoFondo    = 'S' )
                   AND  F.Stsfact          IN ('ANU') 
                   AND  DF.IdFactura        = F.IdFactura;
                 --*/
  --               SELECT /*+ INDEX(T SYS_C0032162) */ NVL(SUM(DNC.Monto_Det_Moneda),0) + NVL(nMtoCptoNcrMoneda,0)
/*                 INTO   nMtoCptoNcrMoneda
                 FROM   DETALLE_NOTAS_DE_CREDITO DNC,
                        NOTAS_DE_CREDITO NC, TRANSACCION T
                 WHERE  T.FechaTransaccion >= dFecDesde
                   AND  T.FechaTransaccion <= dFecHasta
                   AND  T.CodCia            = NC.CodCia
                   AND  T.IdTransaccion     = NC.IdTransaccion
                   AND  NC.CodCia           = nCodCia
                   AND  NC.IdPoliza         = Z.IdPoliza
                   AND  DNC.CodCpto        IN ( SELECT CodConcepto 
                                                FROM CATALOGO_DE_CONCEPTOS 
                                                WHERE IndCptoPrimas   = 'S' 
                                                   OR IndCptoServicio = 'S'
                                                   OR IndCptoFondo    = 'S')
                   AND  NC.IdNcr            = DNC.IdNcr;
                 --
                 SELECT NVL(SUM(DNC.Monto_Det_Moneda),0) + NVL(nMtoCptoNcrMonedaAnu,0)
                 INTO   nMtoCptoNcrMonedaAnu
                 FROM   DETALLE_NOTAS_DE_CREDITO DNC,
                        NOTAS_DE_CREDITO NC
                 WHERE  NC.FecSts          >= dFecDesde
                   AND  NC.FecSts          <= dFecHasta
                   AND  NC.CodCia           = nCodCia
                   AND  NC.IdPoliza         = Z.IdPoliza
                   AND  DNC.CodCpto        IN ( SELECT CodConcepto 
                                                FROM CATALOGO_DE_CONCEPTOS 
                                                WHERE IndCptoPrimas   = 'S' 
                                                   OR IndCptoServicio = 'S'
                                                   OR IndCptoFondo    = 'S' )
                   AND  NC.StsNCR           = 'ANU' 
                   AND  NC.IdNcr            = DNC.IdNcr;
*/
                        END LOOP;

                        EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                    END LOOP;

                    CLOSE POL_Q;
                   -- 
            --END LOOP; 

--             nPrimaContable := (NVL(nPrimaContable,0) - NVL(nPrimaContableAnu,0)) - (NVL(nMtoCptoNcrMoneda,0) - NVL(nMtoCptoNcrMonedaAnu,0));

             --
                    cRecalculoPrimas := 'N';
             --
                    IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                        cRecalculoPrimas := 'S';
                --
                        OPEN POL_Q;
                        LOOP
                            FETCH POL_Q
                            BULK COLLECT INTO obj_sesasdatgen2;
                            FOR z IN 1..obj_sesasdatgen2.COUNT LOOP
                --FOR z IN POL_Q LOOP
                                nIdPolizaCalc := obj_sesasdatgen2(z).IdPoliza;

                                BEGIN
                                    nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen2(z).IdTipoSeg, obj_sesasdatgen2(z).PlanCob, obj_sesasdatgen2(z).FecIniVig);
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' || nCod_Asegurado, SQLCODE, SQLERRM);
                                END;
                    --
                                nCodAseguradoAfina := NULL;
                                OPEN CALC_Q;
                                LOOP
                                    FETCH CALC_Q
                                    BULK COLLECT INTO obj_sesasdatgen3;
                                    FOR w IN 1..obj_sesasdatgen3.COUNT LOOP
                    --FOR w IN CALC_Q LOOP
                                        IF obj_sesasdatgen3(w).Tasa > 0 THEN
                                            nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( obj_sesasdatgen3(w).SumaAseg_Moneda * obj_sesasdatgen3(w).Tasa );

                                        ELSIF obj_sesasdatgen3(w).CodTarifa IS NULL THEN
                                            IF NVL(obj_sesasdatgen3(w).Prima_Cobert, 0) != 0 THEN
                                                nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + NVL(obj_sesasdatgen3(w).Prima_Cobert,0);

                                            ELSE
                                                nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( obj_sesasdatgen3(w).SumaAseg_Moneda * obj_sesasdatgen3(w).Porc_Tasa / 1000 );
                                            END IF;
                                        ELSE
                           --Afinación para no obtener N veces la mismsa información cuando se trata del mismo asegurado
                                            IF nCodAseguradoAfina IS NULL OR nCodAseguradoAfina <> obj_sesasdatgen3(w).Cod_Asegurado THEN
                                                nCodAseguradoAfina := obj_sesasdatgen3(w).Cod_Asegurado;
                                                SICAS_OC.OC_PROCESOSSESAS.DATOSASEGURADO(nCodCia, nCodEmpresa, obj_sesasdatgen3(w).Cod_Asegurado, dFecIniVig, cSexo, nEdad, cCodActividad, cRiesgo);

                                            END IF;
                           --
                                            IF nEdad = 0 THEN
                                                BEGIN
                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS(nCodCia, nCodEmpresa,obj_sesasdatgen3(w).IdTipoSeg, obj_sesasdatgen3(w).PlanCob, obj_sesasdatgen3(w).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);

                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, nIdPolizaCalc,'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' ||obj_sesasdatgen3(w).Cod_Asegurado,SQLCODE, SQLERRM);
                                                END;

                                            ELSE
                                                BEGIN
                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, obj_sesasdatgen3(w).IdTipoSeg, obj_sesasdatgen3(w).PlanCob, obj_sesasdatgen3(w).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,NULL);

                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        BEGIN
                                                            nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS(nCodCia, nCodEmpresa, obj_sesasdatgen3(w).IdTipoSeg, obj_sesasdatgen3(w).PlanCob, obj_sesasdatgen3( w).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);

                                                        EXCEPTION
                                                            WHEN OTHERS THEN
                                                                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, nIdPolizaCalc,'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' ||obj_sesasdatgen3(w).Cod_Asegurado,SQLCODE, SQLERRM);
                                                        END;
                                                END;
                                            END IF;
                           --
                                            nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( obj_sesasdatgen3(w).SumaAseg_Moneda * nTasa / obj_sesasdatgen3(w).FactorTasa );

                                        END IF;
                                    END LOOP;

                                    EXIT WHEN obj_sesasdatgen3.COUNT = 0;
                                END LOOP;

                                CLOSE CALC_Q;
                    --END LOOP;
                      --  


                            END LOOP;

                            EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                        END LOOP;

                        CLOSE POL_Q;
                       -- 
                --END LOOP;
                    END IF;
             --
                    IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                        nPrimaMonedaTotPol := 1;
                    END IF;
                END IF;
          --
                OPEN POL_Q;
                LOOP
                    FETCH POL_Q
                    BULK COLLECT INTO obj_sesasdatgen2;
                    FOR z IN 1..obj_sesasdatgen2.COUNT LOOP
          --FOR z IN POL_Q LOOP
                        IF
                            cTodasAnuladas = 'N'
                            AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza
                        THEN
                            BEGIN
                                nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen2(z).IdTipoSeg, obj_sesasdatgen2(z).PlanCob, obj_sesasdatgen2(z).FecIniVig);
                            EXCEPTION
                                WHEN OTHERS THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' || nCod_Asegurado, SQLCODE, SQLERRM);
                            END;
                 --
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

                        ELSIF
                            cTodasAnuladas = 'S'
                            AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza
                        THEN
                            BEGIN
                                nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen2(z).IdTipoSeg, obj_sesasdatgen2(z).PlanCob, obj_sesasdatgen2(z).FecIniVig);
                            EXCEPTION
                                WHEN OTHERS THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-GT_TARIFA_CONTROL_VIGENCIAS: ' || nCod_Asegurado, SQLCODE, SQLERRM);
                            END;

                            cStatus1 := ' ';
                            cStatus2 := ' ';
                            cStatus3 := ' ';
                            cStatus4 := ' ';
                        END IF;
                    END LOOP;

                    EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                END LOOP;

                CLOSE POL_Q;
               -- 
          --END LOOP;
          --
                IF obj_sesasdatgen(x).TipoDetalle = 'IND' THEN
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
                        AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );

                ELSE
                    SELECT
                        NVL(SUM(MontoAsistLocal), 0)
                    INTO nMtoAsistLocal
                    FROM
                        SICAS_OC.ASISTENCIAS_ASEGURADO
                    WHERE
                            CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa
                        AND IdPoliza = nIdPoliza
                        AND IDetPol = nIDetPol
                        AND Cod_Asegurado = nCod_Asegurado
                        AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );

                END IF;
          --
                OPEN COBERT_Q;
                LOOP
                    FETCH COBERT_Q
                    BULK COLLECT INTO obj_sesasdatgen4;
                    FOR w IN 1..obj_sesasdatgen4.COUNT LOOP
          --FOR w IN COBERT_Q LOOP
                        IF cRecalculoPrimas = 'N' THEN
                            nPrima_Moneda := NVL(obj_sesasdatgen4(w).Prima_Moneda, 0);
                        ELSE
                            IF NVL(obj_sesasdatgen4(w).Prima_Moneda, 0) > 0 THEN
                                nPrima_Moneda := NVL(obj_sesasdatgen4(w).Prima_Moneda, 0);
                            ELSE
                                cCodCobert := obj_sesasdatgen4(w).CodCobert;
                    --
                                nCodAseguradoAfina := NULL;
                                OPEN COB_CALC_Q;
                                LOOP
                                    FETCH COB_CALC_Q
                                    BULK COLLECT INTO obj_sesasdatgen3;
                                    FOR r IN 1..obj_sesasdatgen3.COUNT LOOP
                    --FOR r IN COB_CALC_Q LOOP
                                        IF obj_sesasdatgen3(r).Tasa > 0 THEN
                                            nPrima_Moneda := obj_sesasdatgen3(r).SumaAseg_Moneda * obj_sesasdatgen3(r).Tasa;
                                        ELSIF obj_sesasdatgen3(r).CodTarifa IS NULL THEN
                                            IF NVL(obj_sesasdatgen3(r).Prima_Cobert, 0) != 0 THEN
                                                nPrima_Moneda := NVL(obj_sesasdatgen3(r).Prima_Cobert, 0);
                                            ELSE
                                                nPrima_Moneda := obj_sesasdatgen3(r).SumaAseg_Moneda * obj_sesasdatgen3(r).Porc_Tasa /1000;
                                            END IF;
                                        ELSE
                                            BEGIN
                                                nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen3( r).IdTipoSeg, obj_sesasdatgen3(r).PlanCob, dFecIniVig);
                                            EXCEPTION
                                                WHEN OTHERS THEN
                                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-GT_TARIFA_CONTROL_VIGENCIAS: ' || obj_sesasdatgen3(w).Cod_Asegurado, SQLCODE, SQLERRM);
                                            END;
                           --       
                           --Afinación para no obtener N veces la mismsa información cuando se trata del mismo asegurado
                                            IF nCodAseguradoAfina IS NULL OR nCodAseguradoAfina <> obj_sesasdatgen3(r).Cod_Asegurado THEN
                                                nCodAseguradoAfina := obj_sesasdatgen3(r).Cod_Asegurado;
                                                SICAS_OC.OC_PROCESOSSESAS.DATOSASEGURADO(nCodCia, nCodEmpresa, obj_sesasdatgen3(r).Cod_Asegurado, dFecIniVig, cSexo, nEdad, cCodActividad, cRiesgo);

                                            END IF;
                           --
                                            IF nEdad = 0 THEN
                                                BEGIN
                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS(nCodCia, nCodEmpresa, obj_sesasdatgen3( r).IdTipoSeg, obj_sesasdatgen3(r).PlanCob, obj_sesasdatgen3(r).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' || obj_sesasdatgen3(w).Cod_Asegurado, SQLCODE, SQLERRM);
                                                END;
                                            ELSE
                                                BEGIN
                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, obj_sesasdatgen3( r).IdTipoSeg, obj_sesasdatgen3(r).PlanCob, obj_sesasdatgen3(r).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,NULL);
                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        BEGIN
                                                            nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMASESAS(nCodCia, nCodEmpresa,obj_sesasdatgen3(r).IdTipoSeg, obj_sesasdatgen3(r).PlanCob, obj_sesasdatgen3( r).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);

                                                        EXCEPTION
                                                            WHEN OTHERS THEN
                                                                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPolizaCalc, 'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' || obj_sesasdatgen3(w).Cod_Asegurado, SQLCODE, SQLERRM);
                                                        END;
                                                END;
                                            END IF;
                           --
                                            nPrima_Moneda := obj_sesasdatgen3(r).SumaAseg_Moneda * nTasa / obj_sesasdatgen3(r).FactorTasa;

                                        END IF;
                                    END LOOP;

                                    EXIT WHEN obj_sesasdatgen3.COUNT = 0;
                                END LOOP;

                                CLOSE COB_CALC_Q;
                              --  
                    --END LOOP;
                            END IF;
                        END IF;
              --
              --IF obj_sesasdatgen4(w).PeriodoEspera > NVL(nPeriodoEspCob, 0) THEN
              --   nPeriodoEspCob := obj_sesasdatgen4(w).PeriodoEspera;
              --END IF; 
              --
                        nPmaEmiCob := NVL(nPrima_Moneda, 0);
              --
                        IF obj_sesasdatgen4(w).OrdenSESAS = 1 THEN
                            nPmaEmiCob := NVL(nPmaEmiCob, 0) + NVL(nMtoAsistLocal, 0);
                            nMtoAsistLocal := 0;
                        END IF;
              --
--              nPmaEmiCob := (NVL(nPrimaContable,0) * (NVL(nPrima_Moneda,0) / NVL(nPrimaMonedaTotPol,0)));
              --nPrimaDevengada := nPmaEmiCob; --Ver calculo
              --
              --Inserto Emisión/Coberturas
                        cTipoExtraPrima := '9';
                        cTipoSumaSeg := SICAS_OC.OC_PROCESOSSESAS.GETTIPOSUMASEG(nCodCia, LPAD(obj_sesasdatgen4(w).ClaveSESAS, 2, '0'),'VIDA');

                        nDiasRenta := SICAS_OC.OC_PROCESOSSESAS.GETNUMDIASRENTA();
                        nPrimaDevengada := SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(nidPoliza, nPmaEmiCob, dFecHasta, dFecIniVig, dFecFinVig);

                        /*IF obj_sesasdatgen(x).Fecbajcert < dvarFecDesde THEN
                            nPmaEmiCob := 0;
                        END IF;*/

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
                                obj_sesasdatgen(x).NumPoliza,
                                obj_sesasdatgen(x).NumCertificado,
                                LPAD(obj_sesasdatgen4(w).ClaveSESAS, 2, '0'),
                                cTipoSumaSeg,
                                obj_sesasdatgen4(w).PeriodoEspera,
                                NVL(obj_sesasdatgen4(w).Suma_Moneda, 0),
                                nPmaEmiCob,
                                nPrimaDevengada,
                                nDiasRenta,
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

                            WHEN OTHERS THEN
                                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, obj_sesasdatgen(x).NumPoliza,obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                        END;

                    END LOOP;

                    EXIT WHEN obj_sesasdatgen4.COUNT = 0;
                END LOOP;

                CLOSE COBERT_Q;
          --END LOOP;
--

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
        

        OPEN cPolizas_DatGen;
        LOOP
            FETCH cPolizas_DatGen
            BULK COLLECT INTO obj_sesasdatgen ;
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
                                            fechainsert = sysdate
                WHERE  CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMCERTIFICADO = TRIM(LPAD(obj_sesasdatgen(x).IdPoliza, 8, '0')) ||TRIM(LPAD(obj_sesasdatgen(x).IDetPol, 2, '0')) ||TRIM(LPAD(obj_sesasdatgen(x).CodAsegurado, 10, '0'))
            AND COBERTURA = COBERTURA;

                END IF;
            END IF;


                END LOOP;
            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
           

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

        dFecConSin      SICAS_OC.SESAS_SINIESTROS.FECCONSIN%TYPE;
        dFecPagSin      SICAS_OC.SESAS_SINIESTROS.FECPAGSIN%TYPE;
        nMontoPagSin    SICAS_OC.SESAS_SINIESTROS.MONTOPAGSIN%TYPE;
        nNumAprobacion  APROBACIONES.NUM_APROBACION%TYPE;
        nIdTransaccion  APROBACIONES.IDTRANSACCION%TYPE;
        nMontoDeducible SICAS_OC.SESAS_SINIESTROS.MONTODEDUCIBLE%TYPE;
        cTipAprobacion  NUMBER;
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
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(S.CODPAISOCURR, S.CODPROVOCURR, PN.CODPAISRES, PN.CODPROVRES, S.IDPOLIZA) EntOcuSin,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(S.CodCia, S.IdPoliza, S.IdSiniestro, S.Sts_Siniestro,((
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
            )),(
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
            ), 'SINAPC')                                                                                                            StatusReclamacion,
            CASE
                WHEN LENGTH(NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)) = 3 THEN
                    S.Motivo_De_Siniestro || 'X'
                ELSE
                    NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)
            END                                                                                                                     CausaSiniestro,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                          Sexo,
            PN.FecNacimiento                                                                                                        FecNacim,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOMOVRECLAMO()                                                                           TipMovRec,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, NULL)                                                      MontoCoaseguro  --Default 1  
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
            S.IDetPol,
            S.Cod_Asegurado,
            NVL(P.MONTODEDUCIBLE, 0)                                                                                                MONTODEDUCIBLE
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.IdPoliza = P.IdPoliza
                AND D.CODCIA = P.CODCIA
                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            INNER JOIN SICAS_OC.SINIESTRO                S ON S.IDetPol = D.IDetPol
                                               AND S.IdPoliza = D.IdPoliza
            INNER JOIN SICAS_OC.ASEGURADO                CL ON CL.Cod_Asegurado = S.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = CL.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.RESERVA_DET              R ON R.ID_SINIESTRO = S.IDSINIESTRO
                                                 AND R.ID_POLIZA = S.IDPOLIZA
                                                 AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE
                D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
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
                  OR R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta )

               --S.Fec_Notificacion        BETWEEN dvarFecDesde AND dvarFecHasta
            AND S.Sts_Siniestro != 'SOL'
            AND D.IdTipoSeg IN (
                SELECT
                    PC.IdTipoSeg IdTipoSeg
                FROM
                    SICAS_OC.PLAN_COBERTURAS PC
                                                   /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  CAS
                                                    ON CAS.IDTIPOSEG = PC.IDTIPOSEG
                                                    AND CAS.PLANCOB = PC.PLANCOB*/
                WHERE  /*(PC.CodTipoPlan = '033'

                                                        OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQC')))*/
                    ( PC.CodTipoPlan IN ( '032', '033' )
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
                                    SICAS_OC.COBERTURA_ASEG X
                                WHERE
                                        X.IDPOLIZA = D.IDPOLIZA
                                    AND X.IDETPOL = D.IDETPOL
                                    AND D.IDTIPOSEG = X.IDTIPOSEG
                            )
                    )
                           AND PC.CodTipoPlan = '099'
                           AND PC.IdTipoSeg = 'PPAQC' ) )
            )
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
            ) ) )
        UNION
        SELECT
            P.NumPolUnico                                                                                                           NumPoliza,
            NVL(TRIM(LPAD(S.IdPoliza, 8, '0')) || TRIM(LPAD(S.IDetPol, 2, '0'))
                || TRIM(LPAD(S.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))  || TRIM(LPAD(D.IDetPol, 2, '0')) || TRIM(LPAD(D.Cod_Asegurado, 10, '0'))) NumCertificado,
            S.IdSiniestro                                                                                                           NumSiniestro,
            S.Fec_Ocurrencia                                                                                                        FecOcuSin,
            S.Fec_Notificacion                                                                                                      FecRepSin,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(S.CODPAISOCURR, S.CODPROVOCURR, PN.CODPAISRES, PN.CODPROVRES, S.IDPOLIZA) EntOcuSin,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(S.CodCia, S.IdPoliza, S.IdSiniestro, S.Sts_Siniestro,((
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
            )),(
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
            ), 'SINAPC')                                                                                                            StatusReclamacion,
            CASE
                WHEN LENGTH(NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)) = 3 THEN
                    S.Motivo_De_Siniestro || 'X'
                ELSE
                    NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)
            END                                                                                                                     CausaSiniestro,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                          Sexo,
            PN.FecNacimiento                                                                                                        FecNacim,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOMOVRECLAMO()                                                                           TipMovRec,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, NULL)                                                      MontoCoaseguro  --Default 1  
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
            S.IDetPol,
            S.Cod_Asegurado,
            NVL(P.MONTODEDUCIBLE, 0)                                                                                                MONTODEDUCIBLE
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA                  D ON D.IdPoliza = P.IdPoliza
                AND D.CODCIA = P.CODCIA
                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            INNER JOIN SICAS_OC.SINIESTRO                S ON S.IDetPol = D.IDetPol
                                               AND S.IdPoliza = D.IdPoliza
            INNER JOIN SICAS_OC.ASEGURADO                CL ON CL.Cod_Asegurado = S.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = CL.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.RESERVA_DET              R ON R.ID_SINIESTRO = S.IDSINIESTRO
                                                 AND R.ID_POLIZA = S.IDPOLIZA
                                                 AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE  /*S.Fec_Notificacion        BETWEEN dvarFecDesde AND dvarFecHasta
               AND */
                S.Sts_Siniestro != 'SOL'
            AND ( EXISTS (
                SELECT
                    'S'
                FROM
                         SICAS_OC.APROBACION_ASEG A
                    INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B ON B.NumTransaccion = A.IdTransaccion
                WHERE
                        A.IdSiniestro = S.IdSiniestro
                    AND A.IDPOLIZA = S.IdPoliza
                    AND A.COD_ASEGURADO = S.Cod_Asegurado
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
                    AND A.IDPOLIZA = S.IdPoliza
                    AND A.COD_ASEGURADO = S.Cod_Asegurado
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )
                  OR R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta )
            AND D.IdTipoSeg IN (
                SELECT
                    PC.IdTipoSeg IdTipoSeg
                FROM
                    SICAS_OC.PLAN_COBERTURAS PC
                                                   /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  CAS
                                                    ON CAS.IDTIPOSEG = PC.IDTIPOSEG
                                                    AND CAS.PLANCOB = PC.PLANCOB*/
                WHERE  /*(PC.CodTipoPlan ='033'

                                                        OR (PC.CodTipoPlan ='099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQC')))*/
                    ( PC.CodTipoPlan IN ( '032', '033' )
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
                                    SICAS_OC.COBERTURA_ASEG X
                                WHERE
                                        X.IDPOLIZA = D.IDPOLIZA
                                    AND X.IDETPOL = D.IDETPOL
                                    AND D.IDTIPOSEG = X.IDTIPOSEG
                            )
                    )
                           AND PC.CodTipoPlan = '099'
                           AND PC.IdTipoSeg = 'PPAQC' ) )
            )
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
            INNER JOIN SICAS_OC.DETALLE_POLIZA        D ON  D.IdPoliza = S.IdPoliza
                                                    AND D.IDetPol = S.IDetPol
                                                    AND D.CODCIA = S.CODCIA

            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.IdTipoSeg = D.IdTipoSeg
                                                            AND CS.PlanCob = D.PlanCob
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
          SELECT NVL(CS.ClaveSesasnew, '1')      ClaveSesas
               , NVL(CS.OrdenSesas, 0)        OrdenSesas
               , C.CodCobert
               , SICAS_OC.OC_PROCESOSSESAS.GETNUMRECLAMACION() /*C.NumMod */      /*              NumReclamacion
               , ((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )))  MontoReclamado
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
          GROUP BY NVL(CS.ClaveSesasnew, '1'), NVL(CS.OrdenSesas, 0), C.CodCobert, C.NumMod, ((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )))

          UNION

          SELECT NVL(CS.ClaveSesasnew, '1')      ClaveSesas
               , NVL(CS.OrdenSesas, 0)        OrdenSesas
               , C.CodCobert
               , SICAS_OC.OC_PROCESOSSESAS.GETNUMRECLAMACION()*/ /*C.NumMod */       /*             NumReclamacion
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
          GROUP BY NVL(CS.ClaveSesasnew, '1'), NVL(CS.OrdenSesas, 0), C.CodCobert, C.NumMod,((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )));*/
    BEGIN

EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.LOGERRORES_SESAS');
/*
        DELETE SICAS_OC.SESAS_SINIESTROS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario;

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
*/
        
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

              --
              /*
              BEGIN
                 SELECT deducible_moneda
                 INTO   nMontoDeducible
                 FROM   SICAS_OC.COBERT_ACT_ASEG
                 WHERE  CodCia        = nCodCia
                   AND  IdPoliza      = x.IdPoliza
                   AND  IdetPol       = x.IdetPol
                   AND  Cod_Asegurado = x.Cod_Asegurado
                   AND  CodCobert     = y.CodCobert;

              EXCEPTION
                WHEN OTHERS THEN
                 BEGIN
                     SELECT deducible_moneda
                     INTO   nMontoDeducible
                         FROM   SICAS_OC.COBERT_ACT
                         WHERE  CodCia        = nCodCia
                           AND  IdPoliza      = x.IdPoliza
                           AND  IdetPol       = x.IdetPol
                           AND  Cod_Asegurado = x.Cod_Asegurado
                           AND  CodCobert     = y.CodCobert;
                 EXCEPTION
                    WHEN OTHERS THEN
                        BEGIN   
                            SELECT MONTODEDUCIBLE
                            INTO nMontoDeducible
                            FROM SICAS_OC.POLIZAS
                            WHERE IdPoliza      = x.IdPoliza;
                        EXCEPTION
                            WHEN OTHERS THEN
                                nMontoDeducible:= 0;
                        END;
                END;
              END;*/
              --Inserto Siniestros/Coberturas
             /* SICAS_OC.OC_PROCESOSSESAS.DATOSSINIESTROS(nCodCia,nCodEmpresa,x.IdPoliza,x.NumSiniestro, ''y.CodCobert,dFecPagSin,nMontoPagSin,dFecConSin);

              /*IF dFecPagSin < dFecDesde OR dFecPagSin > dFecHasta THEN
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
            END IF;
*/
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
                        NULL/*NVL(nMontoDividendo, 0)*/,
                        x.TipMovRec,
                        NULL/*NVL(x.MontoVencimiento, 0),*/,
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
                          ,  */
                            MontoCoaseguro = NVL(MontoCoaseguro, 0) + NVL(NULL/*x.MontoCoaseguro*/, 0)
                          --,    MontoPagSin      = NVL(MontoPagSin     , 0) + NVL(nMontoPagSin     , 0)
                            ,
                            MontoRecRea = NVL(MontoRecRea, 0) + NVL(x.MontoRecRea, 0),
                            MontoDividendo = NVL(MontoDividendo, 0) + NVL(NULL/*nMontoDividendo */, 0),
                            MontoVencimiento = NVL(MontoVencimiento, 0) + NVL(NULL/*x.MontoVencimiento*/, 0),
                            MontoRescate = NVL(MontoRescate, 0) + NVL(NULL/*nMontoRescate*/, 0),
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
                    y.MontoPagado,
                                                                               nMontoReclamo, 'SINAPI'),
                    FECPAGSIN = dFecPagSin,
                                            fechainsert = sysdate
                WHERE
                        NUMPOLIZA = x.NumPoliza
                    AND NUMSINIESTRO = x.NumSiniestro
                    AND COBERTURA = y.ClaveSesas;

            END LOOP;
        END LOOP;

        UPDATE SICAS_OC.SESAS_SINIESTROS
        SET
            STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(CodCia, NULL, NumSiniestro, StatusReclamacion, MONTOPAGSIN,
                                                                       MONTORECLAMADO, 'SINAPI'),
            FECPAGSIN =
                CASE
                    WHEN MONTOPAGSIN = 0 THEN
                        NULL
                    ELSE
                        FECPAGSIN
                END,
                                            fechainsert = sysdate
        WHERE
                NUMPOLIZA = NumPoliza
            AND NUMSINIESTRO = NumSiniestro;--OrdeSesas

        
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
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0')) || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))|| TRIM(LPAD(D.IDetPol, 2, '0'))|| TRIM(LPAD(D.Cod_Asegurado, 10, '0'))) NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(C.TipoSeguro, NULL)                                                           TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20', '30')                                                                   Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CodPaisRes, PN.CodProvRes, D.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert
		      --, SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig , D.FecFinVig, P.FecAnul, dFecHasta)                          FecBajCert
            ,SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, XX.FecAnulExclu, dFecDesde, dFecHasta)            FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo
              --, SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza,D.IDETPOL,  D.FecAnul, dFecHasta, D.StsDetalle,D.FecIniVig , D.FecFinVig,NVL(XX.Cod_Asegurado,D.Cod_Asegurado))   StatusCert
            ,SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, XX.FecAnulExclu, dFecHasta, XX.ESTADO, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))                StatusCert,
            NVL(C.SubTipoSeg, '1')                                                                                                SubTipoSeg,
            ( CASE WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN 1 ELSE CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) END )  AnioPoliza,
            DECODE(C.MODALSUMAASEG, 'N', 'N', 'N')                                                                                ModSumAseg --Siempre debe retornar N, se puede implementar una función si se requieren cambiar reglas de negocio
            ,SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, 'GMM')                                                    Coaseguro      --no se usa la función porque dicen que por default un 1 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMC devolver un 1
            ,SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMC devolver un 0
            ,SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, D.IdPoliza)                                                        PrimaCedida    --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMC devolver un 0
            ,P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(D.CANTASEGMODELO, 0)                                                                                              CANTASEGMODELO
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA                  D ON D.IdPoliza = P.IdPoliza 
                                             AND D.CodCia = P.CodCia
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO C ON C.CodCia = PC.CodCia
                                                              AND C.CodEmpresa = PC.CodEmpresa
                                                              AND C.IdTipoSeg = PC.IdTipoSeg
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                            AND XX.IdPoliza = D.IdPoliza
                                                            AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = XX.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        WHERE
            PC.CodTipoPlan IN ( '035', '036' ) -- Corresponden a GMM de Grupo y Colectivo respectivamente
            /*AND ( D.FecFinVig BETWEEN dvarFecDesde AND dvarFecHasta
                  OR D.FecIniVig BETWEEN dvarFecDesde AND dvarFecHasta
                  AND P.FecEmision <= dvarFecHasta  )*/
            AND (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
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
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(P.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde, dFecHasta)                  FecBajCert,
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
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMC devolver un 0
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida  --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMI devolver un 0
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(D.CANTASEGMODELO, 0)                                                                                              CANTASEGMODELO
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA                  D ON D.IdPoliza = P.IdPoliza
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                                             AND D.CodCia = P.CodCia
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO C ON C.CodCia = PC.CodCia
                                                              AND C.CodEmpresa = PC.CodEmpresa
                                                              AND C.IdTipoSeg = PC.IdTipoSeg
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                            AND XX.IdPoliza = D.IdPoliza
                                                            AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = XX.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
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

            AND PC.CodTipoPlan IN ( '035', '036' )
            AND EXISTS (
                SELECT /*+ INDEX(DT SYS_C0031885) */
                    'S'
                FROM  SICAS_OC.TRANSACCION T
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT ON DT.IdTransaccion = T.IdTransaccion
                WHERE  DT.Valor1 = P.IdPoliza
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
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(P.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde, dFecHasta)                  FecBajCert,
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
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, D.IdPoliza)                                                          MontoDividendo --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMC devolver un 0
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida  --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMI devolver un 0
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(D.CANTASEGMODELO, 0)                                                                                              CANTASEGMODELO
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA                  D ON D.IdPoliza = P.IdPoliza
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                                             AND D.CodCia = P.CodCia
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO C ON C.CodCia = PC.CodCia
                                                              AND C.CodEmpresa = PC.CodEmpresa
                                                              AND C.IdTipoSeg = PC.IdTipoSeg
            INNER JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                            AND XX.IdPoliza = D.IdPoliza
                                                            AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado = XX.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
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
            AND PC.CodTipoPlan IN ( '035', '036' )
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
      --
        TYPE r_SesasDatGen IS RECORD (
            CodCia           NUMBER,
            CodEmpresa       NUMBER,
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
            TipoDividendo    VARCHAR2(1),
            MontoDividendo   NUMBER,
            PrimaCedida      NUMBER,
            IdPoliza         NUMBER,
            IdetPol          NUMBER,
            Cod_Asegurado    NUMBER,
            CANTASEGMODELO   NUMBER
        );
      --
        TYPE t_SesasDatGen IS TABLE OF r_SesasDatGen;
        o_DatGen          t_SesasDatGen;
        vl_Contador       NUMBER;
        vl_Contador2      NUMBER;
        vl_AsegModel      NUMBER;
        vl_CodValido      NUMBER;
        vl_Asegurado2     NUMBER;
    BEGIN

EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.LOGERRORES_SESAS');
/*
        DELETE SICAS_OC.SESAS_DATGEN
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'--(SELECT MIN(NUMPOLIZA) FROM SESAS_DATGEN)
            AND NUMCERTIFICADO >= '0'--(SELECT MIN(NUMCERTIFICADO) FROM SESAS_DATGEN);
;
        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
      --
        */
      --
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY')|| ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY')|| ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
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
            BULK COLLECT INTO o_DatGen ;
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

                        SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMANETA_MONEDA) *(ROUND((nComisionDirecta / 100), 10)), 0)
                        INTO nComisionDirecta2
                        FROM SICAS_OC.ASEGURADO_CERTIFICADO
                        WHERE CODCIA = o_DatGen(x).CodCia
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
                                nComisionDirecta2 := nComisionDirecta;
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
                            TipoDividendo,
                            MontoDividendo,
                            ComisionDirecta,
                            IdPoliza,
                            IDetPol,
                            CodAsegurado,
                            CANTCERTIFICADOS
                        ) VALUES (
                            o_DatGen(x).CodCia,
                            o_DatGen(x).CodEmpresa,
                            o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario,
                            o_DatGen(x).NumPoliza,
                            o_DatGen(x).NumCertificado,
                            o_DatGen(x).TipoSeguro,
                            o_DatGen(x).Moneda,
                            NVL(o_DatGen(x).EntidadAsegurado,'09'),
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
                            o_DatGen(x).TipoDividendo,
                            o_DatGen(x).MontoDividendo,
                            ROUND(nComisionDirecta2, 2),
                            o_DatGen(x).IdPoliza,
                            o_DatGen(x).IDetPol,
                            o_DatGen(x).Cod_Asegurado,
                            o_DatGen(x).CANTASEGMODELO
                        );

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

                ELSE
                    vl_Contador2 := 0;
                    nComisionDirecta2 := ROUND(nComisionDirecta / vl_AsegModel, 10);
                    BEGIN
                        SELECT COUNT(1)
                        INTO vl_CodValido
                        FROM SICAS_OC.SESA_ASEGMODELO
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
                                    TipoDividendo,
                                    MontoDividendo,
                                    ComisionDirecta,
                                    IdPoliza,
                                    IDetPol,
                                    CodAsegurado,
                                    CANTCERTIFICADOS
                                ) VALUES (
                                    o_DatGen(x).CodCia,
                                    o_DatGen(x).CodEmpresa,
                                    o_DatGen(x).CodReporte,
                                    o_DatGen(x).CodUsuario,
                                    o_DatGen(x).NumPoliza,
                                    LPAD(vl_Asegurado2, 20, '0'),
                                    o_DatGen(x).TipoSeguro,
                                    o_DatGen(x).Moneda,
                                    NVL(o_DatGen(x).EntidadAsegurado,'09'),
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
                                    o_DatGen(x).TipoDividendo,
                                    o_DatGen(x).MontoDividendo,
                                    ROUND(nComisionDirecta2, 2),
                                    o_DatGen(x).IdPoliza,
                                    o_DatGen(x).IDetPol,
                                    o_DatGen(x).Cod_Asegurado,
                                    o_DatGen(x).CANTASEGMODELO
                                );

                                vl_Contador2 := vl_Contador2 + 1;
                            END LOOP;

                            
                        ELSIF vl_CodValido > 1 THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza, o_DatGen(x).NumCertificado, SQLCODE, 'La póliza '
                                                                                                              || o_DatGen(x).IdPoliza
                                                                                                              || ' tiene '
                                                                                                              || vl_CodValido
                                                                                                              || ' certificados de Asegurado Modelo validos en el catálogo.');
                        ELSIF vl_CodValido = 0 THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza, o_DatGen(x).NumCertificado, SQLCODE, 'La póliza '
                                                                                                              || o_DatGen(x).IdPoliza
                                                                                                              || ' NO tiene certificados de Asegurado Modelo validos en el catálogo.');
                        END IF;

                    EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza, o_DatGen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                        WHEN OTHERS THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza, o_DatGen(x).NumCertificado, SQLCODE, SQLERRM);
                    END;

                END IF;
             --Inserto los registros

            END LOOP;

            EXIT WHEN o_DatGen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_IND_Q;
      --
        
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

        nPmaEmiCob      NUMBER(20,10);
        nMtoAsistLocal  NUMBER(20, 2);
        nCodAsegurado   NUMBER;
        nIdPoliza       DETALLE_POLIZA.IDPOLIZA%TYPE;
        nIDetPol        DETALLE_POLIZA.IDETPOL%TYPE;
        dFecIniVig      DETALLE_POLIZA.FECINIVIG%TYPE;
        dFecFinVig      DETALLE_POLIZA.FECFINVIG%TYPE;
        nPrimaDevengada SICAS_OC.SESAS_EMISION.PrimaDevengada%TYPE;
        cTipoExtraPrima SICAS_OC.SESAS_EMISION.TIPOEXTRAPRIMA%TYPE;
        nNumDiasRenta   SICAS_OC.SESAS_EMISION.NumDiasRenta%TYPE;
      --
        CURSOR cPolizas_DatGen IS
        SELECT
            D.IdPoliza,
            D.IDetPol,
            D.CodAsegurado,
            D.FecIniVig,
            D.FecFinVig,
            D.FecBajcert,
            D.TipoDetalle,
            D.NumPoliza,
            D.NumCertificado
        FROM SICAS_OC.SESAS_DATGEN D
        WHERE D.CodCia = nCodCia
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodReporte = 'SESADATGMC'
            AND D.CodUsuario = cCodUsuario
             AND NUMCERTIFICADO = TRIM(LPAD(D.IdPoliza, 8, '0')) || TRIM(LPAD(D.IDetPol, 2, '0'))
                || TRIM(LPAD(D.CodAsegurado, 10, '0'))
            AND NUMPOLIZA >= '0'--(SELECT MIN(NUMPOLIZA) FROM SESAS_DATGEN)
            AND NUMCERTIFICADO >= '0'--(SELECT MIN(NUMCERTIFICADO) FROM SESAS_DATGEN);
      ;
        TYPE r_SesasDatGen IS RECORD (
            IdPoliza       NUMBER,
            IDetPol        NUMBER,
            CodAsegurado   NUMBER,
            FecIniVig      DATE,
            FecFinVig      DATE,
            FecBajcert     DATE,
            TipoDetalle    VARCHAR2(3),
            NumPoliza      VARCHAR2(30),
            NumCertificado VARCHAR2(30)
        );

        TYPE t_SesasDatGen IS TABLE OF r_SesasDatGen;

        o_SesasDatGen   t_SesasDatGen;

        CURSOR COBERT_Q IS
        SELECT  C.CodCobert,
                NVL(OrdenSESAS, 0)       OrdenSESAS,
                NVL(ClaveSESASNew, '99') ClaveSESAS,
                SUM(SumaAseg_Moneda)     Suma_Moneda,
                SUM(C.Prima_Moneda)      Prima_Moneda
        FROM SICAS_OC.COBERT_ACT_ASEG C
        INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
            ON CS.CodCobert = C.CodCobert
            AND CS.PlanCob = C.PlanCob
            AND CS.IdTipoSeg = C.IdTipoSeg
            AND CS.CodEmpresa = C.CodEmpresa
            AND CS.CodCia = C.CodCia
        WHERE C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND C.COD_ASEGURADO = nCodAsegurado
        GROUP BY C.CodCobert,  NVL(OrdenSESAS, 0), NVL(ClaveSESASNew, '99')
        UNION
        SELECT  C.CodCobert,
                NVL(OrdenSESAS, 0)       OrdenSESAS,
                NVL(ClaveSESASNew, '99') ClaveSESAS,
                SUM(SumaAseg_Moneda)     Suma_Moneda,
                SUM(C.Prima_Moneda)      Prima_Moneda
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
            AND C.COD_ASEGURADO = nCodAsegurado
        GROUP BY C.CodCobert,NVL(OrdenSESAS, 0),NVL(ClaveSESASNew, '99');
      --
        TYPE r_SesasEmision IS RECORD (
            CodCobert    VARCHAR2(6),
            OrdenSESAS   NUMBER,
            ClaveSESAS   VARCHAR2(3),
            Suma_Moneda  NUMBER,
            Prima_Moneda NUMBER
        );

        TYPE t_SesasEmision IS TABLE OF r_SesasEmision;

        o_SesasEmision  t_SesasEmision;

        vl_Contador2    NUMBER;
        vl_CodValido    NUMBER;
        vl_AsegModel    NUMBER;
        vl_Asegurado2   VARCHAR2(25);
    BEGIN

EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
/*
        DELETE SICAS_OC.SESAS_EMISION
        WHERE  CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario;

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE  CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
*/
        
      --
      SICAS_OC.OC_SESASCOLECTIVO.DATGEN_GM(nCodCia, nCodEmpresa, dFecDesde, dFecHasta, cCodUsuario,'SESADATGMC', 'SESADATGMC', cFiltrarPolizas);

        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY')|| ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY')|| ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');


        OPEN cPolizas_DatGen;
        LOOP
            FETCH cPolizas_DatGen
            BULK COLLECT INTO o_SesasDatGen  ;
            FOR x IN 1..o_SesasDatGen.COUNT LOOP
                nIdPoliza := o_SesasDatGen(x).IdPoliza;
                nIDetPol := o_SesasDatGen(x).IDetPol;
                dFecIniVig := o_SesasDatGen(x).FecIniVig;
                dFecFinVig := o_SesasDatGen(x).FecFinVig;
                nMtoAsistLocal := 0;
                nPmaEmiCob := 0;
                nCodAsegurado := o_SesasDatGen(x).CodAsegurado;
                OPEN COBERT_Q;
                LOOP
                    FETCH COBERT_Q
                    BULK COLLECT INTO o_SesasEmision ;
                    FOR w IN 1..o_SesasEmision.COUNT LOOP
                        nPrimaDevengada := NULL; --Implementar la función que devuelve la prima devengada
                        nPmaEmiCob := o_SesasEmision(w).Prima_Moneda;
                        nPrimaDevengada := SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(nidPoliza, nPmaEmiCob, dvarFecHasta, dFecIniVig, dFecFinVig);
                    --Inserto Emisión/Coberturas
                        IF o_SesasDatGen(x).Fecbajcert < dvarFecDesde THEN
                            nPmaEmiCob := 0;
                        END IF;
                        IF dFecFinVig <= dFecHasta THEN
                            nPrimaDevengada := nPmaEmiCob;
                        END IF;

                      /*  DBMS_OUTPUT.PUT_LINE('POLIZA  '|| o_DatGen(x).IdPoliza   ||'  ASEGMODELO  '||vl_AsegModel);*/

                        SELECT NVL(CANTASEGMODELO,0)
                        INTO vl_AsegModel
                        FROM SICAS_OC.DETALLE_POLIZA
                        WHERE IDPOLIZA = nIdPoliza
                            AND IDETPOL = nIdetpol
                            AND CODCIA = nCodCia;

                        IF vl_AsegModel <= 1 THEN

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
                                    SET PrimaEmitida = NVL(PrimaEmitida, 0) + nPmaEmiCob,
                                        SumaAsegurada = NVL(SumaAsegurada, 0) + NVL(NVL(o_SesasEmision(w).Suma_Moneda, 0), 0),
                                        primadevengada = primadevengada + nPrimaDevengada,
                                            fechainsert = sysdate
                                    WHERE CodCia = nCodCia
                                        AND CodEmpresa = nCodEmpresa
                                        AND CodReporte = cCodReporteProces
                                        AND CodUsuario = cCodUsuario
                                        AND NumPoliza = o_SesasDatGen(x).NumPoliza
                                        AND NumCertificado = o_SesasDatGen(x).NumCertificado
                                        AND Cobertura = LPAD(o_SesasEmision(w).ClaveSESAS, 2, '0');
                              --AND  OrdenSesas     = nOrdenSesas;
                                  
                                WHEN OTHERS THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, o_SesasDatGen(x).NumPoliza, o_SesasDatGen(x).NumCertificado, SQLCODE, SQLERRM);
                            END;

                       ELSE --SI TIENE ASEGURADO MODELO

                            BEGIN
                                SELECT COUNT(1)
                                INTO vl_CodValido
                                FROM SICAS_OC.SESA_ASEGMODELO
                                WHERE CODCIA = nCodCia
                                    AND CodEmpresa = nCodEmpresa
                                    AND COD_ASEGURADO = o_SesasDatGen(x).CodAsegurado;

                                IF ( vl_CodValido = 1 ) THEN --Si el asegurado modelo corresponde al catalogo, se recorre la inserción, si no, solo se inserta en el log de errores
                                vl_Contador2 :=  1;

                                    WHILE vl_Contador2 <= ( vl_AsegModel - 1 ) LOOP
                                        vl_Asegurado2 := TO_CHAR(o_SesasDatGen(x).NumCertificado + vl_Contador2);

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
                                               LPAD(vl_Asegurado2, 20, '0'),
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
                                                SET PrimaEmitida = NVL(PrimaEmitida, 0) + nPmaEmiCob,
                                                    SumaAsegurada = NVL(SumaAsegurada, 0) + NVL(NVL(o_SesasEmision(w).Suma_Moneda, 0), 0),
                                                    primadevengada = primadevengada + nPrimaDevengada,
                                            fechainsert = sysdate
                                                WHERE CodCia = nCodCia
                                                    AND CodEmpresa = nCodEmpresa
                                                    AND CodReporte = cCodReporteProces
                                                    AND CodUsuario = cCodUsuario
                                                    AND NumPoliza = o_SesasDatGen(x).NumPoliza
                                                    AND NumCertificado = o_SesasDatGen(x).NumCertificado
                                                    AND Cobertura = LPAD(o_SesasEmision(w).ClaveSESAS, 2, '0');
                                          --AND  OrdenSesas     = nOrdenSesas;
                                              
                                            WHEN OTHERS THEN
                                                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, o_SesasDatGen(x).NumPoliza, o_SesasDatGen(x).NumCertificado, SQLCODE, SQLERRM);
                                        END;


                                        vl_Contador2 := vl_Contador2 + 1;
                                    END LOOP;
                            

                                ELSIF (vl_CodValido > 1) THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, o_SesasDatGen(x).NumPoliza, o_SesasDatGen(x).NumCertificado, SQLCODE, 'La póliza '
                                                                                                                      || o_SesasDatGen(x).IdPoliza|| ' tiene '|| vl_CodValido|| ' certificados de Asegurado Modelo validos en el catálogo.');
                                ELSIF (vl_CodValido = 0) THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, o_SesasDatGen(x).NumPoliza, o_SesasDatGen(x).NumCertificado, SQLCODE, 'La póliza '
                                                                                                                      || o_SesasDatGen(x).IdPoliza|| ' NO tiene certificados de Asegurado Modelo validos en el catálogo.');
                                END IF;

                            EXCEPTION
                                WHEN DUP_VAL_ON_INDEX THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, o_SesasDatGen(x).NumPoliza, o_SesasDatGen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                                WHEN OTHERS THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, o_SesasDatGen(x).NumPoliza, o_SesasDatGen(x).NumCertificado, SQLCODE, SQLERRM);
                            END;


                        END IF;

                    END LOOP;

                    EXIT WHEN o_SesasEmision.COUNT = 0;
                END LOOP;

                CLOSE COBERT_Q;
                --
            END LOOP;

            EXIT WHEN o_SesasDatGen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
        



      OPEN cPolizas_DatGen;
        LOOP
            FETCH cPolizas_DatGen
            BULK COLLECT INTO o_SesasDatGen;
            FOR x IN 1..o_SesasDatGen.COUNT LOOP         

                BEGIN
                    SELECT NVL(CANTASEGMODELO, 0)
                    INTO vl_AsegModel
                    FROM SICAS_OC.DETALLE_POLIZA
                    WHERE IDPOLIZA = o_SesasDatGen(x).IdPoliza
                        AND IDETPOL = o_SesasDatGen(x).IDetPol
                        AND CODCIA = nCodCia;

                EXCEPTION
                    WHEN OTHERS THEN
                        vl_AsegModel := 0;
                END;
                      /*  DBMS_OUTPUT.PUT_LINE('POLIZA  '|| o_DatGen(x).IdPoliza   ||'  ASEGMODELO  '||vl_AsegModel);*/

                IF vl_AsegModel <= 1 THEN

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


                    UPDATE SICAS_OC.SESAS_EMISION E
                    SET PrimaEmitida = NVL((ROUND((100 / nComisionDirecta2), 10) * NVL(SumaAsegurada, 0)) *(ROUND((nPmaEmiCob / 100), 10)), 0)   ,
                        PrimaDevengada = SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(nidPoliza, NVL((ROUND((100 / nComisionDirecta2), 10) * NVL(SumaAsegurada, 0)) *(ROUND((nPmaEmiCob / 100), 10)), 0) , dvarFecHasta, o_SesasDatGen(x).FecIniVig,o_SesasDatGen(x).FecFinVig),
                                            fechainsert = sysdate
                    WHERE  CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMCERTIFICADO = TRIM(LPAD(o_SesasDatGen(x).IdPoliza, 8, '0')) ||TRIM(LPAD(o_SesasDatGen(x).IDetPol, 2, '0')) ||TRIM(LPAD(o_SesasDatGen(x).CodAsegurado, 10, '0'))
            AND COBERTURA = COBERTURA;


                ELSE  --ES ASEGURADO MODELO
            BEGIN
                    SELECT SUM(PRIMANETA) /vl_AsegModel
                    INTO nPmaEmiCob
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = nCodCia
                        AND IDPOLIZA = o_SesasDatGen(x).IdPoliza
                        AND IDETPOL = o_SesasDatGen(x).IDetPol;
        EXCEPTION
            WHEN OTHERS THEN
                nPmaEmiCob := NULL;
        END;
                    IF nPmaEmiCob IS NULL THEN 
        BEGIN
                        SELECT SUM(PRIMA_MONEDA)/vl_AsegModel
                        INTO nPmaEmiCob
                        FROM SICAS_OC.DETALLE_POLIZA 
                        WHERE CODCIA = nCodCia
                            AND IDPOLIZA = o_SesasDatGen(x).IdPoliza
                            AND IDETPOL = o_SesasDatGen(x).IDetPol;
EXCEPTION
WHEN OTHERS THEN
    nPmaEmiCob := 0;
END;
                   END IF;



                    UPDATE SICAS_OC.SESAS_EMISION E
                    SET PrimaEmitida = nPmaEmiCob,
                        PrimaDevengada = SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(o_SesasDatGen(x).IdPoliza, nPmaEmiCob , dvarFecHasta, o_SesasDatGen(x).FecIniVig,o_SesasDatGen(x).FecFinVig),
                        fechainsert = sysdate
                    WHERE CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa
                        AND CodReporte = cCodReporteProces
                        AND CodUsuario = cCodUsuario
                        AND SUBSTR(NUMCERTIFICADO,0,10) = TRIM(LPAD(o_SesasDatGen(x).IdPoliza, 8, '0')) ||TRIM(LPAD(o_SesasDatGen(x).IDetPol, 2, '0')) 
                        AND COBERTURA = COBERTURA;

                END IF;

            END LOOP;
            EXIT WHEN o_SesasDatGen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
             
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
            TRIM(LPAD(S.IdPoliza, 8, '0')) || TRIM(LPAD(S.IDetPol, 2, '0')) || TRIM(LPAD(S.Cod_Asegurado, 10, '0'))                 NumCertificado,
            S.IdSiniestro                                                                                                           NumSiniestro,
            SICAS_OC.OC_PROCESOSSESAS.GETNUMRECLAMOSINI()                                                                           NumReclamacion  --Por definir
            ,S.Fec_Ocurrencia                                                                                                        FecOcuSin,
            S.Fec_Notificacion                                                                                                      FecRepSin       --Por Definir  fecha reclamación
            ,SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(S.CodPaisOcurr, S.CodProvOcurr, PN.CodPaisRes, PN.CodProvRes, S.IdPoliza) EntOcuSin,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINGMM(S.CodCia, S.IdPoliza, S.IdSiniestro, S.Sts_Siniestro,(
                CASE  WHEN R.TIPO_MOVIMIENTO IN('PAGOS') THEN R.IMPTE_MOVIMIENTO *( CASE WHEN R.SIGNO = '-' THEN -1  ELSE 1 END ) ELSE 0 END) +(
                CASE  WHEN R.TIPO_MOVIMIENTO IN('DESPAG', 'DESCUE', 'DEDUC') THEN R.IMPTE_MOVIMIENTO *( CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1 END )  ELSE 0  END ),
                CASE  WHEN R.TIPO_MOVIMIENTO IN('ESTINI', 'AJUMAS', 'AJUMEN') THEN R.IMPTE_MOVIMIENTO *( CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1 END ) ELSE 0 END, 'SINGMC')  StatusReclamacion  --Aplicar en la rutina la parte de SINGMMC
            ,SICAS_OC.OC_PROCESOSSESAS.GETTIPOGASTOINI()                                                                             TipoGasto       --Por Definir
            ,
            0                                                                                                                       PeriodoEspera   --Revisar porque este va a nivel cobertura y el reporte no va a ese nivel, va a nivel siniestro
            ,
            CASE WHEN LENGTH(NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)) = 3 THEN S.Motivo_De_Siniestro || 'X'
                ELSE NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro) END                                        CausaSiniestro,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOPAGOSINI()                                                                             TipoPago        --Por Definir
            ,DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                          Sexo,
            PN.FecNacimiento                                                                                                        FecNacim,
            NVL(P.MONTODEDUCIBLE, 0)                                                                                                MontoDeducible  --Por definir y revisar porque este va a nivel cobertura y el reporte no va a ese nivel, va a nivel siniestro
            ,SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, NULL)                                                     MontoCoaseguro  --Default 0   
            ,0                                                                                                                       MontoRecRea     --Default 0
            ,CASE WHEN R.TIPO_MOVIMIENTO IN ( 'ESTINI', 'AJUMAS', 'AJUMEN' ) THEN R.IMPTE_MOVIMIENTO * ( CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1 END ) ELSE 0 END  MontoReclamado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOMOVRECLAMO()                                                                           TipMovRec       --Por definir y revisar porque este va a nivel cobertura y el reporte no va a ese nivel, va a nivel siniestro
            ,( CASE WHEN R.TIPO_MOVIMIENTO IN ( 'PAGOS' ) THEN R.IMPTE_MOVIMIENTO * ( CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1 END ) ELSE  0 END ) + (
                CASE WHEN R.TIPO_MOVIMIENTO IN ( 'DESPAG', 'DESCUE', 'DEDUC' ) THEN R.IMPTE_MOVIMIENTO * ( CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1  END ) ELSE 0  END  ) Monto_Pago_Moneda
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA                  D
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
        INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO C 
            ON C.IdTipoSeg = D.IdTipoSeg
            AND C.CodEmpresa = D.CodEmpresa
            AND C.CodCia = D.CodCia
        INNER JOIN SICAS_OC.RESERVA_DET              R 
            ON R.ID_SINIESTRO = S.IDSINIESTRO
            AND R.ID_POLIZA = S.IDPOLIZA
            AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE  /*S.Fec_Notificacion  BETWEEN dvarFecDesde AND dvarFecHasta
            AND  */
                S.Sts_Siniestro != 'SOL'
            AND ( EXISTS (
                SELECT 'S'
                FROM SICAS_OC.APROBACION_ASEG A
                INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B 
                    ON B.NumTransaccion = A.IdTransaccion
                WHERE A.IdSiniestro = S.IdSiniestro 
                                /*AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )  OR EXISTS (   SELECT 'S'
                                FROM SICAS_OC.APROBACIONES A
                                INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B 
                                    ON B.NumTransaccion = A.IdTransaccion
                                WHERE A.IdSiniestro = S.IdSiniestro 
                                               /* AND A.IDPOLIZA = S.IdPoliza 
                                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )
                    --OR R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta 
             )
            AND D.IdTipoSeg IN (
                SELECT PC.IdTipoSeg
                FROM SICAS_OC.PLAN_COBERTURAS PC
                WHERE PC.CodTipoPlan IN ( '035', '036' )
            ) -- Corresponden a GMM de Grupo y Colectivo respectivamente
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND P.IdPoliza IN (
                SELECT IdPoliza
                FROM SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) );
      --
        TYPE r_SesasSiniestro IS RECORD (
            IdPoliza          NUMBER,
            IDetPol           NUMBER,
            NumPoliza         VARCHAR2(30),
            NumCertificado    VARCHAR2(30),
            NumSiniestro      VARCHAR2(20),
            NumReclamacion    VARCHAR2(20),
            FecOcuSin         DATE,
            FecRepSin         DATE,
            EntOcuSin         VARCHAR2(2),
            StatusReclamacion VARCHAR2(1),
            TipoGasto         VARCHAR2(2),
            PeriodoEspera     NUMBER,
            CausaSiniestro    VARCHAR2(4),
            TipoPago          VARCHAR2(1),
            Sexo              VARCHAR2(1),
            FecNacim          DATE,
            MontoDeducible    NUMBER,
            MontoCoaseguro    NUMBER,
            MontoRecRea       NUMBER,
            MontoReclamado    NUMBER,
            TipMovRec         VARCHAR2(1),
            Monto_Pago_Moneda NUMBER
        );
        TYPE t_SesasSiniestro IS TABLE OF r_SesasSiniestro;
        o_SesasSiniestro t_SesasSiniestro;

        nMonto_Moneda    NUMBER;
        nMontoPagado     NUMBER;
    BEGIN

EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.LOGERRORES_SESAS');
/*
        DELETE SICAS_OC.SESAS_SINIESTROS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario;

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
*/
        
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
                    SELECT  MIN(FE_MOVTO)
                    INTO dFecConSin
                    FROM SICAS_OC.RESERVA_DET
                    WHERE ID_POLIZA = o_SesasSiniestro(x).IdPoliza
                        AND ID_SINIESTRO = o_SesasSiniestro(x).NumSiniestro
                        AND AÑO_MOVIMIENTO = TO_NUMBER(TO_CHAR(dvarFecDesde, 'YYYY'));

                EXCEPTION
                    WHEN OTHERS THEN
                        dFecConSin := NULL;
                END;

                nMontoReclamo := NVL(o_SesasSiniestro(x).MONTODEDUCIBLE, 0) + NVL(o_SesasSiniestro(x).MontoReclamado, 0);

                SICAS_OC.OC_PROCESOSSESAS.INSERTASINIESTRO(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, o_SesasSiniestro(x).
                NumPoliza, o_SesasSiniestro(x).NumCertificado, o_SesasSiniestro(x).NumSiniestro, o_SesasSiniestro(x).NumReclamacion, o_SesasSiniestro(x).FecOcuSin, o_SesasSiniestro(x).FecRepSin,
                                                          dFecConSin, NVL(dFecPagSin, dFecPagSin), o_SesasSiniestro(x).StatusReclamacion,
                                                          o_SesasSiniestro(x).EntOcuSin, ' '   --Cobertura
                                                          , nMontoReclamo,o_SesasSiniestro(x).CausaSiniestro, NVL(o_SesasSiniestro(x).MontoDeducible,0), o_SesasSiniestro(x).MontoCoaseguro, o_SesasSiniestro(x).Monto_Pago_Moneda,
                                                          o_SesasSiniestro(x).MontoRecRea, NULL  --MontoDividendo
                                                          ,o_SesasSiniestro(x).TipMovRec, NULL  --MontoVencimiento
                                                          , NULL   --MontoRescate
                                                          , o_SesasSiniestro(x).TipoGasto, o_SesasSiniestro(x).PeriodoEspera,
                                                          o_SesasSiniestro(x).TipoPago, o_SesasSiniestro(x).Sexo, o_SesasSiniestro(x).
                                                          FecNacim, NULL);   --OrdeSesas

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
                SET STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINGMM(nCodCia, o_SesasSiniestro(x).IdPoliza, o_SesasSiniestro( x).NumSiniestro, o_SesasSiniestro(x).StatusReclamacion, o_SesasSiniestro(x).Monto_Pago_Moneda,nMontoReclamo, 'SINGMC'), FECPAGSIN = dFecPagSin,
                    fechainsert = sysdate
                WHERE NUMPOLIZA = o_SesasSiniestro(x).NumPoliza
                    AND NUMSINIESTRO = o_SesasSiniestro(x).NumSiniestro;--OrdeSesas

            END LOOP;

            EXIT WHEN o_SesasSiniestro.COUNT = 0;
        END LOOP;

        CLOSE cSiniestros;
        UPDATE SICAS_OC.SESAS_SINIESTROS
        SET STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINGMM(CodCia, NULL, NumSiniestro, StatusReclamacion, MONTOPAGSIN, MONTORECLAMADO, 'SINGMC'),
            FECPAGSIN = CASE WHEN MONTOPAGSIN = 0 THEN NULL ELSE FECPAGSIN END,
                                            fechainsert = sysdate
        WHERE NUMPOLIZA = NumPoliza
            AND NUMSINIESTRO = NumSiniestro;--OrdeSesas

        
    END SINIESTROS_GM;

END OC_SESASCOLECTIVO;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_SESASCOLECTIVO FOR SICAS_OC.OC_SESASCOLECTIVO;

GRANT EXECUTE ON SICAS_OC.OC_SESASCOLECTIVO TO PUBLIC
/
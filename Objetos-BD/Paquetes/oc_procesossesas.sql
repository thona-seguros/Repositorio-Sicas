CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROCESOSSESAS IS

    PROCEDURE CONTROLPRINCIPAL (
        nCodCia           SICAS_OC.ENTREGAS_CNSF_CONFIG.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.ENTREGAS_CNSF_CONFIG.CODEMPRESA%TYPE,
        cCodEntregaProces SICAS_OC.ENTREGAS_CNSF_CONFIG.CODENTREGA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.TEMP_REGISTROS_SESAS.CODUSUARIO%TYPE,
        cFiltrarPolizas   VARCHAR2 );

    PROCEDURE NOTIFICACORREO (cNombreUser VARCHAR2, cNomSesa VARCHAR2, cEstatus VARCHAR2, dInicio VARCHAR2, dFin VARCHAR2, cDuracion VARCHAR2);

    PROCEDURE NOTIFICARUTINA (cNombreUser VARCHAR2, cNomSesa VARCHAR2, cEstatus VARCHAR2, dInicio VARCHAR2, dFin VARCHAR2, cDuracion VARCHAR2);

    FUNCTION GENERAENCABEZADO (
        nCodCia       SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODCIA%TYPE,
        nCodEmpresa   SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODEMPRESA%TYPE,
        cCodPlantilla SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODPLANTILLA%TYPE,
        cSeparador    VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION GETANIOPOLIZA (
        nNumPolUnico   VARCHAR 
    ) RETURN NUMBER;

    FUNCTION GETCANTASEGAPC (
        nCodCia         NUMBER,
        nCodEmpresa     NUMBER,
        nCodAsegurado   VARCHAR,
        nCantAsegurado NUMBER
    ) RETURN NUMBER;

    FUNCTION GETOCUPACIONAP (
        cCodActividad   VARCHAR,
        cTipoSeg        VARCHAR --IND O COL PARA SABER A QUE CATALOGO IR
    ) RETURN VARCHAR2;

    FUNCTION GETENTIDADASEGURADO (
        cCodPaisRes   SICAS_OC.PERSONA_NATURAL_JURIDICA.CODPAISRES%TYPE,
        cCodProvRes   SICAS_OC.PERSONA_NATURAL_JURIDICA.CODPROVRES%TYPE,
        cCodPaisResPN SICAS_OC.PERSONA_NATURAL_JURIDICA.CODPROVRES%TYPE,
        cCodProvResPN SICAS_OC.PERSONA_NATURAL_JURIDICA.CODPROVRES%TYPE,
        nIdPoliza     SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN VARCHAR2;

    FUNCTION GETSTATUSCERT (
        nCodCia      SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza    SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        nIdetPol     NUMBER,
        dFecAnul     DATE,
        dFecHasta    DATE,
        cStsDetalle  SICAS_OC.DETALLE_POLIZA.STSDETALLE%TYPE,
        dFecIniVig   SICAS_OC.DETALLE_POLIZA.FECINIVIG%TYPE,
        dFecFinVig   SICAS_OC.DETALLE_POLIZA.FECFINVIG%TYPE,
        cCodAegurado NUMBER
    ) RETURN VARCHAR2;

    FUNCTION GETSTATUSCERTAP (
        nCodCia      SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza    SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        nIdetPol     NUMBER,
        dFecAnul     DATE,
        dFecHasta    DATE,
        cStsDetalle  SICAS_OC.DETALLE_POLIZA.STSDETALLE%TYPE,
        dFecIniVig   SICAS_OC.DETALLE_POLIZA.FECINIVIG%TYPE,
        dFecFinVig   SICAS_OC.DETALLE_POLIZA.FECFINVIG%TYPE,
        cCodAegurado NUMBER
    ) RETURN VARCHAR2;

    FUNCTION GETCANTCERTIFICADOS (
        nCodCia         SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.DETALLE_POLIZA.CODEMPRESA%TYPE,
        nIdPoliza       SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        nIDetPol        SICAS_OC.DETALLE_POLIZA.IDETPOL%TYPE,
        cIndAsegModelo  SICAS_OC.DETALLE_POLIZA.INDASEGMODELO%TYPE,
        nCantAsegModelo SICAS_OC.DETALLE_POLIZA.CANTASEGMODELO%TYPE,
        cIndConcentrada SICAS_OC.POLIZAS.INDCONCENTRADA%TYPE,
        nIdEndoso       SICAS_OC.ASEGURADO_CERTIFICADO.IDENDOSO%TYPE
    ) RETURN NUMBER;

    FUNCTION GENERADETALLE (
        nCodCia       SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODCIA%TYPE,
        nCodEmpresa   SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODEMPRESA%TYPE,
        cCodPlantilla SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODPLANTILLA%TYPE,
        cSeparador    VARCHAR2,
        cCodUsuario   SICAS_OC.TEMP_REGISTROS_SESAS.CODUSUARIO%TYPE,
        cOrigen       VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    FUNCTION GENERADETALLEERROR (
        nCodCia       SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODCIA%TYPE,
        nCodEmpresa   SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODEMPRESA%TYPE,
        cCodPlantilla SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODPLANTILLA%TYPE,
        cSeparador    VARCHAR2,
        cCodUsuario   SICAS_OC.TEMP_REGISTROS_SESAS.CODUSUARIO%TYPE,
        cOrigen       VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    PROCEDURE GENERAREPORTES (
        nCodCia             SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODCIA%TYPE,
        nCodEmpresa         SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODEMPRESA%TYPE,
        cNomArchDatGen      VARCHAR2,
        cEncabDatGen        VARCHAR2,
        cDetalleDatGen      VARCHAR2,
        cNomArchProces      VARCHAR2,
        cEncabProces        VARCHAR2,
        cEncabProcesError   VARCHAR2,
        cDetalleProces      VARCHAR2,
        cDetalleProcesError VARCHAR2,
        cNomArchZip         VARCHAR2,
        cEjecutaLog         NUMBER
    ); --SI ES 0 NO EJECUTA LOG DE ERRORES

    PROCEDURE INSERTAEMISION (
        nCodCia         SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        cCodReporte     SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodUsuario     SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cNumPoliza      SICAS_OC.SESAS_EMISION.NUMPOLIZA%TYPE,
        cNumCertificado SICAS_OC.SESAS_EMISION.NUMCERTIFICADO%TYPE,
        cCobertura      SICAS_OC.SESAS_EMISION.COBERTURA%TYPE,
        cTipoSumaSeg    SICAS_OC.SESAS_EMISION.TIPOSUMASEG%TYPE,
        nPeriodoEspera  SICAS_OC.SESAS_EMISION.PERIODOESPERA%TYPE,
        nSumaAsegurada  SICAS_OC.SESAS_EMISION.SUMAASEGURADA%TYPE,
        nPrimaEmitida   SICAS_OC.SESAS_EMISION.PRIMAEMITIDA%TYPE,
        nPrimaDevengada SICAS_OC.SESAS_EMISION.PRIMADEVENGADA%TYPE,
        nNumDiasRenta   NUMBER,
        cTipoExtraPrima SICAS_OC.SESAS_EMISION.TIPOEXTRAPRIMA%TYPE,
        nOrdenSesas     SICAS_OC.SESAS_EMISION.ORDENSESAS%TYPE
    );

    PROCEDURE ACTUALIZAEMISION (
        nCodCia         SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        cCodReporte     SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodUsuario     SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cNumPoliza      SICAS_OC.SESAS_EMISION.NUMPOLIZA%TYPE,
        cNumCertificado SICAS_OC.SESAS_EMISION.NUMCERTIFICADO%TYPE,
        cCobertura      SICAS_OC.SESAS_EMISION.COBERTURA%TYPE,
        nSumaAsegurada  SICAS_OC.SESAS_EMISION.SUMAASEGURADA%TYPE,
        nPrimaEmitida   SICAS_OC.SESAS_EMISION.PRIMAEMITIDA%TYPE,
        nOrdenSesas     SICAS_OC.SESAS_EMISION.ORDENSESAS%TYPE
    );

    FUNCTION EXISTEREGISTROEMISION (
        nCodCia         SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        cCodReporte     SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodUsuario     SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cNumPoliza      SICAS_OC.SESAS_EMISION.NUMPOLIZA%TYPE,
        cNumCertificado SICAS_OC.SESAS_EMISION.NUMCERTIFICADO%TYPE,
        cCobertura      SICAS_OC.SESAS_EMISION.COBERTURA%TYPE,
        nOrdenSesas     SICAS_OC.SESAS_EMISION.ORDENSESAS%TYPE
    ) RETURN VARCHAR2;

    PROCEDURE DATOSASEGURADO (
        nCodCia        IN SICAS_OC.ASEGURADO.CODCIA%TYPE,
        nCodEmpresa    IN SICAS_OC.ASEGURADO.CODEMPRESA%TYPE,
        nCod_Asegurado IN SICAS_OC.ASEGURADO.COD_ASEGURADO%TYPE,
        dFecIniVig     IN DATE,
        cSexo          OUT SICAS_OC.PERSONA_NATURAL_JURIDICA.SEXO%TYPE,
        nEdad          OUT NUMBER,
        cCodActividad  OUT SICAS_OC.PERSONA_NATURAL_JURIDICA.CODACTIVIDAD%TYPE,
        cRiesgo        OUT actividades_economicas.RIESGOACTIVIDAD%TYPE
    );

    FUNCTION GETMONTOCOMISION (
        nCodCia     SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nCodEmpresa SICAS_OC.DETALLE_POLIZA.CODEMPRESA%TYPE,
        nIdPoliza   SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        dFecDesde   DATE,
        dFecHasta   DATE
    ) RETURN NUMBER;

    FUNCTION GETMONTOCOMISIONAP (
        nCodCia     SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nCodEmpresa SICAS_OC.DETALLE_POLIZA.CODEMPRESA%TYPE,
        nIdPoliza   SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        dFecDesde   DATE,
        dFecHasta   DATE
    ) RETURN NUMBER;

    FUNCTION GETSTATUSSIN (
        nCodCia       SICAS_OC.SINIESTRO.CODCIA%TYPE,
        nIdPoliza     SICAS_OC.SINIESTRO.IDPOLIZA%TYPE,
        nIdSiniestro  SICAS_OC.SINIESTRO.IDSINIESTRO%TYPE,
        cStsSiniestro SICAS_OC.SINIESTRO.STS_SINIESTRO%TYPE,
        nMtoPagMon    SICAS_OC.SINIESTRO.MONTO_PAGO_MONEDA%TYPE,
        nMtoResMon    SICAS_OC.SINIESTRO.MONTO_RESERVA_MONEDA%TYPE,
        cProcedencia  VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION GETSTATUSSINGMM (
        nCodCia       SICAS_OC.SINIESTRO.CODCIA%TYPE,
        nIdPoliza     SICAS_OC.SINIESTRO.IDPOLIZA%TYPE,
        nIdSiniestro  SICAS_OC.SINIESTRO.IDSINIESTRO%TYPE,
        cStsSiniestro SICAS_OC.SINIESTRO.STS_SINIESTRO%TYPE,
        nMtoPagMon    SICAS_OC.SINIESTRO.MONTO_PAGO_MONEDA%TYPE,
        nMtoResMon    SICAS_OC.SINIESTRO.MONTO_RESERVA_MONEDA%TYPE,
        cProcedencia  VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION GETSTATUSSINVII (
        nCodCia       SICAS_OC.SINIESTRO.CODCIA%TYPE,
        nIdPoliza     SICAS_OC.SINIESTRO.IDPOLIZA%TYPE,
        nIdSiniestro  SICAS_OC.SINIESTRO.IDSINIESTRO%TYPE,
        cStsSiniestro SICAS_OC.SINIESTRO.STS_SINIESTRO%TYPE,
        nMtoPagMon    SICAS_OC.SINIESTRO.MONTO_PAGO_MONEDA%TYPE,
        nMtoResMon    SICAS_OC.SINIESTRO.MONTO_RESERVA_MONEDA%TYPE,
        cProcedencia  VARCHAR2
    ) RETURN VARCHAR2;

    PROCEDURE INSERTASINIESTRO (
        nCodCia            SICAS_OC.SESAS_SINIESTROS.CODCIA%TYPE,
        nCodEmpresa        SICAS_OC.SESAS_SINIESTROS.CODEMPRESA%TYPE,
        cCodReporte        SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cCodUsuario        SICAS_OC.SESAS_SINIESTROS.CODUSUARIO%TYPE,
        cNumPoliza         SICAS_OC.SESAS_SINIESTROS.NUMPOLIZA%TYPE,
        cNumCertificado    SICAS_OC.SESAS_SINIESTROS.NUMCERTIFICADO%TYPE,
        cNumSiniestro      SICAS_OC.SESAS_SINIESTROS.NUMSINIESTRO%TYPE,
        cNumReclamacion    SICAS_OC.SESAS_SINIESTROS.NUMRECLAMACION%TYPE,
        dFecOcuSin         SICAS_OC.SESAS_SINIESTROS.FECOCUSIN%TYPE,
        dFecRepRec         SICAS_OC.SESAS_SINIESTROS.FECREPREC%TYPE,
        dFecConSin         SICAS_OC.SESAS_SINIESTROS.FECCONSIN%TYPE,
        dFecPagSin         SICAS_OC.SESAS_SINIESTROS.FECPAGSIN%TYPE,
        cStatusReclamacion SICAS_OC.SESAS_SINIESTROS.STATUSRECLAMACION%TYPE,
        cEntOcuSin         SICAS_OC.SESAS_SINIESTROS.ENTOCUSIN%TYPE,
        cCobertura         SICAS_OC.SESAS_SINIESTROS.COBERTURA%TYPE,
        nMontoReclamado    SICAS_OC.SESAS_SINIESTROS.MONTORECLAMADO%TYPE,
        cCausaSiniestro    SICAS_OC.SESAS_SINIESTROS.CAUSASINIESTRO%TYPE,
        nMontoDeducible    SICAS_OC.SESAS_SINIESTROS.MONTODEDUCIBLE%TYPE,
        nMontoCoaseguro    SICAS_OC.SESAS_SINIESTROS.MONTOCOASEGURO%TYPE,
        nMontoPagSin       SICAS_OC.SESAS_SINIESTROS.MONTOPAGSIN%TYPE,
        nMontoRecRea       SICAS_OC.SESAS_SINIESTROS.MONTORECREA%TYPE,
        nMontoDividendo    SICAS_OC.SESAS_SINIESTROS.MONTODIVIDENDO%TYPE,
        cTipMovRec         SICAS_OC.SESAS_SINIESTROS.TIPMOVREC%TYPE,
        nMontoVencimiento  SICAS_OC.SESAS_SINIESTROS.MONTOVENCIMIENTO%TYPE,
        nMontoRescate      SICAS_OC.SESAS_SINIESTROS.MONTORESCATE%TYPE,
        cTipoGasto         SICAS_OC.SESAS_SINIESTROS.TIPOGASTO%TYPE,
        nPeriodoEspera     SICAS_OC.SESAS_SINIESTROS.PERIODOESPERA%TYPE,
        cTipoPago          SICAS_OC.SESAS_SINIESTROS.TIPOPAGO%TYPE,
        cSexo              SICAS_OC.SESAS_SINIESTROS.SEXO%TYPE,
        dFecNacim          SICAS_OC.SESAS_SINIESTROS.FECNACIM%TYPE,
        nOrdenSesas        SICAS_OC.SESAS_SINIESTROS.ORDENSESAS%TYPE
    );

    FUNCTION GETCANTCERTIFICADOS_2 (
        nCodCia         SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.DETALLE_POLIZA.CODEMPRESA%TYPE,
        nIdPoliza       SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        nIDetPol        SICAS_OC.DETALLE_POLIZA.IDETPOL%TYPE,
        cIndAsegModelo  SICAS_OC.DETALLE_POLIZA.INDASEGMODELO%TYPE,
        nCantAsegModelo SICAS_OC.DETALLE_POLIZA.CANTASEGMODELO%TYPE,
        nPolConcentrada NUMBER,
        nIdEndoso       SICAS_OC.ASEGURADO_CERTIFICADO.IDENDOSO%TYPE
    ) RETURN NUMBER;

    PROCEDURE DATOSSINIESTROS (
        nCodCia        IN SICAS_OC.ASEGURADO.CODCIA%TYPE,
        nCodEmpresa    IN SICAS_OC.ASEGURADO.CODEMPRESA%TYPE,
        nIdPoliza      IN SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        cNumSiniestro  IN VARCHAR2,
        cCoberturaSini IN VARCHAR2 DEFAULT NULL,
        dFecPagSin     OUT DATE,
        nMonto_Moneda  OUT NUMBER,
        dFecConSin     OUT DATE
    );

    FUNCTION GETFORMAVENTA (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN VARCHAR;

    FUNCTION GETCOASEGURO (
        nCodCia    SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza  SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        cCoaseguro VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;

    FUNCTION GETPRIMACEDIDA (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER;

    FUNCTION GETSDOFONINV (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER;

    FUNCTION GETSDOFONADM (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER;

    FUNCTION GETMNTODIVID (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER;

    FUNCTION GETMNTORESCATE (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER;

    FUNCTION GETFECBAJACERT (
        nIdPoliza  SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        dFecIniVig DATE,
        dFecFinVig DATE,
        dFecAnul   DATE,
        dFecDesde   DATE,
        dFecHasta  DATE,
        cTipoSeg    VARCHAR2 DEFAULT NULL
    ) RETURN DATE;

    FUNCTION GETTIPOSUMASEG (
        nCodCia    SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        ClaveSesas VARCHAR2,
        TipoSeguro VARCHAR2
    ) RETURN NUMBER;

    FUNCTION GETPRIMADEVENGADA (
        IdPoliza      NUMBER,
        nPrimaEmitida NUMBER,
        dFecHasta     DATE,
        dFecIniVig    DATE,
        dFecFinVig    DATE
    ) RETURN NUMBER;

    FUNCTION GETNUMCERTIFICADO (
        vCodCia   IN NUMBER,
        vIdPoliza IN NUMBER,
        vIDetPol  IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION GETTIPOSEGURO (
        TipoSeguro VARCHAR2,
        IdPoliza   NUMBER
    ) RETURN VARCHAR2;


    FUNCTION GETNUMRECLAMACION RETURN NUMBER;

    FUNCTION GETTIPOMOVRECLAMO RETURN VARCHAR2;

    FUNCTION GETNUMDIASRENTA RETURN NUMBER;

    FUNCTION GETNUMSINIESTRO RETURN NUMBER;

    FUNCTION GETTIPOPAGOSINI RETURN NUMBER;

    FUNCTION GETTIPOGASTOINI RETURN NUMBER;

    FUNCTION GETNUMRECLAMOSINI RETURN NUMBER;

    PROCEDURE CALCULO_NUMREC (vlPnomsesa IN VARCHAR2);

    vl_Ejecucion    VARCHAR2(1) := '0';
    vl_Intento      NUMBER      :=  0;
    vl_Intento2     NUMBER      := 0;
    vl_Inicio       DATE;
    vl_Final        DATE;
    vl_Duracion     VARCHAR2(4000);
    prueba          VARCHAR2(4000);
    vl_NomSesa      VARCHAR2(50);
    cNomDirectorio     VARCHAR2(1000) := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
    
END OC_PROCESOSSESAS;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROCESOSSESAS IS

    PROCEDURE CONTROLPRINCIPAL (
        nCodCia           SICAS_OC.ENTREGAS_CNSF_CONFIG.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.ENTREGAS_CNSF_CONFIG.CODEMPRESA%TYPE
                            -- , cCodEntregaDatGen  SICAS_OC.ENTREGAS_CNSF_CONFIG.CODENTREGA%TYPE
        ,
        cCodEntregaProces SICAS_OC.ENTREGAS_CNSF_CONFIG.CODENTREGA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.TEMP_REGISTROS_SESAS.CODUSUARIO%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS

        cNomArchDatGen      SICAS_OC.ENTREGAS_CNSF_CONFIG.NOMARCHIVO%TYPE;
        cNomArchDatGenError SICAS_OC.ENTREGAS_CNSF_CONFIG.NOMARCHIVO%TYPE;
        cNomArchProces      SICAS_OC.ENTREGAS_CNSF_CONFIG.NOMARCHIVO%TYPE;
        cNomArchProcesError SICAS_OC.ENTREGAS_CNSF_CONFIG.NOMARCHIVO%TYPE;
        cNomProcDatGen      SICAS_OC.ENTREGAS_CNSF_CONFIG.NOMREPPROC%TYPE;
        cNomProcProces      SICAS_OC.ENTREGAS_CNSF_CONFIG.NOMREPPROC%TYPE;
        cEncabDatGen        VARCHAR2(4000);
        cEncabDatGenError   VARCHAR2(4000);
        cDetalleDatGen      VARCHAR2(4000);
        cDetalleDatGenError VARCHAR2(4000);
        cEncabProces        VARCHAR2(4000);
        cEncabProcesError   VARCHAR2(4000);
        cDetalleProces      VARCHAR2(4000);
        cDetalleProceserror VARCHAR2(4000);
        cNomArchZip         VARCHAR2(100);
        cNomArchZipError    VARCHAR2(100);
        cBlockPlSql         VARCHAR2(4000);
        cSeparador          SICAS_OC.ENTREGAS_CNSF_CONFIG.Separador%TYPE;
        cCodPlantilla       SICAS_OC.ENTREGAS_CNSF_CONFIG.CodPlantilla%TYPE;
        cCodPlantillaError  SICAS_OC.ENTREGAS_CNSF_CONFIG.CodPlantilla%TYPE;
        cCodEntregaDatGen   VARCHAR2(25);
        nEjecutaLog         NUMBER := 0;
        vl_Rutina           NUMBER := 0;
        vl_CorreoRutina     VARCHAR2(2) :='N';
    BEGIN
    
        BEGIN
            UTL_FILE.FREMOVE(cNomDirectorio,'SESASLOGERROR.TXT');
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        
        EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.LOGERRORES_SESAS');
        
        IF SUBSTR(cCodEntregaProces, 5, 3) IN ( 'DAT', 'EMI' ) THEN
            SELECT TRIM(SUBSTR(cCodEntregaProces, 1, 4)|| 'DAT'|| SUBSTR(cCodEntregaProces, 8))
            INTO cCodEntregaDatGen
            FROM DUAL;

        END IF;


      /*  IF cCodEntregaDatGen IS NOT NULL THEN  SE COMENTO ESTE COMO MEJORA
         --SESAS de Datos Generales

            cSeparador := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.SEPARADOR(nCodCia, nCodEmpresa, cCodEntregaDatGen);
            cCodPlantilla := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.PLANTILLA(nCodCia, nCodEmpresa, cCodEntregaDatGen);
            cCodPlantillaError := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.PLANTILLA(nCodCia, nCodEmpresa, 'SESAERROR');
            cNomArchDatGen := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.NOMBRE_ARCHIVO(nCodCia, nCodEmpresa, cCodEntregaDatGen);
            cNomArchDatGenError := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.NOMBRE_ARCHIVO(nCodCia, nCodEmpresa, 'SESAERROR');
            cNomProcDatGen := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.NOMBRE_PROCESO(nCodCia, nCodEmpresa, cCodEntregaDatGen);
            cEncabDatGen := GeneraEncabezado(nCodCia, nCodEmpresa, cCodPlantilla, cSeparador);
            cEncabDatGenError := GeneraEncabezado(nCodCia, nCodEmpresa, cCodPlantillaError, cSeparador);
            cDetalleDatGen := GeneraDetalle(nCodCia, nCodEmpresa, cCodPlantilla, cSeparador, cCodUsuario,NULL);
            cDetalleDatGenError := GeneraDetalleError(nCodCia, nCodEmpresa, cCodPlantilla, cSeparador, cCodUsuario,'ERROR');


         --Ejecuta el Proceso de Datos Generales
            cBlockPlSql := 'BEGIN '
                           || cNomProcDatGen
                           || '( :nCodCia, :nCodEmpresa, :dFecDesde, :dFecHasta, :cCodUsuario, :cCodEntregaDatGen, :cCodEntregaProces, :cFiltrarPolizas ); END;';
            EXECUTE IMMEDIATE cBlockPlSql
                USING nCodCia, nCodEmpresa, dFecDesde, dFecHasta, cCodUsuario, cCodEntregaDatGen, cCodEntregaProces, cFiltrarPolizas;

        END IF;*/

      --SESAS del Proceso a Generar Emision/Siniestros

        cSeparador := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.SEPARADOR(nCodCia, nCodEmpresa, cCodEntregaProces);
        cCodPlantilla := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.PLANTILLA(nCodCia, nCodEmpresa, cCodEntregaProces);
        cCodPlantillaError := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.PLANTILLA(nCodCia, nCodEmpresa, 'SESAERROR');
        cNomArchProces := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.NOMBRE_ARCHIVO(nCodCia, nCodEmpresa, cCodEntregaProces);
        cNomArchProcesError := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.NOMBRE_ARCHIVO(nCodCia, nCodEmpresa, 'SESAERROR');
        cNomProcProces := SICAS_OC.OC_ENTREGAS_CNSF_CONFIG.NOMBRE_PROCESO(nCodCia, nCodEmpresa, cCodEntregaProces);


        cEncabProces := GeneraEncabezado(nCodCia, nCodEmpresa, cCodPlantilla, cSeparador);
        cEncabProcesError := GeneraEncabezado(nCodCia, nCodEmpresa, cCodPlantillaError, cSeparador);

      --DBMS_OUTPUT.PUT_LINE('cCodPlantilla: ' || cCodPlantilla);
        cDetalleProces := GeneraDetalle(nCodCia, nCodEmpresa, cCodPlantilla, cSeparador, cCodUsuario,NULL);
        cDetalleDatGenError := GeneraDetalleError(nCodCia, nCodEmpresa, cCodPlantilla, cSeparador, cCodUsuario, 'ERROR');


      --Ejecuta el Proceso de Correspondiente: Emisión o Siniestros, se corre con cCodEntregaDatGen para que tome como base el resultado de este

        BEGIN
            SELECT CODVALOR,TO_NUMBER(NVL(CVE_CNSF,'0'))
            INTO vl_Ejecucion, vl_Intento
            FROM SICAS_OC.VALORES_DE_LISTAS
            WHERE CODLISTA ='ONSESAS' 
                AND CODVALOR=1
                AND ROWNUM <= 1;
        EXCEPTION
            WHEN OTHERS THEN
                vl_Ejecucion := '0';
        END;

        IF vl_Ejecucion = '1' OR vl_Intento > 2 THEN

            UPDATE SICAS_OC.VALORES_DE_LISTAS
            SET CVE_CNSF = '1'
            WHERE CODLISTA ='ONSESAS' 
                AND CODVALOR=1
                AND ROWNUM <= 1;

            SELECT COUNT(1)
            INTO vl_Rutina
            FROM SICAS_OC.SESAS_HISTORICO
            WHERE ANOREP = TO_NUMBER(TO_CHAR(dFecDesde,'YYYY'));

            vl_CorreoRutina := 'N';

            vl_Inicio := SYSDATE;
            
            IF cCodEntregaProces = 'SESADATAPC' THEN
                vl_NomSesa := 'DATOS GENERALES AP COLECTIVO';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
            ELSIF cCodEntregaProces = 'SESADATVIG' THEN
                vl_NomSesa := 'DATOS GENERALES VIDA GRUPO';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
            ELSIF cCodEntregaProces = 'SESADATGMC' THEN
                vl_NomSesa := 'DATOS GENERALES GASTOS MEDICOS COLECTIVO';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
            ELSIF cCodEntregaProces = 'SESAEMIAPC' THEN
                vl_NomSesa := 'EMISION AP COLECTIVO';
                cCodEntregaDatGen := 'SESAEMIAPC';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
            ELSIF cCodEntregaProces = 'SESAEMIVIG' THEN
                vl_NomSesa := 'EMISION VIDA GRUPO';
                cCodEntregaDatGen := 'SESAEMIVIG';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
            ELSIF cCodEntregaProces = 'SESAEMIGMC' THEN
                vl_NomSesa := 'EMISION GASTOS MEDICOS COLECTIVO';
                cCodEntregaDatGen := 'SESAEMIGMC';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
            ELSIF cCodEntregaProces = 'SESASINAPC' THEN
                vl_NomSesa := 'SINIESTROS AP COLECTIVO';
                IF vl_Rutina = 0 THEN
                    vl_CorreoRutina := 'S';
                END IF;
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
            ELSIF cCodEntregaProces = 'SESASINVIG' THEN
                vl_NomSesa := 'SINIESTROS VIDA GRUPO';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
            ELSIF cCodEntregaProces = 'SESASINGMC' THEN
                vl_NomSesa := 'SINIESTROS GASTOS MEDICOS COLECTIVO';
                IF vl_Rutina = 0 THEN
                    vl_CorreoRutina := 'S';
                END IF;
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
            ELSIF cCodEntregaProces = 'SESADATAPI' THEN
                vl_NomSesa := 'DATOS GENERALES AP INDIVIDUAL';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
            ELSIF cCodEntregaProces = 'SESADATVII' THEN
                vl_NomSesa := 'DATOS GENERALES VIDA INDIVIDUAL';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
            ELSIF cCodEntregaProces = 'SESADATGMI' THEN
                vl_NomSesa := 'DATOS GENERALES GASTOS MEDICOS INDIVIDUAL';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_DATGEN');
            ELSIF cCodEntregaProces = 'SESAEMIAPI' THEN
                vl_NomSesa := 'EMISION AP INDIVIDUAL';
                cCodEntregaDatGen := 'SESAEMIAPI';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
            ELSIF cCodEntregaProces = 'SESAEMIVII' THEN
                vl_NomSesa := 'EMISION VIDA INDIVIDUAL';
                cCodEntregaDatGen := 'SESAEMIVII';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
            ELSIF cCodEntregaProces = 'SESAEMIGMI' THEN
                vl_NomSesa := 'EMISION GASTOS MEDICOS INDIVIDUAL';
                cCodEntregaDatGen := 'SESAEMIGMI';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_EMISION');
            ELSIF cCodEntregaProces = 'SESASINAPI' THEN
                IF vl_Rutina = 0 THEN
                    vl_CorreoRutina := 'S';
                END IF;
                vl_NomSesa := 'SINIESTROS AP INDIVIDUAL';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
            ELSIF cCodEntregaProces = 'SESASINVII' THEN
                vl_NomSesa := 'SINIESTROS VIDA INDIVIDUAL';
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
            ELSIF cCodEntregaProces = 'SESASINGMI' THEN
                vl_NomSesa := 'SINIESTROS GASTOS MEDICOS INDIVIDUAL';
                IF vl_Rutina = 0 THEN
                    vl_CorreoRutina := 'S';
                END IF;
                EXECUTE IMMEDIATE ('TRUNCATE TABLE SICAS_OC.SESAS_SINIESTROS');
            ELSE
                vl_NomSesa := cCodEntregaProces;
            END IF;

            IF vl_CorreoRutina = 'S' THEN
                oc_procesossesas.NOTIFICARUTINA (cCodUsuario , vl_NomSesa , TO_CHAR(dFecDesde,'YYYY'),TO_CHAR(vl_Inicio,'DD/MM/YYYY HH24:MI:SS'),NULL,NULL);
            ELSE
                oc_procesossesas.NOTIFICACORREO (cCodUsuario , vl_NomSesa , 'Inicio',TO_CHAR(vl_Inicio,'DD/MM/YYYY HH24:MI:SS'),NULL,NULL);


            cBlockPlSql := 'BEGIN '|| cNomProcProces|| '( :nCodCia, :nCodEmpresa, :dFecDesde, :dFecHasta, :cCodUsuario, :cCodEntregaDatGen, :cCodEntregaProces, :cFiltrarPolizas ); END;';
            EXECUTE IMMEDIATE cBlockPlSql USING nCodCia, nCodEmpresa, dFecDesde, dFecHasta, cCodUsuario, cCodEntregaDatGen, cCodEntregaProces, cFiltrarPolizas;

            COMMIT;
            -----avm
			IF cCodEntregaProces IN ('SESASINAPC','SESASINGMC','SESASINAPI','SESASINGMI')THEN
				SICAS_OC.OC_PROCESOSSESAS.CALCULO_NUMREC(cCodEntregaProces);
			END IF;


            cNomArchZip := SUBSTR(cNomArchProces, 1, INSTR(cNomArchProces, '.') - 1)|| '.zip';

            cNomArchZipError := SUBSTR(cNomArchProcesError, 1, INSTR(cNomArchProcesError, '.') - 1) || '.zip';

          --Ejecuta el Armado de los Layouts y Genera los Reportes

            SELECT COUNT(1)
            INTO nEjecutaLog
            FROM SICAS_OC.LOGERRORES_SESAS
            WHERE  CODCIA = nCodCia
                AND CODEMPRESA = nCodEmpresa
                AND CODUSUARIO = cCodUsuario
                AND CODREPORTE = cCodEntregaProces;

            GeneraReportes(nCodCia, nCodEmpresa, REPLACE(cNomArchZipError, '.zip', '.TXT'), cEncabDatGen, cDetalleDatGen, cNomArchProces,cEncabProces,cEncabProcesError, cDetalleProces, cDetalleDatGenError, cNomArchZip, nEjecutaLog);

			/*IF(nEjecutaLog > 0)THEN
				SICAS_OC.OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB(nCodCia, nCodEmpresa, cCodEntregaProces, cCodUsuario, cNomArchZip);
				SICAS_OC.OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB(nCodCia, nCodEmpresa, cEncabProcesError, cCodUsuario, cNomArchZipError);
			ELSE*/
				SICAS_OC.OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB(nCodCia, nCodEmpresa, cCodEntregaProces, cCodUsuario, cNomArchZip);
			--END IF;

            --SICAS_OC.OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB(nCodCia, nCodEmpresa, cCodEntregaProces, cCodUsuario, cNomArchZip);

            UPDATE SICAS_OC.VALORES_DE_LISTAS
            SET CVE_CNSF = '0'
            WHERE CODLISTA ='ONSESAS' 
                AND CODVALOR = 1
                AND ROWNUM <= 1;

            COMMIT;

            END IF;
        ELSE

            vl_Intento2 := vl_Intento +1;

            UPDATE SICAS_OC.VALORES_DE_LISTAS
            SET CVE_CNSF = TO_CHAR(vl_Intento2)
            WHERE CODLISTA ='ONSESAS' 
                AND CODVALOR = 1;

            COMMIT;
             IF vl_Intento2 = 1 THEN  
                RAISE_APPLICATION_ERROR(-20220,'       ***        YA EXISTE UN PROCESO DE SESA´s EN EJECUCION.        ***        ');
            ELSIF vl_Intento2= 2 THEN
                RAISE_APPLICATION_ERROR(-20220,'       ***        ESTAS INTENTANDO DETENER EL PROCESO ACTUAL DE SESA´s, FAVOR DE VALIDAR...        ***        ');
            ELSE
                RAISE_APPLICATION_ERROR(-20220,'       ***        EL PROCESO ACTUAL DE SESAS SERA DETENIDO, PUEDES INICIAR EL NUEVO PROCESO AHORA!!!        ***        ');
            END IF;
        END IF;
      --SICAS_OC.OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, 'SESAERROR', cCodUsuario, cNomArchZipError );

      vl_Final := SYSDATE;

        SELECT 'Duracion: '||TO_CHAR(DIFERENCIA_HORAS, '00') || ':' || TO_CHAR(DIFERENCIA_MINUTOS, '00') || ':' || TO_CHAR(DIFERENCIA_SEGUNDOS, '00') 
        INTO vl_Duracion
        FROM (  SELECT FECHA_UNO,
                    FECHA_DOS,
                    TRUNC((FECHA_DOS - FECHA_UNO)) DIFERENCIA_DIAS,
                    TRUNC(MOD((FECHA_DOS - FECHA_UNO) * 24, 24)) DIFERENCIA_HORAS,
                    TRUNC(MOD((FECHA_DOS - FECHA_UNO) * (60 * 24), 60)) DIFERENCIA_MINUTOS,
                    TRUNC(MOD((FECHA_DOS - FECHA_UNO) * (60 * 60 * 24), 60)) DIFERENCIA_SEGUNDOS
                FROM (
                    SELECT 
                        vl_Inicio FECHA_UNO,
                        vl_Final FECHA_DOS
                    FROM DUAL
        ));

        IF vl_CorreoRutina = 'N' THEN
            oc_procesossesas.NOTIFICACORREO (cCodUsuario , vl_NomSesa , 'Termino exitosamente ',TO_CHAR(vl_Inicio,'DD/MM/YYYY HH24:MI:SS'),TO_CHAR(vl_Final,'DD/MM/YYYY HH24:MI:SS'),vl_Duracion);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            UPDATE SICAS_OC.VALORES_DE_LISTAS
            SET CVE_CNSF = '0'
            WHERE CODLISTA ='ONSESAS' 
                AND CODVALOR = 1
            AND ROWNUM <= 1;

            COMMIT;
            vl_Inicio := SYSDATE;
            vl_Final := SYSDATE;
            vl_Duracion := SQLERRM;
            oc_procesossesas.NOTIFICACORREO (cCodUsuario , vl_NomSesa , 'Termino con error',SQLERRM,TO_CHAR(vl_Final,'DD/MM/YYYY HH24:MI:SS'),vl_Duracion);

    END CONTROLPRINCIPAL;

    FUNCTION GENERAENCABEZADO (
        nCodCia       SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODCIA%TYPE,
        nCodEmpresa   SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODEMPRESA%TYPE,
        cCodPlantilla SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODPLANTILLA%TYPE,
        cSeparador    VARCHAR2
    ) RETURN VARCHAR2 IS

        cEncabezado VARCHAR2(4000);
        cCadena     VARCHAR2(4000);
        CURSOR c_Campos IS
        SELECT
            NomCampo
        FROM
            SICAS_OC.CONFIG_PLANTILLAS_CAMPOS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodPlantilla = cCodPlantilla
        ORDER BY
            OrdenCampo;

    BEGIN
        FOR x IN c_Campos LOOP
            cCadena := cCadena
                       || x.NomCampo
                       || cSeparador;
        END LOOP;

        cEncabezado := SUBSTR(cCadena, 1, LENGTH(cCadena) - 1);
        RETURN cEncabezado;
    END GENERAENCABEZADO;

    FUNCTION GETENTIDADASEGURADO (
        cCodPaisRes   SICAS_OC.PERSONA_NATURAL_JURIDICA.CODPAISRES%TYPE,
        cCodProvRes   SICAS_OC.PERSONA_NATURAL_JURIDICA.CODPROVRES%TYPE,
        cCodPaisResPN SICAS_OC.PERSONA_NATURAL_JURIDICA.CODPROVRES%TYPE,
        cCodProvResPN SICAS_OC.PERSONA_NATURAL_JURIDICA.CODPROVRES%TYPE,
        nIdPoliza     SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN VARCHAR2 IS

        cEntidadAsegurado VARCHAR2(2) := '09';
        nCodCliente       NUMBER;
        vl_Tipo           VARCHAR2(400);
        vl_RFC            VARCHAR2(400);

    BEGIN

        IF cCodPaisRes IS NULL  AND cCodPaisResPN IS NULL THEN

            BEGIN

                SELECT TRIM(TO_CHAR(TO_NUMBER( P.CODPROVRES), '00')) 
                INTO cEntidadAsegurado
                FROM SICAS_OC.PERSONA_NATURAL_JURIDICA P
                INNER JOIN SICAS_OC.CLIENTES C 
                    ON C.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
                    AND C.Num_Doc_Identificacion = P.Num_Doc_Identificacion
                INNER JOIN SICAS_OC.POLIZAS  D 
                    ON D.CODCLIENTE = C.CODCLIENTE
                WHERE D.IDPOLIZA = nIdPoliza
                    AND ROWNUM <= 1;

            EXCEPTION
                WHEN OTHERS THEN
                    cEntidadAsegurado := '09';
            END;

        ELSE

            IF cCodPaisRes = '001' THEN
                IF TO_NUMBER(cCodProvRes) BETWEEN 1 AND 32 THEN
                    cEntidadAsegurado := TRIM(TO_CHAR(TO_NUMBER(cCodProvRes), '00'));

                ELSE
                    cEntidadAsegurado := '34';
                END IF;

            ELSIF cCodPaisRes != '001' AND cCodPaisRes IS NOT NULL THEN
                cEntidadAsegurado := '33';

            ELSIF cCodPaisResPN = '001' THEN
                IF TO_NUMBER(cCodProvResPN) BETWEEN 1 AND 32 THEN
                    cEntidadAsegurado := TRIM(TO_CHAR(TO_NUMBER(cCodProvResPN), '00'));
                ELSE
                    cEntidadAsegurado := '34';
                END IF;
            ELSIF cCodPaisResPN != '001' AND cCodPaisResPN IS NOT NULL THEN
                cEntidadAsegurado := '33';
            ELSE
                BEGIN

                    SELECT P.CODPROVRES
                    INTO cEntidadAsegurado
                    FROM SICAS_OC.PERSONA_NATURAL_JURIDICA P
                    INNER JOIN SICAS_OC.CLIENTES C 
                        ON C.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
                        AND C.Num_Doc_Identificacion = P.Num_Doc_Identificacion
                    INNER JOIN SICAS_OC.POLIZAS  D 
                        ON D.CODCLIENTE = C.CODCLIENTE
                    WHERE D.IDPOLIZA = nIdPoliza
                        AND ROWNUM <= 1;

                EXCEPTION
                    WHEN OTHERS THEN
                        cEntidadAsegurado := '09';
                END;
            END IF;

        END IF;

        RETURN cEntidadAsegurado;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN cEntidadAsegurado;
    END GETENTIDADASEGURADO;

    FUNCTION GETSTATUSCERTAP (
        nCodCia      SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza    SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        nIdetPol     NUMBER,
        dFecAnul     DATE,
        dFecHasta    DATE,
        cStsDetalle  SICAS_OC.DETALLE_POLIZA.STSDETALLE%TYPE,
        dFecIniVig   SICAS_OC.DETALLE_POLIZA.FECINIVIG%TYPE,
        dFecFinVig   SICAS_OC.DETALLE_POLIZA.FECFINVIG%TYPE,
        cCodAegurado NUMBER
    ) RETURN VARCHAR2 IS
        cStatusCert VARCHAR2(1) := NULL;
        nTotal      NUMBER := 0;
    BEGIN
      -- Status del Certificado

        SELECT COUNT(1)
        INTO nTotal
        FROM SICAS_OC.SINIESTRO S
        INNER JOIN DETALLE_POLIZA D
            ON D.IDPOLIZA = S.IDPOLIZA
            AND D.IDETPOL = S.IDETPOL
        INNER JOIN COBERTURAS_DE_SEGUROS C
            ON C.IDTIPOSEG = D.IDTIPOSEG
            AND C.PLANCOB = D.PLANCOB
        LEFT JOIN SICAS_OC.RESERVA_DET R
            ON R.ID_SINIESTRO = S.IDSINIESTRO
        WHERE C.CLAVESESASNEW = '01'
            AND S.IDPOLIZA = nIdPoliza
            AND S.IDETPOL = nIdetPol
            AND S.COD_ASEGURADO = cCodAegurado
            AND R.ID_COBERTURA = C.CODCOBERT
            AND TO_CHAR(dFecHasta, 'YYYY') = TO_CHAR(S.FEC_NOTIFICACION, 'YYYY');


        IF dFecAnul IS NOT NULL OR dFecAnul <> '' THEN
            cStatusCert := '3';
        ELSIF dFecFinVig > dFecHasta THEN
            cStatusCert := '1';
        ELSIF dFecIniVig > dFecHasta THEN
            cStatusCert := '5';
        ELSIF nTotal > 0 THEN
            cStatusCert := '4';
        ELSIF dFecFinVig <= dFecHasta THEN
            cStatusCert := '2';
        ELSE
            cStatusCert := NULL;
        END IF;
      /*
      IF cStsDetalle = 'EMI' THEN
         cStatusCert := '1'; -- En Vigor
         --
         IF dFecFinVig <= dFecHasta THEN
            cStatusCert := '2'; -- Expirada o Terminada
         END IF;
      ELSIF cStsDetalle IN ('ANU','EXC') THEN
         cStatusCert := '3'; -- Cancelada
         --
         IF OC_SINIESTRO.TIENE_SINIESTRO(nCodCia, nIdPoliza, nIDetPol, dFecDesde) = 'S' THEN
            cStatusCert := '4'; -- Baja por muerte, invalidez o incapacidad
         END IF;
      ELSIF cStsDetalle = 'RES' THEN
         cStatusCert := '5'; -- Rescatas
      ELSIF cStsDetalle = 'SAL' THEN
         cStatusCert := '6'; -- Saldada
      ELSIF cStsDetalle = 'PRO' THEN
         cStatusCert := '7'; -- Prorrogada
      ELSIF dFecFinVig <= dFecHasta THEN
         cStatusCert := '2'; -- Expirada o Terminada
      END IF;*/
      --
        RETURN cStatusCert;

    END GETSTATUSCERTAP;

    FUNCTION GETSTATUSCERT (
        nCodCia      SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza    SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        nIdetPol     NUMBER,
        dFecAnul     DATE,
        dFecHasta    DATE,
        cStsDetalle  SICAS_OC.DETALLE_POLIZA.STSDETALLE%TYPE,
        dFecIniVig   SICAS_OC.DETALLE_POLIZA.FECINIVIG%TYPE,
        dFecFinVig   SICAS_OC.DETALLE_POLIZA.FECFINVIG%TYPE,
        cCodAegurado NUMBER
    ) RETURN VARCHAR2 IS
        cStatusCert VARCHAR2(1) := NULL;
        nTotal      NUMBER := 0;
    BEGIN
      -- Status del Certificado
        SELECT COUNT(1)
        INTO nTotal
        FROM SICAS_OC.SINIESTRO S
        WHERE S.IDPOLIZA = nIdPoliza
            AND S.IDETPOL = nIdetPol
            AND S.COD_ASEGURADO = cCodAegurado

            AND TO_CHAR(dFecHasta, 'YYYY') = TO_CHAR(FEC_NOTIFICACION, 'YYYY');

        IF dFecAnul IS NOT NULL OR dFecAnul <> '' THEN
            cStatusCert := '3';
        ELSIF dFecFinVig > dFecHasta THEN
            cStatusCert := '1';
        ELSIF dFecIniVig > dFecHasta THEN
            cStatusCert := '5';
        ELSIF nTotal > 0 THEN
            cStatusCert := '4';
        ELSIF dFecFinVig <= dFecHasta THEN
            cStatusCert := '2';
        ELSE
            cStatusCert := NULL;
        END IF;
      /*
      IF cStsDetalle = 'EMI' THEN
         cStatusCert := '1'; -- En Vigor
         --
         IF dFecFinVig <= dFecHasta THEN
            cStatusCert := '2'; -- Expirada o Terminada
         END IF;
      ELSIF cStsDetalle IN ('ANU','EXC') THEN
         cStatusCert := '3'; -- Cancelada
         --
         IF OC_SINIESTRO.TIENE_SINIESTRO(nCodCia, nIdPoliza, nIDetPol, dFecDesde) = 'S' THEN
            cStatusCert := '4'; -- Baja por muerte, invalidez o incapacidad
         END IF;
      ELSIF cStsDetalle = 'RES' THEN
         cStatusCert := '5'; -- Rescatas
      ELSIF cStsDetalle = 'SAL' THEN
         cStatusCert := '6'; -- Saldada
      ELSIF cStsDetalle = 'PRO' THEN
         cStatusCert := '7'; -- Prorrogada
      ELSIF dFecFinVig <= dFecHasta THEN
         cStatusCert := '2'; -- Expirada o Terminada
      END IF;*/
      --
        RETURN cStatusCert;
    END GETSTATUSCERT;

    FUNCTION GETCANTCERTIFICADOS (
        nCodCia         SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.DETALLE_POLIZA.CODEMPRESA%TYPE,
        nIdPoliza       SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        nIDetPol        SICAS_OC.DETALLE_POLIZA.IDETPOL%TYPE,
        cIndAsegModelo  SICAS_OC.DETALLE_POLIZA.INDASEGMODELO%TYPE,
        nCantAsegModelo SICAS_OC.DETALLE_POLIZA.CANTASEGMODELO%TYPE,
        cIndConcentrada SICAS_OC.POLIZAS.INDCONCENTRADA%TYPE,
        nIdEndoso       SICAS_OC.ASEGURADO_CERTIFICADO.IDENDOSO%TYPE
    ) RETURN NUMBER IS
        nCantCertificados NUMBER := 0;
        vl_Concentrada  VARCHAR2(1) := 'N';

    BEGIN

    vl_Concentrada := CASE WHEN cIndConcentrada = 0 THEN 'N' ELSE 'S' END; 
        IF NVL(cIndConcentrada, 'N') = 'S' THEN

            IF vl_Concentrada = 'S' THEN
                IF nIdEndoso = 0 THEN
                    BEGIN
                        SELECT SICAS_OC.OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol) - ( COUNT(*) - 1 )
                        INTO nCantCertificados
                        FROM SICAS_OC.ASEGURADO_CERTIFICADO
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = nIdPoliza
                            AND IDetPol = nIDetPol
                            AND Estado IN ( 'SOL', 'XRE', 'EMI' );
                    EXCEPTION
                        WHEN OTHERS THEN
                            nCantCertificados := -1;
                    END;

                ELSE
                    nCantCertificados := 1;
                END IF;
            ELSE
                nCantCertificados := SICAS_OC.OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
            END IF;
        ELSIF NVL(vl_Concentrada, 'N') = 'N' THEN
            nCantCertificados := 1; --valor por defecto solicitado en requerimiento
            nCantCertificados := SICAS_OC.OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
        ELSIF cIndAsegModelo = 'S' THEN
            nCantCertificados := NVL(nCantAsegModelo, 0);
        ELSE
            nCantCertificados := 1;
        END IF;

        RETURN NVL(nCantCertificados,0);
    END GETCANTCERTIFICADOS;

    FUNCTION GENERADETALLE (
        nCodCia       SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODCIA%TYPE,
        nCodEmpresa   SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODEMPRESA%TYPE,
        cCodPlantilla SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODPLANTILLA%TYPE,
        cSeparador    VARCHAR2,
        cCodUsuario   SICAS_OC.TEMP_REGISTROS_SESAS.CODUSUARIO%TYPE,
        cOrigen       VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 IS

        cDetalle  VARCHAR2(4000);
        cCadena   VARCHAR2(4000);
        cNomTabla VARCHAR2(4000);
        cWhere    VARCHAR2(4000) := ' WHERE CODCIA = '
                                 || nCodCia
                                 || ' AND CODEMPRESA = '
                                 || nCodEmpresa
                                 || ' AND CODREPORTE = '''
                                 || cCodPlantilla
                                 || ''' AND CODUSUARIO = '''
                                 || cCodUsuario
                                 || '''';
        cOrderBy  VARCHAR2(4000) := ' ORDER BY NUMPOLIZA, NUMCERTIFICADO';
        cOrderBy2 VARCHAR2(4000) := ' ORDER BY EPOLIZ, ECERTI';

        CURSOR c_Campos IS
        SELECT
            CASE
                WHEN TipoCampo = 'VARCHAR2' THEN
                    DescValLst
                    || ' || '''
                    || cSeparador
                    || ''' || '
                WHEN TipoCampo = 'DATE'     THEN
                    'TO_CHAR('
                    || DescValLst
                    || ', ''YYYYMMDD'')'
                    || ' || '''
                    || cSeparador
                    || ''' || '
                WHEN TipoCampo = 'NUMBER'   THEN
                        CASE
                            WHEN NumDecimales > 0 THEN
                                'TO_CHAR('
                                || DescValLst
                                || ', '''
                                || LPAD('9', LongitudCampo, 9)
                                || '.'
                                || LPAD('9', NumDecimales, 9)
                                || ''')'
                                || ' || '''
                                || cSeparador
                                || ''' || '
                            ELSE
                                'TO_CHAR('
                                || DescValLst
                                || ')'
                                || ' || '''
                                || cSeparador
                                || ''' || '
                        END
            END Campo
        FROM
            SICAS_OC.CONFIG_PLANTILLAS_CAMPOS,
            SICAS_OC.VALORES_DE_LISTAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodPlantilla = CASE
                                   WHEN cOrigen LIKE '%ERROR%' THEN
                                       'SESAERROR'
                                   ELSE
                                       cCodPlantilla
                               END
            AND CodLista (+) = 'SEEQUCAM'
            AND CodValor (+) = NomCampo
        ORDER BY
            OrdenCampo;

    BEGIN
        SELECT  NomTabla
        INTO cNomTabla
        FROM
            SICAS_OC.CONFIG_PLANTILLAS_TABLAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodPlantilla = CASE
                                   WHEN cOrigen LIKE '%ERROR%' THEN
                                       'SESAERROR'
                                   ELSE
                                       cCodPlantilla
                               END;

        cCadena := 'SELECT ';


        FOR x IN c_Campos LOOP
            cCadena := cCadena || x.Campo;
        END LOOP;
        cCadena := SUBSTR(cCadena, 1, LENGTH(cCadena) - 11)
                   || ' FROM '
                   || cNomTabla
                   || cWhere
                   || CASE
            WHEN cOrigen LIKE '%ERROR%' THEN
                cOrderBy2
            ELSE cOrderBy
        END;


        cDetalle := cCadena;
      DBMS_OUTPUT.PUT_LINE(cDetalle);
        RETURN cDetalle;

    END GENERADETALLE;

    FUNCTION GENERADETALLEERROR (
        nCodCia       SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODCIA%TYPE,
        nCodEmpresa   SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODEMPRESA%TYPE,
        cCodPlantilla SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODPLANTILLA%TYPE,
        cSeparador    VARCHAR2,
        cCodUsuario   SICAS_OC.TEMP_REGISTROS_SESAS.CODUSUARIO%TYPE,
        cOrigen       VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 IS

        cDetalle  VARCHAR2(4000);
        cCadena   VARCHAR2(4000);
        cNomTabla VARCHAR2(4000);
        cWhere    VARCHAR2(4000) := ' WHERE CODCIA = '
                                 || nCodCia
                                 || ' AND CODEMPRESA = '
                                 || nCodEmpresa
                                 || ' AND CODREPORTE = '''
                                 || cCodPlantilla
                                 || ''' AND CODUSUARIO = '''
                                 || cCodUsuario
                                 || '''';
        cOrderBy  VARCHAR2(4000) := ' ORDER BY NUMPOLIZA, NUMCERTIFICADO';
        cOrderBy2 VARCHAR2(4000) := ' ORDER BY EPOLIZ, ECERTI';
        CURSOR c_Campos IS
        SELECT
            CASE
                WHEN TipoCampo = 'VARCHAR2' THEN
                    DescValLst
                    || ' || '''
                    || cSeparador
                    || ''' || '
                WHEN TipoCampo = 'DATE'     THEN
                    'TO_CHAR('
                    || DescValLst
                    || ', ''YYYYMMDD'')'
                    || ' || '''
                    || cSeparador
                    || ''' || '
                WHEN TipoCampo = 'NUMBER'   THEN
                        CASE
                            WHEN NumDecimales > 0 THEN
                                'TO_CHAR('
                                || DescValLst
                                || ', '''
                                || LPAD('9', LongitudCampo, 9)
                                || '.'
                                || LPAD('9', NumDecimales, 9)
                                || ''')'
                                || ' || '''
                                || cSeparador
                                || ''' || '
                            ELSE
                                'TO_CHAR('
                                || DescValLst
                                || ')'
                                || ' || '''
                                || cSeparador
                                || ''' || '
                        END
            END Campo
        FROM
            SICAS_OC.CONFIG_PLANTILLAS_CAMPOS,
            SICAS_OC.VALORES_DE_LISTAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodPlantilla = CASE
                                   WHEN cOrigen LIKE '%ERROR%' THEN
                                       'SESAERROR'
                                   ELSE
                                       cCodPlantilla
                               END
            AND CodLista (+) = 'SEEQUCAM'
            AND CodValor (+) = NomCampo
        ORDER BY
            OrdenCampo;

    BEGIN
        SELECT
            NomTabla
        INTO cNomTabla
        FROM
            SICAS_OC.CONFIG_PLANTILLAS_TABLAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodPlantilla = CASE
                                   WHEN cOrigen LIKE '%ERROR%' THEN
                                       'SESAERROR'
                                   ELSE
                                       cCodPlantilla
                               END;

        cCadena := 'SELECT ';
        FOR x IN c_Campos LOOP
            cCadena := cCadena || x.Campo;
        END LOOP;
        cCadena := SUBSTR(cCadena, 1, LENGTH(cCadena) - 11)
                   || ' FROM '
                   || cNomTabla
                   || cWhere
                   || CASE
            WHEN cOrigen LIKE '%ERROR%' THEN
                cOrderBy2
            ELSE cOrderBy
        END;

        cDetalle := cCadena;
        RETURN cDetalle;
    END GENERADETALLEERROR;

    PROCEDURE GENERAREPORTES (
        nCodCia             SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODCIA%TYPE,
        nCodEmpresa         SICAS_OC.CONFIG_PLANTILLAS_CAMPOS.CODEMPRESA%TYPE,
        cNomArchDatGen      VARCHAR2,
        cEncabDatGen        VARCHAR2,
        cDetalleDatGen      VARCHAR2,
        cNomArchProces      VARCHAR2,
        cEncabProces        VARCHAR2,
        cEncabProcesError   VARCHAR2,
        cDetalleProces      VARCHAR2,
        cDetalleProcesError VARCHAR2,
        cNomArchZip         VARCHAR2,
        cEjecutaLog         NUMBER
    ) IS

        TYPE DetCurTyp IS REF CURSOR;
        c_Detalle      DetCurTyp;
        cCadena        VARCHAR2(4000);
        nContador      NUMBER := 0;
        cCtlArchDatGen UTL_FILE.FILE_TYPE;
        cCtlArchProces UTL_FILE.FILE_TYPE;
        cNomDirectorio VARCHAR2(100);

        l_file          BLOB;
        l_zip           BLOB;
        NOM_ARCHIVO_ZIP VARCHAR2(200);
    BEGIN
        cNomDirectorio := SICAS_OC.OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');

      --
      /*
      IF cNomArchDatGen IS NOT NULL THEN
         --Generación del Reporte de Datos Generales
         cCtlArchDatGen    := UTL_FILE.FOPEN(cNomDirectorio, cNomArchDatGen, 'W', 32767);
         --
         UTL_FILE.PUT_LINE(cCtlArchDatGen, cEncabDatGen);
         --
         OPEN c_Detalle FOR cDetalleDatGen;
         LOOP
            FETCH c_Detalle INTO cCadena;
            EXIT WHEN c_Detalle%NOTFOUND;
            --


            UTL_FILE.PUT_LINE(cCtlArchDatGen, cCadena);
            --
         END LOOP;
         CLOSE c_Detalle;
         UTL_FILE.FCLOSE(cCtlArchDatGen);
      END IF;
      */

      --Generación del Reporte del Proceso
        cCtlArchProces := UTL_FILE.FOPEN(cNomDirectorio, cNomArchProces, 'W', 32767);
        UTL_FILE.PUT_LINE(cCtlArchProces, cEncabProces);

        OPEN c_Detalle FOR cDetalleProces;

        LOOP
            FETCH c_Detalle INTO cCadena;
            EXIT WHEN c_Detalle%NOTFOUND;
            UTL_FILE.PUT_LINE(cCtlArchProces, cCadena);
        END LOOP;

        CLOSE c_Detalle;
        UTL_FILE.FCLOSE(cCtlArchProces);
                
        IF NVL(cEjecutaLog,0) >= 1 THEN
            --generacion log de errores
            cCtlArchProces := UTL_FILE.FOPEN(cNomDirectorio, cNomArchDatGen, 'W', 32767);
            UTL_FILE.PUT_LINE(cCtlArchProces, cEncabProcesError);
            OPEN c_Detalle FOR cDetalleProcesError;

            LOOP
                FETCH c_Detalle INTO cCadena;
                EXIT WHEN c_Detalle%NOTFOUND;
                UTL_FILE.PUT_LINE(cCtlArchProces, cCadena);
            END LOOP;

            CLOSE c_Detalle;
            UTL_FILE.FCLOSE(cCtlArchProces);
        END IF;

        IF NVL(cEjecutaLog,0) >= 1 THEN
                /*SE ESCRIBE LA PARTE DEL LOG DE ERRORES POR EXISTIR*/
                BEGIN
                    FOR ENT IN (SELECT COLUMN_VALUE ARCHIVO
                        from table(GT_WEB_SERVICES.split(cNomArchDatGen))) LOOP
                        l_file := zip_util_pkg.file_to_blob (cNomDirectorio, ENT.ARCHIVO);
                        zip_util_pkg.add_file (l_zip, ENT.ARCHIVO, l_file);
                    END LOOP;
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END;
                
                /*SE ESCRIBE LA PARTE DE LA SESA EN CASO DE EXISTIR*/
                BEGIN
                    FOR ENT IN (SELECT COLUMN_VALUE ARCHIVO
                        from table(GT_WEB_SERVICES.split(cNomArchProces))) LOOP
                        l_file := zip_util_pkg.file_to_blob (cNomDirectorio, ENT.ARCHIVO);
                        zip_util_pkg.add_file (l_zip, ENT.ARCHIVO, l_file);
                    END LOOP;
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END;

                zip_util_pkg.finish_zip (l_zip);
                --  
                IF INSTR(UPPER(cNomArchZip), '.ZIP')> 0 THEN
                    NOM_ARCHIVO_ZIP := UPPER(cNomArchZip);
                ELSE
                    NOM_ARCHIVO_ZIP := UPPER(cNomArchZip) || '.ZIP';
                END IF;
                --
                zip_util_pkg.save_zip (l_zip, cNomDirectorio, NOM_ARCHIVO_ZIP);
                --
                BEGIN
                    FOR ENT IN (SELECT COLUMN_VALUE ARCHIVO
                                 from table(GT_WEB_SERVICES.split(cNomArchProces))) LOOP
                        UTL_FILE.FREMOVE(cNomDirectorio, ENT.ARCHIVO);                     
                    END LOOP;
                EXCEPTION 
                    WHEN OTHERS THEN 
                        NULL; 
                END;
            /*
            IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchProces) THEN
                DBMS_OUTPUT.PUT_LINE('OK');
            END IF;
            IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchDatGen) THEN
                DBMS_OUTPUT.PUT_LINE('OK');
            END IF;
			*/
        ELSE

                BEGIN
                    FOR ENT IN (SELECT COLUMN_VALUE ARCHIVO
                        from table(GT_WEB_SERVICES.split(cNomArchProces))) LOOP
                        l_file := zip_util_pkg.file_to_blob (cNomDirectorio, ENT.ARCHIVO);
                        zip_util_pkg.add_file (l_zip, ENT.ARCHIVO, l_file);
                    END LOOP;
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END;
                --
                zip_util_pkg.finish_zip (l_zip);
                --  
                IF INSTR(UPPER(cNomArchZip), '.ZIP')> 0 THEN
                    NOM_ARCHIVO_ZIP := UPPER(cNomArchZip);
                ELSE
                    NOM_ARCHIVO_ZIP := UPPER(cNomArchZip) || '.ZIP';
                END IF;
                --
                zip_util_pkg.save_zip (l_zip, cNomDirectorio, NOM_ARCHIVO_ZIP);
                --
                BEGIN
                    FOR ENT IN (SELECT COLUMN_VALUE ARCHIVO
                                 from table(GT_WEB_SERVICES.split(cNomArchProces))) LOOP
                        UTL_FILE.FREMOVE(cNomDirectorio, ENT.ARCHIVO);                     
                    END LOOP;
                EXCEPTION WHEN OTHERS THEN NULL; 
                END;
            /*
            IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchProces) THEN
                DBMS_OUTPUT.PUT_LINE('OK');
            END IF;*/
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            UTL_FILE.FCLOSE(cCtlArchDatGen);
            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia,nCodEmpresa, cNomArchDatGen, USER, 'SISTEMA', '', SQLCODE, ' Error al generar el archivo: GENERAREPORTES - '|| SQLERRM);

    END GENERAREPORTES;

    PROCEDURE INSERTAEMISION (
        nCodCia         SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        cCodReporte     SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodUsuario     SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cNumPoliza      SICAS_OC.SESAS_EMISION.NUMPOLIZA%TYPE,
        cNumCertificado SICAS_OC.SESAS_EMISION.NUMCERTIFICADO%TYPE,
        cCobertura      SICAS_OC.SESAS_EMISION.COBERTURA%TYPE,
        cTipoSumaSeg    SICAS_OC.SESAS_EMISION.TIPOSUMASEG%TYPE,
        nPeriodoEspera  SICAS_OC.SESAS_EMISION.PERIODOESPERA%TYPE,
        nSumaAsegurada  SICAS_OC.SESAS_EMISION.SUMAASEGURADA%TYPE,
        nPrimaEmitida   SICAS_OC.SESAS_EMISION.PRIMAEMITIDA%TYPE,
        nPrimaDevengada SICAS_OC.SESAS_EMISION.PRIMADEVENGADA%TYPE,
        nNumDiasRenta   NUMBER,
        cTipoExtraPrima SICAS_OC.SESAS_EMISION.TIPOEXTRAPRIMA%TYPE,
        nOrdenSesas     SICAS_OC.SESAS_EMISION.ORDENSESAS%TYPE
    ) IS
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
            cCodReporte,
            cCodUsuario,
            cNumPoliza,
            cNumCertificado,
            cCobertura,
            cTipoSumaSeg,
            nPeriodoEspera,
            nSumaAsegurada,
            nPrimaEmitida,
            nPrimaDevengada,
            nNumDiasRenta,
            cTipoExtraPrima,
            nOrdenSesas
        );

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            UPDATE SICAS_OC.SESAS_EMISION
            SET
                PrimaEmitida = NVL(PrimaEmitida, 0) + NVL(nPrimaEmitida, 0),
                SumaAsegurada = NVL(SumaAsegurada, 0) + NVL(nSumaAsegurada, 0)
            WHERE
                    CodCia = nCodCia
                AND CodEmpresa = nCodEmpresa
                AND CodReporte = cCodReporte
                AND CodUsuario = cCodUsuario
                AND NumPoliza = cNumPoliza
                AND NumCertificado = cNumCertificado
                AND Cobertura = cCobertura;
          --AND  OrdenSesas     = nOrdenSesas;
            COMMIT;
        WHEN OTHERS THEN
            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporte, cCodUsuario, cNumPoliza,
                                                         cNumCertificado, SQLCODE, SQLERRM);
    END INSERTAEMISION;

    PROCEDURE ACTUALIZAEMISION (
        nCodCia         SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        cCodReporte     SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodUsuario     SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cNumPoliza      SICAS_OC.SESAS_EMISION.NUMPOLIZA%TYPE,
        cNumCertificado SICAS_OC.SESAS_EMISION.NUMCERTIFICADO%TYPE,
        cCobertura      SICAS_OC.SESAS_EMISION.COBERTURA%TYPE,
        nSumaAsegurada  SICAS_OC.SESAS_EMISION.SUMAASEGURADA%TYPE,
        nPrimaEmitida   SICAS_OC.SESAS_EMISION.PRIMAEMITIDA%TYPE,
        nOrdenSesas     SICAS_OC.SESAS_EMISION.ORDENSESAS%TYPE
    ) IS
    BEGIN
        UPDATE SICAS_OC.SESAS_EMISION
        SET
            PrimaEmitida = NVL(PrimaEmitida, 0) + NVL(nPrimaEmitida, 0),
            SumaAsegurada = NVL(SumaAsegurada, 0) + NVL(nSumaAsegurada, 0)
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporte
            AND CodUsuario = cCodUsuario
            AND NumPoliza = cNumPoliza
            AND NumCertificado = cNumCertificado
            AND Cobertura = cCobertura
            AND OrdenSesas = nOrdenSesas;

    END ACTUALIZAEMISION;

    FUNCTION EXISTEREGISTROEMISION (
        nCodCia         SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        cCodReporte     SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodUsuario     SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cNumPoliza      SICAS_OC.SESAS_EMISION.NUMPOLIZA%TYPE,
        cNumCertificado SICAS_OC.SESAS_EMISION.NUMCERTIFICADO%TYPE,
        cCobertura      SICAS_OC.SESAS_EMISION.COBERTURA%TYPE,
        nOrdenSesas     SICAS_OC.SESAS_EMISION.ORDENSESAS%TYPE
    ) RETURN VARCHAR2 IS
        cExiste VARCHAR2(1) := 'N';
    BEGIN
        SELECT
            'S'
        INTO cExiste
        FROM
            SICAS_OC.SESAS_EMISION
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporte
            AND CodUsuario = cCodUsuario
            AND NumPoliza = cNumPoliza
            AND NumCertificado = cNumCertificado
            AND Cobertura = cCobertura
            AND OrdenSesas = nOrdenSesas;

        RETURN cExiste;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'N';
        WHEN TOO_MANY_ROWS THEN
            RETURN 'S';
    END EXISTEREGISTROEMISION;

    PROCEDURE DATOSASEGURADO (
        nCodCia        IN SICAS_OC.ASEGURADO.CODCIA%TYPE,
        nCodEmpresa    IN SICAS_OC.ASEGURADO.CODEMPRESA%TYPE,
        nCod_Asegurado IN SICAS_OC.ASEGURADO.COD_ASEGURADO%TYPE,
        dFecIniVig     IN DATE,
        cSexo          OUT SICAS_OC.PERSONA_NATURAL_JURIDICA.SEXO%TYPE,
        nEdad          OUT NUMBER,
        cCodActividad  OUT SICAS_OC.PERSONA_NATURAL_JURIDICA.CODACTIVIDAD%TYPE,
        cRiesgo        OUT actividades_economicas.RIESGOACTIVIDAD%TYPE
    ) IS
    BEGIN
        SELECT
            A.Sexo,
            FLOOR((TRUNC(dFecIniVig) - TRUNC(A.FecNacimiento)) / 365.25),
            A.CodActividad,
            NVL(B.RiesgoActividad, 'NA')--OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD( CodActividad )
        INTO
            cSexo,
            nEdad,
            cCodActividad,
            cRiesgo
        FROM
            SICAS_OC.PERSONA_NATURAL_JURIDICA A
            LEFT JOIN SICAS_OC.ACTIVIDADES_ECONOMICAS   B ON B.CodActividad (+) = A.CodActividad
            INNER JOIN SICAS_OC.ASEGURADO                C ON A.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                                               AND A.Num_Doc_Identificacion = C.Num_Doc_Identificacion
        WHERE
                C.CodCia = nCodCia
            AND C.CodEmpresa = nCodEmpresa
            AND C.Cod_Asegurado = nCod_Asegurado
            AND ROWNUM <= 1;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            cSexo := 'M';
            nEdad := FLOOR((TRUNC(dFecIniVig) - TRUNC(SYSDATE)) / 365.25);

            cCodActividad := NULL;
            cRiesgo := 'NA';
        WHEN TOO_MANY_ROWS THEN
            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia,nCodEmpresa, 'SISTEMA', USER, 'SISTEMA', '', SQLCODE, 'OC_PROCESOSSESAS.DATOSASEGURADO Riesgo de Actividad Economica Duplicada, Cod_Asegurado: ' || nCod_Asegurado);

    END DATOSASEGURADO;

    FUNCTION GETMONTOCOMISION (
        nCodCia     SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nCodEmpresa SICAS_OC.DETALLE_POLIZA.CODEMPRESA%TYPE,
        nIdPoliza   SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        dFecDesde   DATE,
        dFecHasta   DATE
    ) RETURN NUMBER IS
        nMontoComision NUMBER := 0;
        dvarFecDesde   DATE;
        dvarFecHasta   DATE;
    BEGIN
    /*SE IMPLEMENTA UNION ALL Y SE QUITA EL DISTINCT por comentarios de tecnicos*/
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        SELECT NVL(SUM(MONTOCOMISION), 0)
        INTO nMontoComision
        FROM
            (
                SELECT DISTINCT  FAC.STSFACT, FAC.IDFACTURA, DCO.MONTO_MON_EXTRANJERA MONTOCOMISION
                FROM
                    SICAS_OC.FACTURAS            FAC,
                    SICAS_OC.TRANSACCION         TRA,
                    SICAS_OC.DETALLE_TRANSACCION DET,
                    SICAS_OC.COMISIONES          COM,
                    SICAS_OC.DETALLE_COMISION    DCO
                WHERE
                        DCO.IDCOMISION = COM.IDCOMISION
                    AND DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )
                    AND COM.IDPOLIZA = FAC.IDPOLIZA
                    AND COM.IDFACTURA = FAC.IDFACTURA
                    AND EXISTS (
                        SELECT
                            *
                        FROM
                            SICAS_OC.DETALLE_TRANSACCION DTR
                        WHERE
                                DTR.IDTRANSACCION = DET.IDTRANSACCION
                            AND DTR.CODCIA = DET.CODCIA
                            AND DTR.CODEMPRESA = DET.CODEMPRESA
                            AND DTR.CORRELATIVO > 0
                            AND ( ( DTR.OBJETO = 'FACTURAS'
                                    AND TRA.IDPROCESO IN ( 7, 14, 18, 21 )
                                    AND DTR.CODSUBPROCESO IN ( 'FAC', 'REHAB', 'FACFON', 'CONFAC' ) )
                                  OR ( DTR.OBJETO = 'ENDOSOS'
                                       AND TRA.IDPROCESO = 8
                                       AND DTR.CODSUBPROCESO IN ( 'CFP', 'AUM', 'EAD', 'INA', 'INC',
                                                                  'IND', 'REHAP', 'RSS' ) ) )
                    )
                    AND DET.IDTRANSACCION = TRA.IDTRANSACCION
                    AND DET.CODCIA = TRA.CODCIA
                    AND DET.CODEMPRESA = TRA.CODEMPRESA
                    AND DET.CORRELATIVO > 0
                    AND TO_NUMBER(DET.VALOR1) = FAC.IDPOLIZA
                    AND DET.OBJETO = 'FACTURAS'
                    AND DET.CODSUBPROCESO IN ( 'FAC', 'REHAB', 'FACFON', 'CONFAC' )
                    AND TRA.IDPROCESO IN ( 7, 8, 14, 18, 21 )
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.IDTRANSACCION = FAC.IDTRANSACCION
                    AND TRA.CODCIA = FAC.CODCIA
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND FAC.STSFACT <> 'PRE'
                    AND FAC.CODCIA = nCodCia
                    AND FAC.IDPOLIZA = nIdPoliza
                UNION 
                SELECT DISTINCT  FAC.STSFACT, FAC.IDFACTURA, DCO.MONTO_MON_EXTRANJERA * - 1 MONTOCOMISION
                FROM
                    SICAS_OC.FACTURAS            FAC,
                    SICAS_OC.TRANSACCION         TRA,
                    SICAS_OC.DETALLE_TRANSACCION DET,
                    SICAS_OC.COMISIONES          COM,
                    SICAS_OC.DETALLE_COMISION    DCO
                WHERE
                        DCO.CODCIA = DCO.CODCIA
                    AND DCO.IDCOMISION = COM.IDCOMISION
                    AND DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )
                    AND COM.IDPOLIZA = FAC.IDPOLIZA
                    AND COM.IDFACTURA = FAC.IDFACTURA
                    AND EXISTS (
                        SELECT
                            *
                        FROM
                            SICAS_OC.DETALLE_TRANSACCION DTR
                        WHERE
                                DTR.IDTRANSACCION = DET.IDTRANSACCION
                            AND DTR.CODCIA = DET.CODCIA
                            AND DTR.CODEMPRESA = DET.CODEMPRESA
                            AND DTR.CORRELATIVO > 0
                            AND ( ( DTR.OBJETO = 'FACTURAS'
                                    AND TRA.IDPROCESO IN ( 2, 11 )
                                    AND DTR.CODSUBPROCESO IN ( 'FAC' ) )
                                  OR ( DTR.OBJETO = 'ENDOSOS'
                                       AND TRA.IDPROCESO = 8
                                       AND DTR.CODSUBPROCESO IN ( 'ANUFAC' ) ) )
                    )
                    AND DET.IDTRANSACCION = TRA.IDTRANSACCION
                    AND DET.CODCIA = TRA.CODCIA
                    AND DET.CODEMPRESA = TRA.CODEMPRESA
                    AND DET.CORRELATIVO > 0
                    AND TO_NUMBER(DET.VALOR1) = FAC.IDPOLIZA
                    AND DET.OBJETO IN ( 'FACTURAS' )
                    AND DET.CODSUBPROCESO IN ( 'FAC', 'ANUFAC' )
                    AND TRA.IDPROCESO IN ( 2, 8, 11 )
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.IDTRANSACCION = NVL(FAC.IDTRANSACCIONANU, FAC.IDTRANSACCION)
                    AND TRA.CODCIA = FAC.CODCIA
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND FAC.CODCIA = nCodCia
                    AND FAC.IDPOLIZA = nIdPoliza
                UNION 
                SELECT DISTINCT NCR.STSNCR, NCR.IDNCR, DCO.MONTO_MON_EXTRANJERA * - 1 MONTOCOMISION
                FROM
                    SICAS_OC.NOTAS_DE_CREDITO NCR,
                    SICAS_OC.TRANSACCION      TRA,
                    SICAS_OC.COMISIONES       COM,
                    SICAS_OC.DETALLE_COMISION DCO
                WHERE
                        DCO.CODCIA = DCO.CODCIA
                    AND DCO.IDCOMISION = COM.IDCOMISION
                    AND DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )
                    AND COM.IDPOLIZA = NCR.IDPOLIZA
                    AND COM.IDNCR = NCR.IDNCR
                    AND TRA.IDPROCESO IN ( 2, 8 )   -- Anulaciones y Endoso
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.IDTRANSACCION = NCR.IDTRANSACCIONANU
                    AND TRA.CODCIA = NCR.CODCIA
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND NCR.CODCIA = nCodCia
                    AND NCR.IDPOLIZA = nIdPoliza
                UNION 
                SELECT DISTINCT NCR.STSNCR, NCR.IDNCR, DCO.MONTO_MON_EXTRANJERA MONTOCOMISION
                FROM SICAS_OC.NOTAS_DE_CREDITO    NCR,
                    SICAS_OC.TRANSACCION         TRA,
                    SICAS_OC.DETALLE_TRANSACCION DET,
                    SICAS_OC.COMISIONES          COM,
                    SICAS_OC.DETALLE_COMISION    DCO
                WHERE
                        DCO.CODCIA = DCO.CODCIA
                    AND DCO.IDCOMISION = COM.IDCOMISION
                    AND DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )
                    AND COM.IDPOLIZA = NCR.IDPOLIZA
                    AND COM.IDNCR = NCR.IDNCR
                    AND DET.IDTRANSACCION = TRA.IDTRANSACCION
                    AND DET.CODEMPRESA = TRA.CODEMPRESA
                    AND DET.CODCIA = TRA.CODCIA
                    AND DET.CORRELATIVO > 0
                    AND DET.OBJETO = 'NOTAS_DE_CREDITO'
                    AND ( ( TRA.IDPROCESO = 2
                            AND DET.CODSUBPROCESO = 'NOTACR' )
                          OR ( TRA.IDPROCESO = 8
                               AND DET.CODSUBPROCESO = 'NCR' )
                          OR ( TRA.IDPROCESO = 18
                               AND DET.CODSUBPROCESO = 'REHNCR' ) )
                    AND TO_NUMBER(DET.VALOR1) = NCR.IDPOLIZA
                    AND TO_NUMBER(DET.VALOR4) = NCR.IDNCR
                    AND TRA.CODCIA = DET.CODCIA
                    AND TRA.CODEMPRESA = DET.CODEMPRESA
                    AND TRA.IDTRANSACCION > 0
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.IDPROCESO IN ( 2, 8, 18 )
                    AND ( TRA.IDTRANSACCION = NCR.IDTRANSACCION
                          AND TO_NUMBER(DET.VALOR4) = NCR.IDNCR )
                    AND EXISTS (
                        SELECT DISTINCT
                            DTR.IDTRANSACCION
                        FROM
                            SICAS_OC.DETALLE_TRANSACCION DTR
                        WHERE
                                DTR.IDTRANSACCION = DET.IDTRANSACCION
                            AND DTR.CODCIA = DET.CODCIA
                            AND DTR.CODEMPRESA = DET.CODEMPRESA
                            AND DTR.CORRELATIVO > 0
                            AND ( ( DTR.OBJETO = 'NOTAS_DE_CREDITO'
                                    AND TRA.IDPROCESO = 2
                                    AND DTR.CODSUBPROCESO = 'NOTACR' )
                                  OR ( DTR.OBJETO = 'ENDOSOS'
                                       AND TRA.IDPROCESO = 8
                                       AND DTR.CODSUBPROCESO IN ( 'NSS', 'EXA', 'EXC' ) )
                                  OR ( DTR.OBJETO = 'NOTAS_DE_CREDITO'
                                       AND TRA.IDPROCESO = 18
                                       AND DTR.CODSUBPROCESO = 'REHNCR' ) )
                    )
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND NCR.CODCIA = nCodCia
                    AND NCR.IDPOLIZA = nIdPoliza
                UNION 
                SELECT DISTINCT NCR.STSNCR, NCR.IDNCR, DCO.MONTO_MON_EXTRANJERA MONTOCOMISION
                FROM
                    SICAS_OC.NOTAS_DE_CREDITO    NCR,
                    SICAS_OC.TRANSACCION         TRA,
                    SICAS_OC.DETALLE_TRANSACCION DET,
                    SICAS_OC.COMISIONES          COM,
                    SICAS_OC.DETALLE_COMISION    DCO
                WHERE
                        DCO.CODCIA = DCO.CODCIA
                    AND DCO.IDCOMISION = COM.IDCOMISION
                    AND DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )
                    AND COM.IDPOLIZA = NCR.IDPOLIZA
                    AND COM.IDNCR = NCR.IDNCR
                    AND DET.IDTRANSACCION = TRA.IDTRANSACCION
                    AND DET.CODEMPRESA = TRA.CODEMPRESA
                    AND DET.CODCIA = TRA.CODCIA
                    AND DET.CORRELATIVO > 0
                    AND DET.OBJETO = 'NOTAS_DE_CREDITO'
                    AND ( ( TRA.IDPROCESO = 2
                            AND DET.CODSUBPROCESO = 'NOTACR' )
                          OR ( TRA.IDPROCESO = 8
                               AND DET.CODSUBPROCESO = 'NCR' )
                          OR ( TRA.IDPROCESO = 18
                               AND DET.CODSUBPROCESO = 'REHNCR' ) )
                    AND TO_NUMBER(DET.VALOR1) = NCR.IDPOLIZA
                    AND TRA.CODCIA = DET.CODCIA
                    AND TRA.CODEMPRESA = DET.CODEMPRESA
                    AND TRA.IDTRANSACCION > 0
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.IDPROCESO IN ( 2, 8, 18 )
                    AND TRA.IDTRANSACCION = NCR.IDTRANSACCION
                    AND EXISTS (
                        SELECT DISTINCT DTR.IDTRANSACCION
                        FROM SICAS_OC.DETALLE_TRANSACCION DTR
                        WHERE DTR.IDTRANSACCION = DET.IDTRANSACCION
                            AND DTR.CODCIA = DET.CODCIA
                            AND DTR.CODEMPRESA = DET.CODEMPRESA
                            AND DTR.CORRELATIVO > 0
                            AND ( ( DTR.OBJETO = 'NOTAS_DE_CREDITO'
                                    AND TRA.IDPROCESO = 2
                                    AND DTR.CODSUBPROCESO = 'NOTACR' )
                                  OR ( DTR.OBJETO = 'ENDOSOS'
                                       AND TRA.IDPROCESO = 8
                                       AND DTR.CODSUBPROCESO IN ( 'NSS', 'EXA', 'EXC' ) )
                                  OR ( DTR.OBJETO = 'NOTAS_DE_CREDITO'
                                       AND TRA.IDPROCESO = 18
                                       AND DTR.CODSUBPROCESO = 'REHNCR' ) )
                    )
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND NCR.CODCIA = nCodCia
                    AND NCR.IDPOLIZA = nIdPoliza
            );

        RETURN nMontoComision;
    EXCEPTION
        WHEN OTHERS THEN
            nMontoComision := 0;
            RETURN nMontoComision;
    END GETMONTOCOMISION;












FUNCTION GETMONTOCOMISIONAP (
        nCodCia     SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nCodEmpresa SICAS_OC.DETALLE_POLIZA.CODEMPRESA%TYPE,
        nIdPoliza   SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        dFecDesde   DATE,
        dFecHasta   DATE
    ) RETURN NUMBER IS
        nMontoComision NUMBER := 0;
        dvarFecDesde   DATE;
        dvarFecHasta   DATE;
    BEGIN
    /*SE IMPLEMENTA UNION ALL Y SE QUITA EL DISTINCT por comentarios de tecnicos*/
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        SELECT NVL(SUM(MONTOCOMISION), 0)
        INTO nMontoComision
        FROM
            (   SELECT DISTINCT STSFACT, IDFACTURA, MONTOCOMISION, IDTRANSACCION, CORRELATIVO, COD_AGENTE
                FROM
                (
                SELECT DISTINCT FAC.STSFACT, FAC.IDFACTURA, DCO.MONTO_MON_EXTRANJERA MONTOCOMISION, TRA.IDTRANSACCION, 0 CORRELATIVO, COM.COD_AGENTE
                FROM
                    SICAS_OC.FACTURAS            FAC
                    INNER JOIN  SICAS_OC.TRANSACCION         TRA 
                        ON  TRA.IDTRANSACCION = FAC.IDTRANSACCION
                        AND TRA.CODCIA = FAC.CODCIA
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DET
                        ON DET.IDTRANSACCION = TRA.IDTRANSACCION
                        AND DET.CODCIA = TRA.CODCIA
                        AND DET.CODEMPRESA = TRA.CODEMPRESA
                    INNER JOIN SICAS_OC.COMISIONES          COM
                        ON COM.IDPOLIZA = FAC.IDPOLIZA
                        AND COM.IDFACTURA = FAC.IDFACTURA
                    INNER JOIN  SICAS_OC.DETALLE_COMISION    DCO
                        ON DCO.IDCOMISION = COM.IDCOMISION
                WHERE
                        DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )

                    AND EXISTS (
                        SELECT
                            *
                        FROM
                            SICAS_OC.DETALLE_TRANSACCION DTR
                        WHERE
                                DTR.IDTRANSACCION = DET.IDTRANSACCION
                            AND DTR.CODCIA = DET.CODCIA
                            AND DTR.CODEMPRESA = DET.CODEMPRESA
                            AND DTR.CORRELATIVO > 0
                            AND ( ( DTR.OBJETO = 'FACTURAS'
                                    AND TRA.IDPROCESO IN ( 7, 14, 18, 21 )
                                    AND DTR.CODSUBPROCESO IN ( 'FAC', 'REHAB', 'FACFON', 'CONFAC' ) )
                                  OR ( DTR.OBJETO = 'ENDOSOS'
                                       AND TRA.IDPROCESO = 8
                                       AND DTR.CODSUBPROCESO IN ( 'CFP', 'AUM', 'EAD', 'INA', 'INC',
                                                                  'IND', 'REHAP', 'RSS' ) ) )
                    )

                    AND DET.CORRELATIVO > 0
                    AND TO_NUMBER(DET.VALOR1) = FAC.IDPOLIZA
                    AND DET.OBJETO = 'FACTURAS'
                    AND DET.CODSUBPROCESO IN ( 'FAC', 'REHAB', 'FACFON', 'CONFAC' )
                    AND TRA.IDPROCESO IN ( 7, 8, 14, 18, 21 )
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta

                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND FAC.STSFACT <> 'PRE'
                    AND FAC.CODCIA = nCodCia
                    AND FAC.IDPOLIZA = nIdPoliza
                UNION ALL
                SELECT DISTINCT FAC.STSFACT, FAC.IDFACTURA, DCO.MONTO_MON_EXTRANJERA * - 1 MONTOCOMISION, TRA.IDTRANSACCION, 0 CORRELATIVO, COM.COD_AGENTE
                FROM

                    SICAS_OC.FACTURAS            FAC
                    INNER JOIN  SICAS_OC.TRANSACCION         TRA 
                        ON   TRA.IDTRANSACCION = NVL(FAC.IDTRANSACCIONANU, FAC.IDTRANSACCION)
                        AND TRA.CODCIA = FAC.CODCIA
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DET
                        ON DET.IDTRANSACCION = TRA.IDTRANSACCION
                        AND DET.CODCIA = TRA.CODCIA
                        AND DET.CODEMPRESA = TRA.CODEMPRESA
                    INNER JOIN SICAS_OC.COMISIONES          COM
                        ON COM.IDPOLIZA = FAC.IDPOLIZA
                        AND COM.IDFACTURA = FAC.IDFACTURA
                    INNER JOIN  SICAS_OC.DETALLE_COMISION    DCO
                        ON DCO.IDCOMISION = COM.IDCOMISION
                WHERE
                         DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )

                    AND EXISTS (
                        SELECT
                            *
                        FROM
                            SICAS_OC.DETALLE_TRANSACCION DTR
                        WHERE
                                DTR.IDTRANSACCION = DET.IDTRANSACCION
                            AND DTR.CODCIA = DET.CODCIA
                            AND DTR.CODEMPRESA = DET.CODEMPRESA
                            AND DTR.CORRELATIVO > 0
                            AND ( ( DTR.OBJETO = 'FACTURAS'
                                    AND TRA.IDPROCESO IN ( 2, 11 )
                                    AND DTR.CODSUBPROCESO IN ( 'FAC' ) )
                                  OR ( DTR.OBJETO = 'ENDOSOS'
                                       AND TRA.IDPROCESO = 8
                                       AND DTR.CODSUBPROCESO IN ( 'ANUFAC' ) ) )
                    )

                    AND DET.CORRELATIVO > 0
                    AND TO_NUMBER(DET.VALOR1) = FAC.IDPOLIZA
                    AND DET.OBJETO IN ( 'FACTURAS' )
                    AND DET.CODSUBPROCESO IN ( 'FAC', 'ANUFAC' )
                    AND TRA.IDPROCESO IN ( 2, 8, 11 )
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND FAC.CODCIA = nCodCia
                    AND FAC.IDPOLIZA = nIdPoliza


                UNION ALL
                SELECT  NCR.STSNCR, NCR.IDNCR, DCO.MONTO_MON_EXTRANJERA * - 1 MONTOCOMISION, TRA.IDTRANSACCION, 1, COM.COD_AGENTE
                FROM
                    SICAS_OC.NOTAS_DE_CREDITO NCR,
                    SICAS_OC.TRANSACCION      TRA,
                    SICAS_OC.COMISIONES       COM,
                    SICAS_OC.DETALLE_COMISION DCO
                WHERE
                        DCO.CODCIA = DCO.CODCIA
                    AND DCO.IDCOMISION = COM.IDCOMISION
                    AND DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )
                    AND COM.IDPOLIZA = NCR.IDPOLIZA
                    AND COM.IDNCR = NCR.IDNCR
                    AND TRA.IDPROCESO IN ( 2, 8 )   -- Anulaciones y Endoso
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.IDTRANSACCION = NCR.IDTRANSACCIONANU
                    AND TRA.CODCIA = NCR.CODCIA
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND NCR.CODCIA = nCodCia
                    AND NCR.IDPOLIZA = nIdPoliza
                UNION ALL
                SELECT  NCR.STSNCR, NCR.IDNCR, DCO.MONTO_MON_EXTRANJERA MONTOCOMISION, TRA.IDTRANSACCION, 0 CORRELATIVO, COM.COD_AGENTE
                FROM SICAS_OC.NOTAS_DE_CREDITO    NCR,
                    SICAS_OC.TRANSACCION         TRA,
                    SICAS_OC.DETALLE_TRANSACCION DET,
                    SICAS_OC.COMISIONES          COM,
                    SICAS_OC.DETALLE_COMISION    DCO
                WHERE
                        DCO.CODCIA = DCO.CODCIA
                    AND DCO.IDCOMISION = COM.IDCOMISION
                    AND DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )
                    AND COM.IDPOLIZA = NCR.IDPOLIZA
                    AND COM.IDNCR = NCR.IDNCR
                    AND DET.IDTRANSACCION = TRA.IDTRANSACCION
                    AND DET.CODEMPRESA = TRA.CODEMPRESA
                    AND DET.CODCIA = TRA.CODCIA
                    AND DET.CORRELATIVO > 0
                    AND DET.OBJETO = 'NOTAS_DE_CREDITO'
                    AND ( ( TRA.IDPROCESO = 2
                            AND DET.CODSUBPROCESO = 'NOTACR' )
                          OR ( TRA.IDPROCESO = 8
                               AND DET.CODSUBPROCESO = 'NCR' )
                          OR ( TRA.IDPROCESO = 18
                               AND DET.CODSUBPROCESO = 'REHNCR' ) )
                    AND TO_NUMBER(DET.VALOR1) = NCR.IDPOLIZA
                    AND TO_NUMBER(DET.VALOR4) = NCR.IDNCR
                    AND TRA.CODCIA = DET.CODCIA
                    AND TRA.CODEMPRESA = DET.CODEMPRESA
                    AND TRA.IDTRANSACCION > 0
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.IDPROCESO IN ( 2, 8, 18 )
                    AND ( TRA.IDTRANSACCION = NCR.IDTRANSACCION
                          AND TO_NUMBER(DET.VALOR4) = NCR.IDNCR )
                    AND EXISTS (
                        SELECT DISTINCT
                            DTR.IDTRANSACCION
                        FROM
                            SICAS_OC.DETALLE_TRANSACCION DTR
                        WHERE
                                DTR.IDTRANSACCION = DET.IDTRANSACCION
                            AND DTR.CODCIA = DET.CODCIA
                            AND DTR.CODEMPRESA = DET.CODEMPRESA
                            AND DTR.CORRELATIVO > 0
                            AND ( ( DTR.OBJETO = 'NOTAS_DE_CREDITO'
                                    AND TRA.IDPROCESO = 2
                                    AND DTR.CODSUBPROCESO = 'NOTACR' )
                                  OR ( DTR.OBJETO = 'ENDOSOS'
                                       AND TRA.IDPROCESO = 8
                                       AND DTR.CODSUBPROCESO IN ( 'NSS', 'EXA', 'EXC' ) )
                                  OR ( DTR.OBJETO = 'NOTAS_DE_CREDITO'
                                       AND TRA.IDPROCESO = 18
                                       AND DTR.CODSUBPROCESO = 'REHNCR' ) )
                    )
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND NCR.CODCIA = nCodCia
                    AND NCR.IDPOLIZA = nIdPoliza
                UNION ALL
                SELECT  NCR.STSNCR, NCR.IDNCR, DCO.MONTO_MON_EXTRANJERA MONTOCOMISION, TRA.IDTRANSACCION, 0 CORRELATIVO, COM.COD_AGENTE
                FROM
                    SICAS_OC.NOTAS_DE_CREDITO    NCR,
                    SICAS_OC.TRANSACCION         TRA,
                    SICAS_OC.DETALLE_TRANSACCION DET,
                    SICAS_OC.COMISIONES          COM,
                    SICAS_OC.DETALLE_COMISION    DCO
                WHERE
                        DCO.CODCIA = DCO.CODCIA
                    AND DCO.IDCOMISION = COM.IDCOMISION
                    AND DCO.CODCONCEPTO IN ( 'COMISI', 'COMIPF', 'COMIPM' )
                    AND COM.IDPOLIZA = NCR.IDPOLIZA
                    AND COM.IDNCR = NCR.IDNCR
                    AND DET.IDTRANSACCION = TRA.IDTRANSACCION
                    AND DET.CODEMPRESA = TRA.CODEMPRESA
                    AND DET.CODCIA = TRA.CODCIA
                    AND DET.CORRELATIVO > 0
                    AND DET.OBJETO = 'NOTAS_DE_CREDITO'
                    AND ( ( TRA.IDPROCESO = 2
                            AND DET.CODSUBPROCESO = 'NOTACR' )
                          OR ( TRA.IDPROCESO = 8
                               AND DET.CODSUBPROCESO = 'NCR' )
                          OR ( TRA.IDPROCESO = 18
                               AND DET.CODSUBPROCESO = 'REHNCR' ) )
                    AND TO_NUMBER(DET.VALOR1) = NCR.IDPOLIZA
                    AND TRA.CODCIA = DET.CODCIA
                    AND TRA.CODEMPRESA = DET.CODEMPRESA
                    AND TRA.IDTRANSACCION > 0
                    AND TRA.FECHATRANSACCION BETWEEN dvarFecDesde AND dvarFecHasta
                    AND TRA.IDPROCESO IN ( 2, 8, 18 )
                    AND TRA.IDTRANSACCION = NCR.IDTRANSACCION
                    AND EXISTS (
                        SELECT DISTINCT DTR.IDTRANSACCION
                        FROM SICAS_OC.DETALLE_TRANSACCION DTR
                        WHERE DTR.IDTRANSACCION = DET.IDTRANSACCION
                            AND DTR.CODCIA = DET.CODCIA
                            AND DTR.CODEMPRESA = DET.CODEMPRESA
                            AND DTR.CORRELATIVO > 0
                            AND ( ( DTR.OBJETO = 'NOTAS_DE_CREDITO'
                                    AND TRA.IDPROCESO = 2
                                    AND DTR.CODSUBPROCESO = 'NOTACR' )
                                  OR ( DTR.OBJETO = 'ENDOSOS'
                                       AND TRA.IDPROCESO = 8
                                       AND DTR.CODSUBPROCESO IN ( 'NSS', 'EXA', 'EXC' ) )
                                  OR ( DTR.OBJETO = 'NOTAS_DE_CREDITO'
                                       AND TRA.IDPROCESO = 18
                                       AND DTR.CODSUBPROCESO = 'REHNCR' ) )
                    )
                    AND TRA.CODEMPRESA = nCodEmpresa
                    AND NCR.CODCIA = nCodCia
                    AND NCR.IDPOLIZA = nIdPoliza
                )
            );

        RETURN nMontoComision;
    EXCEPTION
        WHEN OTHERS THEN
            nMontoComision := 0;
            RETURN nMontoComision;
    END GETMONTOCOMISIONAP;







    FUNCTION GETFORMAVENTA (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN VARCHAR IS
        cFormaVenta VARCHAR2(2);
    BEGIN
        SELECT
            (
                CASE
                    WHEN A.COD_AGENTE = '99' THEN '06'
                    ELSE
                        (
                            CASE SUBSTR(B.CODTIPO, - 1)
                                WHEN 'F' THEN
                                    '01'
                                WHEN 'M' THEN
                                    '02'
                                ELSE
                                    '06'
                            END
                        )
                END
            )
        INTO cFormaVenta
        FROM
                 SICAS_OC.AGENTE_POLIZA A
            INNER JOIN SICAS_OC.AGENTES B ON B.COD_AGENTE = A.COD_AGENTE
        WHERE
                A.IND_PRINCIPAL = 'S'
            AND A.IDPOLIZA = nIdPoliza
            AND A.CODCIA = nCodCia;

        RETURN cFormaVenta;
    EXCEPTION
        WHEN OTHERS THEN
            cFormaVenta := '06';
            RETURN cFormaVenta;
    END GETFORMAVENTA;

    FUNCTION GETSTATUSSINVII (
        nCodCia       SICAS_OC.SINIESTRO.CODCIA%TYPE,
        nIdPoliza     SICAS_OC.SINIESTRO.IDPOLIZA%TYPE,
        nIdSiniestro  SICAS_OC.SINIESTRO.IDSINIESTRO%TYPE,
        cStsSiniestro SICAS_OC.SINIESTRO.STS_SINIESTRO%TYPE,
        nMtoPagMon    SICAS_OC.SINIESTRO.MONTO_PAGO_MONEDA%TYPE,
        nMtoResMon    SICAS_OC.SINIESTRO.MONTO_RESERVA_MONEDA%TYPE,
        cProcedencia  VARCHAR2
    ) RETURN VARCHAR2 IS
        cAprobPago VARCHAR2(1);
        cStsSin    VARCHAR(1) := '';
    BEGIN
        IF ( 0 < nMtoPagMon ) AND ( nMtoPagMon < nMtoResMon )  THEN
            cStsSin := '1';
        ELSIF ( ( nMtoPagMon = nMtoResMon ) AND ( nMtoResMon <> 0 ) ) OR ( nMtoResMon = 0 AND nMtoPagMon > 0 ) THEN
            cStsSin := '2';
        ELSIF ( nMtoResMon < 0 ) OR ( nMtoPagMon = 0 AND nMtoResMon = 0 ) THEN
            cStsSin := '3';
        ELSIF nMtoPagMon = 0 THEN
            cStsSin := '4';
        ELSE
            cStsSin := '';
        END IF;

        RETURN cStsSin;

    EXCEPTION
        WHEN OTHERS THEN
            cStsSin := '';
            RETURN cStsSin;
    END GETSTATUSSINVII;

    FUNCTION GETSTATUSSINGMM (
        nCodCia       SICAS_OC.SINIESTRO.CODCIA%TYPE,
        nIdPoliza     SICAS_OC.SINIESTRO.IDPOLIZA%TYPE,
        nIdSiniestro  SICAS_OC.SINIESTRO.IDSINIESTRO%TYPE,
        cStsSiniestro SICAS_OC.SINIESTRO.STS_SINIESTRO%TYPE,
        nMtoPagMon    SICAS_OC.SINIESTRO.MONTO_PAGO_MONEDA%TYPE,
        nMtoResMon    SICAS_OC.SINIESTRO.MONTO_RESERVA_MONEDA%TYPE,
        cProcedencia  VARCHAR2
    ) RETURN VARCHAR2 IS
        cAprobPago VARCHAR2(1);
        cStsSin    VARCHAR(1) := '';
    BEGIN
        IF ( 0 < nMtoPagMon ) AND ( nMtoPagMon < nMtoResMon )  THEN
            cStsSin := '2';
        ELSIF ( ( nMtoPagMon = nMtoResMon ) AND ( nMtoResMon <> 0 ) ) OR ( nMtoResMon = 0 AND nMtoPagMon > 0 ) THEN
            cStsSin := '1';
        ELSIF ( nMtoResMon < 0 ) OR ( nMtoPagMon = 0 AND nMtoResMon = 0 ) THEN
            cStsSin := '5';
        ELSIF nMtoPagMon = 0 THEN
            cStsSin := '3';
        ELSE
            cStsSin := '';
        END IF;

        RETURN cStsSin;

    EXCEPTION
        WHEN OTHERS THEN
            cStsSin:= '';
            RETURN cStsSin;
    END GETSTATUSSINGMM;

    FUNCTION GETSTATUSSIN (
        nCodCia       SICAS_OC.SINIESTRO.CODCIA%TYPE,
        nIdPoliza     SICAS_OC.SINIESTRO.IDPOLIZA%TYPE,
        nIdSiniestro  SICAS_OC.SINIESTRO.IDSINIESTRO%TYPE,
        cStsSiniestro SICAS_OC.SINIESTRO.STS_SINIESTRO%TYPE,
        nMtoPagMon    SICAS_OC.SINIESTRO.MONTO_PAGO_MONEDA%TYPE,
        nMtoResMon    SICAS_OC.SINIESTRO.MONTO_RESERVA_MONEDA%TYPE,
        cProcedencia  VARCHAR2
    ) RETURN VARCHAR2 IS
        cAprobPago VARCHAR2(1);
        cStsSin    VARCHAR(1):='4';
    BEGIN
        IF ( 0 < nMtoPagMon ) AND ( nMtoPagMon < nMtoResMon )  THEN
            cStsSin := '2';
        ELSIF ( ( nMtoPagMon = nMtoResMon ) AND ( nMtoResMon <> 0 ) ) OR ( nMtoResMon = 0 AND nMtoPagMon > 0 ) THEN
            cStsSin := '1';
        ELSIF ( nMtoResMon < 0 ) OR ( nMtoPagMon = 0 AND nMtoResMon = 0 ) THEN
            cStsSin := '5';
        ELSIF nMtoPagMon = 0 THEN
            cStsSin := '3';
        ELSE
            cStsSin := '4';
        END IF;

        RETURN cStsSin;
    EXCEPTION
        WHEN OTHERS THEN
            cStsSin := '4';
            RETURN cStsSin;
    END GETSTATUSSIN;

    PROCEDURE INSERTASINIESTRO (
        nCodCia            SICAS_OC.SESAS_SINIESTROS.CODCIA%TYPE,
        nCodEmpresa        SICAS_OC.SESAS_SINIESTROS.CODEMPRESA%TYPE,
        cCodReporte        SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cCodUsuario        SICAS_OC.SESAS_SINIESTROS.CODUSUARIO%TYPE,
        cNumPoliza         SICAS_OC.SESAS_SINIESTROS.NUMPOLIZA%TYPE,
        cNumCertificado    SICAS_OC.SESAS_SINIESTROS.NUMCERTIFICADO%TYPE,
        cNumSiniestro      SICAS_OC.SESAS_SINIESTROS.NUMSINIESTRO%TYPE,
        cNumReclamacion    SICAS_OC.SESAS_SINIESTROS.NUMRECLAMACION%TYPE,
        dFecOcuSin         SICAS_OC.SESAS_SINIESTROS.FECOCUSIN%TYPE,
        dFecRepRec         SICAS_OC.SESAS_SINIESTROS.FECREPREC%TYPE,
        dFecConSin         SICAS_OC.SESAS_SINIESTROS.FECCONSIN%TYPE,
        dFecPagSin         SICAS_OC.SESAS_SINIESTROS.FECPAGSIN%TYPE,
        cStatusReclamacion SICAS_OC.SESAS_SINIESTROS.STATUSRECLAMACION%TYPE,
        cEntOcuSin         SICAS_OC.SESAS_SINIESTROS.ENTOCUSIN%TYPE,
        cCobertura         SICAS_OC.SESAS_SINIESTROS.COBERTURA%TYPE,
        nMontoReclamado    SICAS_OC.SESAS_SINIESTROS.MONTORECLAMADO%TYPE,
        cCausaSiniestro    SICAS_OC.SESAS_SINIESTROS.CAUSASINIESTRO%TYPE,
        nMontoDeducible    SICAS_OC.SESAS_SINIESTROS.MONTODEDUCIBLE%TYPE,
        nMontoCoaseguro    SICAS_OC.SESAS_SINIESTROS.MONTOCOASEGURO%TYPE,
        nMontoPagSin       SICAS_OC.SESAS_SINIESTROS.MONTOPAGSIN%TYPE,
        nMontoRecRea       SICAS_OC.SESAS_SINIESTROS.MONTORECREA%TYPE,
        nMontoDividendo    SICAS_OC.SESAS_SINIESTROS.MONTODIVIDENDO%TYPE,
        cTipMovRec         SICAS_OC.SESAS_SINIESTROS.TIPMOVREC%TYPE,
        nMontoVencimiento  SICAS_OC.SESAS_SINIESTROS.MONTOVENCIMIENTO%TYPE,
        nMontoRescate      SICAS_OC.SESAS_SINIESTROS.MONTORESCATE%TYPE,
        cTipoGasto         SICAS_OC.SESAS_SINIESTROS.TIPOGASTO%TYPE,
        nPeriodoEspera     SICAS_OC.SESAS_SINIESTROS.PERIODOESPERA%TYPE,
        cTipoPago          SICAS_OC.SESAS_SINIESTROS.TIPOPAGO%TYPE,
        cSexo              SICAS_OC.SESAS_SINIESTROS.SEXO%TYPE,
        dFecNacim          SICAS_OC.SESAS_SINIESTROS.FECNACIM%TYPE,
        nOrdenSesas        SICAS_OC.SESAS_SINIESTROS.ORDENSESAS%TYPE
    ) IS
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
            cCodReporte,
            cCodUsuario,
            cNumPoliza,
            cNumCertificado,
            cNumSiniestro,
            cNumReclamacion,
            dFecOcuSin,
            dFecRepRec,
            dFecConSin,
            dFecPagSin,
            cStatusReclamacion,
            cEntOcuSin,
            cCobertura,
            NVL(nMontoReclamado, 0),
            cCausaSiniestro,
            NVL(nMontoDeducible, 0),
            NVL(nMontoCoaseguro, 0),
            NVL(nMontoPagSin, 0),
            NVL(nMontoRecRea, 0),
            NVL(nMontoDividendo, 0),
            cTipMovRec,
            NVL(nMontoVencimiento, 0),
            NVL(nMontoRescate, 0),
            cTipoGasto,
            nPeriodoEspera,
            cTipoPago,
            cSexo,
            dFecNacim,
            nOrdenSesas
        );

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            UPDATE SICAS_OC.SESAS_SINIESTROS
            SET
                MontoReclamado = NVL(MontoReclamado, 0) + NVL(nMontoReclamado, 0),
                MontoDeducible = NVL(MontoDeducible, 0) + NVL(nMontoDeducible, 0),
                MontoCoaseguro = NVL(MontoCoaseguro, 0) + NVL(nMontoCoaseguro, 0),
                MontoPagSin = NVL(MontoPagSin, 0) + NVL(nMontoPagSin, 0),
                MontoRecRea = NVL(MontoRecRea, 0) + NVL(nMontoRecRea, 0),
                MontoDividendo = NVL(MontoDividendo, 0) + NVL(nMontoDividendo, 0),
                MontoVencimiento = NVL(MontoVencimiento, 0) + NVL(nMontoVencimiento, 0),
                MontoRescate = NVL(MontoRescate, 0) + NVL(nMontoRescate, 0)
            WHERE
                    CodCia = nCodCia
                AND CodEmpresa = nCodEmpresa
                AND CodReporte = cCodReporte
                AND CodUsuario = cCodUsuario
                AND NumPoliza = cNumPoliza
                AND NumCertificado = cNumCertificado
                AND NumSiniestro = cNumSiniestro
                AND Cobertura = cCobertura;

            COMMIT;
        WHEN OTHERS THEN
            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporte, cCodUsuario, cNumPoliza,
                                                         cNumCertificado, SQLCODE, SQLERRM);
    END INSERTASINIESTRO;

    FUNCTION GETCANTCERTIFICADOS_2 (
        nCodCia         SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nCodEmpresa     SICAS_OC.DETALLE_POLIZA.CODEMPRESA%TYPE,
        nIdPoliza       SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        nIDetPol        SICAS_OC.DETALLE_POLIZA.IDETPOL%TYPE,
        cIndAsegModelo  SICAS_OC.DETALLE_POLIZA.INDASEGMODELO%TYPE,
        nCantAsegModelo SICAS_OC.DETALLE_POLIZA.CANTASEGMODELO%TYPE,
        nPolConcentrada NUMBER,
        nIdEndoso       SICAS_OC.ASEGURADO_CERTIFICADO.IDENDOSO%TYPE
    ) RETURN NUMBER IS
        nCantAseg_1 NUMBER;
        nCantAseg_2 NUMBER;
        nCantCertif NUMBER;
    BEGIN
        nCantAseg_1 := SICAS_OC.OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
        nCantAseg_2 := nCantAseg_1;
        SELECT
            nCantAseg_1 - ( COUNT(*) - 1 )
        INTO nCantAseg_1
        FROM
            SICAS_OC.ASEGURADO_CERTIFICADO
        WHERE
                IdPoliza = nIdPoliza
            AND IDetPol = nIDetPol
            AND CodCia = nCodCia
            AND Estado IN ( 'SOL', 'XRE', 'EMI' );

        IF nPolConcentrada = 1 THEN
            IF cIndAsegModelo = 'S' THEN
                IF nIdEndoso = 0 THEN
                    nCantCertif := nCantAseg_1;
                ELSE
                    nCantCertif := 1;
                END IF;

            ELSE
                nCantCertif := nCantAseg_2;
            END IF;
        ELSIF cIndAsegModelo = 'S' THEN
            nCantCertif := NVL(nCantAsegModelo, 0);
        ELSE
            nCantCertif := 1;
        END IF;

        RETURN nCantCertif;
    EXCEPTION
        WHEN OTHERS THEN
            nCantCertif := 0;
            RETURN nCantCertif;
    END GETCANTCERTIFICADOS_2;

    FUNCTION GETCOASEGURO (
        nCodCia    SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza  SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        cCoaseguro VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER IS
        nCoaseguro NUMBER;
    BEGIN
        IF cCoaseguro IS NULL THEN
            nCoaseguro := 0;
        ELSE
            nCoaseguro := 1;
        END IF;

   /*
      SELECT CASE
                WHEN A.COD_AGENTE <= 99 THEN '06'
                ELSE
                   CASE 
                      WHEN B.CODTIPO IN ('AGTEPF','HONORF','HONPF') THEN '01'
                      WHEN B.CODTIPO IN ('AGTEPM','HONORM','HONPM') THEN '02'
                      ELSE '99'
                   END
             END
      INTO   nCoaseguro
      FROM   SICAS_OC.AGENTE_POLIZA  A
         ,   SICAS_OC.AGENTES        B
      WHERE  A.IND_PRINCIPAL = 'S'
        AND  B.COD_AGENTE = A.COD_AGENTE
        AND  A.IDPOLIZA = nIdPoliza
        AND  A.CODCIA   = nCodCia;
      --*/
        RETURN nCoaseguro;
    EXCEPTION
        WHEN OTHERS THEN
            IF cCoaseguro IS NOT NULL THEN
                nCoaseguro := 1;
            ELSE
                nCoaseguro := 0;
            END IF;

            RETURN nCoaseguro;
    END GETCOASEGURO;

    FUNCTION GETPRIMACEDIDA (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER IS
        nPrimaCedida NUMBER;
    BEGIN
        nPrimaCedida := 0;
        RETURN nPrimaCedida;
    EXCEPTION
        WHEN OTHERS THEN
            nPrimaCedida := 0;
            RETURN nPrimaCedida;
    END GETPRIMACEDIDA;

    FUNCTION GETSDOFONINV (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER IS
        nSdoFonInv NUMBER;
    BEGIN
        nSdoFonInv := 0;
        RETURN nSdoFonInv;
    EXCEPTION
        WHEN OTHERS THEN
            nSdoFonInv := 0;
            RETURN nSdoFonInv;
    END GETSDOFONINV;

    FUNCTION GETSDOFONADM (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER IS
        nSdoFonAdm NUMBER;
    BEGIN
        nSdoFonAdm := 0;
        RETURN nSdoFonAdm;
    EXCEPTION
        WHEN OTHERS THEN
            nSdoFonAdm := 0;
            RETURN nSdoFonAdm;
    END GETSDOFONADM;

    FUNCTION GETMNTODIVID (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER IS
        nMontoDiv NUMBER;
    BEGIN
        nMontoDiv := 0;
        RETURN nMontoDiv;
    EXCEPTION
        WHEN OTHERS THEN
            nMontoDiv := 0;
            RETURN nMontoDiv;
    END GETMNTODIVID;

    FUNCTION GETMNTORESCATE (
        nCodCia   SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        nIdPoliza SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE
    ) RETURN NUMBER IS
        nMontoResc NUMBER;
    BEGIN
        nMontoResc := 0;
        RETURN nMontoResc;
    EXCEPTION
        WHEN OTHERS THEN
            nMontoResc := 0;
            RETURN nMontoResc;
    END GETMNTORESCATE;

    FUNCTION GETFECBAJACERT (
        nIdPoliza  SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        dFecIniVig DATE,
        dFecFinVig DATE,
        dFecAnul   DATE,
        dFecDesde   DATE,
        dFecHasta  DATE,
        cTipoSeg    VARCHAR2 DEFAULT NULL
    ) RETURN DATE IS
        dFecBajaCert        DATE := NULL;
        dFecBajaCert2       DATE := NULL;
        vl_FechaAnulNew     DATE := NULL;
    BEGIN

    IF dFecAnul IS NOT NULL AND cTipoSeg IS NOT NULL THEN

        SELECT MAX(F.FECSTS)
        INTO dFecBajaCert
        FROM SICAS_OC.FACTURAS F
        WHERE F.IDPOLIZA = nIdPoliza
            AND F.FECSTS BETWEEN dFecDesde AND dFecHasta;


        SELECT MAX(N.FECSTS)
        INTO dFecBajaCert2 
        FROM SICAS_OC.NOTAS_DE_CREDITO N
        WHERE IDPOLIZA = nIdPoliza
            AND N.FECSTS BETWEEN dFecDesde AND dFecHasta;

        IF dFecBajaCert < dFecBajaCert2 THEN
            dFecBajaCert := dFecBajaCert2;
        END IF;

    END IF;

    IF dFecBajaCert IS NULL THEN

        SELECT
            ( CASE WHEN dFecAnul IS NOT NULL THEN dFecAnul
                    WHEN dFecFinVig > dFecHasta  THEN NULL
                    WHEN dFecIniVig > dFecHasta  THEN NULL
                    WHEN ( ( SELECT COUNT(1)
                        FROM SICAS_OC.SINIESTRO
                        WHERE IDPOLIZA = nIdPoliza
                            AND TO_CHAR(dFecHasta, 'YYYY') = TO_CHAR(FEC_NOTIFICACION, 'YYYY') ) > 0 ) THEN
                        ( SELECT  MIN(FEC_NOTIFICACION)
                            FROM SICAS_OC.SINIESTRO
                            WHERE IDPOLIZA = nIdPoliza
                                AND TO_CHAR(dFecHasta, 'YYYY') = TO_CHAR(FEC_NOTIFICACION, 'YYYY') )
                    WHEN dFecFinVig <= dFecHasta THEN dFecFinVig END  )
        INTO dFecBajaCert
        FROM DUAL;

    END IF;

        RETURN dFecBajaCert;
    EXCEPTION
        WHEN OTHERS THEN
            dFecBajaCert := NULL;
            RETURN dFecBajaCert;
    END GETFECBAJACERT;

    FUNCTION GETTIPOSUMASEG (
        nCodCia    SICAS_OC.DETALLE_POLIZA.CODCIA%TYPE,
        ClaveSesas VARCHAR2,
        TipoSeguro VARCHAR2
    ) RETURN NUMBER IS
        nTipoSumAseg NUMBER;
    BEGIN
        IF
            ClaveSesas = 10
            AND TipoSeguro = 'VIDA'
        THEN
            nTipoSumAseg := 9;
        ELSE
            nTipoSumAseg := 1;
        END IF;

        RETURN nTipoSumAseg;
    EXCEPTION
        WHEN OTHERS THEN
            nTipoSumAseg := 1;
            RETURN nTipoSumAseg;
    END;

    FUNCTION GETNUMSINIESTRO RETURN NUMBER IS
        nNumSiniestro NUMBER;
    BEGIN
        nNumSiniestro := 0;
        RETURN nNumSiniestro;
    EXCEPTION
        WHEN OTHERS THEN
            nNumSiniestro := 0;
            RETURN nNumSiniestro;
    END GETNUMSINIESTRO;

    FUNCTION GETTIPOSEGURO (
        TipoSeguro VARCHAR2,
        IdPoliza   NUMBER
    ) RETURN VARCHAR2 IS
        cTipoSeg VARCHAR2(10);
    BEGIN
   /* SI LA POLIZA RECIBIDA ES NULL O 0, SE INTERPRETA COMO SEGURO DE VIDA O GMM, POR LO QUE SE VA POR EL TIPO DE SEGURO A NIVEL SESA*/
        IF IdPoliza IS NULL OR IdPoliza = 0 THEN
            cTipoSeg := TipoSeguro;
        ELSE --SI SE RECIBE UN VALOR EN EL PARAMETRO DE POLIZA, SE TOMA EN CUANTA COMO SEGURO DE AP Y SE IRA POR EL TIPO DE SEGURO ESTABLECIDO A NIVEL POLIZA

            cTipoSeg := TipoSeguro; --AQUI SERIA APUNTAR AL NUEVO CAMPO DE TIPO SEGURO A NIVEL POLIZA PARA LOS DE AP
        END IF;

        RETURN cTipoSeg;
    EXCEPTION
        WHEN OTHERS THEN
            cTipoSeg := '';
            RETURN cTipoSeg;
    END GETTIPOSEGURO;


    FUNCTION GETNUMRECLAMACION RETURN NUMBER IS
        nNumReclamo NUMBER;
    BEGIN
        nNumReclamo := 0; --aqui debe ir la rutina de area tecnica

        RETURN nNumReclamo;
    EXCEPTION
        WHEN OTHERS THEN
            nNumReclamo := 0;
            RETURN nNumReclamo;
    END GETNUMRECLAMACION;

    FUNCTION GETTIPOMOVRECLAMO RETURN VARCHAR2 IS
        cTipoMovRec VARCHAR2(2);
    BEGIN
        cTipoMovRec := 'I';  --aqui va rutina del area tecnica

        RETURN cTipoMovRec;
    EXCEPTION
        WHEN OTHERS THEN
            cTipoMovRec := 'I';
            RETURN cTipoMovRec;
    END GETTIPOMOVRECLAMO;

    FUNCTION GETNUMDIASRENTA RETURN NUMBER IS
        nDiasRenta NUMBER;
    BEGIN
        nDiasRenta := 90;  --aqui va rutina del area tecnica

        RETURN nDiasRenta;
    EXCEPTION
        WHEN OTHERS THEN
            nDiasRenta := 90;
            RETURN nDiasRenta;
    END GETNUMDIASRENTA;

    FUNCTION GETPRIMADEVENGADA (
        IdPoliza      NUMBER,
        nPrimaEmitida NUMBER,
        dFecHasta     DATE,
        dFecIniVig    DATE,
        dFecFinVig    DATE
    ) RETURN NUMBER IS

        nPrimaDevengada NUMBER;
        nDiasTotales    NUMBER;
        nDiasDevengados NUMBER;

    BEGIN

        --DIAS DEVENGADOS = SE CALCULA EL DIA PROXIMO MAYOR DESDE EL INICIO DE VIGENCIA A LA FECHA DE CORTE
        --DIAS DE COBERTURA = TOTAL DE DIAS ENTRE EL INICIO DE VIGENCIA Y EL FIN DE VIGENCIA
        --PRIMA EMITIDA = ES LA PRIMA NETA EMITIDA PARA LA POLIZA
        --FORMULA = (DIAS DEVENGADOS/DIAS DE COBERTURA) MULTIPLICADOS POR LA PRIMA EMITIDA

        IF
            IdPoliza IS NOT NULL
            AND IdPoliza > 0
        THEN  --Validacion solo para revisar que sea una poliza valida y 
            --que los demás valores recibidos provienen de lo que tiene la poliza asignada
            IF ( dFecFinVig <= dFecHasta ) THEN
                nPrimaDevengada := nPrimaEmitida;
            ELSE
                nDiasDevengados := ROUND(dFecHasta - dFecIniVig) - 1;
                nDiasTotales := ROUND(dFecFinVig - dFecIniVig);
                nPrimaDevengada := ROUND((nDiasDevengados / nDiasTotales) * nPrimaEmitida, 2);
            END IF;
        ELSE
            nPrimaDevengada := 0;
        END IF;

        RETURN nPrimaDevengada;
    EXCEPTION
        WHEN OTHERS THEN
            nPrimaDevengada := 0;
            RETURN nPrimaDevengada;
    END GETPRIMADEVENGADA;

    FUNCTION GETTIPOPAGOSINI RETURN NUMBER IS
        nTipoPagoSini NUMBER;
    BEGIN
        nTipoPagoSini := 1;  --aqui va rutina del area tecnica

        RETURN nTipoPagoSini;
    EXCEPTION
        WHEN OTHERS THEN
            nTipoPagoSini := 1;
            RETURN nTipoPagoSini;
    END GETTIPOPAGOSINI;

    FUNCTION GETTIPOGASTOINI RETURN NUMBER IS
        nTipoGastoSini NUMBER;
    BEGIN
        nTipoGastoSini := 11;  --aqui va rutina del area tecnica

        RETURN nTipoGastoSini;
    EXCEPTION
        WHEN OTHERS THEN
            nTipoGastoSini := 11;
            RETURN nTipoGastoSini;
    END GETTIPOGASTOINI;

    FUNCTION GETNUMRECLAMOSINI RETURN NUMBER IS
        nReclamoSini NUMBER;
    BEGIN
        nReclamoSini := 1;  --aqui va rutina del area tecnica

        RETURN nReclamoSini;
    EXCEPTION
        WHEN OTHERS THEN
            nReclamoSini := 1;
            RETURN nReclamoSini;
    END GETNUMRECLAMOSINI;

    PROCEDURE DATOSSINIESTROS (
        nCodCia        IN SICAS_OC.ASEGURADO.CODCIA%TYPE,
        nCodEmpresa    IN SICAS_OC.ASEGURADO.CODEMPRESA%TYPE,
        nIdPoliza      IN SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE,
        cNumSiniestro  IN VARCHAR2,
        cCoberturaSini IN VARCHAR2 DEFAULT NULL,
        dFecPagSin     OUT DATE,
        nMonto_Moneda  OUT NUMBER,
        dFecConSin     OUT DATE
    ) IS
        dFecPagSinFin   DATE;
        nIdTransaccion2 NUMBER;
        nNumAprobacion  NUMBER;
        nIdTransaccion  NUMBER;
        cTipAprobacion  NUMBER;
    BEGIN
        BEGIN
            SELECT Num_Aprobacion, FecPago,  IdTransaccion, 1
            INTO  nNumAprobacion, dFecPagSin, nIdTransaccion, cTipAprobacion
            FROM SICAS_OC.APROBACIONES
            WHERE IdPoliza = nIdPoliza
                AND IdSiniestro = cNumSiniestro
                AND CodCia = nCodCia
                AND CodEmpresa = nCodEmpresa
                AND Num_Aprobacion = (
                    SELECT MAX(Num_Aprobacion)
                    FROM SICAS_OC.APROBACIONES
                    WHERE IdPoliza = IdPoliza
                        AND IdSiniestro = cNumSiniestro
                        AND CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa
                );

            SELECT MIN(IdTransaccion)
            INTO nIdTransaccion2
            FROM SICAS_OC.APROBACIONES
            WHERE IdPoliza = nIdPoliza
                AND IdSiniestro = cNumSiniestro
                AND CodCia = nCodCia
                AND CodEmpresa = nCodEmpresa;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                BEGIN
                    SELECT Num_Aprobacion, FecPago,  IdTransaccion, 2
                    INTO nNumAprobacion, dFecPagSin, nIdTransaccion, cTipAprobacion
                    FROM SICAS_OC.APROBACION_ASEG
                    WHERE IdSiniestro = cNumSiniestro
                        AND IdPoliza = nIdPoliza
                        AND CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa
                        AND Num_Aprobacion = (
                            SELECT MAX(Num_Aprobacion)
                            FROM SICAS_OC.APROBACION_ASEG
                            WHERE IdPoliza = nIdPoliza
                                AND IdSiniestro = cNumSiniestro
                                AND CodCia = nCodCia
                                AND CodEmpresa = nCodEmpresa
                        );

                    SELECT MIN(IdTransaccion)
                    INTO nIdTransaccion2
                    FROM SICAS_OC.APROBACION_ASEG
                    WHERE IdPoliza = nIdPoliza
                        AND IdSiniestro = cNumSiniestro
                        AND CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa;

                EXCEPTION
                    WHEN OTHERS THEN
                        dFecPagSin := NULL;
                        nNumAprobacion := NULL;
                        nIdTransaccion := NULL;
                        nIdTransaccion2 := NULL;
                END;
            WHEN OTHERS THEN
                dFecPagSin := NULL;
                nNumAprobacion := NULL;
                nIdTransaccion := NULL;
                nIdTransaccion2 := NULL;
        END;

        IF nIdTransaccion IS NOT NULL THEN
            IF cTipAprobacion = 1 THEN
                BEGIN
                    SELECT SUM(Monto_Moneda)
                    INTO nMonto_Moneda
                    FROM SICAS_OC.DETALLE_APROBACION
                    WHERE IdSiniestro = cNumSiniestro
                        AND Num_Aprobacion = nNumAprobacion
                        AND CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa
                        AND COD_PAGO = NVL(cCoberturaSini, COD_PAGO);

                EXCEPTION
                    WHEN OTHERS THEN
                        nMonto_Moneda := NULL;
                END;
            ELSE
                BEGIN
                    SELECT SUM(Monto_Moneda)
                    INTO nMonto_Moneda
                    FROM SICAS_OC.DETALLE_APROBACION_ASEG
                    WHERE IdSiniestro = cNumSiniestro
                        AND Num_Aprobacion = nNumAprobacion
                        AND CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa
                        AND COD_PAGO = NVL(cCoberturaSini, COD_PAGO);

                EXCEPTION
                    WHEN OTHERS THEN
                        nMonto_Moneda := NULL;
                END;
            END IF;

            SELECT FecComprob
            INTO dFecConSin
            FROM SICAS_OC.COMPROBANTES_CONTABLES
            WHERE CodCIa = nCodCia
                AND NumTransaccion = nIdTransaccion2;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dFecPagSin := NULL;
            nMonto_Moneda := NULL;
            dFecConSin := NULL;
    END DATOSSINIESTROS;

    FUNCTION GETNUMCERTIFICADO (
        vCodCia   IN NUMBER,
        vIdPoliza IN NUMBER,
        vIDetPol  IN NUMBER
    ) RETURN VARCHAR2 IS
        cNumCertificado VARCHAR2(25);
    BEGIN
        SELECT TRIM(LPAD(XX.IdPoliza, 8, '0'))
            || TRIM(LPAD(XX.IDetPol, 2, '0'))
            || TRIM(LPAD(XX.Cod_Asegurado, 10, '0'))
        INTO cNumCertificado
        FROM SICAS_OC.ASEGURADO_CERTIFICADO XX
        WHERE XX.CodCia = vCodCia
            AND XX.IdPoliza = vIdPoliza
            AND XX.IdetPol = vIDetPol
            AND ROWNUM <= 1;

        RETURN cNumCertificado;
    EXCEPTION
        WHEN OTHERS THEN
            cNumCertificado := NULL;
            RETURN cNumCertificado;
    END GETNUMCERTIFICADO;

    FUNCTION GETOCUPACIONAP (
        cCodActividad   VARCHAR,
        cTipoSeg        VARCHAR --IND O COL PARA SABER A QUE CATALOGO IR
    ) RETURN VARCHAR2 IS
        c_CodActividad  VARCHAR2(1500) := NULL;
    BEGIN
        BEGIN
            SELECT NVL(CLAVESESA,'')
            INTO c_CodActividad
            FROM SICAS_OC.OCUPACION_SESAS
            WHERE CODACTIVIDAD = cCodActividad
                AND CODREPORTE = (CASE cTipoSeg WHEN 'API' THEN 'SESAS251' WHEN 'APC' THEN 'SESAS253' END )
                AND ROWNUM <= 1;
        EXCEPTION
            WHEN OTHERS THEN
                c_CodActividad := NULL;
        END;

        RETURN c_CodActividad;

    EXCEPTION
        WHEN OTHERS THEN
            c_CodActividad := NULL;
    END GETOCUPACIONAP;

    FUNCTION GETANIOPOLIZA (
        nNumPolUnico   VARCHAR 
    ) RETURN NUMBER IS
        nAnioRenova  NUMBER := 1;
    BEGIN

         IF REGEXP_LIKE(SUBSTR(nNumPolUnico,-3), '-[0-9][0-9]') THEN
            nAnioRenova := TO_NUMBER(SUBSTR(nNumPolUnico,-2)) + 1;
         ELSE
            nAnioRenova := 1;
         END IF;

        RETURN nAnioRenova;
    EXCEPTION
        WHEN OTHERS THEN
            nAnioRenova := 1;
    END GETANIOPOLIZA;

    FUNCTION GETCANTASEGAPC (
        nCodCia         NUMBER,
        nCodEmpresa     NUMBER,
        nCodAsegurado   VARCHAR,
        nCantAsegurado  NUMBER

    ) RETURN NUMBER IS
    vl_CantAseg     NUMBER := 0;
    BEGIN

        SELECT COUNT(1)
        INTO vl_CantAseg
        FROM SICAS_OC.SESA_ASEGMODELO
        WHERE CODCIA = nCodCia
            AND CODEMPRESA = nCodEmpresa
            AND COD_ASEGURADO = nCodAsegurado;

        IF vl_CantAseg >= 1 THEN
            vl_CantAseg := nCantAsegurado;
        ELSE
            vl_CantAseg := 1;
        END IF;

        RETURN vl_CantAseg;

    EXCEPTION
        WHEN OTHERS THEN
            vl_CantAseg := 1;
            RETURN vl_CantAseg;
    END;

    PROCEDURE NOTIFICACORREO (cNombreUser VARCHAR2, cNomSesa VARCHAR2, cEstatus VARCHAR2, dInicio VARCHAR2, dFin VARCHAR2, cDuracion VARCHAR2) IS
    nCodCia NUMBER := 1;
    nCodEmpresa NUMBER := 1;
    nCodCliente             CLIENTES.CodCliente%TYPE;
    cTipoDocIdentificacion  CLIENTES.Tipo_Doc_Identificacion%TYPE;
    cNumDocIdentificacion   CLIENTES.Num_Doc_Identificacion%TYPE;
    cEmailCliente           CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
    cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
    dFecIniVig              POLIZAS.FecIniVig%TYPE;
    cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;

    cSubject                VARCHAR2(10000);
    cMessage                VARCHAR2(20000);
    cEmailAuth              VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
    cPwdEmail               VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
    cEmailEnvio             VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
    cCadenaLogo             VARCHAR2(200)     := ' <img src="http://www.thonaseguros.mx/images/Thona_Seguros.png" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="80" width="300"> ';
    cAvisoImportante        VARCHAR2(1000)    := 'AVISO IMPORTANTE. Este correo electrÃ³nico y cualquier archivo que se adjunte al mismo, es propiedad de THONA Seguros S.A. de C.V., y podrÃ¡ '||
                                                 'contener informaciÃ³n privada y privilegiada para uso exclusivo del destinatario. Si usted ha recibido este correo por error, por favor, notifique '||
                                                 'al remitente y bÃ³rrelo. No estÃ¡ autorizado para copiar, retransmitir, utilizar o divulgar este mensaje ni los archivos adjuntos, de lo contrario '||
                                                 'estarÃ¡ infringiendo leyes mexicanas y de otros paÃ­ses que se aplican rigurosamente.';
    cHTMLHeader             VARCHAR2(2000)    := '<html>'                                                                     ||CHR(13)||
                                                 '<head>'                                                                     ||CHR(13)||
                                                 '<meta http-equiv="Content-Language" content="en/us"/>'                      ||CHR(13)||
                                                 '</head><body>'                                                              ||CHR(13);
    cHTMLFooter             VARCHAR2(100)     := '</body></html>';
    cTextoAlignDerecha      VARCHAR2(50)      := '<P align="right">';
    cTextoAlignDerechaClose VARCHAR2(50)      := '</P>';
    cSaltoLinea             VARCHAR2(5)       := '<br>';
    cTextoImportanteOpen    VARCHAR2(10)      := '<strong>';
    cTextoImportanteClose   VARCHAR2(10)      := '</strong>';
    cTextoRojoOpen          VARCHAR2(100)     := '<FONT COLOR="red">';
    cTextoAmarilloOpen      VARCHAR2(100)     := '<FONT COLOR="#ffbf00">';
    cTextoClose             VARCHAR2(30)      := '</FONT>';
    cTextoSmall             VARCHAR2(100)     := '<FONT SIZE="2" COLOR="blue">';
    cError                  VARCHAR2(200);

    nCod                    NUMBER;
    vl_CodAgente            NUMBER;
    vl_Mails                VARCHAR2(4000) := NULL;
    cError2                  VARCHAR2(200);
    VL_LONG                 NUMBER;
    cNomArchivo             VARCHAR2(4000) := NULL;
    cDirectorio             VARCHAR2(4000) := NULL;
    vl_salida               VARCHAR2(4000) := NULL;
    nCodSalida          NUMBER := 1;
    nc0                 CONSTANT        NUMBER := 0;
    nc1                 CONSTANT        NUMBER := 1;
    nc2                 CONSTANT        NUMBER  :=2;
    nc7                 CONSTANT        NUMBER :=7;
    vl_Existe       NUMBER;
    vMsjSalida          VARCHAR2(4000);
    vl_cNomSesa VARCHAR2(4000);
    http_req utl_http.req;
    http_resp utl_http.resp;

    content_type varchar2(4000);
    post_content varchar2(4000);
    vl_Enlace  varchar2(4000);
    v_resp_chunked varchar2(4000);
    v_resp CLOB;
    vl_Nom  VARCHAR2(4000);
    cEmailCopia VARCHAR2(4000);
    BEGIN

    IF cNomSesa IN ('DATOS GENERLAES AP COLECTIVO','EMISION AP COLECTIVO','DATOS GENERALES VIDA GRUPO','EMISION VIDA GRUPO') THEN
        vl_cNomSesa := cTextoImportanteOpen||' <p style="color:#D31313";>'||cNomSesa||'</p>'||cTextoImportanteClose;
    ELSE
        vl_cNomSesa := cTextoImportanteOpen||' <p style="color:#000000";>'||cNomSesa||'</p>'||cTextoImportanteClose;
    END IF;

        cSubject := cEstatus||' ejecucion SESA '||cNomSesa;
        cMessage := cHTMLHeader||cSaltoLinea||'Por medio del presente se notifica que '||cEstatus||' la ejecucion de la SESA '||vl_cNomSesa ||cSaltoLinea||
            'Responsable: '||cNombreUser||cSaltoLinea||
            cSaltoLinea||'  Inicio: '||dInicio;

            IF (cEstatus ='Termino exitosamente ') THEN
                cMessage := cMessage||cSaltoLinea||'  Final: '||dFin||
                cSaltoLinea||cTextoImportanteOpen||'   '||cDuracion||cTextoImportanteClose;
            END IF;

            cMessage := cMessage||cSaltoLinea||cSaltoLinea||'Este Correo es Generado de Manera Automatica, Por Favor no lo Responda.'||cSaltoLinea||UTL_TCP.CRLF||cSaltoLinea||
            cCadenaLogo||cSaltoLinea||cSaltoLinea||
            cSaltoLinea||cTextoSmall||cAvisoImportante||cTextoClose||
            cHTMLFooter;

        OC_MAIL.INIT_PARAM;
        OC_MAIL.cCtaEnvio   := cEmailAuth;
        OC_MAIL.cPwdCtaEnvio:= cPwdEmail;

        cEmailCliente := 'lreynoso@thonaseguros.mx,jibarra@thonaseguros.mx,msiller@thonaseguros.mx,cgarcia@thonaseguros.mx';
        cEmailCopia := 'ogudino@thonaseguros.mx,chernandez@thonaseguros.mx,egarduno@thonaseguros.mx,masanchez@thonaseguros.mx,rperez@thonaseguros.mx';

        BEGIN
            SELECT DESCVALLST 
            INTO cEmailCliente
            FROM VALORES_DE_LISTAS
            WHERE CODLISTA = 'ONSESAS'
                AND CODVALOR = 2;

            SELECT DESCVALLST 
            INTO cEmailCopia
            FROM VALORES_DE_LISTAS
            WHERE CODLISTA = 'ONSESAS'
                AND CODVALOR = 3;
        EXCEPTION
            WHEN OTHERS THEN
                cEmailCliente := 'lreynoso@thonaseguros.mx,jibarra@thonaseguros.mx,msiller@thonaseguros.mx,cgarcia@thonaseguros.mx';
                cEmailCopia := 'ogudino@thonaseguros.mx,chernandez@thonaseguros.mx,egarduno@thonaseguros.mx,masanchez@thonaseguros.mx,rperez@thonaseguros.mx';
        END;


            BEGIN
                OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,cEmailCopia,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);

            EXCEPTION
                WHEN OTHERS THEN
                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(1,1, cNomSesa, USER, 'SISTEMA', 'No fue posible enviar el correo.', SQLCODE, ' Error al enviar correo: '|| SQLERRM);
            END;


END NOTIFICACORREO;

    PROCEDURE NOTIFICARUTINA (cNombreUser VARCHAR2, cNomSesa VARCHAR2, cEstatus VARCHAR2, dInicio VARCHAR2, dFin VARCHAR2, cDuracion VARCHAR2) IS
    nCodCia NUMBER := 1;
    nCodEmpresa NUMBER := 1;
    nCodCliente             CLIENTES.CodCliente%TYPE;
    cTipoDocIdentificacion  CLIENTES.Tipo_Doc_Identificacion%TYPE;
    cNumDocIdentificacion   CLIENTES.Num_Doc_Identificacion%TYPE;
    cEmailCliente           CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
    cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
    dFecIniVig              POLIZAS.FecIniVig%TYPE;
    cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;

    cSubject                VARCHAR2(10000);
    cMessage                VARCHAR2(20000);
    cEmailAuth              VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
    cPwdEmail               VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
    cEmailEnvio             VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
    cCadenaLogo             VARCHAR2(200)     := ' <img src="http://www.thonaseguros.mx/images/Thona_Seguros.png" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="80" width="300"> ';
    cAvisoImportante        VARCHAR2(1000)    := 'AVISO IMPORTANTE. Este correo electrÃ³nico y cualquier archivo que se adjunte al mismo, es propiedad de THONA Seguros S.A. de C.V., y podrÃ¡ '||
                                                 'contener informaciÃ³n privada y privilegiada para uso exclusivo del destinatario. Si usted ha recibido este correo por error, por favor, notifique '||
                                                 'al remitente y bÃ³rrelo. No estÃ¡ autorizado para copiar, retransmitir, utilizar o divulgar este mensaje ni los archivos adjuntos, de lo contrario '||
                                                 'estarÃ¡ infringiendo leyes mexicanas y de otros paÃ­ses que se aplican rigurosamente.';
    cHTMLHeader             VARCHAR2(2000)    := '<html>'                                                                     ||CHR(13)||
                                                 '<head>'                                                                     ||CHR(13)||
                                                 '<meta http-equiv="Content-Language" content="en/us"/>'                      ||CHR(13)||
                                                 '</head><body>'                                                              ||CHR(13);
    cHTMLFooter             VARCHAR2(100)     := '</body></html>';
    cTextoAlignDerecha      VARCHAR2(50)      := '<P align="right">';
    cTextoAlignDerechaClose VARCHAR2(50)      := '</P>';
    cSaltoLinea             VARCHAR2(5)       := '<br>';
    cTextoImportanteOpen    VARCHAR2(10)      := '<strong>';
    cTextoImportanteClose   VARCHAR2(10)      := '</strong>';
    cTextoRojoOpen          VARCHAR2(100)     := '<FONT COLOR="red">';
    cTextoAmarilloOpen      VARCHAR2(100)     := '<FONT COLOR="#ffbf00">';
    cTextoClose             VARCHAR2(30)      := '</FONT>';
    cTextoSmall             VARCHAR2(100)     := '<FONT SIZE="2" COLOR="blue">';
    cError                  VARCHAR2(200);

    nCod                    NUMBER;
    vl_CodAgente            NUMBER;
    vl_Mails                VARCHAR2(4000) := NULL;
    cError2                  VARCHAR2(200);
    VL_LONG                 NUMBER;
    cNomArchivo             VARCHAR2(4000) := NULL;
    cDirectorio             VARCHAR2(4000) := NULL;
    vl_salida               VARCHAR2(4000) := NULL;
    nCodSalida          NUMBER := 1;
    nc0                 CONSTANT        NUMBER := 0;
    nc1                 CONSTANT        NUMBER := 1;
    nc2                 CONSTANT        NUMBER  :=2;
    nc7                 CONSTANT        NUMBER :=7;
    vl_Existe       NUMBER;
    vMsjSalida          VARCHAR2(4000);
    vl_cNomSesa VARCHAR2(4000);
    http_req utl_http.req;
    http_resp utl_http.resp;

    content_type varchar2(4000);
    post_content varchar2(4000);
    vl_Enlace  varchar2(4000);
    v_resp_chunked varchar2(4000);
    v_resp CLOB;
    vl_Nom  VARCHAR2(4000);
    cEmailCopia VARCHAR2(4000);
    BEGIN

    IF cNomSesa IN ('DATOS GENERLAES AP COLECTIVO','EMISION AP COLECTIVO','DATOS GENERALES VIDA GRUPO','EMISION VIDA GRUPO') THEN
        vl_cNomSesa := cTextoImportanteOpen||' <p style="color:#D31313";>'||cNomSesa||'</p>'||cTextoImportanteClose;
    ELSE
        vl_cNomSesa := cTextoImportanteOpen||' <p style="color:#000000";>'||cNomSesa||'</p>'||cTextoImportanteClose;
    END IF;

        cSubject := 'No se a ejecutado la rutina para la SESA '||cNomSesa;
        cMessage := cHTMLHeader||cSaltoLinea||'Por medio del presente se notifica que '||cTextoImportanteOpen||'hace falta la ejecucion de la rutina del '||cEstatus||cTextoImportanteClose||' para ejecutar la SESA '||vl_cNomSesa ||cSaltoLinea||
            'Responsable: '||cNombreUser||cSaltoLinea;

            cMessage := cMessage||cSaltoLinea||cSaltoLinea||'Este Correo es Generado de Manera Automatica, Por Favor no lo Responda.'||cSaltoLinea||UTL_TCP.CRLF||cSaltoLinea||
            cCadenaLogo||cSaltoLinea||cSaltoLinea||
            cSaltoLinea||cTextoSmall||cAvisoImportante||cTextoClose||
            cHTMLFooter;

        OC_MAIL.INIT_PARAM;
        OC_MAIL.cCtaEnvio   := cEmailAuth;
        OC_MAIL.cPwdCtaEnvio:= cPwdEmail;

        cEmailCliente := 'lreynoso@thonaseguros.mx,jibarra@thonaseguros.mx,msiller@thonaseguros.mx,cgarcia@thonaseguros.mx';
        cEmailCopia := 'ogudino@thonaseguros.mx,chernandez@thonaseguros.mx,egarduno@thonaseguros.mx,masanchez@thonaseguros.mx,rperez@thonaseguros.mx';

        BEGIN
            SELECT DESCVALLST 
            INTO cEmailCliente
            FROM VALORES_DE_LISTAS
            WHERE CODLISTA = 'ONSESAS'
                AND CODVALOR = 2;

            SELECT DESCVALLST 
            INTO cEmailCopia
            FROM VALORES_DE_LISTAS
            WHERE CODLISTA = 'ONSESAS'
                AND CODVALOR = 3;
        EXCEPTION
            WHEN OTHERS THEN
                cEmailCliente := 'lreynoso@thonaseguros.mx,jibarra@thonaseguros.mx,msiller@thonaseguros.mx,cgarcia@thonaseguros.mx';
                cEmailCopia := 'ogudino@thonaseguros.mx,chernandez@thonaseguros.mx,egarduno@thonaseguros.mx,masanchez@thonaseguros.mx,rperez@thonaseguros.mx';
        END;


            BEGIN
                OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,cEmailCopia,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);

            EXCEPTION
                WHEN OTHERS THEN
                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(1,1, cNomSesa, USER, 'SISTEMA', 'No fue posible enviar el correo.', SQLCODE, ' Error al enviar correo rutina: '|| SQLERRM);
            END;

END NOTIFICARUTINA;

PROCEDURE CALCULO_NUMREC (vlPnomsesa IN VARCHAR2) IS

      CURSOR GET_SINIESTROS IS
        WITH MONTO_TS AS (SELECT CODCIA
                                ,CODEMPRESA
                                ,NUMPOLIZA
                                ,NUMSINIESTRO
                                ,SUM(MONTORECLAMADO) MONTO_TOTALS
                            FROM SICAS_OC.SESAS_SINIESTROS
                            WHERE 1 = 1
                            GROUP BY CODCIA, CODEMPRESA, NUMPOLIZA, NUMSINIESTRO
                            )
        SELECT SS.*,TS.MONTO_TOTALS
        FROM SICAS_OC.SESAS_SINIESTROS SS
            ,MONTO_TS TS
        WHERE 1 = 1
        AND TS.CODCIA = SS.CODCIA
        AND TS.CODEMPRESA = SS.CODEMPRESA
        AND TS.NUMPOLIZA = SS.NUMPOLIZA
        AND TS.NUMSINIESTRO = SS.NUMSINIESTRO
        ORDER BY SS.NUMPOLIZA, SS.NUMSINIESTRO, SS.FECCONSIN ASC, SS.MONTORECLAMADO DESC
        ;

    vNumRec         NUMBER := 0;
    vNumRecAnt      NUMBER := -99;
    vSiniestroCtrl  NUMBER := NULL;
    vMontoSum       NUMBER := 0;
	vFechaCtrl      DATE := NULL;
    vR3Ctrl         NUMBER := 0;
    vR3CtrlS        NUMBER := 0;
    vR3Ant          NUMBER := -99;
BEGIN
    FOR X IN GET_SINIESTROS LOOP
        IF (vSiniestroCtrl IS NULL) THEN
            vSiniestroCtrl := X.NUMSINIESTRO;
            vMontoSum := X.MONTORECLAMADO;
            vFechaCtrl := X.FECCONSIN;
        ELSIF(vSiniestroCtrl != X.NUMSINIESTRO)THEN
            --DBMS_OUTPUT.PUT_LINE('*********************************************');
            vSiniestroCtrl := X.NUMSINIESTRO;
            vMontoSum := X.MONTORECLAMADO;
            vNumRec := 0;
            vR3CtrlS := 0;
            vNumRecAnt := -99;
            vR3Ant := -99;
        ELSE 
            vMontoSum := (vMontoSum + X.MONTORECLAMADO);
        END IF;

        IF(vMontoSum <= X.MONTO_TOTALS)THEN
            IF(X.MONTORECLAMADO >= 0 AND X.FECCONSIN != vFechaCtrl)THEN
                IF(vNumRec = 0)THEN
                    vNumRec := X.NUMRECLAMACION;
                ELSE
                    vNumRec := (vNumRec + 1);
                END IF;
            ELSE
                IF(vNumRec = 0)THEN
                    vNumRec := X.NUMRECLAMACION;
                END IF;
            END IF;
        ELSE
            IF(X.MONTO_TOTALS < 0 AND vNumRec = 0)THEN
                vNumRec := X.NUMRECLAMACION;
            ELSE
                IF(X.MONTORECLAMADO > 0 AND vNumRec = 0)THEN
                    vNumRec := X.NUMRECLAMACION;
                ELSIF(X.MONTO_TOTALS > 0)THEN
                    vNumRec := (vNumRec + 1);
                END IF;
            END IF;
        END IF;

        IF(vMontoSum < X.MONTO_TOTALS)THEN
            vR3CtrlS := (vR3CtrlS+1);
            vR3Ctrl := vR3CtrlS;
        ELSE
            vR3Ctrl := 0;
        END IF;

        IF(vR3Ant = 0 AND vMontoSum >= X.MONTO_TOTALS AND X.MONTORECLAMADO > 0)THEN
            vNumRec := vNumRecAnt;
        END IF;

        /*DBMS_OUTPUT.PUT_LINE(X.NUMSINIESTRO || '|' || X.NUMRECLAMACION || '|' || TO_CHAR(X.FECREPREC,'DD/MM/YYYY') || '|' || TO_CHAR(X.FECCONSIN,'DD/MM/YYYY') || '|' || X.COBERTURA
                            || '|' || X.MONTORECLAMADO || '|' || X.MONTODEDUCIBLE || '|' || (X.MONTORECLAMADO - X.MONTODEDUCIBLE) || '|' || vMontoSum || '|' || X.MONTO_TOTALS || '|' || CASE WHEN vMontoSum >= X.MONTO_TOTALS THEN 0 ELSE vNumRec END || '|' || vNumRec);*/

           UPDATE SICAS_OC.SESAS_SINIESTROS
            SET
            MOMENDED = (X.MONTORECLAMADO - X.MONTODEDUCIBLE) 
            , MONTSUM = vMontoSum 
            , MONTOTAL = X.MONTO_TOTALS 
            , R3 = vR3Ctrl
            , NUM_REC = vNumRec
            WHERE CODCIA = X.CODCIA
                AND CODEMPRESA = X.CODEMPRESA
                AND NUMPOLIZA = X.NUMPOLIZA
                AND NUMSINIESTRO = X.NUMSINIESTRO
                AND MONTORECLAMADO = X.MONTORECLAMADO
                AND COBERTURA = X.COBERTURA;
        --AND NUMRECLAMACION = X.NUMRECLAMACION;*/
        COMMIT;
        vFechaCtrl := X.FECCONSIN;
        vNumRecAnt := vNumRec;
        vR3Ant := vR3Ctrl;
    END LOOP;
    EXCEPTION WHEN OTHERS THEN 
         SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(1,1, vlPnomsesa, USER, 'CALCULO_NUMREC', 'Error:', SQLCODE, ' Error al generar proceso numero de reclamacion final: '|| SQLERRM);

END CALCULO_NUMREC;

END OC_PROCESOSSESAS;
/

GRANT EXECUTE ON SICAS_OC.OC_PROCESOSSESAS TO PUBLIC;
/

--SYNONYM
CREATE OR REPLACE PUBLIC SYNONYM OC_PROCESOSSESAS FOR SICAS_OC.OC_PROCESOSSESAS;
/

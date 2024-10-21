CREATE OR REPLACE PACKAGE THONAPI.GENERALES_PLATAFORMA_DIGITAL AS
/******************************************************************************
   NOMBRE:       GENERALES_PLATAFORMA_DIGITAL
   1.0        12/07/2019      CPEREZ<       1. Created this package.
******************************************************************************/
--masp
    
    xInformacionFiscal  XMLTYPE;  --quitar cuando darbrain haga el cambio
    FUNCTION REQUISITOS_COBERT ( PA_IDPOLIZA IN  NUMBER,   PA_CODASEGURADO IN  NUMBER,  PA_NOMBRE IN  VARCHAR2, PA_APPATERNO IN  VARCHAR2, PA_APMATERNO    IN  VARCHAR2, PA_CODCOBERT    IN  VARCHAR2, PA_IDREQUISITO  IN  VARCHAR2 ) RETURN CLOB;
    FUNCTION ES_NUMERICO(pEntrada VARCHAR2) RETURN NUMBER;
    FUNCTION DIGITAL_PLANTILLA   (nNivel IN OUT int, pPK1 IN OUT VARCHAR2) return CLOB;
    FUNCTION DIGITAL_GENERAWHERE (pCOLUMN_NAME  VARCHAR2, pPK VARCHAR2, pSqlWhere VARCHAR2) return VARCHAR2;
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
    --
    FUNCTION PRE_EMITE_POLIZA_NEW( nCodCia             NUMBER
                                 , nCodEmpresa         NUMBER
                                 , nIdCotizacion       NUMBER
                                 , cCadena             VARCHAR2
                                 , cIdPoliza           NUMBER := NULL ) RETURN CLOB;
    --
    FUNCTION CONSULTA_FACTURA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN CLOB;
    FUNCTION PAGO_FACTURA (nIdPoliza NUMBER, nIdFactura NUMBER, cCodFormaPago VARCHAR2) RETURN BOOLEAN;
    FUNCTION CONSULTA_COT_PAGO_FRACCIONARIO(nCodCia NUMBER, nIdCotizacion NUMBER) RETURN CLOB;
    --
    FUNCTION CONSULTA_CODIGO_POSTAL( pCatalogo        NUMBER := 0
                                   , pCODPOSTAL       VARCHAR2
                                   , pCODPAIS         VARCHAR2
                                   , pCODCIUDAD       VARCHAR2
                                   , pCODESTADO       VARCHAR2
                                   , pCODMUNICIPIO    VARCHAR2
                                   , pCODIGO_COLONIA  VARCHAR2 ) RETURN CLOB;
    --
    FUNCTION CATALOGO_GENERAL(pCodLista VARCHAR2 := 'FORMPAGO', pCodValor VARCHAR2) RETURN CLOB;
    FUNCTION CATALOGO_ENTIDAD_FINANCIERA(pCodEntidad VARCHAR2) RETURN CLOB;
    PROCEDURE POLIZA_ANULA(pIDPoliza NUMBER, pMotivAnul VARCHAR2, pCod_Moneda VARCHAR2 := 'PS');
    FUNCTION MUESTRA_COTIZACIONES(pIDCOTIZACION NUMBER, pNombre VARCHAR2, pCodAgente NUMBER, pEstatus VARCHAR2, nNumRegIni NUMBER := 1, nNumRegFin NUMBER := 50) RETURN CLOB;
    FUNCTION PLD_POLIZA_LIBERADA(nIdPoliza NUMBER) RETURN CHAR;
    FUNCTION PLD_POLIZA_BLOQUEDA(nIdPoliza NUMBER) RETURN CHAR;
    FUNCTION COTIZACION_CONCEPTOS_PRIMA(pIDCOTIZACION NUMBER) RETURN CLOB;
    FUNCTION MUESTRA_POLIZAS(pCodCia NUMBER, pIDPOLIZA NUMBER, pRFC VARCHAR2, pNombre VARCHAR2, pCodAgente VARCHAR2, nNumRegIni NUMBER, nNumRegFin NUMBER) RETURN CLOB;
    FUNCTION CONSULTA_AGENTE(pCODCIA NUMBER, pCODEMPRESA NUMBER, pCODAGENTE NUMBER) RETURN CLOB;
    FUNCTION CONDICIONES_GENERALES(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecEmision DATE) RETURN BLOB;
    FUNCTION DESCARTA_POLIZA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN INT;
    FUNCTION LIMPIA_COTIZACIONES (pFecha DATE := TRUNC(SYSDATE)) RETURN NUMBER;
    FUNCTION PAQUETE_COMERCIAL_DOCUMENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cDescPaquete VARCHAR2) RETURN BLOB;
    FUNCTION DOCUMENTO_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, nCodPaquete NUMBER) RETURN BLOB;
    FUNCTION QUE_HACER_SINIESTROS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN BLOB;
    FUNCTION TIPO_ARCH_BLOB(pTabla VARCHAR2, pCampo_Blob VARCHAR2, pWhere VARCHAR2) return varchar;
    FUNCTION ACTIVIDAD_ECONOMICA(cRiesgoActividad IN VARCHAR2, cTipoRiesgo IN VARCHAR2) RETURN XMLTYPE;
    PROCEDURE ACTUALIZA_COMISIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nPorcComisAgente NUMBER, nPorcConv OUT NUMBER, nGastos OUT NUMBER);
    PROCEDURE ACTUALIZA_CONVENCIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nPorcConvenciones NUMBER);
    --PROCEDURE RECIBE_GENERALES_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, xGenerales XMLTYPE);
    PROCEDURE RECIBE_GENERALES_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, xGenerales XMLTYPE);
    FUNCTION CREA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, cCadena VARCHAR2) RETURN NUMBER;
    PROCEDURE CANCELACION_POLIZAS(nCodCia NUMBER,nCodEmpresa NUMBER,nIdPoliza NUMBER,cMotivAnul VARCHAR2,cRespuesta OUT VARCHAR2,cTipoProceso VARCHAR2,cCod_Moneda OUT VARCHAR2, xRespuesta OUT NUMBER, fechaAnulacion DATE);
    --
   PROCEDURE ACTUALIZA_INFORMACION_FISCAL( nCodCia             POLIZAS.CodCia%TYPE
                                         , nCodEmpresa         POLIZAS.CodEmpresa%TYPE
                                         , nIdPoliza           POLIZAS.IdPoliza%TYPE
                                         , xInformacionFiscal  XMLTYPE );

    FUNCTION PRE_EMITE_POLIZA_NEW_CFDI40( nCodCia             NUMBER
                                        , nCodEmpresa         NUMBER
                                        , nIdCotizacion       NUMBER
                                        , cCadena             VARCHAR2
                                        , cIdPoliza           NUMBER := NULL
                                        , xInformacionFiscal  XMLTYPE ) RETURN CLOB;

    /*JACF [28/09/2023] <Se agrega funci√É¬≥n para consultar catalogo de formas de cobro desde las listas de valores>*/
    FUNCTION FORMAS_COBRO(LISTA VARCHAR2) RETURN CLOB;
END GENERALES_PLATAFORMA_DIGITAL;
/

CREATE OR REPLACE PACKAGE BODY THONAPI.GENERALES_PLATAFORMA_DIGITAL AS
/******************************************************************************
   NOMBRE:       GENERALES_PLATAFORMA_DIGITAL
   1.0        12/07/2019      CPEREZ<       1. Created this package.
******************************************************************************/
    FUNCTION REQUISITOS_COBERT (  PA_IDPOLIZA     IN  NUMBER,
                                                PA_CODASEGURADO IN  NUMBER,
                                                PA_NOMBRE       IN  VARCHAR2,
                                                PA_APPATERNO    IN  VARCHAR2,
                                                PA_APMATERNO    IN  VARCHAR2,
                                                PA_CODCOBERT    IN  VARCHAR2,
                                                PA_IDREQUISITO  IN  VARCHAR2
                                            ) RETURN CLOB IS

    vl_IdTipoSeg        VARCHAR2(4000);
    vl_PlanCob          VARCHAR2(4000);
    vl_CodCobert        VARCHAR2(4000);
    vl_CodAseg          VARCHAR2(4000);
    CURSOR Q_FORMA IS 
        SELECT  XMLELEMENT("DOCUMENTO", XMLATTRIBUTES(IDTIPOSEG AS "IDTIPOSEG", PLANCOB AS "PLANCOB", CODCOBERT AS "CODCOBERT", DESCCOBERT AS "DESCCOBERT", CODREQUISITO AS "CODREQUISITO", NOMARCHIVO AS "NOMARCHIVO",DESCREQUISITO AS "DESCREQUISITO", 
                        REQUERIDO AS "REQUERIDO", ORDENEXPEDIENTE AS "ORDEN_EXPEDIENTE", ORDENPDF AS "ORDEN_PDF", CANTIDAD AS "CANTIDAD", TAMANIOBYTES AS "TAMANIO_BYTES", FORMATOS AS "FORMATOS", CLAVEOCR AS "PALABRAS_CLAVE_OCR", TOOLTIP AS "TOOLTIP")
                ) DOCUMENTO
        FROM (              
                SELECT DISTINCT A.IDTIPOSEG, 
                        A.PLANCOB,
                        A.CODCOBERT,
                        B.DESCCOBERT,
                        A.CODREQUISITO,
                        NVL(C.NOMARCHIVO,'') NOMARCHIVO,
                        C.DESCREQUISITO ,
                        (CASE A.REQUERIDO WHEN 'S' THEN 'TRUE' ELSE 'FALSE' END) REQUERIDO,
                        A.ORDENEXPEDIENTE,
                        A.ORDENPDF,
                        A.CANTIDAD,
                        C.TAMANIOBYTES,
                        NVL(C.FORMATOS,'') FORMATOS,
                        NVL(C.CLAVEOCR,'') CLAVEOCR,
                        NVL(C.TOOLTIP,'') TOOLTIP
                FROM SICAS_OC.DETALLE_POLIZA D
                INNER JOIN SICAS_OC.REQUISITOS_COBERTURAS A
                    ON A.IDTIPOSEG = D.IDTIPOSEG
                    AND A.PLANCOB = D.PLANCOB
                INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  B
                    ON B.IDTIPOSEG = A.IDTIPOSEG
                    AND B.PLANCOB = A.PLANCOB
                    AND B.CODCOBERT = A.CODCOBERT
                INNER JOIN SICAS_OC.REQUISITOS C
                    ON C.CODREQUISITO = A.CODREQUISITO
                WHERE A.IDTIPOSEG = NVL(vl_IdTipoSeg,A.IDTIPOSEG)
                    AND A.PLANCOB = NVL(vl_PlanCob,A.PLANCOB)
                    AND A.CODCOBERT = NVL(vl_CodCobert,A.CODCOBERT)
                    AND NVL(C.NOMARCHIVO,'') = NVL(PA_IDREQUISITO,NVL(C.NOMARCHIVO,''))
                    AND D.IDPOLIZA = PA_IDPOLIZA
                ORDER BY A.IDTIPOSEG,A.PLANCOB,A.CODCOBERT,A.CODREQUISITO);

    CURSOR Q_CODASEG IS 
        SELECT  XMLELEMENT("DOCUMENTO", XMLATTRIBUTES(IDTIPOSEG AS "IDTIPOSEG", PLANCOB AS "PLANCOB", CODCOBERT AS "CODCOBERT", DESCCOBERT AS "DESCCOBERT", CODREQUISITO AS "CODREQUISITO", NOMARCHIVO AS "NOMARCHIVO", DESCREQUISITO AS "DESCREQUISITO", 
                        REQUERIDO AS "REQUERIDO", ORDENEXPEDIENTE AS "ORDEN_EXPEDIENTE", ORDENPDF AS "ORDEN_PDF", CANTIDAD AS "CANTIDAD", TAMANIOBYTES AS "TAMANIO_BYTES", FORMATOS AS "FORMATOS", CLAVEOCR AS "PALABRAS_CLAVE_OCR", TOOLTIP AS "TOOLTIP")
                ) DOCUMENTO
        FROM (              
                SELECT DISTINCT A.IDTIPOSEG IDTIPOSEG, 
                        A.PLANCOB,
                        A.CODCOBERT,
                        B.DESCCOBERT,
                        A.CODREQUISITO,
                        NVL(C.NOMARCHIVO,'') NOMARCHIVO,
                        C.DESCREQUISITO ,
                        (CASE A.REQUERIDO WHEN 'S' THEN 'TRUE' ELSE 'FALSE' END) REQUERIDO,
                        A.ORDENEXPEDIENTE,
                        A.ORDENPDF,
                        A.CANTIDAD,
                        C.TAMANIOBYTES,
                        NVL(C.FORMATOS,'') FORMATOS,
                        NVL(C.CLAVEOCR,'') CLAVEOCR,
                        NVL(C.TOOLTIP,'') TOOLTIP
                FROM SICAS_OC.DETALLE_POLIZA D
                LEFT JOIN SICAS_OC.COBERT_ACT CA
                    ON CA.IDPOLIZA = D.IDPOLIZA
                    AND CA.IDTIPOSEG = D.IDTIPOSEG
                    AND CA.PLANCOB = D.PLANCOB
                 LEFT JOIN SICAS_OC.COBERT_ACT_ASEG CAA
                    ON CAA.IDPOLIZA = D.IDPOLIZA
                    AND CAA.IDTIPOSEG = D.IDTIPOSEG
                    AND CAA.PLANCOB = D.PLANCOB
                INNER JOIN SICAS_OC.REQUISITOS_COBERTURAS A
                    ON A.IDTIPOSEG = D.IDTIPOSEG
                    AND A.PLANCOB = D.PLANCOB
                    AND (A.CODCOBERT = CA.CODCOBERT OR A.CODCOBERT = CAA.CODCOBERT)                    
                INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  B
                    ON B.IDTIPOSEG = A.IDTIPOSEG
                    AND B.PLANCOB = A.PLANCOB
                    AND B.CODCOBERT = A.CODCOBERT
                INNER JOIN SICAS_OC.REQUISITOS C
                    ON C.CODREQUISITO = A.CODREQUISITO
                WHERE D.IDPOLIZA = PA_IDPOLIZA -- 26052--PA_IDPOLIZA
                    AND (NVL(CA.COD_ASEGURADO,0) = vl_CodAseg  OR  NVL(CAA.COD_ASEGURADO,0) = vl_CodAseg )--2330189 --vl_CodAseg
                ORDER BY A.IDTIPOSEG,A.PLANCOB,A.CODCOBERT,A.CODREQUISITO);

    CURSOR Q_TODOS IS 
        SELECT  XMLELEMENT("DOCUMENTO", XMLATTRIBUTES(IDTIPOSEG AS "IDTIPOSEG", PLANCOB AS "PLANCOB", CODCOBERT AS "CODCOBERT", DESCCOBERT AS "DESCCOBERT", CODREQUISITO AS "CODREQUISITO", NOMARCHIVO AS "NOMARCHIVO", DESCREQUISITO AS "DESCREQUISITO", 
                        REQUERIDO AS "REQUERIDO", ORDENEXPEDIENTE AS "ORDEN_EXPEDIENTE", ORDENPDF AS "ORDEN_PDF", CANTIDAD AS "CANTIDAD", TAMANIOBYTES AS "TAMANIO_BYTES", FORMATOS AS "FORMATOS", CLAVEOCR AS "PALABRAS_CLAVE_OCR", TOOLTIP AS "TOOLTIP")
                ) DOCUMENTO
        FROM (
            SELECT  DISTINCT A.IDTIPOSEG, 
                        A.PLANCOB,
                        A.CODCOBERT,
                        B.DESCCOBERT,
                        A.CODREQUISITO,
                        NVL(C.NOMARCHIVO,'') NOMARCHIVO,
                        C.DESCREQUISITO ,
                        (CASE A.REQUERIDO WHEN 'S' THEN 'TRUE' ELSE 'FALSE' END) REQUERIDO,
                        A.ORDENEXPEDIENTE,
                        A.ORDENPDF,
                        A.CANTIDAD,
                        C.TAMANIOBYTES,
                        NVL(C.FORMATOS,'') FORMATOS,
                        NVL(C.CLAVEOCR,'') CLAVEOCR,
                        NVL(C.TOOLTIP,'') TOOLTIP
                FROM SICAS_OC.REQUISITOS_COBERTURAS A
                INNER JOIN SICAS_OC.DETALLE_POLIZA D
                    ON D.IDTIPOSEG = A.IDTIPOSEG
                    AND D.PLANCOB = A.PLANCOB
                INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  B
                    ON B.IDTIPOSEG = A.IDTIPOSEG
                    AND B.PLANCOB = A.PLANCOB
                    AND B.CODCOBERT = A.CODCOBERT
                INNER JOIN SICAS_OC.REQUISITOS C
                    ON C.CODREQUISITO = A.CODREQUISITO
                WHERE D.IDPOLIZA = PA_IDPOLIZA --35868
                    AND A.CODCOBERT = NVL(vl_CodCobert,A.CODCOBERT)
                    AND NVL(C.NOMARCHIVO,'') = NVL(PA_IDREQUISITO,NVL(C.NOMARCHIVO,''))
                ORDER BY A.IDTIPOSEG,A.PLANCOB,A.CODCOBERT,A.CODREQUISITO
        );
    
    CURSOR Q_TODOS2 IS 
        SELECT  XMLELEMENT("DOCUMENTO", XMLATTRIBUTES(IDTIPOSEG AS "IDTIPOSEG", PLANCOB AS "PLANCOB", CODCOBERT AS "CODCOBERT", DESCCOBERT AS "DESCCOBERT", CODREQUISITO AS "CODREQUISITO", NOMARCHIVO AS "NOMARCHIVO", DESCREQUISITO AS "DESCREQUISITO", 
                        REQUERIDO AS "REQUERIDO", ORDENEXPEDIENTE AS "ORDEN_EXPEDIENTE", ORDENPDF AS "ORDEN_PDF", CANTIDAD AS "CANTIDAD", TAMANIOBYTES AS "TAMANIO_BYTES", FORMATOS AS "FORMATOS", CLAVEOCR AS "PALABRAS_CLAVE_OCR", TOOLTIP AS "TOOLTIP")
                ) DOCUMENTO
        FROM (
            SELECT  DISTINCT A.IDTIPOSEG, 
                        A.PLANCOB,
                        A.CODCOBERT,
                        B.DESCCOBERT,
                        A.CODREQUISITO,
                        NVL(C.NOMARCHIVO,'') NOMARCHIVO,
                        C.DESCREQUISITO ,
                        (CASE A.REQUERIDO WHEN 'S' THEN 'TRUE' ELSE 'FALSE' END) REQUERIDO,
                        A.ORDENEXPEDIENTE,
                        A.ORDENPDF,
                        A.CANTIDAD,
                        C.TAMANIOBYTES,
                        NVL(C.FORMATOS,'') FORMATOS,
                        NVL(C.CLAVEOCR,'') CLAVEOCR,
                        NVL(C.TOOLTIP,'') TOOLTIP
                FROM SICAS_OC.REQUISITOS_COBERTURAS A
                INNER JOIN SICAS_OC.DETALLE_POLIZA D
                    ON D.IDTIPOSEG = A.IDTIPOSEG
                    AND D.PLANCOB = A.PLANCOB
                INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  B
                    ON B.IDTIPOSEG = A.IDTIPOSEG
                    AND B.PLANCOB = A.PLANCOB
                    AND B.CODCOBERT = A.CODCOBERT
                INNER JOIN SICAS_OC.REQUISITOS C
                    ON C.CODREQUISITO = A.CODREQUISITO
                WHERE D.IDPOLIZA = PA_IDPOLIZA --35868
                ORDER BY A.IDTIPOSEG,A.PLANCOB,A.CODCOBERT,A.CODREQUISITO
        );
        
    R_FORMA             Q_FORMA%ROWTYPE;
    R_TODOS             Q_TODOS%ROWTYPE;
    R_TODOS2            Q_TODOS2%ROWTYPE;
    R_ASEGURADO         Q_CODASEG%ROWTYPE;
    cHeader             VARCHAR2(4000);
    FORMAS              CLOB;
    OPCION              VARCHAR2(4000);
    vl_ApPat            VARCHAR2(4000)  := ' ';
    vl_ApMat            VARCHAR2(4000)  := ' ';
    vl_Nombre           VARCHAR2(4000)  := ' ';
    vl_NombreCompleto   VARCHAR2(4000)  := ' ';

    vl_Zip              NUMBER  :=  0;
    BEGIN  
        cHeader := 'DOCUMENTOS';

        IF (PA_IDPOLIZA IS NOT NULL OR PA_IDPOLIZA <> 0) --AND (PA_CODASEGURADO IS NOT NULL OR PA_CODASEGURADO <> 0) 
            AND (PA_NOMBRE IS NOT NULL) THEN 
            
            BEGIN
                
                BEGIN
                    SELECT DISTINCT A.COD_ASEGURADO
                    INTO vl_CodAseg
                    FROM SICAS_OC.PERSONA_NATURAL_JURIDICA J
                    INNER JOIN SICAS_OC.ASEGURADO A
                        ON A.TIPO_DOC_IDENTIFICACION = J.TIPO_DOC_IDENTIFICACION
                        AND A.NUM_DOC_IDENTIFICACION = J.NUM_DOC_IDENTIFICACION
                    INNER JOIN SICAS_OC.COBERT_ACT_ASEG AC
                        ON AC.COD_ASEGURADO = A.COD_ASEGURADO
                        AND AC.IDPOLIZA = PA_IDPOLIZA
                    WHERE REPLACE(TRANSLATE(UPPER(J.NOMBRE),'¡…Õ”⁄', 'AEIOU'),' ','') = REPLACE(TRANSLATE(UPPER(PA_NOMBRE),'¡…Õ”⁄', 'AEIOU'),' ','')
                        AND REPLACE(TRANSLATE(UPPER(NVL(J.APELLIDO_PATERNO,' ')),'¡…Õ”⁄', 'AEIOU'),' ','') = REPLACE(TRANSLATE(UPPER(NVL(PA_APPATERNO,' ')),'¡…Õ”⁄', 'AEIOU'),' ','')
                        AND REPLACE(TRANSLATE(UPPER(NVL(J.APELLIDO_MATERNO,' ')),'¡…Õ”⁄', 'AEIOU'),' ','') = REPLACE(TRANSLATE(UPPER(NVL(PA_APMATERNO,' ')),'¡…Õ”⁄', 'AEIOU'),' ','')
                        AND ROWNUM <=1;
                EXCEPTION
                    WHEN OTHERS THEN
                        BEGIN
                            SELECT DISTINCT A.COD_ASEGURADO
                            INTO vl_CodAseg
                            FROM SICAS_OC.PERSONA_NATURAL_JURIDICA J
                            INNER JOIN SICAS_OC.ASEGURADO A
                                ON A.TIPO_DOC_IDENTIFICACION = J.TIPO_DOC_IDENTIFICACION
                                AND A.NUM_DOC_IDENTIFICACION = J.NUM_DOC_IDENTIFICACION
                            INNER JOIN SICAS_OC.COBERT_ACT AC
                                ON AC.COD_ASEGURADO = A.COD_ASEGURADO
                                AND AC.IDPOLIZA = PA_IDPOLIZA
                            WHERE REPLACE(TRANSLATE(UPPER(J.NOMBRE),'¡…Õ”⁄', 'AEIOU'),' ','') = REPLACE(TRANSLATE(UPPER(PA_NOMBRE),'¡…Õ”⁄', 'AEIOU'),' ','')
                                AND REPLACE(TRANSLATE(UPPER(NVL(J.APELLIDO_PATERNO,' ')),'¡…Õ”⁄', 'AEIOU'),' ','') = REPLACE(TRANSLATE(UPPER(NVL(PA_APPATERNO,' ')),'¡…Õ”⁄', 'AEIOU'),' ','')
                                AND REPLACE(TRANSLATE(UPPER(NVL(J.APELLIDO_MATERNO,' ')),'¡…Õ”⁄', 'AEIOU'),' ','') = REPLACE(TRANSLATE(UPPER(NVL(PA_APMATERNO,' ')),'¡…Õ”⁄', 'AEIOU'),' ','')
                                AND ROWNUM <=1;
                        EXCEPTION
                            WHEN OTHERS THEN
                                vl_CodAseg := 0;
                        END;
                        
                END;
                
        IF vl_CodAseg <> 0 THEN
                    SELECT J.NOMBRE,NVL(J.APELLIDO_PATERNO,' '),NVL(J.APELLIDO_MATERNO,' '),NVL(J.CODPOSRES,' ')--,NVL(AC.IDTIPOSEG,ACC.IDTIPOSEG) IDTIPOSEG,NVL(AC.PLANCOB,ACC.PLANCOB) PLANCOB
                    INTO vl_Nombre,vl_ApPat,vl_ApMat,vl_Zip--,vl_IdTipoSeg,vl_PlanCob
                    FROM SICAS_OC.PERSONA_NATURAL_JURIDICA J
                    INNER JOIN SICAS_OC.ASEGURADO A
                        ON A.TIPO_DOC_IDENTIFICACION = J.TIPO_DOC_IDENTIFICACION
                        AND A.NUM_DOC_IDENTIFICACION = J.NUM_DOC_IDENTIFICACION
                    WHERE COD_ASEGURADO = vl_CodAseg
                        AND ROWNUM <=1;
    
                    SELECT IDTIPOSEG,PLANCOB 
                    INTO vl_IdTipoSeg,vl_PlanCob
                    FROM SICAS_OC.DETALLE_POLIZA 
                    WHERE IDPOLIZA = PA_IDPOLIZA
                        AND IDETPOL = 1 
                        AND ROWNUM <= 1;
    
                    vl_CodCobert := PA_CODCOBERT;
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    vl_IdTipoSeg := NULL;
                    vl_CodAseg := NULL;
                    FORMAS := NULL;
            END;
        ELSIF (PA_CODASEGURADO IS NOT NULL AND PA_CODASEGURADO <> 0) AND (PA_IDPOLIZA IS NOT NULL OR PA_IDPOLIZA <> 0) THEN

            BEGIN
                /*CONSULTA DATOS SIN TODOS LOS INNERS*/
                SELECT J.NOMBRE,NVL(J.APELLIDO_PATERNO,' '),NVL(J.APELLIDO_MATERNO,' '),J.CODPOSRES
                INTO vl_Nombre,vl_ApPat,vl_ApMat,vl_Zip
                FROM SICAS_OC.PERSONA_NATURAL_JURIDICA J
                INNER JOIN SICAS_OC.ASEGURADO A
                    ON A.TIPO_DOC_IDENTIFICACION = J.TIPO_DOC_IDENTIFICACION
                    AND A.NUM_DOC_IDENTIFICACION = J.NUM_DOC_IDENTIFICACION
                WHERE A.COD_ASEGURADO = PA_CODASEGURADO
                    AND ROWNUM <=1;

                SELECT NVL(AC.COD_ASEGURADO,D.COD_ASEGURADO) COD_ASEGURADO,D.IDTIPOSEG,D.PLANCOB
                INTO vl_CodAseg,vl_IdTipoSeg,vl_PlanCob
                FROM SICAS_OC.DETALLE_POLIZA D
                LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO AC
                    ON AC.IDPOLIZA = D.IDPOLIZA
                    AND AC.IDETPOL = D.IDETPOL
                WHERE D.IDPOLIZA = PA_IDPOLIZA
                    AND AC.COD_ASEGURADO = PA_CODASEGURADO
                    AND ROWNUM <=1;

                vl_CodCobert := PA_CODCOBERT;
            EXCEPTION
                WHEN OTHERS THEN
                    vl_IdTipoSeg := NULL;
                    vl_PlanCob := NULL;
                    vl_CodAseg := 0;
                    FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO></ASEGURADO>;<'|| cHeader || '>';
                    FORMAS := FORMAS || '<DOCUMENTO></DOCUMENTO>';
                    FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
            END;
            
        ELSE
            vl_PlanCob := NULL;
            vl_IdTipoSeg := NULL;
            vl_CodAseg := 0;
            FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO></ASEGURADO><'|| cHeader || '>';
            FORMAS := FORMAS || '<DOCUMENTO></DOCUMENTO>';
            FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
        END IF;
        
        IF vl_CodAseg = 0 OR vl_CodAseg IS NULL THEN
            vl_CodCobert := PA_CODCOBERT;
            vl_Zip := 0;

            OPEN Q_TODOS2;
                LOOP
                    FETCH Q_TODOS2 INTO R_TODOS2;  
                    EXIT WHEN Q_TODOS2%NOTFOUND;
                        IF FORMAS IS NULL THEN
                           FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><ASEGURADO COD_ASEG="0" NOMBRE="'||PA_NOMBRE||'" APPATERNO="'||PA_APPATERNO||'" APMATERNO="'||PA_APMATERNO||'" CODPOST=" "></ASEGURADO><'|| cHeader || '>';
                        END IF;

                        FORMAS :=  FORMAS || R_TODOS2.DOCUMENTO.getclobval();

            END LOOP;              
            CLOSE Q_TODOS2;  

            IF FORMAS IS NULL THEN --CURSOR VACIO, NO TIENE REQUISITOS ASIGNADOS EN EL CATALOGO
                FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO></ASEGURADO><'|| cHeader || '>';
                FORMAS := FORMAS || '<DOCUMENTO></DOCUMENTO>';
                FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
            ELSE
                FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
            END IF;

        ELSIF vl_Nombre IS NOT NULL OR vl_Nombre <> ' ' THEN

            /*SELECT J.NOMBRE,J.APELLIDO_PATERNO,J.APELLIDO_MATERNO,J.CODPOSRES,NVL(AC.COD_ASEGURADO,D.COD_ASEGURADO) COD_ASEGURADO,D.IDTIPOSEG,D.PLANCOB
                INTO vl_Nombre,vl_ApPat,vl_ApMat,vl_Zip,vl_CodAseg,vl_IdTipoSeg,vl_PlanCob
                FROM SICAS_OC.PERSONA_NATURAL_JURIDICA J
                INNER JOIN SICAS_OC.ASEGURADO A
                    ON A.TIPO_DOC_IDENTIFICACION = J.TIPO_DOC_IDENTIFICACION
                    AND A.NUM_DOC_IDENTIFICACION = J.NUM_DOC_IDENTIFICACION
                LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO AC
                    ON AC.COD_ASEGURADO = A.COD_ASEGURADO
                INNER JOIN SICAS_OC.DETALLE_POLIZA D
                    ON AC.IDPOLIZA = D.IDPOLIZA
                    AND AC.IDETPOL = D.IDETPOL
                WHERE REPLACE(TRANSLATE(UPPER(NOMBRE),'·ÈÌÛ˙¡…Õ”⁄', 'aeiouAEIOU'),'  ',' ') = REPLACE(TRANSLATE(UPPER(PA_NOMBRE),'·ÈÌÛ˙¡…Õ”⁄', 'aeiouAEIOU'),'  ',' ')
                    AND REPLACE(TRANSLATE(UPPER(APELLIDO_PATERNO),'·ÈÌÛ˙¡…Õ”⁄', 'aeiouAEIOU'),'  ','') = REPLACE(TRANSLATE(UPPER(PA_APPATERNO),'·ÈÌÛ˙¡…Õ”⁄', 'aeiouAEIOU'),'  ','')
                    AND REPLACE(TRANSLATE(UPPER(APELLIDO_MATERNO),'·ÈÌÛ˙¡…Õ”⁄', 'aeiouAEIOU'),'  ','') = REPLACE(TRANSLATE(UPPER(PA_APMATERNO),'·ÈÌÛ˙¡…Õ”⁄', 'aeiouAEIOU'),'  ','')
                    AND D.IDPOLIZA = PA_IDPOLIZA
                    AND ROWNUM <=1;
*/
                OPEN Q_CODASEG;
                LOOP
                    FETCH Q_CODASEG INTO   R_ASEGURADO;  
                    EXIT WHEN Q_CODASEG%NOTFOUND;

                        IF FORMAS IS NULL THEN
                           FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO COD_ASEG="'||vl_CodAseg||'" NOMBRE="'||vl_Nombre||'" APPATERNO="'||vl_ApPat||'" APMATERNO="'||vl_ApMat||'" CODPOST="'||vl_Zip||'"></ASEGURADO><'|| cHeader || '>';
                        END IF;

                        FORMAS :=  FORMAS || R_ASEGURADO.DOCUMENTO.getclobval();
                END LOOP;              
                CLOSE Q_CODASEG;  

                IF FORMAS IS NULL THEN --CURSOR VACIO, se retornan todas lascoberturas y requisitos que puede tener una poliza

                    FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO></ASEGURADO><'|| cHeader || '>';
                    FORMAS := FORMAS || '<DOCUMENTO></DOCUMENTO>';
                    FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
                ELSE
                    FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
                END IF;

        ELSIF vl_IdTipoSeg IS NULL OR vl_IdTipoSeg = '' AND vl_PlanCob IS NULL AND vl_PlanCob = '' THEN 
            OPEN Q_FORMA;
            LOOP
                FETCH Q_FORMA INTO   R_FORMA;  
                EXIT WHEN Q_FORMA%NOTFOUND;
                    IF FORMAS IS NULL THEN
                       FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO COD_ASEG="'||vl_CodAseg||'" NOMBRE="'||vl_Nombre||'" APPATERNO="'||vl_ApPat||'" APMATERNO="'||vl_ApMat||'" CODPOST="'||vl_Zip||'"></ASEGURADO><'|| cHeader || '>';
                    END IF;

                    FORMAS :=  FORMAS || R_FORMA.DOCUMENTO.getclobval();
            END LOOP;              
            CLOSE Q_FORMA;  

            IF FORMAS IS NULL THEN --CURSOR VACIO, se retornan todas lascoberturas y requisitos que puede tener una poliza
                FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO></ASEGURADO><'|| cHeader || '>';
                FORMAS := FORMAS || '<DOCUMENTO></DOCUMENTO>';
                FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
            ELSE
                FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
            END IF;

        ELSIF (vl_IdTipoSeg IS NULL AND vl_PlanCob IS NULL) THEN   --EL CURSOR ESTA VACIO, NO SE ENCONTRO EL ASEGURADO, SE RETORNAN TODAS LAS COBERTURAS Q PUEDA TENER LA POLIZA
            vl_CodCobert := PA_CODCOBERT;

            OPEN Q_TODOS;
                LOOP
                    FETCH Q_TODOS INTO R_TODOS;  
                    EXIT WHEN Q_TODOS%NOTFOUND;
                        IF FORMAS IS NULL THEN
                           FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><ASEGURADO COD_ASEG="0" NOMBRE=" " APPATERNO=" " APMATERNO=" " CODPOST=" "></ASEGURADO><'|| cHeader || '>';
                        END IF;

                        FORMAS :=  FORMAS || R_TODOS.DOCUMENTO.getclobval();
            END LOOP;              
            CLOSE Q_TODOS;  

            IF FORMAS IS NULL THEN --CURSOR VACIO, NO TIENE REQUISITOS ASIGNADOS EN EL CATALOGO
                FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO></ASEGURADO><'|| cHeader || '>';
                FORMAS := FORMAS || '<DOCUMENTO></DOCUMENTO>';
                FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
            ELSE
                FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
            END IF;

        END IF;

        RETURN  FORMAS;  

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EXC: '||SQLERRM);
            --FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><DATA><ASEGURADO></ASEGURADO><'|| cHeader || '>';
            --FORMAS := FORMAS || '<DOCUMENTO></DOCUMENTO>';
            --FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';

            RETURN  FORMAS; 
    END REQUISITOS_COBERT;
    
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
        val           long ; --VARCHAR2(32767);
        cName         VARCHAR2(30);
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
                 IF cDICCION.COLUMN_NAME NOT IN ('DESCELEGIBILIDAD','DESCRIESGOSCUBIERTOS') THEN
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
                            ---DBMS_OUTPUT.PUT_LINE('SALIDA LOCSALIDA 1: ' ||  locSalida);
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
    --EXCEPTION WHEN OTHERS THEN
         --DBMS_OUTPUT.PUT_LINE(cSqlText || '-' || SQLERRM);
         --DBMS_OUTPUT.PUT_LINE('curs: ' || curs); 
        --NULL;        
    END DIGITAL_PLANTILLA;
    --
    FUNCTION DIGITAL_GENERAWHERE(pCOLUMN_NAME VARCHAR2, pPK VARCHAR2, pSqlWhere VARCHAR2) return VARCHAR2 is
        SqlWhere VARCHAR2(32767);
        linea VARCHAR2(100);
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
FUNCTION DIGITAL_CATALOGO_PRODUCT RETURN CLOB IS
CURSOR Q_CATA IS
   SELECT XMLELEMENT("PRODUCTOS", 
              XMLELEMENT("CodCotizador",      G.CodCotizador), 
              XMLELEMENT("DescCotizador",     G.DescCotizador), 
              XMLELEMENT("IdCotizacion",      C.IdCotizacion), 
              XMLELEMENT("NombreContratante", C.NombreContratante)) AS DATAXML
     FROM COTIZADOR_CONFIG G INNER JOIN COTIZACIONES C ON C.CodCia          = G.CodCia 
                                                       AND C.CodEmpresa     = G.CodEmpresa 
                                                       AND C.CodCotizador   = G.CodCotizador  
                             INNER JOIN TIPOS_DE_SEGUROS T ON T.CodCia      = C.CodCia
                                                           AND T.CodEmpresa = C.CodEmpresa
                                                           AND T.IdTipoSeg  = C.IdTipoSeg
    WHERE G.CodCia             =  1
      AND G.CodEmpresa         =  1
      AND TRUNC(SYSDATE) BETWEEN G.FecIniCotizador AND G.FecFinCotizador 
      AND GT_COTIZACIONES.COTIZACION_BASE_WEB(C.CodCia, C.CodEmpresa, C.IdCotizacion ) = 'S'  
      AND T.StsTipSeg          = 'ACT'
    ORDER BY G.CodCotizador, C.IdCotizacion; 

R_cAta Q_CATA%ROWTYPE;
cAta CLOB;
BEGIN
   cAta := '<?xml version="1.0" encoding="UTF-8" ?><CATALOGO>';
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
      FETCH Q_CATA INTO R_cAta;
      EXIT WHEN Q_CATA%NOTFOUND;
      --
      cAta := cAta || R_cAta.DATAXML.getclobval();
      --
   END LOOP;
   --    
   CLOSE Q_CATA;
   cAta :=  cAta || '</CATALOGO>';
   RETURN  cAta;           
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
            IF ES_ATRIB THEN
                XGENTAG := NOMTAG || '="' || VALOR || ' ';
            ELSE
                XGENTAG := '<' ||NOMTAG ||'>' || VALOR || '</' ||NOMTAG ||'>';
            END IF;
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

               -- DBMS_OUTPUT.PUT_LINE(P_IDTIPOSEG);
               -- DBMS_OUTPUT.PUT_LINE(P_PLANCOB);

            --
            OPEN Q_NUMREG (P_IDTIPOSEG, P_PLANCOB);
                FETCH Q_NUMREG INTO R_NUMREG;
                --DBMS_OUTPUT.PUT_LINE(R_NUMREG.CODSUBGRUPO);
                wNumReg := TO_NUMBER(NVL(R_NUMREG.CODSUBGRUPO, 1));   
                --DBMS_OUTPUT.PUT_LINE(wNumReg);
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
                --DBMS_OUTPUT.PUT_LINE(R_NUMREG.CODSUBGRUPO);
                wNumReg := TO_NUMBER(NVL(R_NUMREG.CODSUBGRUPO, 1));   
                --DBMS_OUTPUT.PUT_LINE(wNumReg);
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
   FUNCTION PRE_EMITE_POLIZA_NEW( nCodCia            NUMBER
                                , nCodEmpresa        NUMBER
                                , nIdCotizacion      NUMBER
                                , cCadena            VARCHAR2
                                , cIdPoliza          NUMBER := NULL ) RETURN CLOB IS
   --                             , xInformacionFiscal XMLTYPE ) RETURN CLOB IS
      --LUCERO MAYOR 
      --cCadena           VARCHAR2(4000) := 'C,RFC,PELC700807XXX,ZORRILLA,NOMCONTRATANTE,ROBERTO,,07/08/1970,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,BURGER PO KING,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N|A,RFC,,PEDRO,TIMBAK,LUPITA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,LUCERITO LUC PE√É‚ÄòON,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N|A,RFC,,GABRIELA,LOPEZ,DE SANTA ANA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,NOMB PAGA CUENTA,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N';
      --
      --Otros productos
      --cCadena            VARCHAR2(32727) := 'C,RFC,PELC700807XXX,ZORRILLA,NOMCONTRATANTE,ROBERTO,,07/08/1970,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,BURGER PO KING,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N|A,RFC,,PEDRO,TIMBAK,LUPITA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,LUCERITO LUC PE√É‚ÄòON,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N';
      --  
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
      cTipoRiesgo       VARCHAR2(6);
      cTipPersona       VARCHAR2(6);
      cCodMoneda        POLIZAS.Cod_Moneda%TYPE;
      wIdCotizacion     NUMBER := 0;
      wPorcComis1       NUMBER := 0;     
      wPorcComis2       NUMBER := 0;     
      wPorcComis3       NUMBER := 0;     
      wPorcComisTot     NUMBER := 0;
      wPorcComProp1     NUMBER := 0;
      wPorcComProp2     NUMBER := 0;
      wPorcComProp3     NUMBER := 0;
      wPorcComPropT     NUMBER := 0;
      nCodAgente        number :=0;
      nIdFormaCobro     MEDIOS_DE_COBRO.IdFormaCobro%TYPE;
      nGastosExpedicion COTIZACIONES.GastosExpedicion%TYPE;
      --
      cIdTipoSeg        COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob          COTIZACIONES.PlanCob%TYPE;
      --
      CURSOR Q_NUMREG IS
             SELECT CASE WHEN COUNT(COLUMN_VALUE)> 2 THEN 'N' ELSE 'N' END EsColectiva, COUNT(COLUMN_VALUE) NUMREG
             FROM TABLE(GT_WEB_SERVICES.SPLIT(cCadena, '|'));
      --
      R_NUMREG Q_NUMREG%ROWTYPE;
      --
      CURSOR Q_TRAN (PnIdePol NUMBER) IS
             SELECT D.IDTRANSACCION      
             FROM DETALLE_TRANSACCION D
             WHERE CodCia           = nCodCia
               AND CodEmpresa       = nCodEmpresa
               AND D.CODSUBPROCESO  = 'POL'
               AND D.OBJETO         = 'POLIZAS'
               AND D.VALOR1         = TRIM(TO_CHAR(PnIdePol));
      --
      R_TRAN Q_TRAN%ROWTYPE;          
      --
      CURSOR Q_DOMI (pCODPOSTAL VARCHAR2, pCODIGO_COLONIA VARCHAR2) IS
             SELECT DISTINCT PA.Codpais, M.CodEstado, D.CODCIUDAD, C.CODMUNICIPIO                       
             FROM SICAS_OC.APARTADO_POSTAL CP INNER JOIN SICAS_OC.CORREGIMIENTO M ON M.CODMUNICIPIO = CP.CODMUNICIPIO AND M.CODPAIS = CP.CODPAIS AND M.CODESTADO = CP.CODESTADO AND M.CODCIUDAD = CP.CODCIUDAD 
                                              INNER JOIN SICAS_OC.COLONIA       C ON C.CODPAIS = CP.CODPAIS AND C.CODESTADO = CP.CODESTADO AND C.CODCIUDAD = CP.CODCIUDAD AND C.CODMUNICIPIO = M.CODMUNICIPIO AND C.CODIGO_POSTAL = CP.CODIGO_POSTAL
                                              INNER JOIN SICAS_OC.PROVINCIA     P ON P.CODPAIS = CP.CODPAIS AND P.CODESTADO = CP.CODESTADO
                                              INNER JOIN DISTRITO               D ON D.CODPAIS = CP.CODPAIS AND D.CODESTADO = CP.CODESTADO AND D.CODCIUDAD = C.CODCIUDAD 
                                              INNER JOIN SICAS_OC.PAIS          PA ON PA.CODPAIS = CP.CODPAIS                                   
             WHERE CP.CODIGO_POSTAL      =    pCODPOSTAL
               AND C.CODIGO_COLONIA      =    pCODIGO_COLONIA;
      --
      R_DOMI Q_DOMI%ROWTYPE;          
      --
      CURSOR DETPOL_Q IS
             SELECT CodCia, CodEmpresa, IdPoliza, IDetPol, IdTipoSeg, PlanCob, Tasa_Cambio, FecIniVig, FecFinVig
             FROM   DETALLE_POLIZA
             WHERE  CodCia        = nCodCia
               AND  CodEmpresa    = nCodEmpresa
               AND  IdPoliza      = nIdPoliza
             ORDER BY IdPoliza;                           
BEGIN
   IF cIdPoliza IS NULL THEN
      IF SICAS_OC.GT_COTIZACIONES.EXISTE_COTIZACION_EMITIDA(NCODCIA, NCODEMPRESA, NIDCOTIZACION ) = 'N' THEN
        RETURN 'Esta cotizaci√É¬≥n no esta emitida: ' || NIDCOTIZACION;
      END IF;

      OPEN  Q_NUMREG;
      FETCH Q_NUMREG INTO R_NUMREG;      
      CLOSE Q_NUMREG;   

      BEGIN
         SELECT IdTipoSeg, PlanCob
           INTO cIdTipoSeg, cPlanCob
           FROM COTIZACIONES
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdCotizacion  = nIdCotizacion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'Error al determinar la cotizaci√É¬≥n '||nIdCotizacion);
      END;  
         --
      INSERT INTO API_LOG_EMISION (Descripcion, Fecha, Id_Cotizacion) VALUES(cCadena, SYSDATE, nIdCotizacion);
      FOR ENT IN (SELECT COLUMN_VALUE Fila FROM table(GT_WEB_SERVICES.SPLIT(cCadena, '|'))) LOOP
         IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,3,',') IS NOT NULL OR OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,3,',') != '' THEN
            CRFC := OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,3,',');
         ELSE
            CRFC := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(CAMBIA_ACENTOS(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,4,',')),
                                                                      CAMBIA_ACENTOS(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,5,',')),
                                                                      (OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,6,',')),
                                                                      TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,8,','), 'DD/MM/YYYY'),
                                                                      'FISICA');
         END IF;                                                                              
         cTipoDocIdentAseg := OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,2,',');
         cNumDocIdentAseg  := CRFC;                                
        --
         IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'C' AND nIdPoliza IS NULL  THEN  
            nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
         END IF;

         BEGIN
            OPEN  Q_DOMI(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,18,','), OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,16,','));                    
            FETCH Q_DOMI INTO R_DOMI;      
            CLOSE Q_DOMI;   

            cCodPaisRes := R_DOMI.CodPais; 
            cCodProvRes := R_DOMI.CodEstado;   
            cCodDistRes := R_DOMI.CodCiudad;
            cCodCorrRes := R_DOMI.CodMunicipio;
         EXCEPTION WHEN OTHERS THEN
            NULL;
         END;

         IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,2,','), CRFC) = 'N' THEN
            OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,2,','),   --cTipo_Doc_Identificacion
                                                         CRFC,                                              --cNum_Doc_Identificacion
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,4,','),   --cNombre
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,5,','),   --cApellidoPat
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,6,','),   --cApellidoMat
                                                         NULL,                                              --cApeCasada
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,7,','),   --cSexo
                                                         NULL,                                              --cEstadoCivil
                                                         TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,8,','), 'DD/MM/YYYY'),   --dFecNacimiento
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,13,','),  --cDirecRes
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,14,','),  --cNumInterior
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,15,','),  --cNumExterior
                                                         cCodPaisRes,                                       --cCodPaisRes
                                                         cCodProvRes,  --OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,16,','),  --cCodProvRes
                                                         cCodDistRes,                                       --cCodDistRes       
                                                         cCodCorrRes,                                       --cCodCorrRes
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,18,','),  --cCodPosRes
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,16,','),  --cCodColonia
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,20,','),  --cTelRes
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,21,','),  --cEmail
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,19,',')); --cLadaTelRes
            IF LENGTH(CRFC) = 13 THEN
               cTipPersona := 'FISICA';
            ELSE
               cTipPersona := 'MORAL';
            END IF;                                                                     

            UPDATE PERSONA_NATURAL_JURIDICA J SET J.Tipo_Persona        = cTipPersona,
                                                  J.Tipo_Id_Tributaria  = 'RFC',
                                                  J.Num_Tributario      = NVL(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,10,','), 'XAXX010101000'),
                                                  J.Nacionalidad        = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,22,',')
             WHERE  J.Tipo_Doc_Identificacion   = 'RFC'
               AND  J.Num_Doc_Identificacion    = CRFC;
         ELSE 
            UPDATE PERSONA_NATURAL_JURIDICA
               SET CodPaisRes      = cCodPaisRes,
                   CodProvRes      = cCodProvRes,
                   CodDistRes      = cCodDistRes,
                   CodCorrRes      = cCodCorrRes,
                   CodPosRes       = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,18,','),
                   ZipRes          = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,18,','),
                   CodColRes       = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,16,','),
                   DirecRes        = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,13,','),  --cDirecRes
                   NumInterior     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,14,','),  --cNumInterior
                   NumExterior     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,15,','),  --cNumExterior
                   Nacionalidad    = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,22,','),  -- Nacionalidad
                   Num_Tributario  = NVL(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,10,','), 'XAXX010101000')
             WHERE Tipo_Doc_Identificacion   = cTipoDocIdentAseg
               AND Num_Doc_Identificacion    = cNumDocIdentAseg;
         END IF;
        --
         IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'C' AND nIdePol = 1 AND nIdPoliza IS NULL AND OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,23,',') IS NOT NULL THEN
            BEGIN
               SELECT NVL(MAX(IdFormaCobro),0)
                 INTO nIdFormaCobro
                 FROM MEDIOS_DE_COBRO
                WHERE Tipo_Doc_Identificacion  = cTipoDocIdentAseg
                  AND Num_Doc_Identificacion   = cNumDocIdentAseg;
            END;

            IF nIdFormaCobro = 0 THEN 
               nIdFormaCobro := 1;
            ELSE
               nIdFormaCobro := nIdFormaCobro + 1;
            END IF;

            OC_MEDIOS_DE_COBRO.INSERTAR(cTipoDocIdentAseg, cNumDocIdentAseg, nIdFormaCobro, 'S', 'CTC');
            UPDATE MEDIOS_DE_COBRO MD SET MD.CodFormaCobro     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,23,','),
                                          MD.CodEntidadFinan   = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,24,','),
                                          MD.NumCuentaBancaria = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,25,','),
                                          MD.NumCuentaClabe    = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,26,','),
                                          MD.NumTarjeta        = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,27,','),
                                          MD.FechaVencTarjeta  = TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,28,','), 'DD/MM/YYYY'),
                                          MD.NombreTitular     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,29,',')
             WHERE MD.Tipo_Doc_Identificacion   = cTipoDocIdentAseg
               AND MD.Num_Doc_Identificacion    = cNumDocIdentAseg
               AND MD.IdFormaCobro              = nIdFormaCobro;
         END IF;
        --
         IF nIdPoliza IS NULL and OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'C'  THEN
            --
            IF NVL(nCodCliente, 0) = 0 THEN
               nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
               UPDATE CLIENTES CTE  
                  SET TipoCliente = 'BAJO'
                WHERE CTE.CodCliente = nCodCliente;
            END IF;      
         ELSE 
            IF nIdPoliza IS NULL AND OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'A'  THEN                        
               nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
               IF nCod_Asegurado = 0 THEN
                  nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
               END IF;                                      
             --                 
             nIdPoliza := gt_cotizaciones.CREAR_POLIZA(nCodCia,nCodEmpresa, nIdCotizacion, nCodCliente, nCod_Asegurado);
             --   
             --DBMS_OUTPUT.PUT_LINE(nIdPoliza);

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
                     SELECT P.COD_MONEDA, P.COD_AGENTE
                       INTO cCodMoneda, nCodAgente
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
            ----------- SE COMENTA 26/11/2019 NO LO REQUIEREN
            --                               BEGIN
            --                                     SELECT CODVALOR
            --                                       INTO cCodValor
            --                                       FROM VALORES_DE_LISTAS
            --                                       WHERE CODLISTA = 'AGRUPA'
            --                                         AND DESCVALLST = 'PLATAFORMA DIGITAL THONAPI'; 
            --                               EXCEPTION WHEN NO_DATA_FOUND THEN
            --                                     SELECT TRIM(TO_CHAR(TO_NUMBER(MAX(CODVALOR)) + 1, '0000'))
            --                                       INTO cCodValor
            --                                       FROM VALORES_DE_LISTAS
            --                                      WHERE CODLISTA = 'AGRUPA';
            --                                     INSERT INTO VALORES_DE_LISTAS VALUES ('AGRUPA', cCodValor, 'PLATAFORMA DIGITAL THONAPI');
            --                               END;
                   cCodValor := NULL;

                      BEGIN
                        SELECT codvalor
                          INTO cTipoRiesgo
                          FROM valores_de_listas 
                         WHERE codlista = 'TIPRIESG'
                           AND DESCVALLST IN (SELECT distinct 'RIESGO ' || RIESGOTARIFA 
                                                FROM COTIZACIONES_DETALLE d 
                                               WHERE  D.CODCIA = nCodCia 
                                                 AND D.CODEMPRESA = nCodEmpresa 
                                                 AND D.IDCOTIZACION IN (nIdCotizacion));                                  
                      EXCEPTION WHEN OTHERS THEN
                            cTipoRiesgo := null;
                      END;

                 --------------------------------- Comisiones esta dividido en dos etapas, una esta la creacion de la poliza y otra al emitir la poliza
                   IF NVL(nIdCotizacion, 0) <> 0 THEN     
                       IF OC_AGENTES.ES_AGENTE_DIRECTO(nCodCia, nCodAgente) = 'S' THEN
                          wPorcComis1     := 0;
                          wPorcComis2     := 0;
                          wPorcComis3     := 0;
                       ELSE                                                                                                          
                       --Copia Comisiones por nivel a la nueva poliza
                          SELECT C.PorcComisDir,
                                 c.PorcComisProm,
                                 c.PorcComisAgte                                                       
                            INTO wPorcComis1, wPorcComis2, wPorcComis3
                            FROM COTIZACIONES C
                           WHERE C.CODCIA          =   nCodCia
                             AND C.CODEMPRESA      =   nCodEmpresa
                             AND C.IDCOTIZACION    =   nIdCotizacion;
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
                                -- DBMS_OUTPUT.PUT_LINE('wPorcComisTot '||wPorcComisTot);
                          END LOOP;
                       END IF;                                        
                   END IF;                                                      

                 --UPDATE POLIZAS P SET NUMPOLUNICO = cNUMPOLUNICO,

                 UPDATE POLIZAS P SET P.HORAVIGINI   = '12:00',
                                       P.HORAVIGFIN   = '12:00',
                                       P.TIPODIVIDENDO = '003',
                                       --P.IDFORMACOBRO = 1,
                                       P.CODAGRUPADOR = cCodValor,
                                       P.TIPORIESGO   = cTipoRiesgo,
                                       P.CODPLANPAGO = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,33,','),
                                       P.PORCCOMIS   = NVL(wPorcComisTot, 0),
                                       P.IdFormaCobro = nIdFormaCobro
                  WHERE P.CODCIA      = nCodCia
                    AND P.CODEMPRESA  = nCodEmpresa
                    AND P.IDPOLIZA    = nIdPoliza;

                 UPDATE DETALLE_POLIZA P SET P.CODPLANPAGO = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,33,','),
                                                 P.CODCATEGORIA = NULL
                  WHERE P.CODCIA      = nCodCia
                    AND P.CODEMPRESA  = nCodEmpresa
                    AND P.IDPOLIZA    = nIdPoliza;                               

                  EXCEPTION WHEN OTHERS THEN
                    NULL;
                  END;
                  --
                  IF R_NUMREG.EsColectiva = 'N' THEN
                     IF OC_COBERT_ACT.EXISTE_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIdePol) = 'N' THEN
                        GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.EsColectiva);
                     END IF;
                  ELSIF R_NUMREG.EsColectiva = 'S' THEN
                     IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIdePol, nCod_Asegurado) = 'N' THEN
                        GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.EsColectiva);
                     END IF;
                  END IF;                             
                  --GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia,nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.ESCOLECTIVA);
                  --       
            ELSIF nIdPoliza IS NOT NULL AND OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'A' THEN
                nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
                IF nCod_Asegurado = 0 THEN
                    nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
                END IF;     
                --      
                nIdePol := nIdePol + 1;
                IF R_NUMREG.EsColectiva = 'N' THEN
                     IF OC_COBERT_ACT.EXISTE_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIdePol) = 'N' THEN
                        GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.EsColectiva);
                     END IF;
                ELSIF R_NUMREG.EsColectiva = 'S' THEN
                     IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIdePol, nCod_Asegurado) = 'N' THEN
                        GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.EsColectiva);
                     END IF;
                END IF;    
                --GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia,nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.ESCOLECTIVA);
                UPDATE DETALLE_POLIZA D SET D.COD_ASEGURADO = nCod_Asegurado
                 WHERE D.CODCIA        =   nCodCia
                   AND D.CODEMPRESA    =   nCodEmpresa
                   AND D.IDPOLIZA      =   nIdPoliza
                   AND D.IDETPOL       = nIdePol;
            END IF;                    

         END IF;        
        --           
        numBenef := 0;            
        IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'A' THEN
            FOR N IN 1..10 LOOP
                numBenef := (6 * (N -1)); 
                IF LENGTH(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,41 + numBenef,',')) > 0 THEN
                    begin
                        dBenefFecNAc := to_date(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,42+numBenef,','), 'dd/mm/yyyy');
                    exception when others then null; end;
                    OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPoliza, nIdePol, nCod_Asegurado, 
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,40 + numBenef,','),
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,41 + numBenef,','), 
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,43 + numBenef,','), 
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,44 + numBenef,','), 'N', 
                                                                            dBenefFecNac, 
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,45 + numBenef,','));
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
           WCODNIVEL                NUMBER :=0;
           WPORPRO                  NUMBER :=0;
           WPORDIST                 NUMBER :=0;    
           nPorc_Com_Proporcional   NUMBER := 0;                
       BEGIN            
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

            IF OC_AGENTES.ES_AGENTE_DIRECTO(nCodCia, nCodAgente) != 'S' THEN
                IF wPorcComisTot = 0 THEN wPorcComisTot := 1; END IF;
                IF wPorcComis3 = 0 THEN wPorcComis3 := 1;     END IF;
            END IF;

            BEGIN
               SELECT TRUNC(ROUND((wPorcComis3 * 100) / wPorcComisTot, 2), 2)
                 INTO nPorc_Com_Proporcional
                 FROM DUAL;
            EXCEPTION 
               WHEN ZERO_DIVIDE THEN
                  nPorc_Com_Proporcional := 0;
            END;

            UPDATE AGENTES_DISTRIBUCION_POLIZA SET  Porc_Com_Distribuida   = wPorcComis3,
                                                    Porc_Com_Proporcional  = nPorc_Com_Proporcional, 
                                                    Porc_Com_Poliza        = wPorcComisTot
             WHERE IdPoliza = nIdPoliza
               AND CODNIVEL = 3
               AND CodCia   = nCodCia;
            IF SQL%ROWCOUNT > 0 THEN
               --wPorcComPropT := wPorcComPropT + TRUNC(ROUND((wPorcComis3 * 100) / wPorcComisTot, 2), 2); 
               wPorcComPropT := wPorcComPropT + nPorc_Com_Proporcional;
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
      SELECT NVL(GastosExpedicion,0)
        INTO nGastosExpedicion
        FROM COTIZACIONES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion;
   END;

   IF nGastosExpedicion = 0 THEN 
      UPDATE POLIZAS
         SET IndCalcDerechoEmis = 'N'
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza;
   END IF;

   BEGIN             -- SE COMENTA, POR EL MOMENTO TODAS LAS POLIZAS QEU VAN A PLD SOLO SE MARCAN PERO SI SE EMITEN                           
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
   --
   -------PRE EMISION
   OPEN Q_TRAN(nIdPoliza);
   FETCH Q_TRAN INTO R_TRAN;
   nIdTransaccion :=  TO_NUMBER(R_TRAN.IdTransaccion);     
   close Q_TRAN;                       
   OC_POLIZAS.PRE_EMITE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion);
   ----------------

   cFacturas := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA(nCodCia, nIdPoliza);       
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
        CURSOR Q_DETA (pIdFactura NUMBER) IS
            SELECT CONCEPTO,
                   DESCRIPCION,
                   MONTO_LOCAL,
                   MONTO_MONEDA                                     
            FROM (                              
            SELECT  DECODE(C.INDCPTOPRIMAS, 'S', 'PRIMNET', F.CODCPTO) CONCEPTO, 
                    DECODE(C.INDCPTOPRIMAS, 'S', 'PRIMA NETA', C.DESCRIPCONCEPTO) DESCRIPCION,
                    SUM(F.MONTO_DET_LOCAL) MONTO_LOCAL,
                    SUM(F.MONTO_DET_MONEDA) MONTO_MONEDA
              FROM DETALLE_FACTURAS F  INNER JOIN SICAS_OC.CATALOGO_DE_CONCEPTOS C ON C.CODCIA = nCodCia AND C.CODCONCEPTO = F.CODCPTO
             WHERE F.IDFACTURA = pIdFactura
            GROUP BY DECODE(C.INDCPTOPRIMAS, 'S', 'PRIMNET', F.CODCPTO),
                     DECODE(C.INDCPTOPRIMAS, 'S', 'PRIMA NETA', C.DESCRIPCONCEPTO))         
            ORDER BY DECODE(DESCRIPCION, 'PRIMA NETA', 1,  ROWNUM + 1);  
        R_DET Q_DETA%ROWTYPE;
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
        CDET CLOB;
        CELE CLOB;
        --
    BEGIN   
            CATA := '<?xml version="1.0" encoding="UTF-8" ?><FACTURAS>';
            OPEN Q_FAC;
            LOOP
                FETCH Q_FAC INTO   R_FAC;   
                EXIT WHEN Q_FAC%NOTFOUND;
                --
                CATA :=  CATA || R_FAC.DATOSXML.getclobval();
                --
                -- DETALLE FACTURA
                CDET :=  EMPTY_CLOB();
                CDET := CDET || CHR(10) || '<DETALLE>' || CHR(10);
                OPEN Q_DETA(R_FAC.IDFACTURA);
                LOOP                                
                    FETCH Q_DETA INTO R_DET;   
                    EXIT WHEN Q_DETA%NOTFOUND;

                    CDET := CDET || CHR(9) || '<' || R_DET.CONCEPTO  || ' ' || 
                                      --'CODCPTO="'       || R_DET.CONCEPTO       ||'" ' ||
                                      'DESCRIPCION="'   || R_DET.DESCRIPCION    ||'" ' ||
                                      'MONTO_LOCAL="'   || R_DET.MONTO_LOCAL    ||'" ' ||
                                      'MONTO_MONEDA="'  || R_DET.MONTO_MONEDA   || '">';
                    CDET := CDET || '</' || R_DET.CONCEPTO  ||'>' || CHR(10) ; 

                    --CDET := CDET ||R_DET.DATOSXML.getclobval();                    
                END LOOP;                
                CDET := CDET || '</DETALLE>' || CHR(10);
                CLOSE Q_DETA;
                --CATA :=  REPLACE(CATA, '"></FACTURA>', '">' || CDET || '</FACTURA>');
                --
                --    CFDI            
                CELE :=  EMPTY_CLOB();                                
                OPEN Q_ELEC (nCodCia, R_FAC.CODEMPRESA, R_FAC.IDFACTURA);
                LOOP                                
                    FETCH Q_ELEC INTO R_ELEC;   
                    EXIT WHEN Q_ELEC%NOTFOUND;
                    CELE := CELE ||R_ELEC.DATOSXML.getclobval();                    
                END LOOP;                
                CLOSE Q_ELEC;
                CATA :=  REPLACE(CATA, '"></FACTURA>', '">' || CDET || CELE || '</FACTURA>');
            END LOOP;               
            CLOSE Q_FAC;   

            CATA :=  CATA || '</FACTURAS>';
            RETURN(CATA);
            --DBMS_OUTPUT.PUT_LINE(CATA);              
    END CONSULTA_FACTURA;
    --
FUNCTION PAGO_FACTURA (nIdPoliza NUMBER, nIdFactura NUMBER, cCodFormaPago VARCHAR2) RETURN BOOLEAN IS 
nCobrar                 NUMBER(1);
nIdTransac              TRANSACCION.IdTransaccion%TYPE;
nIdTransaccion          TRANSACCION.IdTransaccion%TYPE;
nCodAsegurado           DETALLE_POLIZA.Cod_Asegurado%TYPE;
nIdFondo                FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nPrimaNivelada          FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
nAporteFondo            DETALLE_POLIZA.MontoAporteFondo%TYPE;
cEstatus                VARCHAR2(10);
--nCodCia        NUMBER := 1;
nIdOpenPay              NUMBER := 0;
cStsPoliza              SICAS_OC.POLIZAS.StsPoliza%TYPE;       
cCodCFDI                VARCHAR2(100);
bTerminoOk              BOOLEAN := FALSE;
nCodCia                 NUMBER;
nCodEmpresa             NUMBER;
cObten_Fecha_Vigencia   OPENPAY_PAGOS.Obten_Fecha_Vigencia%TYPE;
dFecIniVig              SICAS_OC.POLIZAS.FecIniVig%TYPE;       
dFechaPag               OPENPAY_PAGOS.FechaPag%TYPE;

CURSOR FACTCOB IS
   SELECT FAC.IdFactura,  POL.CodEmpresa, FAC.IndContabilizada,
          FAC.Monto_Fact_Moneda, FAC.IdPoliza, FAC.IDetPol,FAC.NumCuota,
          --'EFEC' CodFormaPago,
          '000'  CodEntidad,
          POL.StsPoliza, 
          O.IdOpenPay, 
          O.Cod_Moneda, 
          O.MontoPago_Local, 
          O.MontoPago_Moneda, 
          O.NumApprob_OpenPay,
          O.StsPago, 
          O.Referencia_Thona, 
          O.Referencia_OpenPay, 
          O.FechaReg, 
          O.FechaPag, 
          O.FechAct, 
          O.Usuario
     FROM FACTURAS FAC, POLIZAS POL,    OPENPAY_PAGOS O     
    WHERE FAC.CodCia     = POL.CodCia
      AND FAC.IdPoliza   = POL.IdPoliza
      AND POL.IdPoliza   = nIdPoliza
      AND FAC.IdFactura  = nIdFactura
      AND O.IdPoliza     = POL.IdPoliza
      AND O.IdFactura    = FAC.IdFactura
      AND O.StsPago = 'CargoAprob';                                

CURSOR Q_FACTURAS IS
   SELECT F.IdFactura,
          F.CodCia,
          1    CodEmpresa,
          'A'  TipoCfdi,
          'N'  IndRelaciona,
          F.StsFact
     FROM FACTURAS F
    WHERE F.IdPoliza     =  nIdPoliza
    ORDER BY F.IdFactura;

R_Facturas Q_FACTURAS%ROWTYPE;          

BEGIN
   BEGIN
      SELECT CodCia, CodEmpresa
        INTO nCodCia, nCodEmpresa
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
   END;

   BEGIN
      SELECT StsPoliza, FecIniVig
        INTO cStsPoliza, dFecIniVig
        FROM POLIZAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;
   END;

   BEGIN
      SELECT NVL(Obten_Fecha_Vigencia,'N'), FechaPag
        INTO cObten_Fecha_Vigencia, dFechaPag
        FROM OPENPAY_PAGOS
       WHERE IdPoliza   = nIdPoliza
         AND IdFactura  = nIdFactura;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20200,'No es posible determinar el pago de la factura '||nIdFactura||' - '||SQLERRM);
   END;

   IF cStsPoliza =  'PRE' THEN
      IF cObten_Fecha_Vigencia = 'N' THEN
         OC_POLIZAS.LIBERA_PRE_EMITE(nCodCia, nCodEmpresa, nIdPoliza, TRUNC(SYSDATE));
      ELSE
         OC_POLIZAS.LIBERA_PRE_EMITE_PLATAFORMA(nCodCia, nCodEmpresa, nIdPoliza, TRUNC(dFechaPag));
      END IF;
   --         
      OPEN Q_FACTURAS;
      LOOP
         FETCH Q_FACTURAS INTO R_Facturas;   
         EXIT WHEN Q_FACTURAS%NOTFOUND; 
         cCodCFDI := OC_FACTURAS.FACTURA_ELECTRONICA(R_Facturas.IdFactura, nCodCia, nCodEmpresa, R_Facturas.TipoCfdi, R_Facturas.IndRelaciona);

         IF OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '026') = cCodCFDI THEN --201
           NULL;
         END IF;
      END LOOP;
      --
      CLOSE Q_FACTURAS;
   END IF;

   BEGIN
      SELECT 1
        INTO nIdOpenPay
        FROM OPENPAY_PAGOS O
       WHERE O.IdPoliza    = nIdPoliza
         AND O.IdFactura   = nIdFactura;
   EXCEPTION WHEN OTHERS THEN
      nIdOpenPay := 0;            
   END;

   IF NVL(nIdOpenPay, 0) = 0 THEN                
      BEGIN
         SELECT NVL(MAX(IdOpenPay),0) + 1 
           INTO nIdOpenPay
           FROM OPENPAY_PAGOS O
          WHERE O.IdPoliza    = nIdPoliza
            AND O.IdFactura   = nIdFactura;
      EXCEPTION WHEN OTHERS THEN
         nIdOpenPay := 1;
      END;
      INSERT INTO OPENPAY_PAGOS (IdOpenPay, IdPoliza, IdFactura, Cod_Moneda, MontoPago_Local, MontoPago_Moneda, StsPago, Referencia_Thona, Referencia_OpenPay, NumApprob_OpenPay) 
                         VALUES (nIdOpenPay,nIdPoliza,nIdFactura, 'PS',0,0,'ENV', 'XXXXX', 'XXXX', 'NUMREF0001');            
   END IF;        

   FOR FC IN FACTCOB LOOP
      BEGIN
         SELECT D.Cod_Asegurado
           INTO nCodAsegurado
           FROM DETALLE_POLIZA D
          WHERE D.CodCia   = nCodCia
            AND D.IdPoliza = FC.IdPoliza
            AND D.IDetPol  = FC.IDetPol;
      END;

      IF FC.IndContabilizada = 'N' THEN
         nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, FC.CodEmpresa, 14, 'CONFAC');
         OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, FC.CodEmpresa, 14, 'CONFAC',
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
         nCobrar := OC_FACTURAS.PAGAR (FC.IdFactura, FC.NumApprob_OpenPay, SYSDATE, FC.MontoPago_Moneda, cCodFormaPago, FC.CodEntidad, nIdTransac);
      ELSE             
         nAporteFondo := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, FC.CodEmpresa, FC.IdPoliza,  FC.IDetPol);             
         nIdFondo     := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, FC.CodEmpresa, FC.IdPoliza, FC.IDetPol, nCodAsegurado);             
         IF NVL(nIdFondo,0) > 0 THEN
            nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, FC.CodEmpresa, FC.IdPoliza, FC.IDetPol, nCodAsegurado, nIdFondo, FC.NumCuota);
         ELSE
            nPrimaNivelada := 0;
         END IF;
         nCobrar := OC_FACTURAS.PAGAR_FONDOS(FC.IdFactura, FC.NumApprob_OpenPay, SYSDATE, FC.Monto_Fact_Moneda, cCodFormaPago, FC.CodEntidad, nIdTransac, nPrimaNivelada, nAporteFondo);
      END IF;

      IF nCobrar = 1 THEN
         bTerminoOk := TRUE;
         UPDATE PAGOS P 
            SET P.Moneda         = FC.Cod_Moneda, 
                P.Num_Recibo_Ref = FC.NumApprob_OpenPay
          WHERE P.CodCia         = nCodCia
            AND P.CodEmpresa     = nCodEmpresa
            AND P.IdFactura      = FC.IdFactura
            AND P.IdTransaccion  = nIdTransac;

         UPDATE FACTURAS
            SET FecSts         = TRUNC(SYSDATE),
                IndDomiciliado = NULL
          WHERE CodCia    = nCodCia
            AND IdFactura = FC.IdFactura;

         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(1, nIdTransac, 'C');

         cCodCFDI := OC_FACTURAS.FACTURA_ELECTRONICA(FC.IdFactura, 1, 1, 'A', 'S');
          --               
         IF OC_GENERALES.BUSCA_PARAMETRO(R_Facturas.CodCia, '026') = cCodCFDI THEN --201
            NULL;
         END IF;

      END IF;
   END LOOP;                                 
   RETURN bTerminoOk ;                      
END PAGO_FACTURA;  

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
                   TO_NUMBER(DECODE(NVL(CPP_REC.CODPLANPAGO,'0'),'0',TO_CHAR(NVL(C.PRIMACOTLOCAL,0) + NVL(C.GastosExpedicion,NVL(CCR.MONTOCONCEPTO,0))), --ANUAL
                   ROUND((C.PRIMACOTLOCAL/PP.NUMPAGOS +                             --PMA NETA
                         (C.PRIMACOTLOCAL/PP.NUMPAGOS * (CPP_REC.PORCCPTO/100)) +   --REC X PAGO FRACCIONADO
                         NVL(C.GastosExpedicion,NVL(CCR.MONTOCONCEPTO,0)))                                  --DEREMI
                         ,2)
                         ) )        PRIMER_RECIBO,
                   TO_NUMBER(DECODE(NVL(CPP_REC.CODPLANPAGO,'0'),'0','0',           --ANUAL
                   ROUND((C.PRIMACOTLOCAL/PP.NUMPAGOS +                             --PMA NETA
                          (C.PRIMACOTLOCAL/PP.NUMPAGOS * (CPP_REC.PORCCPTO/100)))   --REC X PAGO FRACCIONADO
                         ,2) ) )    RECIBOS_SUBSECUENTES,
                   PP.NUMPAGOS,
                   TO_NUMBER(DECODE(NVL(CPP_REC.CODPLANPAGO,'0'),'0',TO_CHAR(NVL(C.PRIMACOTLOCAL,0) + NVL(C.GastosExpedicion,NVL(CCR.MONTOCONCEPTO,0))),  --ANUAL
                   ROUND((C.PRIMACOTLOCAL +                            --PMA NETA
                         (C.PRIMACOTLOCAL * (CPP_REC.PORCCPTO/100)) +  --REC X PAGO FRACCIONADO
                         NVL(C.GastosExpedicion,NVL(CCR.MONTOCONCEPTO,0)))                     --DEREMI
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
    FUNCTION CONSULTA_CODIGO_POSTAL( pCatalogo        NUMBER := 0
                                   , pCODPOSTAL       VARCHAR2
                                   , pCODPAIS         VARCHAR2
                                   , pCODCIUDAD       VARCHAR2
                                   , pCODESTADO       VARCHAR2
                                   , pCODMUNICIPIO    VARCHAR2
                                   , pCODIGO_COLONIA  VARCHAR2 ) RETURN CLOB IS
            --
             CURSOR Q_FAC IS
                SELECT XMLELEMENT("CODIGOPOSTAL",  XMLATTRIBUTES("CODIGO_POSTAL" , 
                                                                 "CODPAIS",  
                                                                 "DESCPAIS",  
                                                                 "CODESTADO",   
                                                                 "DESCESTADO",   
                                                                 "CODCIUDAD",
                                                                 "DESCCIUDAD",
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
                               DECODE(pCatalogo, 1, DECODE(pCODCIUDAD, '%',      X.CODCIUDAD, NULL), X.CODCIUDAD)                       CODCIUDAD,
                               DECODE(pCatalogo, 1, DECODE(pCODCIUDAD, '%',      X.DESCCIUDAD, NULL), X.DESCCIUDAD)                     DESCCIUDAD,
                               DECODE(pCatalogo, 1, DECODE(pCODMUNICIPIO, '%',   M.CODMUNICIPIO, NULL), M.CODMUNICIPIO)                 CODMUNICIPIO,       
                               DECODE(pCatalogo, 1, DECODE(pCODMUNICIPIO, '%',   M.DESCMUNICIPIO, NULL), M.DESCMUNICIPIO)               DESCMUNICIPIO,
                               DECODE(pCatalogo, 1, DECODE(pCODIGO_COLONIA, '%', C.CODIGO_COLONIA, NULL), C.CODIGO_COLONIA)             CODIGO_COLONIA,
                               DECODE(pCatalogo, 1, DECODE(pCODIGO_COLONIA, '%', C.DESCRIPCION_COLONIA, NULL), C.DESCRIPCION_COLONIA)   DESCRIPCION_COLONIA       
                          FROM SICAS_OC.APARTADO_POSTAL CP INNER JOIN SICAS_OC.CORREGIMIENTO M ON M.CODMUNICIPIO = CP.CODMUNICIPIO AND M.CODPAIS = CP.CODPAIS AND M.CODESTADO = CP.CODESTADO AND M.CODCIUDAD = CP.CODCIUDAD 
                                                           INNER JOIN SICAS_OC.COLONIA       C ON C.CODPAIS = CP.CODPAIS AND C.CODESTADO = CP.CODESTADO AND C.CODCIUDAD = CP.CODCIUDAD AND C.CODMUNICIPIO = M.CODMUNICIPIO AND C.CODIGO_POSTAL = CP.CODIGO_POSTAL
                                                           INNER JOIN SICAS_OC.DISTRITO      X ON X.CODPAIS = CP.CODPAIS AND X.CODESTADO = CP.CODESTADO AND X.CODCIUDAD = CP.CODCIUDAD
                                                           INNER JOIN SICAS_OC.PROVINCIA     P ON P.CODPAIS = CP.CODPAIS AND P.CODESTADO = CP.CODESTADO 
                                                           INNER JOIN SICAS_OC.PAIS          PA ON PA.CODPAIS = CP.CODPAIS                                   
                        WHERE CP.CODIGO_POSTAL      =    DECODE(pCODPOSTAL,                                                                                   NULL, CP.CODIGO_POSTAL,     pCODPOSTAL)
                          AND CP.CODPAIS            =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODPAIS),         1, pCODPAIS, null),        NULL, CP.CODPAIS,           pCODPAIS)
                          AND CP.CODESTADO          =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODESTADO),       1, pCODESTADO, null),      NULL, CP.CODESTADO,         pCODESTADO)
                          AND CP.CODCIUDAD          =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODCIUDAD),       1, pCODCIUDAD, null),      NULL, CP.CODCIUDAD,         pCODCIUDAD)
                          AND CP.CODMUNICIPIO       =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODMUNICIPIO),    1, pCODMUNICIPIO, null),   NULL, CP.CODMUNICIPIO,      pCODMUNICIPIO)
                          AND C.CODIGO_COLONIA      =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODIGO_COLONIA),  1, pCODIGO_COLONIA, null), NULL, C.CODIGO_COLONIA,     pCODIGO_COLONIA)
                          AND PA.DESCPAIS           LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODPAIS),         1, NULL, pCODPAIS),        NULL, PA.DESCPAIS,          pCODPAIS)
                          AND P.DESCESTADO          LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODESTADO),       1, NULL, pCODESTADO),      NULL, P.DESCESTADO,         pCODESTADO)
                          AND X.DESCCIUDAD          LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODCIUDAD),       1, NULL, pCODCIUDAD),      NULL, X.DESCCIUDAD,         pCODCIUDAD)
                          AND M.DESCMUNICIPIO       LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODMUNICIPIO),    1, NULL, pCODMUNICIPIO),   NULL, M.DESCMUNICIPIO,      pCODMUNICIPIO)
                          AND C.DESCRIPCION_COLONIA LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODIGO_COLONIA),  1, NULL, pCODIGO_COLONIA), NULL, C.DESCRIPCION_COLONIA,pCODIGO_COLONIA)  
                        ORDER BY DESCPAIS, DESCESTADO, DESCCIUDAD, DESCMUNICIPIO, DESCRIPCION_COLONIA)  ;                                 
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
                    FROM ENTIDAD_FINANCIERA E INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA P ON P.Tipo_Doc_Identificacion = E.Tipo_Doc_Identificacion AND P.Num_Doc_Identificacion = E.Num_Doc_Identificacion
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

        --Consulta_Cotizaciones :   En digital lleva registro por RFC o Correo de las cotizaciones y deber√É¬≠a haber guardado el numero de IDCotizacion y CODAGENTE
        --pEstatus in 'EMITID'  Cotizaci√É¬≥n solo EMITIDA
        --            'POLEMI', Cotizaci√É¬≥n con Poliza emitida
        -- Paginaci√É¬≥n de registros: nNumRegIni y nNumRegFin
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
                            DECODE(NVL(Z.GastosExpedicion,0),0,NVL(C.MontoConcepto,0),NVL(Z.GastosExpedicion,0)) MONTOCONCEPTO
                            --NVL(Z.GastosExpedicion,NVL(C.MONTOCONCEPTO, 0)) MONTOCONCEPTO
                            --NVL(C.MONTOCONCEPTO, 0) MONTOCONCEPTO
                    from SICAS_OC.CATALOGO_DE_CONCEPTOS P  LEFT JOIN SICAS_OC.COTIZACIONES              Z ON Z.CODCIA      = P.CODCIA      AND Z.CODEMPRESA = 1 AND Z.IDCOTIZACION = pIDCOTIZACION     
                                                           LEFT JOIN SICAS_OC.CATALOGO_CONCEPTOS_RANGOS C ON C.CODCONCEPTO = P.CODCONCEPTO AND C.CODCIA = P.CODCIA AND Z.IDTIPOSEG = C.IDTIPOSEG AND C.CODMONEDA = Z.COD_MONEDA 
                                                           AND  Z.PrimaCotLocal  BETWEEN C.RangoInicial AND C.RangoFinal
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
    FUNCTION MUESTRA_POLIZAS(pCodCia NUMBER, pIDPOLIZA NUMBER, pRFC VARCHAR2, pNombre VARCHAR2, pCodAgente VARCHAR2, nNumRegIni NUMBER, nNumRegFin NUMBER) RETURN CLOB IS 
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
                   --OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) NOMBRE_CLIENTE,
                   TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada) NOMBRE_CLIENTE,
                   NVL(PNJ.TELMOVIL, PNJ.TELRES) TELMOVIL,
                   PNJ.EMAIL ,
                   P.NUM_COTIZACION,
                   P.COD_AGENTE  ,
                   P.COD_MONEDA,
                   P.PRIMANETA_MONEDA,
                   ANTERIOR.NOMBRECONTRATANTE NOMPAQ,
                   'REMXX'   REMPLAZO
            FROM POLIZAS P  INNER JOIN CLIENTES                 CLI         ON CLI.CodCliente = P.CodCliente
                            INNER JOIN PERSONA_NATURAL_JURIDICA PNJ         ON CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion                            
                            LEFT JOIN COTIZACIONES              C           ON C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA AND C.IDCOTIZACION = P.NUM_COTIZACION 
                            LEFT JOIN COTIZACIONES              ANTERIOR    ON ANTERIOR.CODCIA = C.CODCIA AND ANTERIOR.CODEMPRESA = C.CODEMPRESA AND ANTERIOR.IDCOTIZACION = C.NUMCOTIZACIONANT
            WHERE  P.CODCIA                     = NVL(pCodCia, 1)              
              AND  P.COD_AGENTE                 = DECODE(NVL(pCodAgente, '0'), '0', P.COD_AGENTE, pCodAgente)              
              AND  P.IDPOLIZA                   = DECODE(NVL(pIDPOLIZA, 0), 0,  P.IDPOLIZA,   pIDPOLIZA)
              AND  PNJ.Num_Doc_Identificacion   = DECODE(pRFC, NULL, PNJ.Num_Doc_Identificacion, pRFC)
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
    FUNCTION CONSULTA_AGENTE(pCodCia NUMBER, pCodEmpresa NUMBER, pCodAgente NUMBER) RETURN CLOB IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : ??                                                                                                               |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: ??                                                                                                               |    
    | Nombre     : CONSULTA_AGENTE                                                                                                  |
    | Version    : 3.0                                                                                                              |
    | Objetivo   : Funcion que obtiene informacion del Agente que coincida con el proporcionado.                                    |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 13/08/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle (JALV)                                                                                    |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    |                                                                                                                               |
    | Obj. Modif.: Se agrego el codigo del Ejecutivo.                                                                               |
    |        14/04/2021 Colocar orden correcto de apellidos en el Nombre del agente (Ape. Paterno y despues Ape. Materno).          |
    |        04/03/2021 Correccion para que muestre el Email correcto de acuerdo al Correlativo.                                    |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           pCodCia             Codigo de la Compa√É¬±ia           (Entrada)                                                       |
    |           pCodEmpresa         Codigo de la Empresa            (Entrada)                                                       |
    |           pCodAgente          Codigo de Agente                (Entrada)                                                       |
    |_______________________________________________________________________________________________________________________________|

*/     
        NUM         NUMBER  := 0;
        nNivel      NUMBER  := 5;
        nAgente     NUMBER  := 0;
        --pCOD_AGENTE NUMBER := 264;     --264 --3048 -- 99
        nCod_Agente NUMBER;     --264 --3048 -- 99
        Linea       CLOB;

        TYPE NIVELES IS RECORD (
            NIVEL   NUMBER,
            JEFE    NUMBER,
            SUB     NUMBER,
            NOMBRE  VARCHAR(500),
            EMAIL   VARCHAR(500),
            TEL     VARCHAR(500),
            CODEJE            AGENTES.CODEJECUTIVO%TYPE,    --> JALV(+) 13/08/2021
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
                               A.CODEJECUTIVO,              --> JALV(+) 13/08/2021
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
                SELECT  REPLACE(PA.NOMBRE || ' ' || PA.APELLIDO_PATERNO || ' ' || PA.APELLIDO_MATERNO, '  ', ' '), -- JALV 14/042021
                        DECODE(ENT.IDCUENTACORREO,NULL,PA.EMAIL,OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(ENT.Tipo_Doc_Identificacion, ENT.Num_Doc_Identificacion, ENT.IDCUENTACORREO)),--PA.EMAIL,   --> 04/03/2021 (JALV +)
                        NVL(PA.TELMOVIL, NVL(PA.TELOFI, PA.TELRES )) TEL                           
                  INTO  TABLA_NIVELES(NUM).NOMBRE, 
                        TABLA_NIVELES(NUM).EMAIL,
                        TABLA_NIVELES(NUM).TEL
                  FROM  PERSONA_NATURAL_JURIDICA PA  
                 WHERE  PA.Tipo_Doc_Identificacion = ENT.Tipo_Doc_Identificacion 
                   AND  PA.Num_Doc_Identificacion = ENT.Num_Doc_Identificacion;
                IF nCOD_AGENTE =  pCODAGENTE THEN                                  
                    TABLA_NIVELES(NUM).CODEJE        := ENT.CODEJECUTIVO;       --> JALV(+) 13/08/2021
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
                            ' COD_EJECUTIVO="' || TABLA_NIVELES(NUM).CODEJE   || '"' || --> JALV(+) 13/08/2021
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
bCondicionesGenerales   REGISTRO_TIPSEG_AUTORIDAD.CondicionesGenerales%TYPE;
cMasDeUnRegistro        VARCHAR2(1);
nNumRegistro            REGISTRO_TIPSEG_AUTORIDAD.NumRegistro%TYPE;
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
         cMasDeUnRegistro := 'S';
   END;
   IF NVL(cMasDeUnRegistro,'N') = 'S' THEN
      BEGIN
         SELECT NumRegistro
           INTO nNumRegistro
           FROM (
                  SELECT MIN(TO_DATE(dFecEmision,'DD/MM/YYYY') - FecRegistro) Minimo, NumRegistro, FecRegistro
                    FROM REGISTRO_TIPSEG_AUTORIDAD
                   WHERE CodCia        = nCodCia
                     AND CodEmpresa    = nCodEmpresa
                     AND IdTipoSeg     = cIdTipoSeg
                   GROUP BY NumRegistro, FecRegistro)
          WHERE TO_DATE(dFecEmision,'DD/MM/YYYY') - FecRegistro = (SELECT MIN(TO_DATE(dFecEmision,'DD/MM/YYYY') - FecRegistro)
                                                                      FROM REGISTRO_TIPSEG_AUTORIDAD
                                                                     WHERE CodCia        = nCodCia
                                                                       AND CodEmpresa    = nCodEmpresa
                                                                       AND IdTipoSeg     = cIdTipoSeg);
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'No es posible determinar el registro de la NCFS para el Tipo de Seguro'||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||SQLERRM);
      END;
      BEGIN
         SELECT CondicionesGenerales --IdTipoSeg,FecRegistro,NumAutorTipSeg,Ds_Arch_Congen,StRegistro,Fec_Suspencion
           INTO bCondicionesGenerales
           FROM REGISTRO_TIPSEG_AUTORIDAD
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdTipoSeg     = cIdTipoSeg
            AND NumRegistro   = nNumRegistro;
      END;
   END IF;
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
                raise_application_error(-20001, 'Esta p√É¬≥liza, no es de origen de la Plataforma Digital');
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
        DELETE AGENTES_DISTRIBUCION_POLIZA   WHERE CodCia   = nCodCia AND IdPoliza = nIdPoliza AND CODNIVEL = NVL(CODNIVEL, 1);                                
        DELETE AGENTES_DISTRIBUCION_COMISION WHERE CodCia        = nCodCia AND IdPoliza      = nIdPoliza AND IDETPOL       = NVL(IDETPOL,1);
        DELETE AGENTES_DETALLES_POLIZAS WHERE IdPoliza      = nIdPoliza AND IDETPOL       = NVL(IDETPOL,1) AND IDTIPOSEG     = NVL(IDTIPOSEG,1) AND COD_AGENTE    = NVL(COD_AGENTE,1);
        DELETE DETALLE_COMISION    WHERE (       CODCIA, IDCOMISION, CODCONCEPTO, ORIGEN) 
                                      IN (SELECT CODCIA, IDCOMISION, CODCONCEPTO, ORIGEN 
                                            FROM COMISIONES C
                                           WHERE C.IDFACTURA   = NVL(C.IDFACTURA, 1)  
                                             AND C.IDPOLIZA    = nIdPoliza
                                             AND C.CODCIA      = nCodCia);                 
        DELETE COMISIONES C WHERE C.IDFACTURA   = NVL(C.IDFACTURA, 1) AND C.IDPOLIZA    = nIdPoliza AND C.CODCIA      = nCodCia;  
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

    FUNCTION DOCUMENTO_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, nCodPaquete NUMBER) RETURN BLOB AS
        bAsistencias PAQUETE_COMERCIAL.Documento%TYPE;
    BEGIN              
      RETURN GT_PAQUETE_COMERCIAL.DOCUMENTO(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nCodPaquete);
    END DOCUMENTO_ASISTENCIAS;
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
            RAISE_APPLICATION_ERROR(-20200,'Existe m√É¬°s de un registro activo para el producto '||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||SQLERRM);
      END;
      RETURN bQueHacerSiniestros;
    END QUE_HACER_SINIESTROS;

FUNCTION TIPO_ARCH_BLOB(pTabla VARCHAR2, pCampo_Blob VARCHAR2, pWhere VARCHAR2) RETURN VARCHAR IS
            uBLOB       BLOB;
            X           NUMBER;
            step        NUMBER;
            VBINARIO    VARCHAR2(10000);
            VTEXTO      VARCHAR2(10000);
            TIPARCH     VARCHAR2(3);  
            SQLTEXT VARCHAR2(10000);
    BEGIN
        SQLTEXT := 'SELECT ' || pCampo_Blob || ' FROM ' || pTabla || ' WHERE ROWNUM = 1 AND ' || pWhere;
        EXECUTE IMMEDIATE SQLTEXT INTO uBLOB;

        FOR X IN 1..DBMS_LOB.GETLENGTH(uBLOB)/2 LOOP
            TIPARCH := null;
            step :=  X * 2;
            VBINARIO := dbms_lob.substr(uBLOB,STEP, 2);
            VTEXTO := UPPER(UTL_RAW.CAST_TO_VARCHAR2(VBINARIO));
            IF INSTR(VTEXTO, 'JFI') > 0 THEN
                TIPARCH := 'jpg';
            ELSIF INSTR(VTEXTO, 'PDF') > 0 THEN
                TIPARCH := 'pdf';
            ELSIF INSTR(VTEXTO, 'PNG') > 0 THEN
                TIPARCH := 'png';
            ELSIF INSTR(VTEXTO, 'GIF') > 0 OR INSTR(VTEXTO, 'IF8') > 0 THEN
                TIPARCH := 'gif';
            ELSE
               IF X >= 50 THEN 
                  TIPARCH := 'jpg';
               END IF;
            END IF;             
            IF X >= 50 or length(TIPARCH) > 0 THEN
              EXIT;
            END IF;           
        END LOOP;  

        RETURN TIPARCH;
    END TIPO_ARCH_BLOB;
    --    
    FUNCTION ACTIVIDAD_ECONOMICA(cRiesgoActividad IN VARCHAR2, cTipoRiesgo IN VARCHAR2) RETURN XMLTYPE IS 
      xDatosActE     XMLTYPE;
    BEGIN
      OC_ACTIVIDADES_ECONOMICAS.ACT_ECONOMICA_DIGITAL(cRiesgoActividad, cTipoRiesgo, xDatosActE);
      RETURN xDatosActE;
    END ACTIVIDAD_ECONOMICA;    

PROCEDURE ACTUALIZA_COMISIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nPorcComisAgente NUMBER, nPorcConv OUT NUMBER, nGastos OUT NUMBER) IS
nCodAgente        COTIZACIONES.CodAgente%TYPE;
nPorcComisAgte    COTIZACIONES.PorcComisAgte%TYPE;
nPorcComisProm    COTIZACIONES.PorcComisProm%TYPE;
nPorcComisDir     COTIZACIONES.PorcComisDir%TYPE;
nPorcGtoAdqui     COTIZACIONES.PorcGtoAdqui%TYPE;
nPorcGtoAdquiCalc COTIZACIONES.PorcGtoAdqui%TYPE;
cCodTipoBono      COTIZACIONES.CodTipoBono%TYPE;
nPorcConvenciones COTIZACIONES.PorcConvenciones%TYPE;
BEGIN   
   BEGIN
      SELECT CodAgente, PorcComisAgte, PorcComisProm, 
             PorcComisDir, PorcGtoAdqui, CodTipoBono,
             PorcConvenciones
        INTO nCodAgente, nPorcComisAgte, nPorcComisProm, 
             nPorcComisDir, nPorcGtoAdqui, cCodTipoBono,
             nPorcConvenciones
        FROM COTIZACIONES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No existe la Cotizaci√É¬≥n '||nIdCotizacion);
   END;
   IF nPorcComisAgente <> nPorcComisAgte THEN
      nPorcGtoAdquiCalc := NVL(nPorcComisAgente,0) + NVL(nPorcComisProm,0) + NVL(nPorcComisDir,0);
      --IF nPorcComisAgente > 30 THEN
      IF nPorcGtoAdquiCalc > 30 THEN
         cCodTipoBono      := 'CUAE';
         nPorcConvenciones := 10;
      END IF;
      UPDATE COTIZACIONES
         SET PorcComisAgte    = nPorcComisAgente,
             PorcGtoAdqui     = nPorcGtoAdquiCalc,
             CodTipoBono      = cCodTipoBono
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion;

      --- llamar funcion de actualizar convenciones
      GENERALES_PLATAFORMA_DIGITAL.ACTUALIZA_CONVENCIONES(nCodCia, nCodEmpresa, nIdCotizacion, nPorcConvenciones);
      --- llamar funcion de restaurar factores ajustes
      --GT_COTIZACIONES_DETALLE.RESTAURA_FACTORAJUSTE(nCodCia, nCodEmpresa, nIdCotizacion, 1);
   END IF;
   BEGIN
      SELECT PorcGtoAdqui, CodTipoBono, PorcConvenciones
      --  INTO nGastos, cTipoBono ,nPorcConv
        INTO nPorcGtoAdqui, cCodTipoBono, nPorcConvenciones
        FROM COTIZACIONES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion;
   END;
   nGastos     := nPorcGtoAdqui;
   --cTipoBono   := cCodTipoBono;
   nPorcConv   := nPorcConvenciones;
END ACTUALIZA_COMISIONES;
    --
PROCEDURE ACTUALIZA_CONVENCIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nPorcConvenciones NUMBER) IS
BEGIN 
   UPDATE COTIZACIONES
      SET PorcConvenciones = nPorcConvenciones
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdCotizacion  = nIdCotizacion; 
END ACTUALIZA_CONVENCIONES;

--PROCEDURE RECIBE_GENERALES_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, xGenerales XMLTYPE) IS
PROCEDURE RECIBE_GENERALES_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, xGenerales XMLTYPE) IS
nHorasVig         COTIZACIONES.HorasVig%TYPE;
nDiasVig          COTIZACIONES.DiasVig%TYPE;
nCantAsegurados   COTIZACIONES.CantAsegurados%TYPE;
nFactorAjuste     COTIZACIONES.FactorAjuste%TYPE;
cRiesgoTarifa     COTIZACIONES.RiesgoTarifa%TYPE;
cTiponegocio      COTIZACIONES.Tipnego_Web%TYPE;
cLaboral          COTIZACIONES.Ries_Labor%TYPE;
cRies24_365       COTIZACIONES.Ries_24365%TYPE;
cTraslados        COTIZACIONES.Ries_Trasla%TYPE;

CURSOR cGenCotiza IS
   WITH
   COTIZA_DATA AS ( SELECT GEN.*
                       FROM   XMLTABLE('/DATA'
                                 PASSING xGenerales
                                    COLUMNS 
                                       HorasVig       NUMBER(5)   PATH 'HorasVig',
                                       DiasVig        NUMBER(5)   PATH 'DiasVig',
                                       CantAsegurados NUMBER(10)  PATH 'CantAsegurados',
                                       FactorAjuste   NUMBER(9,6) PATH 'FactorAjuste',
                                       RiesgoTarifa   VARCHAR(2)  PATH 'RiesgoTarifa',
                                       Tiponegocio    VARCHAR(10) PATH 'Tiponegocio',
                                       Laboral        VARCHAR(2)  PATH 'Laboral',
                                       Ries24_365     VARCHAR(2)  PATH 'Ries24_365',
                                       Traslados      VARCHAR(2)  PATH 'Traslados') GEN				   
                     )
   SELECT * FROM COTIZA_DATA;
BEGIN
   FOR X IN cGenCotiza LOOP
      IF X.HorasVig IS NOT NULL THEN
         nHorasVig         := X.HorasVig;
      END IF;
      IF X.DiasVig IS NOT NULL THEN
         nDiasVig          := X.DiasVig;
      END IF;
      IF X.CantAsegurados IS NOT NULL THEN
         nCantAsegurados   := X.CantAsegurados;
      END IF;
      IF X.FactorAjuste IS NOT NULL THEN 
         nFactorAjuste := X.FactorAjuste;
      END IF;
      IF X.RiesgoTarifa IS NOT NULL THEN 
         cRiesgoTarifa := X.RiesgoTarifa;
      END IF;
      IF X.Tiponegocio IS NOT NULL THEN 
         cTiponegocio := X.Tiponegocio;
      END IF;
      IF X.Laboral IS NOT NULL THEN 
         cLaboral := X.Laboral;
      END IF;
      IF X.Ries24_365 IS NOT NULL THEN 
         cRies24_365 := X.Ries24_365;
      END IF;
      IF X.Traslados IS NOT NULL THEN 
         cTraslados := X.Traslados;   
      END IF;
   END LOOP;

   --IF nHorasVig IS NOT NULL OR nDiasVig IS NOT NULL THEN
   /*   UPDATE COTIZACIONES_DETALLE
         SET HorasVig         = NVL(nHorasVig,HorasVig),
             DiasVig          = NVL(nDiasVig,DiasVig)
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND IdCotizacion     = nIdCotizacion
         --AND IDetCotizacion   = nIDetCotizacion
         ; */
   --END IF;

   UPDATE COTIZACIONES
      SET CantAsegurados   = NVL(nCantAsegurados,CantAsegurados),
          FactorAjuste     = NVL(nFactorAjuste,FactorAjuste),
          RiesgoTarifa     = NVL(cRiesgoTarifa,RiesgoTarifa),
          Tipnego_Web      = cTiponegocio,
          Ries_Labor       = cLaboral,
          Ries_24365       = cRies24_365,
          Ries_Trasla      = cTraslados
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdCotizacion  = nIdCotizacion;     
    GT_COTIZACIONES_CLAUSULAS.CREAR_TEXTORIESGOS_COTIZA(nCodCia, cTiponegocio, cLaboral, cRies24_365, cTraslados, nIdCotizacion);--ARH 23/08/2024

   UPDATE COTIZACIONES_DETALLE
      SET CantAsegurados   = NVL(nCantAsegurados,CantAsegurados),
          HorasVig         = NVL(nHorasVig,HorasVig),
          DiasVig          = NVL(nDiasVig,DiasVig),
          RiesgoTarifa     = NVL(cRiesgoTarifa,RiesgoTarifa)
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdCotizacion  = nIdCotizacion;        
END RECIBE_GENERALES_COTIZACION;

FUNCTION CREA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, cCadena VARCHAR2) RETURN NUMBER IS
nIdPoliza   POLIZAS.IdPoliza%TYPE;
BEGIN
   RETURN nIdPoliza;
END CREA_POLIZA;

PROCEDURE CANCELACION_POLIZAS(nCodCia NUMBER,nCodEmpresa NUMBER,nIdPoliza NUMBER,cMotivAnul VARCHAR2,cRespuesta OUT VARCHAR2,cTipoProceso VARCHAR2,cCod_Moneda OUT VARCHAR2, xRespuesta OUT NUMBER, fechaAnulacion DATE) IS
    dFecAnul DATE := TRUNC(TO_DATE(fechaAnulacion, 'DD/MM/RRRR'));
    BEGIN
        cCod_Moneda := OC_POLIZAS.MONEDA(nCodCia, nCodEmpresa, nIdPoliza);
        xRespuesta := OC_POLIZAS_SERVICIOS_WEB.ANULAR_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, dFecAnul, cMotivAnul, cCod_Moneda, cRespuesta, cTipoProceso);
    END CANCELACION_POLIZAS;

   PROCEDURE ACTUALIZA_INFORMACION_FISCAL( nCodCia             POLIZAS.CodCia%TYPE
                                         , nCodEmpresa         POLIZAS.CodEmpresa%TYPE
                                         , nIdPoliza           POLIZAS.IdPoliza%TYPE
                                         , xInformacionFiscal  XMLTYPE ) IS
      cCodUsoCFDI               POLIZAS.CodUsoCFDI%TYPE;
      cCodObjetoImp             POLIZAS.CodObjetoImp%TYPE;
      --
      nIdRegFisSAT              PERSONA_NATURAL_JURIDICA.IdRegFisSAT%TYPE;
      cRazonSocialFact          PERSONA_NATURAL_JURIDICA.RazonSocialFact%TYPE;
      --
      cTipo_Doc_Identificacion  DIRECCIONES_PNJ.Tipo_Doc_Identificacion%TYPE;
      cNum_Doc_Identificacion   DIRECCIONES_PNJ.Num_Doc_Identificacion%TYPE;
      cTipo_Direccion           DIRECCIONES_PNJ.Tipo_Direccion%TYPE;
      cDireccion                DIRECCIONES_PNJ.Direccion%TYPE;
      cCodPais                  DIRECCIONES_PNJ.CodPais%TYPE;
      cCodEstado                DIRECCIONES_PNJ.CodEstado%TYPE;
      cCodCiudad                DIRECCIONES_PNJ.CodCiudad%TYPE;
      cCodMunicipio             DIRECCIONES_PNJ.CodMunicipio%TYPE;
      cCodigo_Postal            DIRECCIONES_PNJ.Codigo_Postal%TYPE;
      cCodAsentamiento          DIRECCIONES_PNJ.CodAsentamiento%TYPE;
      cCodigo_ZIP               DIRECCIONES_PNJ.Codigo_ZIP%TYPE;
      cDireccion_Principal      DIRECCIONES_PNJ.Direccion_Principal%TYPE;
      cNumInterior              DIRECCIONES_PNJ.NumInterior%TYPE;
      cNumExterior              DIRECCIONES_PNJ.NumExterior%TYPE;
      nCorrelativo_Direccion    DIRECCIONES_PNJ.Correlativo_Direccion%TYPE;
      cContador                 NUMBER;
      --
      CURSOR cInformacionFiscal IS
         WITH
         FISCAL_DATA AS ( SELECT GEN.*
                          FROM   XMLTABLE('/DATA'
                             PASSING xInformacionFiscal
                                 COLUMNS 
                                 CodUsoCFDI               VARCHAR2(10)   PATH 'CodUsoCFDI',
                                 CodObjetoImp             VARCHAR2(10)   PATH 'CodObjetoImp',
                                 IdRegFisSAT              NUMBER(5,0)    PATH 'IdRegFisSAT',
                                 RazonSocialFact          VARCHAR2(300)  PATH 'RazonSocialFact',
                                 Tipo_Doc_Identificacion  VARCHAR2(6)    PATH 'Tipo_Doc_Identificacion',
                                 Num_Doc_Identificacion   VARCHAR2(20)   PATH 'Num_Doc_Identificacion',
                                 Tipo_Direccion           VARCHAR2(6)    PATH 'Tipo_Direccion',
                                 Direccion                VARCHAR2(250)  PATH 'Direccion',
                                 CodPais                  VARCHAR2(3)    PATH 'CodPais',
                                 CodEstado                VARCHAR2(3)    PATH 'CodEstado',
                                 CodCiudad                VARCHAR2(3)    PATH 'CodCiudad',
                                 CodMunicipio             VARCHAR2(3)    PATH 'CodMunicipio',
                                 Codigo_Postal            VARCHAR2(30)   PATH 'Codigo_Postal',
                                 CodAsentamiento          VARCHAR2(6)    PATH 'CodAsentamiento',
                                 Codigo_ZIP               VARCHAR2(10)   PATH 'Codigo_ZIP',
                                 Direccion_Principal      VARCHAR2(1)    PATH 'Direccion_Principal',
                                 NumInterior              VARCHAR2(20)   PATH 'NumInterior',
                                 NumExterior              VARCHAR2(20)   PATH 'NumExterior') GEN
                        )
         SELECT * FROM FISCAL_DATA;
   BEGIN
      FOR x IN cInformacionFiscal LOOP
         IF x.CodUsoCFDI IS NOT NULL THEN
            cCodUsoCFDI := x.CodUsoCFDI;
         END IF;
         --
         IF x.CodObjetoImp IS NOT NULL THEN
            cCodObjetoImp := x.CodObjetoImp;
         END IF;
         --
         IF x.IdRegFisSAT IS NOT NULL THEN
            nIdRegFisSAT := x.IdRegFisSAT;
         END IF;
         --
         IF x.RazonSocialFact IS NOT NULL THEN
            cRazonSocialFact := x.RazonSocialFact;
         END IF;
         --
         IF x.Tipo_Doc_Identificacion IS NOT NULL THEN
            cTipo_Doc_Identificacion := x.Tipo_Doc_Identificacion;
         END IF;
         --
         IF x.Num_Doc_Identificacion IS NOT NULL THEN
            cNum_Doc_Identificacion := x.Num_Doc_Identificacion;
         END IF;
         --
         IF x.Tipo_Direccion IS NOT NULL THEN
            cTipo_Direccion := x.Tipo_Direccion;
         END IF;
         --
         IF x.Direccion IS NOT NULL THEN
            cDireccion := x.Direccion;
         END IF;
         --
         IF x.CodPais IS NOT NULL THEN
            cCodPais := x.CodPais;
         END IF;
         --
         IF x.CodEstado IS NOT NULL THEN
            cCodEstado := x.CodEstado;
         END IF;
         --
         IF x.CodCiudad IS NOT NULL THEN
            cCodCiudad := x.CodCiudad;
         END IF;
         --
         IF x.CodMunicipio IS NOT NULL THEN
            cCodMunicipio := x.CodMunicipio;
         END IF;
         --
         IF x.Codigo_Postal IS NOT NULL THEN
            cCodigo_Postal := x.Codigo_Postal;
         END IF;
         --
         IF x.CodAsentamiento IS NOT NULL THEN
            cCodAsentamiento := x.CodAsentamiento;
         END IF;
         --
         IF x.Codigo_ZIP IS NOT NULL THEN
            cCodigo_ZIP := x.Codigo_ZIP;
         END IF;
         --
         IF x.Direccion_Principal IS NOT NULL THEN
            cDireccion_Principal := x.Direccion_Principal;
         END IF;
         --
         IF x.NumInterior IS NOT NULL THEN
            cNumInterior := x.NumInterior;
         END IF;
         --
         IF x.NumExterior IS NOT NULL THEN
            cNumExterior := x.NumExterior;
         END IF;
      END LOOP;
      --
      UPDATE POLIZAS
      SET    CodUsoCFDI   = cCodUsoCFDI
        ,    CodObjetoImp = cCodObjetoImp
      WHERE  CodCia     = nCodCia
        AND  CodEmpresa = nCodEmpresa
        AND  IdPoliza   = nIdPoliza;
      --
      OC_PERSONA_NATURAL_JURIDICA.ACTUALIZA_INFORMACION_FISCAL( cTipo_Doc_Identificacion, cNum_Doc_Identificacion, nIdRegFisSAT, cRazonSocialFact );
      --
      BEGIN
         SELECT NVL(MAX(Correlativo_Direccion), 0) + 1
         INTO   nCorrelativo_Direccion
         FROM   DIRECCIONES_PNJ
         WHERE  Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
           AND  Num_Doc_Identificacion  = cNum_Doc_Identificacion;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           nCorrelativo_Direccion := 1;
      END;
      --
      SELECT COUNT(*)
      INTO   cContador
      FROM   DIRECCIONES_PNJ
      WHERE  Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
        AND  Num_Doc_Identificacion  = cNum_Doc_Identificacion
        AND  Tipo_Direccion          = cTipo_Direccion;
      --
      IF cContador > 0 THEN
         DELETE DIRECCIONES_PNJ
         WHERE  Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
           AND  Num_Doc_Identificacion  = cNum_Doc_Identificacion
           AND  Tipo_Direccion          = cTipo_Direccion;
      END IF;
      --
      INSERT INTO DIRECCIONES_PNJ
      VALUES ( cTipo_Doc_Identificacion, cNum_Doc_Identificacion, cTipo_Direccion     , nCorrelativo_Direccion, cDireccion    ,
               cCodPais                , cCodEstado             , cCodCiudad          , cCodMunicipio         , cCodigo_Postal,
               cCodAsentamiento        , cCodigo_ZIP            , cDireccion_Principal, cNumInterior          , cNumExterior );
      --
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUZALIZAR INFORMACION FISCAL: ' || SQLERRM);
   END ACTUALIZA_INFORMACION_FISCAL;

   FUNCTION PRE_EMITE_POLIZA_NEW_CFDI40( nCodCia            NUMBER
                                , nCodEmpresa        NUMBER
                                , nIdCotizacion      NUMBER
                                , cCadena            VARCHAR2
                                , cIdPoliza          NUMBER := NULL 
                                , xInformacionFiscal XMLTYPE ) RETURN CLOB IS
      --LUCERO MAYOR 
      --cCadena           VARCHAR2(4000) := 'C,RFC,PELC700807XXX,ZORRILLA,NOMCONTRATANTE,ROBERTO,,07/08/1970,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,BURGER PO KING,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N|A,RFC,,PEDRO,TIMBAK,LUPITA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,LUCERITO LUC PE√É‚ÄòON,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N|A,RFC,,GABRIELA,LOPEZ,DE SANTA ANA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,NOMB PAGA CUENTA,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N';
      --
      --Otros productos
      --cCadena            VARCHAR2(32727) := 'C,RFC,PELC700807XXX,ZORRILLA,NOMCONTRATANTE,ROBERTO,,07/08/1970,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,BURGER PO KING,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N|A,RFC,,PEDRO,TIMBAK,LUPITA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,LUCERITO LUC PE√É‚ÄòON,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N';
      --  
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
      cTipoRiesgo       VARCHAR2(6);
      cTipPersona       VARCHAR2(6);
      cCodMoneda        POLIZAS.Cod_Moneda%TYPE;
      wIdCotizacion     NUMBER := 0;
      wPorcComis1       NUMBER := 0;     
      wPorcComis2       NUMBER := 0;     
      wPorcComis3       NUMBER := 0;     
      wPorcComisTot     NUMBER := 0;
      wPorcComProp1     NUMBER := 0;
      wPorcComProp2     NUMBER := 0;
      wPorcComProp3     NUMBER := 0;
      wPorcComPropT     NUMBER := 0;
      nCodAgente        number :=0;
      nIdFormaCobro     MEDIOS_DE_COBRO.IdFormaCobro%TYPE;
      nGastosExpedicion COTIZACIONES.GastosExpedicion%TYPE;
      --
      cIdTipoSeg        COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob          COTIZACIONES.PlanCob%TYPE;
      --
      CURSOR Q_NUMREG IS
             SELECT CASE WHEN COUNT(COLUMN_VALUE)> 2 THEN 'N' ELSE 'N' END EsColectiva, COUNT(COLUMN_VALUE) NUMREG
             FROM TABLE(GT_WEB_SERVICES.SPLIT(cCadena, '|'));
      --
      R_NUMREG Q_NUMREG%ROWTYPE;
      --
      CURSOR Q_TRAN (PnIdePol NUMBER) IS
             SELECT D.IDTRANSACCION      
             FROM DETALLE_TRANSACCION D
             WHERE CodCia           = nCodCia
               AND CodEmpresa       = nCodEmpresa
               AND D.CODSUBPROCESO  = 'POL'
               AND D.OBJETO         = 'POLIZAS'
               AND D.VALOR1         = TRIM(TO_CHAR(PnIdePol));
      --
      R_TRAN Q_TRAN%ROWTYPE;          
      --
      CURSOR Q_DOMI (pCODPOSTAL VARCHAR2, pCODIGO_COLONIA VARCHAR2) IS
             SELECT DISTINCT PA.Codpais, M.CodEstado, D.CODCIUDAD, C.CODMUNICIPIO                       
             FROM SICAS_OC.APARTADO_POSTAL CP INNER JOIN SICAS_OC.CORREGIMIENTO M ON M.CODMUNICIPIO = CP.CODMUNICIPIO AND M.CODPAIS = CP.CODPAIS AND M.CODESTADO = CP.CODESTADO AND M.CODCIUDAD = CP.CODCIUDAD 
                                              INNER JOIN SICAS_OC.COLONIA       C ON C.CODPAIS = CP.CODPAIS AND C.CODESTADO = CP.CODESTADO AND C.CODCIUDAD = CP.CODCIUDAD AND C.CODMUNICIPIO = M.CODMUNICIPIO AND C.CODIGO_POSTAL = CP.CODIGO_POSTAL
                                              INNER JOIN SICAS_OC.PROVINCIA     P ON P.CODPAIS = CP.CODPAIS AND P.CODESTADO = CP.CODESTADO
                                              INNER JOIN DISTRITO               D ON D.CODPAIS = CP.CODPAIS AND D.CODESTADO = CP.CODESTADO AND D.CODCIUDAD = C.CODCIUDAD 
                                              INNER JOIN SICAS_OC.PAIS          PA ON PA.CODPAIS = CP.CODPAIS                                   
             WHERE CP.CODIGO_POSTAL      =    pCODPOSTAL
               AND C.CODIGO_COLONIA      =    pCODIGO_COLONIA;
      --
      R_DOMI Q_DOMI%ROWTYPE;          
      --
      CURSOR DETPOL_Q IS
             SELECT CodCia, CodEmpresa, IdPoliza, IDetPol, IdTipoSeg, PlanCob, Tasa_Cambio, FecIniVig, FecFinVig
             FROM   DETALLE_POLIZA
             WHERE  CodCia        = nCodCia
               AND  CodEmpresa    = nCodEmpresa
               AND  IdPoliza      = nIdPoliza
             ORDER BY IdPoliza;                           
BEGIN
   IF cIdPoliza IS NULL THEN
      IF SICAS_OC.GT_COTIZACIONES.EXISTE_COTIZACION_EMITIDA(NCODCIA, NCODEMPRESA, NIDCOTIZACION ) = 'N' THEN
        RETURN 'Esta cotizaci√É¬≥n no esta emitida: ' || NIDCOTIZACION;
      END IF;

      OPEN  Q_NUMREG;
      FETCH Q_NUMREG INTO R_NUMREG;      
      CLOSE Q_NUMREG;   

      BEGIN
         SELECT IdTipoSeg, PlanCob
           INTO cIdTipoSeg, cPlanCob
           FROM COTIZACIONES
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdCotizacion  = nIdCotizacion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'Error al determinar la cotizaci√É¬≥n '||nIdCotizacion);
      END;  
         --
      INSERT INTO API_LOG_EMISION (Descripcion, Fecha, Id_Cotizacion) VALUES(cCadena, SYSDATE, nIdCotizacion);
      FOR ENT IN (SELECT COLUMN_VALUE Fila FROM table(GT_WEB_SERVICES.SPLIT(cCadena, '|'))) LOOP
         IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,3,',') IS NOT NULL OR OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,3,',') != '' THEN
            CRFC := OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,3,',');
         ELSE
            CRFC := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(CAMBIA_ACENTOS(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,4,',')),
                                                                      CAMBIA_ACENTOS(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,5,',')),
                                                                      (OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,6,',')),
                                                                      TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,8,','), 'DD/MM/YYYY'),
                                                                      'FISICA');
         END IF;                                                                              
         cTipoDocIdentAseg := OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,2,',');
         cNumDocIdentAseg  := CRFC;                                
        --
         IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'C' AND nIdPoliza IS NULL  THEN  
            nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
         END IF;

         BEGIN
            OPEN  Q_DOMI(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,18,','), OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,16,','));                    
            FETCH Q_DOMI INTO R_DOMI;      
            CLOSE Q_DOMI;   

            cCodPaisRes := R_DOMI.CodPais; 
            cCodProvRes := R_DOMI.CodEstado;   
            cCodDistRes := R_DOMI.CodCiudad;
            cCodCorrRes := R_DOMI.CodMunicipio;
         EXCEPTION WHEN OTHERS THEN
            NULL;
         END;

         IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,2,','), CRFC) = 'N' THEN
            OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,2,','),   --cTipo_Doc_Identificacion
                                                         CRFC,                                              --cNum_Doc_Identificacion
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,4,','),   --cNombre
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,5,','),   --cApellidoPat
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,6,','),   --cApellidoMat
                                                         NULL,                                              --cApeCasada
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,7,','),   --cSexo
                                                         NULL,                                              --cEstadoCivil
                                                         TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,8,','), 'DD/MM/YYYY'),   --dFecNacimiento
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,13,','),  --cDirecRes
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,14,','),  --cNumInterior
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,15,','),  --cNumExterior
                                                         cCodPaisRes,                                       --cCodPaisRes
                                                         cCodProvRes,  --OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,16,','),  --cCodProvRes
                                                         cCodDistRes,                                       --cCodDistRes       
                                                         cCodCorrRes,                                       --cCodCorrRes
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,18,','),  --cCodPosRes
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,16,','),  --cCodColonia
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,20,','),  --cTelRes
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,21,','),  --cEmail
                                                         OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,19,',')); --cLadaTelRes
            IF LENGTH(CRFC) = 13 THEN
               cTipPersona := 'FISICA';
            ELSE
               cTipPersona := 'MORAL';
            END IF;                                                                     

            UPDATE PERSONA_NATURAL_JURIDICA J SET J.Tipo_Persona        = cTipPersona,
                                                  J.Tipo_Id_Tributaria  = 'RFC',
                                                  J.Num_Tributario      = NVL(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,10,','), 'XAXX010101000'),
                                                  J.Nacionalidad        = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,22,',')
             WHERE  J.Tipo_Doc_Identificacion   = 'RFC'
               AND  J.Num_Doc_Identificacion    = CRFC;
         ELSE 
            UPDATE PERSONA_NATURAL_JURIDICA
               SET CodPaisRes      = cCodPaisRes,
                   CodProvRes      = cCodProvRes,
                   CodDistRes      = cCodDistRes,
                   CodCorrRes      = cCodCorrRes,
                   CodPosRes       = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,18,','),
                   ZipRes          = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,18,','),
                   CodColRes       = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,16,','),
                   DirecRes        = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,13,','),  --cDirecRes
                   NumInterior     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,14,','),  --cNumInterior
                   NumExterior     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,15,','),  --cNumExterior
                   Nacionalidad    = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,22,','),  -- Nacionalidad
                   Num_Tributario  = NVL(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,10,','), 'XAXX010101000')
             WHERE Tipo_Doc_Identificacion   = cTipoDocIdentAseg
               AND Num_Doc_Identificacion    = cNumDocIdentAseg;
         END IF;
        --
         IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'C' AND nIdePol = 1 AND nIdPoliza IS NULL AND OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,23,',') IS NOT NULL THEN
            BEGIN
               SELECT NVL(MAX(IdFormaCobro),0)
                 INTO nIdFormaCobro
                 FROM MEDIOS_DE_COBRO
                WHERE Tipo_Doc_Identificacion  = cTipoDocIdentAseg
                  AND Num_Doc_Identificacion   = cNumDocIdentAseg;
            END;

            IF nIdFormaCobro = 0 THEN 
               nIdFormaCobro := 1;
            ELSE
               nIdFormaCobro := nIdFormaCobro + 1;
            END IF;

            OC_MEDIOS_DE_COBRO.INSERTAR(cTipoDocIdentAseg, cNumDocIdentAseg, nIdFormaCobro, 'S', 'CTC');
            UPDATE MEDIOS_DE_COBRO MD SET MD.CodFormaCobro     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,23,','),
                                          MD.CodEntidadFinan   = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,24,','),
                                          MD.NumCuentaBancaria = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,25,','),
                                          MD.NumCuentaClabe    = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,26,','),
                                          MD.NumTarjeta        = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,27,','),
                                          MD.FechaVencTarjeta  = TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,28,','), 'DD/MM/YYYY'),
                                          MD.NombreTitular     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,29,',')
             WHERE MD.Tipo_Doc_Identificacion   = cTipoDocIdentAseg
               AND MD.Num_Doc_Identificacion    = cNumDocIdentAseg
               AND MD.IdFormaCobro              = nIdFormaCobro;
         END IF;
        --
         IF nIdPoliza IS NULL and OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'C'  THEN
            --
            IF NVL(nCodCliente, 0) = 0 THEN
               nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
               UPDATE CLIENTES CTE  
                  SET TipoCliente = 'BAJO'
                WHERE CTE.CodCliente = nCodCliente;
            END IF;      
         ELSE 
            IF nIdPoliza IS NULL AND OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'A'  THEN                        
               nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
               IF nCod_Asegurado = 0 THEN
                  nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
               END IF;                                      
             --                 
             nIdPoliza := gt_cotizaciones.CREAR_POLIZA(nCodCia,nCodEmpresa, nIdCotizacion, nCodCliente, nCod_Asegurado);
             --   
             --DBMS_OUTPUT.PUT_LINE(nIdPoliza);

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
                     SELECT P.COD_MONEDA, P.COD_AGENTE
                       INTO cCodMoneda, nCodAgente
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
            ----------- SE COMENTA 26/11/2019 NO LO REQUIEREN
            --                               BEGIN
            --                                     SELECT CODVALOR
            --                                       INTO cCodValor
            --                                       FROM VALORES_DE_LISTAS
            --                                       WHERE CODLISTA = 'AGRUPA'
            --                                         AND DESCVALLST = 'PLATAFORMA DIGITAL THONAPI'; 
            --                               EXCEPTION WHEN NO_DATA_FOUND THEN
            --                                     SELECT TRIM(TO_CHAR(TO_NUMBER(MAX(CODVALOR)) + 1, '0000'))
            --                                       INTO cCodValor
            --                                       FROM VALORES_DE_LISTAS
            --                                      WHERE CODLISTA = 'AGRUPA';
            --                                     INSERT INTO VALORES_DE_LISTAS VALUES ('AGRUPA', cCodValor, 'PLATAFORMA DIGITAL THONAPI');
            --                               END;
                   cCodValor := NULL;

                      BEGIN
                        SELECT codvalor
                          INTO cTipoRiesgo
                          FROM valores_de_listas 
                         WHERE codlista = 'TIPRIESG'
                           AND DESCVALLST IN (SELECT distinct 'RIESGO ' || RIESGOTARIFA 
                                                FROM COTIZACIONES_DETALLE d 
                                               WHERE  D.CODCIA = nCodCia 
                                                 AND D.CODEMPRESA = nCodEmpresa 
                                                 AND D.IDCOTIZACION IN (nIdCotizacion));                                  
                      EXCEPTION WHEN OTHERS THEN
                            cTipoRiesgo := null;
                      END;

                 --------------------------------- Comisiones esta dividido en dos etapas, una esta la creacion de la poliza y otra al emitir la poliza
                   IF NVL(nIdCotizacion, 0) <> 0 THEN     
                       IF OC_AGENTES.ES_AGENTE_DIRECTO(nCodCia, nCodAgente) = 'S' THEN
                          wPorcComis1     := 0;
                          wPorcComis2     := 0;
                          wPorcComis3     := 0;
                       ELSE                                                                                                          
                       --Copia Comisiones por nivel a la nueva poliza
                          SELECT C.PorcComisDir,
                                 c.PorcComisProm,
                                 c.PorcComisAgte                                                       
                            INTO wPorcComis1, wPorcComis2, wPorcComis3
                            FROM COTIZACIONES C
                           WHERE C.CODCIA          =   nCodCia
                             AND C.CODEMPRESA      =   nCodEmpresa
                             AND C.IDCOTIZACION    =   nIdCotizacion;
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
                                -- DBMS_OUTPUT.PUT_LINE('wPorcComisTot '||wPorcComisTot);
                          END LOOP;
                       END IF;                                        
                   END IF;                                                      

                 --UPDATE POLIZAS P SET NUMPOLUNICO = cNUMPOLUNICO,

                 UPDATE POLIZAS P SET P.HORAVIGINI   = '12:00',
                                       P.HORAVIGFIN   = '12:00',
                                       P.TIPODIVIDENDO = '003',
                                       --P.IDFORMACOBRO = 1,
                                       P.CODAGRUPADOR = cCodValor,
                                       P.TIPORIESGO   = cTipoRiesgo,
                                       P.CODPLANPAGO = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,33,','),
                                       P.PORCCOMIS   = NVL(wPorcComisTot, 0),
                                       P.IdFormaCobro = nIdFormaCobro
                  WHERE P.CODCIA      = nCodCia
                    AND P.CODEMPRESA  = nCodEmpresa
                    AND P.IDPOLIZA    = nIdPoliza;

                 UPDATE DETALLE_POLIZA P SET P.CODPLANPAGO = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,33,','),
                                                 P.CODCATEGORIA = NULL
                  WHERE P.CODCIA      = nCodCia
                    AND P.CODEMPRESA  = nCodEmpresa
                    AND P.IDPOLIZA    = nIdPoliza;                               

                  EXCEPTION WHEN OTHERS THEN
                    NULL;
                  END;
                  --
                  IF R_NUMREG.EsColectiva = 'N' THEN
                     IF OC_COBERT_ACT.EXISTE_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIdePol) = 'N' THEN
                        GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.EsColectiva);
                     END IF;
                  ELSIF R_NUMREG.EsColectiva = 'S' THEN
                     IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIdePol, nCod_Asegurado) = 'N' THEN
                        GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.EsColectiva);
                     END IF;
                  END IF;                             
                  --GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia,nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.ESCOLECTIVA);
                  --       
            ELSIF nIdPoliza IS NOT NULL AND OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'A' THEN
                nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
                IF nCod_Asegurado = 0 THEN
                    nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
                END IF;     
                --      
                nIdePol := nIdePol + 1;
                IF R_NUMREG.EsColectiva = 'N' THEN
                     IF OC_COBERT_ACT.EXISTE_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIdePol) = 'N' THEN
                        GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.EsColectiva);
                     END IF;
                ELSIF R_NUMREG.EsColectiva = 'S' THEN
                     IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIdePol, nCod_Asegurado) = 'N' THEN
                        GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.EsColectiva);
                     END IF;
                END IF;    
                --GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia,nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.ESCOLECTIVA);
                UPDATE DETALLE_POLIZA D SET D.COD_ASEGURADO = nCod_Asegurado
                 WHERE D.CODCIA        =   nCodCia
                   AND D.CODEMPRESA    =   nCodEmpresa
                   AND D.IDPOLIZA      =   nIdPoliza
                   AND D.IDETPOL       = nIdePol;
            END IF;                    

         END IF;        
        --           
        numBenef := 0;            
        IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,1,',') = 'A' THEN
            FOR N IN 1..10 LOOP
                numBenef := (6 * (N -1)); 
                IF LENGTH(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,41 + numBenef,',')) > 0 THEN
                    begin
                        dBenefFecNAc := to_date(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,42+numBenef,','), 'dd/mm/yyyy');
                    exception when others then null; end;
                    OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPoliza, nIdePol, nCod_Asegurado, 
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,40 + numBenef,','),
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,41 + numBenef,','), 
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,43 + numBenef,','), 
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,44 + numBenef,','), 'N', 
                                                                            dBenefFecNac, 
                                                                            OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.Fila,45 + numBenef,','));
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
           WCODNIVEL                NUMBER :=0;
           WPORPRO                  NUMBER :=0;
           WPORDIST                 NUMBER :=0;    
           nPorc_Com_Proporcional   NUMBER := 0;                
       BEGIN            
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

            IF OC_AGENTES.ES_AGENTE_DIRECTO(nCodCia, nCodAgente) != 'S' THEN
                IF wPorcComisTot = 0 THEN wPorcComisTot := 1; END IF;
                IF wPorcComis3 = 0 THEN wPorcComis3 := 1;     END IF;
            END IF;

            BEGIN
               SELECT TRUNC(ROUND((wPorcComis3 * 100) / wPorcComisTot, 2), 2)
                 INTO nPorc_Com_Proporcional
                 FROM DUAL;
            EXCEPTION 
               WHEN ZERO_DIVIDE THEN
                  nPorc_Com_Proporcional := 0;
            END;

            UPDATE AGENTES_DISTRIBUCION_POLIZA SET  Porc_Com_Distribuida   = wPorcComis3,
                                                    Porc_Com_Proporcional  = nPorc_Com_Proporcional, 
                                                    Porc_Com_Poliza        = wPorcComisTot
             WHERE IdPoliza = nIdPoliza
               AND CODNIVEL = 3
               AND CodCia   = nCodCia;
            IF SQL%ROWCOUNT > 0 THEN
               --wPorcComPropT := wPorcComPropT + TRUNC(ROUND((wPorcComis3 * 100) / wPorcComisTot, 2), 2); 
               wPorcComPropT := wPorcComPropT + nPorc_Com_Proporcional;
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
      SELECT NVL(GastosExpedicion,0)
        INTO nGastosExpedicion
        FROM COTIZACIONES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion;
   END;

   IF nGastosExpedicion = 0 THEN 
      UPDATE POLIZAS
         SET IndCalcDerechoEmis = 'N'
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza;
   END IF;

   BEGIN             -- SE COMENTA, POR EL MOMENTO TODAS LAS POLIZAS QEU VAN A PLD SOLO SE MARCAN PERO SI SE EMITEN                           
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
   --
   GENERALES_PLATAFORMA_DIGITAL.ACTUALIZA_INFORMACION_FISCAL( nCodCia, nCodEmpresa, nIdPoliza, xInformacionFiscal );
   --
   -------PRE EMISION
   OPEN Q_TRAN(nIdPoliza);
   FETCH Q_TRAN INTO R_TRAN;
   nIdTransaccion :=  TO_NUMBER(R_TRAN.IdTransaccion);     
   close Q_TRAN;                       
   OC_POLIZAS.PRE_EMITE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion);
   ----------------

   cFacturas := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA(nCodCia, nIdPoliza);       
   RETURN cFacturas;                          
END PRE_EMITE_POLIZA_NEW_CFDI40; 

/*JACF [28/09/2023] <Se agrega funci√É¬≥n para consultar catalogo de formas de cobro desde las listas de valores>*/
FUNCTION FORMAS_COBRO(LISTA VARCHAR2) RETURN CLOB IS    
        CURSOR Q_FORMA IS            
            SELECT CODLISTA, CODVALOR, DESCVALLST
            FROM VALORES_DE_LISTAS
            WHERE 1 = 1
            AND CODLISTA = LISTA
        ;

         R_FORMA  Q_FORMA%ROWTYPE;
         cHeader VARCHAR2(100);
         FORMAS CLOB;
         OPCION VARCHAR2(100);
    BEGIN   
        OPEN Q_FORMA;
        LOOP
            FETCH Q_FORMA INTO   R_FORMA;   
            EXIT WHEN Q_FORMA%NOTFOUND;
            IF FORMAS IS NULL THEN
               cHeader := 'DATOS';
               FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><'|| cHeader || '>';
            END IF; 
            OPCION := R_FORMA.DESCVALLST;
            FORMAS := FORMAS || '<OPCION valor="'||R_FORMA.CODVALOR||'">'||OPCION||'</OPCION>';
        END LOOP;               
        CLOSE Q_FORMA;   
        FORMAS :=  FORMAS || '</' || cHeader || '>';
        RETURN  FORMAS;      
END FORMAS_COBRO;

END GENERALES_PLATAFORMA_DIGITAL;

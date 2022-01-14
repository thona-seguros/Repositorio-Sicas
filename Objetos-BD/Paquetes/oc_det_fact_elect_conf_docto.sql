--
-- OC_DET_FACT_ELECT_CONF_DOCTO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   NOTAS_DE_CREDITO (Table)
--   MONEDA (Table)
--   PLAN_DE_PAGOS (Table)
--   POLIZAS (Table)
--   OC_DISTRITO (Package)
--   OC_EMPRESAS (Package)
--   OC_EMPRESAS_DE_SEGUROS (Package)
--   OC_FACTURAS (Package)
--   OC_FACT_ELECT_CLAVE_UNIDAD (Package)
--   OC_FACT_ELECT_CONF_DOCTO (Package)
--   OC_FACT_ELECT_DETALLE_TIMBRE (Package)
--   OC_FACT_ELECT_FORMA_PAGO (Package)
--   OC_FACT_ELECT_SERIES_FOLIOS (Package)
--   CORREGIMIENTO (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_FACT_ELECT_CONF_DOCTO (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_TRANSACCION (Package)
--   PAGOS (Table)
--   PAGO_DETALLE (Table)
--   PAIS (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   ASEGURADO (Table)
--   PROVINCIA (Table)
--   OC_CORREGIMIENTO (Package)
--   OC_DETALLE_FACTURAS (Package)
--   OC_DETALLE_NOTAS_DE_CREDITO (Package)
--   CAMBIA_ACENTOS (Function)
--   CLIENTES (Table)
--   COLONIA (Table)
--   TASAS_CAMBIO (Table)
--   OC_MONEDA (Package)
--   OC_PAIS (Package)
--   OC_PERSONA_NATURAL_JURIDICA (Package)
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--   OC_COLONIA (Package)
--   DETALLE_POLIZA (Table)
--   DIRECCIONES_PNJ (Table)
--   DISTRITO (Table)
--   FACTURAS (Table)
--   FACT_ELECT_CONF_DOCTO (Table)
--   FACT_ELECT_SERIES_FOLIOS (Table)
--   OC_PROVINCIA (Package)
--   TIPOS_DE_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DET_FACT_ELECT_CONF_DOCTO IS

    FUNCTION  EXTRAE_VALOR_ATRIBUTO(cLinea IN VARCHAR2,cCodAtributo IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION  GENERA_VALOR_ATRIBUTO (nIdFactura IN NUMBER,nIdNcr IN NUMBER DEFAULT NULL,nCodCia IN NUMBER,nCodEmpresa IN NUMBER,
                                        cProceso IN VARCHAR2,cCodIdLinea IN VARCHAR2,cCodAtributo IN VARCHAR2,
                                        cTipoCfdi IN VARCHAR2,cCodCpto IN VARCHAR2 DEFAULT NULL, cCodRutinaCalc VARCHAR2,
                                        cIndRelaciona VARCHAR2) RETURN VARCHAR2;

END OC_DET_FACT_ELECT_CONF_DOCTO;
/
--
-- OC_DET_FACT_ELECT_CONF_DOCTO  (Package Body) 
--
--  Dependencies: 
--   OC_DET_FACT_ELECT_CONF_DOCTO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DET_FACT_ELECT_CONF_DOCTO IS

    FUNCTION  EXTRAE_VALOR_ATRIBUTO(cLinea IN VARCHAR2,cCodAtributo IN VARCHAR2) RETURN VARCHAR2 IS
        cValorAtributo   DETALLE_FACT_ELECT_CONF_DOCTO.ValorAtributo%TYPE;
        cSubCadIdLinea   VARCHAR2(1000);
        cSubCadAtrib     VARCHAR2(300);
        cSeparaAtrib     VARCHAR2(2) := '||';
        cSeparaValorAtr  VARCHAR2(1) := '|';
    BEGIN
        cSubCadIdLinea:= SUBSTR(cLinea,INSTR(cLinea,cCodAtributo,1),LENGTH(cLinea));
        cSubCadAtrib  := SUBSTR(cSubCadIdLinea,1,INSTR(cSubCadIdLinea,cSeparaAtrib,1) - 1);
        cValorAtributo:= SUBSTR(cSubCadAtrib,INSTR(cSubCadAtrib,cSeparaValorAtr,1) + 1,LENGTH(cSubCadAtrib));
        RETURN cValorAtributo;
    END EXTRAE_VALOR_ATRIBUTO;
    --
    --
    FUNCTION  GENERA_VALOR_ATRIBUTO (nIdFactura IN NUMBER,nIdNcr IN NUMBER DEFAULT NULL,nCodCia IN NUMBER,nCodEmpresa IN NUMBER,
                                        cProceso IN VARCHAR2,cCodIdLinea IN VARCHAR2,cCodAtributo IN VARCHAR2,
                                        cTipoCfdi IN VARCHAR2,cCodCpto IN VARCHAR2 DEFAULT NULL, cCodRutinaCalc VARCHAR2,
                                        cIndRelaciona VARCHAR2) RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : ??                                                                                                               |
    | Email      : ??                                                                                                               |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: ??                                                                                                               |    
	| Nombre     : GENERA_VALOR_ATRIBUTO                                                                                            |
    | Objetivo   : Funcion que genera el valor de los atributos de acuerdo con los valores recibidos.                               |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 10/01/2022                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx / alvalle007@hotmail.com                                                                  |
    |                                                                                                                               |
    | Obj. Modif.: Modificar y colocar la Fecha de Pago correcta, dado que para esta se tomaba la misma fecha de timbrado de la     |
    |              factura.                                                                                                         |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nIdFactura          Numero de Recibo o Factura.     (Entrada)                                                       |
    |           nIdNcr              ID de la Nota de Credito.       (Entrada)                                                       |
    |			nCodCia				Codigo de la Compañia	        (Entrada)                                                       |
    |			nCodEmpresa			Codigo de la Empresa	        (Entrada)                                                       |
    |           cProceso            Proceso                         (Entrada)                                                       |
    |           cCodIdLinea         Codigo del ID de Linea          (Entrada)                                                       |
    |           cCodAtributo        Codigo del Atributo             (Entrada)                                                       |
    |           cTipoCfdi           Tipo del CFDI                   (Entrada)                                                       |
    |           cCodCpto            Codigo de Concepto              (Entrada)                                                       |
    |           cCodRutinaCalc      Codigo de rutina de calculo     (Entrada)                                                       |
    |           cIndRelaciona       Indicador de Relaciona          (Entrada)                                                       |
    |_______________________________________________________________________________________________________________________________|
*/                                        
        cValorAtributo          DETALLE_FACT_ELECT_CONF_DOCTO.ValorAtributo%TYPE := NULL;
        cTipoComprobante        VARCHAR2(1);
        cSerie                  FACT_ELECT_SERIES_FOLIOS.Serie%TYPE;
        nSubTotal               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
        nTotal                  FACTURAS.Monto_Fact_Local%TYPE;
        cCodMoneda              MONEDA.Cod_Moneda%TYPE;
        nTasaCambio             TASAS_CAMBIO.Tasa_Cambio%TYPE;
        cCodCliente             FACTURAS.CodCliente%TYPE;
        cTipoDocIdentificacion  PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
        cNumDocIdentificacion   PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
        cNombrePersona          PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
        cApePaterno             PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;
        cApeMaterno             PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;
        dFecNac                 PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
        cTipoPersona            PERSONA_NATURAL_JURIDICA.Tipo_Persona%TYPE;
        nIdDirecAviCob          DETALLE_POLIZA.IdDirecAviCob%TYPE;
        nIdPoliza               POLIZAS.IdPoliza%TYPE;
        nIdDetPol               DETALLE_POLIZA.IDetPol%TYPE;
        cCodPaisRes             PAIS.CodPais%TYPE;
        cCodProvRes             PROVINCIA.CodEstado%TYPE;
        cCodDistRes             DISTRITO.CodCiudad%TYPE;
        cCodCorrRes             CORREGIMIENTO.CodMunicipio%TYPE;
        cCodPosRes              PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE;
        cCodColRes              COLONIA.Codigo_Colonia%TYPE;
        cNumExterior            PERSONA_NATURAL_JURIDICA.NumExterior%TYPE;
        cNumInterior            PERSONA_NATURAL_JURIDICA.NumInterior%TYPE;
        cDescColonia            COLONIA.Descripcion_Colonia%TYPE;
        DescMunicipio           CORREGIMIENTO.DescMunicipio%TYPE;
        cDescCiudad             DISTRITO.DescCiudad%TYPE;
        cDescEstado             PROVINCIA.DescEstado%TYPE;
        cDescPais               PAIS.DescPais%TYPE;
        cDirecRes               VARCHAR2(500);
        cIdTipoSeg              TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
        nIdTransaccion          FACTURAS.IdTransaccion%TYPE;
        nIdTransaccionAnu       FACTURAS.IdTransaccionAnu%TYPE;
        cDescripcion            VARCHAR2(1000);
        nIdEndoso               FACTURAS.IdEndoso%TYPE;
        cCodImpto               FACT_ELECT_CONF_DOCTO.CodCptoImpto%TYPE;
        cTipoFactor             VARCHAR2(10);
        cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
        nMontoPago              PAGOS.Monto%TYPE;
        cNumDocPago             PAGOS.NumDoc%TYPE;
        cFormaPago              PAGOS.FormPago%TYPE;
        dFecPago                DATE;
        dFecTransaccion         DATE;
        cLeyendaEsp             VARCHAR2(1000) :=  NULL;
        --nIdEndoso               FACTURAS.IdEndoso%TYPE;
        cCodPlanPagos           PLAN_DE_PAGOS.CodPlanPago%TYPE;
        nIdProceso              FACTURAS.IdProceso%TYPE;        --> JALV(+) 10/01/2022
        cIndDomiciliado         FACTURAS.IndDomiciliado%TYPE;   --> JALV(+) 10/01/2022
        dFecha_Pago             DATE;                           --> JALV(+) 10/01/2022
        dFecha_Pago_CM          DATE;                           --> JALV(+) 10/01/2022
        cIndPlataforma          VARCHAR2(1);

    BEGIN
        IF NVL(nIdFactura,0) != 0 AND cProceso IN ('EMI','PAG') THEN
            IF cProceso = 'PAG' THEN
                cTipoComprobante := 'P';
            ELSE
                cTipoComprobante := 'I';
            END IF;
            BEGIN
                SELECT Cod_Moneda,Tasa_Cambio,CodCliente,
                       Tipo_Doc_Identificacion,Num_Doc_Identificacion,
                       IdPoliza,IDetpol,IdTransaccion,
                       IdTransaccionAnu,IdEndoso,FecPago,
                       ReciboPago, IdProceso, IndDomiciliado    --> JALV(+) 10/01/2022
                  INTO cCodMoneda,nTasaCambio,cCodCliente,
                       cTipoDocIdentificacion,cNumDocIdentificacion,
                       nIdPoliza,nIdDetPol,nIdTransaccion,
                       nIdTransaccionAnu,nIdEndoso,dFecPago,
                       dFecha_Pago, nIdProceso, cIndDomiciliado    --> JALV(+) 10/01/2022
                  FROM (
                        SELECT F.Cod_Moneda,F.Tasa_Cambio,F.CodCliente,
                               C.Tipo_Doc_Identificacion,C.Num_Doc_Identificacion,
                               F.IdPoliza,F.IDetpol,F.IdTransaccion,
                               F.IdTransaccionAnu,IdEndoso,F.FecPago,
                               ReciboPago, IdProceso, IndDomiciliado    --> JALV(+) 10/01/2022
                          FROM FACTURAS F,POLIZAS PO,CLIENTES C
                         WHERE F.CodCia             = nCodCia
                           AND F.IdFactura          = nIdFactura
                           AND F.IndFactElectronica = 'S'
                           AND PO.IndFacturaPol     = 'S'
                           AND F.FecEnvFactElec     IS NULL
                           AND F.CodUsuarioEnvFact  = 'XENVIAR'
                           AND F.CodCliente         = C.CodCliente
                           AND PO.CodCia            = F.CodCia
                           AND PO.IdPoliza          = F.IdPoliza
                         UNION
                        SELECT F.Cod_Moneda,F.Tasa_Cambio,PO.CodCliente,
                               P.Tipo_Doc_Identificacion,P.Num_Doc_Identificacion,
                               F.IdPoliza,F.IDetpol,F.IdTransaccion,
                               F.IdTransaccionAnu,IdEndoso,F.FecPago,
                               ReciboPago, IdProceso, IndDomiciliado    --> JALV(+) 10/01/2022
                          FROM FACTURAS F, POLIZAS PO, DETALLE_POLIZA D, ASEGURADO A, PERSONA_NATURAL_JURIDICA P
                         WHERE P.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
                           AND P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
                           AND A.Cod_Asegurado      = D.Cod_Asegurado
                           AND D.CodCia             = F.CodCia
                           AND D.IdPoliza           = F.IdPoliza
                           AND D.IDetPol            = F.IDetPol
                           AND PO.IndFacturaPol     = 'N'
                           AND PO.CodCia            = F.CodCia
                           AND PO.IdPoliza          = F.IdPoliza
                           AND F.CodCia             = nCodCia
                           AND F.IdFactura          = nIdFactura
                           AND F.IndFactElectronica = 'S'
                           AND F.CodUsuarioEnvFact  = 'XENVIAR'
                           AND F.FecEnvFactElec     IS NULL);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar Datos Generales De Factura Para Generacion De Informacion Al SAT Favor De Verificar');
            END;
        ELSIF NVL(nIdNcr,0) != 0 THEN
            cTipoComprobante := 'E';
            BEGIN
                SELECT CodMoneda,Tasa_Cambio,CodCliente,
                       Tipo_Doc_Identificacion,Num_Doc_Identificacion,
                       IdPoliza,IDetPol,IdTransaccion,
                       IdTransaccionAnu,FecPago
                  INTO cCodMoneda,nTasaCambio,cCodCliente,
                       cTipoDocIdentificacion,cNumDocIdentificacion,
                       nIdPoliza,nIdDetPol,nIdTransaccion,
                       nIdTransaccionAnu,dFecPago
                  FROM (
                        SELECT N.CodMoneda,N.Tasa_Cambio,N.CodCliente,
                               C.Tipo_Doc_Identificacion,C.Num_Doc_Identificacion,
                               N.IdPoliza,N.IDetpol,N.IdTransaccion,
                               N.IdTransaccionAnu,NULL FecPago
                          FROM NOTAS_DE_CREDITO N,POLIZAS PO,CLIENTES C
                         WHERE N.CodCia             = nCodCia
                           AND N.IdNcr              = nIdNcr
                           AND N.IndFactElectronica = 'S'
                           AND PO.IndFacturaPol     = 'S'
                           AND N.FecEnvFactElec     IS NULL
                           AND N.CodUsuarioEnvFact  = 'XENVIAR'
                           AND N.CodCliente         = C.CodCliente
               AND PO.CodCia            = N.CodCia
               AND PO.IdPoliza          = N.IdPoliza
                         UNION
                        SELECT N.CodMoneda,N.Tasa_Cambio,PO.CodCliente,
                               P.Tipo_Doc_Identificacion,P.Num_Doc_Identificacion,
                               N.IdPoliza,N.IDetpol,N.IdTransaccion,
                               N.IdTransaccionAnu,NULL FecPago
                          FROM NOTAS_DE_CREDITO N, POLIZAS PO, DETALLE_POLIZA D, ASEGURADO A, PERSONA_NATURAL_JURIDICA P
                         WHERE P.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
                           AND P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
                           AND A.Cod_Asegurado      = D.Cod_Asegurado
                           AND D.CodCia             = N.CodCia
                           AND D.IdPoliza           = N.IdPoliza
                           AND D.IDetPol            = N.IDetPol
                           AND PO.IndFacturaPol     = 'N'
                           AND PO.CodCia            = N.CodCia
                           AND PO.IdPoliza          = N.IdPoliza
                           AND N.CodCia             = nCodCia
                           AND N.IdNcr              = nIdNcr
                           AND N.IndFactElectronica = 'S'
                           AND N.CodUsuarioEnvFact  = 'XENVIAR'
                           AND N.FecEnvFactElec     IS NULL);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar Datos Generales De Nota De Credito  Para Generacion De Informacion Al SAT Favor De Verificar');
            END;
        END IF;

        ----DATOS GENERALES DE POLIZA
        BEGIN
            SELECT DirecRes,CodPaisRes,CodProvRes,CodDistRes,CodCorrRes,
                   CodPosRes,CodColRes,NumInterior,NumExterior,IdDirecAviCob,
                   IdTipoSeg, NumPolUnico
              INTO cDirecRes,cCodPaisRes,cCodProvRes,cCodDistRes,cCodCorrRes,
                   cCodPosRes,cCodColRes,cNumInterior,cNumExterior,nIdDirecAviCob,
                   cIdTipoSeg, cNumPolUnico
              FROM (
                   SELECT DISTINCT REPLACE(REPLACE(P.DirecRes,CHR(13),' '),CHR(10),' ') DirecRes, P.CodPaisRes, P.CodProvRes, P.CodDistRes, P.CodCorrRes,
                          P.CodPosRes, P.CodColRes,P.NumInterior, P.NumExterior,0 IdDirecAviCob, D.IdTipoSeg, PO.NumPolUnico
                     FROM POLIZAS PO, DETALLE_POLIZA D,
                          CLIENTES C, PERSONA_NATURAL_JURIDICA P
                    WHERE PO.IdPoliza               = nIdPoliza
                      AND PO.IndFacturaPol          = 'S'
                      AND PO.CodCia                 = nCodCia
                      AND C.CodCliente              = cCodCliente
                      AND PO.CodCliente             = C.CodCliente
                      AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                      AND P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                      AND PO.IdPoliza               = D.IdPoliza
                    UNION
                   SELECT DISTINCT
                          REPLACE(P.DirecRes,CHR(13),' ') DirecRes, P.CodPaisRes, P.CodProvRes, P.CodDistRes,P.CodCorrRes,
                          P.CodPosRes, P.CodColRes, P.NumInterior, P.NumExterior,NVL(D.IdDirecAviCob,0) IdDirecAviCob, D.IdTipoSeg, PO.NumPolUnico
                     FROM POLIZAS PO, DETALLE_POLIZA D,
                          ASEGURADO A, PERSONA_NATURAL_JURIDICA P
                    WHERE D.IdPoliza                = nIdPoliza
                      AND D.IDetPol                 = nIdDetPol
                      AND PO.IndFacturaPol          = 'N'
                      AND PO.CodCia                 = nCodCia
                      AND P.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
                      AND P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
                      AND A.Cod_Asegurado           = D.Cod_Asegurado
                      AND D.CodCia                  = PO.CodCia
                      AND PO.IdPoliza               = D.IdPoliza
                   );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar Datos Generales De Póliza Para Generacion De Informacion Al SAT Favor De Verificar');
        END;

        ---DATOS GENERALES DEL PAGO SI EL PROCESO ES DE PAGO
        IF cProceso = 'PAG' THEN
            BEGIN
                SELECT DISTINCT NVL(P.Moneda,'PS'),NVL(P.Tasa_Cambio,1),P.Monto,
                       P.NumDoc,P.FormPago
                  INTO cCodMoneda,nTasaCambio,nMontoPago,
                       cNumDocPago,cFormaPago
                  FROM PAGOS P,PAGO_DETALLE PD
                 WHERE P.IdFactura  = PD.IdFactura
                   AND P.IdRecibo   = PD.IdRecibo
                   AND P.IdFactura  = nIdFactura
                   AND P.FecAnulacion IS NULL;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20225,'No es posible determinar la moneda para el pago de la factura '||nIdFactura||' Por favor valide el pago');
            END;
        END IF;
        --- DATOS DE UBICACION
        IF cCodIdLinea = 'DOR' THEN
            IF nIdDirecAviCob = 0 THEN
                cDescColonia    := OC_COLONIA.DESCRIPCION_COLONIA(cCodPaisRes, cCodProvRes, cCodDistRes, cCodCorrRes,
                                                                  cCodPosRes, cCodColRes);
                cDescCiudad     := OC_DISTRITO.NOMBRE_DISTRITO(cCodPaisRes, cCodProvRes, cCodDistRes); ---LOCALIDAD
                DescMunicipio   := OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(cCodPaisRes, cCodProvRes, cCodDistRes, cCodCorrRes);
                cDescEstado     := OC_PROVINCIA.NOMBRE_PROVINCIA(cCodPaisRes, cCodProvRes);
                cDescPais       := OC_PAIS.NOMBRE_PAIS(cCodPaisRes);
                cDirecRes       := cDirecRes;
                cCodPosRes      := cCodPosRes;
                cNumExterior    := cNumExterior;
                cNumInterior    := cNumInterior;
            ELSE
                BEGIN
                   SELECT REPLACE(REPLACE(Direccion,CHR(13),' '),CHR(10),' ') DirecRes,
                          NumExterior, NumInterior, Codigo_Postal,
                          OC_COLONIA.DESCRIPCION_COLONIA(CodPais, CodEstado, CodCiudad, CodMunicipio, Codigo_Postal, CodAsentamiento) Colonia,
                          OC_DISTRITO.NOMBRE_DISTRITO(CodPais, CodEstado, CodCiudad) CiudadLocalidad,
                          OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(CodPais, CodEstado, CodCiudad, CodMunicipio) Municipio,
                          OC_PROVINCIA.NOMBRE_PROVINCIA(CodPais, CodEstado) Estado,
                          OC_PAIS.NOMBRE_PAIS(CodPais)
                     INTO cDirecRes,cNumExterior,cNumInterior,cCodPosRes,
                          cDescColonia,cDescCiudad,DescMunicipio,cDescEstado,cDescPais
                     FROM DIRECCIONES_PNJ D
                    WHERE Tipo_Doc_Identificacion = cTipoDocIdentificacion
                      AND Num_Doc_Identificacion  = cNumDocIdentificacion
                      AND Correlativo_Direccion   = nIdDirecAviCob;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      cDirecRes     := NULL;
                      cNumExterior  := NULL;
                      cNumInterior  := NULL;
                      cCodPosRes    := NULL;
                      cDescColonia  := NULL;
                      cDescCiudad   := NULL; --LOCALIDAD
                      DescMunicipio := NULL;
                      cDescEstado   := NULL;
                      cDescPais     := NULL;
                END;
            END IF;
        ELSIF cCodIdLinea = 'CONIT' OR cCodIdLinea = 'TRA' THEN
            cCodImpto := OC_FACT_ELECT_CONF_DOCTO.CONCEPTO_IMPUESTO(nCodCia, cProceso ,cCodIdLinea);
        END IF;

        CASE cCodRutinaCalc
            WHEN 'COMVAL01' THEN
                NULL;
            WHEN 'COMVAL02' THEN
                cValorAtributo := OC_FACT_ELECT_SERIES_FOLIOS.SERIE(nCodCia,cTipoCfdi,cTipoComprobante);
            WHEN 'COMVAL03' THEN
                cSerie         := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaCom,'serie');
                cValorAtributo := TO_CHAR(OC_FACT_ELECT_SERIES_FOLIOS.FOLIO(nCodCia,cTipoCfdi,cTipoComprobante,cSerie));
            WHEN 'COMVAL04' THEN
                cValorAtributo := TO_CHAR(SYSDATE,'yyyy-mm-dd')||'T'||TO_CHAR((SYSDATE - 10 / (24 * 60)),'HH:MI:SS');
            WHEN 'COMVAL05' THEN
                NULL; --- ESTE CAMPO ES FIJO EN LA CONFIGURACION
            WHEN 'COMVAL06' THEN
                NULL; ---ESTE CAMPO ES FIJO EN LA CONFIGURACION
            WHEN 'COMVAL07' THEN
                IF  cTipoComprobante = 'P' THEN
                    nSubTotal := 0;
                ELSIF cTipoComprobante = 'I' THEN
                    SELECT NVL(SUM(DF.Monto_Det_Moneda),0) --NVL(SUM(DF.Monto_Det_Local),0)
                      INTO nSubTotal
                      FROM FACTURAS F,DETALLE_FACTURAS DF
                     WHERE F.Codcia    = nCodCia
                       AND F.IdFactura = nIdFactura
                       AND F.IdFactura = DF.IdFactura
                       AND DF.CodCpto  NOT IN ('IVASIN','DCTEMI');
                ELSIF cTipoComprobante = 'E' THEN
                    SELECT NVL(SUM(DN.Monto_Det_Moneda),0) --NVL(SUM(DN.Monto_Det_Local),0)
                      INTO nSubTotal
                      FROM NOTAS_DE_CREDITO N,DETALLE_NOTAS_DE_CREDITO DN
                     WHERE N.IdNcr     = nIdNcr
                       AND N.IdNcr     = DN.IdNcr
                       AND DN.CodCpto NOT IN ('IVASIN','DCTEMI');
                END IF;
                IF nSubTotal = 0 AND cTipoComprobante != 'P' THEN
                    cValorAtributo := NULL;
                ELSIF cTipoComprobante = 'P' THEN
                    cValorAtributo := TRIM(TO_CHAR(nSubTotal,'9999999999999999999999990.99'));
                ELSE
                    cValorAtributo := TRIM(TO_CHAR(nSubTotal,'9999999999999999999999990.99'));
                END IF;
            WHEN 'COMVAL08' THEN
                NULL;
            WHEN 'COMVAL09' THEN
                cValorAtributo := OC_MONEDA.CODIGO_FACTURACION_ELECTRONICA(cCodMoneda);
            WHEN 'COMVAL10' THEN
                IF cCodMoneda != 'PS' THEN
                    cValorAtributo := TO_CHAR(nTasaCambio);
                END IF;
            WHEN 'COMVAL11' THEN
                IF  cTipoComprobante = 'P' THEN
                    nTotal := 0;
                ELSIF cTipoComprobante = 'I' THEN
                    SELECT NVL(SUM(F.Monto_Fact_Moneda),0)--NVL(SUM(F.Monto_Fact_Local),0)
                      INTO nTotal
                      FROM FACTURAS F
                     WHERE F.Codcia    = nCodCia
                       AND F.IdFactura = nIdFactura;
                ELSIF cTipoComprobante = 'E' THEN
                    SELECT NVL(SUM(N.Monto_Ncr_Moneda),0)--NVL(SUM(N.Monto_Ncr_Local),0)
                      INTO nTotal
                      FROM NOTAS_DE_CREDITO N
                     WHERE N.IdNcr     = nIdNcr;
                END IF;
                IF nTotal = 0 AND cTipoComprobante != 'P' THEN
                    cValorAtributo := NULL;
                ELSIF cTipoComprobante = 'P' THEN
                    cValorAtributo := TRIM(TO_CHAR(nTotal,'9999999999999999999999990.99'));
                ELSE
                    cValorAtributo := TRIM(TO_CHAR(nTotal,'9999999999999999999999990.99'));
                END IF;
            WHEN 'COMVAL12' THEN
                cValorAtributo := cTipoComprobante;
            WHEN 'COMVAL13' THEN
                NULL; -- ESTE CAMPO ES FIJO EN LA CONFIGURACION, EN CASO DE CAMBIO HABRA QUE PROGRAMAR AQUI LAS CONDICIONES
            WHEN 'COMVAL14' THEN
                NULL;
            WHEN 'COMVAL15' THEN
                NULL;
            WHEN 'COMVAL16' THEN
                NULL;
            WHEN 'EXEVAL01' THEN
                NULL;
            WHEN 'EXEVAL02' THEN
                NULL;
            WHEN 'EXEVAL03' THEN
                NULL;
            WHEN 'EXEVAL04' THEN
                NULL;
            WHEN 'EXEVAL05' THEN
                NULL;
            WHEN 'EXEVAL06' THEN
                NULL;
            WHEN 'EXEVAL07' THEN
                NULL;
            WHEN 'EXEVAL08' THEN
                NULL;
            WHEN 'EXEVAL09' THEN
                NULL;
            WHEN 'CRELSVAL01' THEN
                NULL;
            WHEN 'CRELVAL01' THEN
                IF cProceso = 'PAG' AND NVL(nIdFactura,0) != 0 THEN
                    cValorAtributo := OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'); -- CUANDO SE PAGA SE BUSCA EL UUID DE EMISION
                    IF cValorAtributo IS NULL THEN
                        RAISE_APPLICATION_ERROR(-20225,'No Es Posible Generar El Timbre De Pago Ya Que No Existe Un UUID De Emisión De La Factura'||nIdFactura||' Por Favor Emita La Facturación Electrónica Para La Emisión Del Recibo');
                    END IF;
                END IF;
            WHEN 'REFVAL01' THEN
                cValorAtributo := OC_EMPRESAS.REGIMEN_FISCAL_FECT_ELECT(nCodCia);
            WHEN 'RECVAL01' THEN
--                IF cTipoDocIdentificacion = 'RFC' THEN
--                    cValorAtributo := cNumDocIdentificacion;
--                ELSE
                    BEGIN
                        SELECT Num_Tributario
                          INTO cValorAtributo
                          FROM PERSONA_NATURAL_JURIDICA
                         WHERE Tipo_Doc_Identificacion = cTipoDocIdentificacion
                           AND Num_Doc_Identificacion  = cNumDocIdentificacion;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            RAISE_APPLICATION_ERROR(-20225,'No es posible identificar el nombre de la persona con la identificacion '||TRIM(cTipoDocIdentificacion)||'-'||TRIM(cNumDocIdentificacion));
                    END;
                --END IF;
                BEGIN
                    SELECT Tipo_Persona
                      INTO cTipoPersona
                      FROM PERSONA_NATURAL_JURIDICA
                     WHERE Tipo_Doc_Identificacion = cTipoDocIdentificacion
                       AND Num_Doc_Identificacion  = cNumDocIdentificacion;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determianr El Tipo De Persona Con La Identificacion '||TRIM(cTipoDocIdentificacion)||'-'||TRIM(cNumDocIdentificacion));
                END;
                IF cTipoPersona = 'FISICA' AND LENGTH(cValorAtributo) != 13 AND cValorAtributo != 'XAXX010101000' THEN
                    RAISE_APPLICATION_ERROR(-20225,'El RFC '||TRIM(cValorAtributo)||' No Cumpe Con La Longitud Requerida Para Personas Físicas, Por Favor Complemente El Rfc Del Cliente O Genere La Facturación Con El Rfc Generico');
                ELSIF cTipoPersona = 'MORAL' AND LENGTH(cValorAtributo) != 12 AND cValorAtributo != 'XAXX010101000' THEN
                    RAISE_APPLICATION_ERROR(-20225,'El RFC '||TRIM(cValorAtributo)||' No Cumpe Con La Longitud Requerida Para Personas Moral, Por Favor Complemente El Rfc Del Cliente O Genere La Facturación Con El Rfc Generico');
                END IF;
                cValorAtributo := REPLACE(cValorAtributo,CHR(38),CHR(38)||'amp;');
            WHEN 'RECVAL02' THEN
                cValorAtributo := REPLACE(CAMBIA_ACENTOS(OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion,cNumDocIdentificacion)),CHR(38),CHR(38)||'amp;');
                --cValorAtributo := CAMBIA_ACENTOS(OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion,cNumDocIdentificacion));
            WHEN 'RECVAL03' THEN
                NULL;
            WHEN 'RECVAL04' THEN
                NULL;
            WHEN 'RECVAL05' THEN
                NULL;
            WHEN 'DORVAL01' THEN
                cValorAtributo := CAMBIA_ACENTOS(cDirecRes);
            WHEN 'DORVAL02' THEN
                cValorAtributo := cNumExterior;
            WHEN 'DORVAL03' THEN
                cValorAtributo := cNumInterior;
            WHEN 'DORVAL04' THEN
                IF cDescColonia = 'NO EXISTE' THEN
                    cValorAtributo := NULL;
                ELSE
                    cValorAtributo := CAMBIA_ACENTOS(cDescColonia);
                END IF;
            WHEN 'DORVAL05' THEN
                IF cDescCiudad = 'DISTRITO NO EXISTE' THEN
                    cValorAtributo := NULL;
                ELSE
                    cValorAtributo := CAMBIA_ACENTOS(cDescCiudad);
                END IF;
            WHEN 'DORVAL06' THEN
                IF DescMunicipio = 'CORREGIMIENTO NO EXISTE' THEN
                    cValorAtributo := NULL;
                ELSE
                    cValorAtributo := CAMBIA_ACENTOS(DescMunicipio);
                END IF;
            WHEN 'DORVAL07' THEN
                cValorAtributo := cDescEstado;
            WHEN 'DORVAL08' THEN
                cValorAtributo := OC_PAIS.CODIGO_ALTERNATIVO(cCodPaisRes);
            WHEN 'DORVAL09' THEN
                cValorAtributo := cCodPosRes;
            WHEN 'CONVAL01' THEN
                cValorAtributo := OC_TIPOS_DE_SEGUROS.CLAVE_FACT_ELECTRONICA(nCodCia,nCodEmpresa,cIdTipoSeg);
            WHEN 'CONVAL02' THEN
                NULL;
            WHEN 'CONVAL03' THEN
                NULL;
            WHEN 'CONVAL04' THEN
                cValorAtributo := OC_FACT_ELECT_CLAVE_UNIDAD.CLAVE_UNIDAD(nCodCia,OC_TIPOS_DE_SEGUROS.CLAVE_FACT_ELECTRONICA(nCodCia,nCodEmpresa,cIdTipoSeg));
                IF cValorAtributo = '0' THEN
                    cValorAtributo := NULL;
                END IF;
            WHEN 'CONVAL05' THEN
                cValorAtributo := cCodCpto;
            WHEN 'CONVAL06' THEN
                dFecTransaccion := OC_TRANSACCION.FECHATRANSACCION(nIdTransaccion);
                IF NVL(nIdFactura,0) != 0 THEN
                    IF cProceso = 'PAG' THEN
                        IF TO_CHAR(dFecPago,'YYYY') = '2017' THEN
                            cLeyendaEsp := ' PRIMAS DE SEGUROS RECIBIDAS EN EL PERIODO FISCAL 2017';
                        END IF;
                    ELSIF cProceso = 'EMI' THEN
                        IF TO_CHAR(dFecTransaccion,'YYYY') = '2017' THEN
                            cLeyendaEsp := ' QUE FUE EMITIDO EN EL PERIODO FISCAL 2017';
                        END IF;
                    END IF;
                    IF cCodCpto = 'PRISEG' THEN
                        cDescripcion := ' '||cNumPolUnico||' RECIBO '||nIdFactura||OC_FACTURAS.DESC_COMPLEMENTARIA_FACT_ELECT(nIdFactura,nCodCia)||cLeyendaEsp;
                    ELSE
                        cDescripcion := ' '||cLeyendaEsp;
                    END IF;
                    IF cProceso = 'PAG' THEN
                        cValorAtributo := 'Pago'||cDescripcion;
                    ELSE
                        cValorAtributo := CAMBIA_ACENTOS(OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia,cCodCpto)||cDescripcion);
                    END IF;
                ELSIF NVL(nIdNcr,0) != 0 THEN
                    IF cProceso = 'EMI' THEN
                        IF TO_CHAR(dFecTransaccion,'YYYY') = '2017' THEN
                            cLeyendaEsp := ' QUE FUE EMITIDO EN EL PERIODO FISCAL 2017';
                        END IF;
                    END IF;
                    IF cCodCpto = 'PRISEG' THEN
                        cDescripcion := ' '||cNumPolUnico||' NOTA DE CREDITO '||nIdNcr||cLeyendaEsp;
                    ELSE
                        cDescripcion := ' '||cLeyendaEsp;
                    END IF;
                    cValorAtributo := CAMBIA_ACENTOS(OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia,cCodCpto)||cDescripcion);
                END IF;
            WHEN 'CONVAL07' THEN
                IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodCpto),'9999999999999999999999990.99'));
                ELSIF NVL(nIdNcr,0) != 0 THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr, cCodCpto),'9999999999999999999999990.99'));
                END IF;
                IF cValorAtributo = '0' THEN
                    cValorAtributo := NULL;
                END IF;
            WHEN 'CONVAL08' THEN
                IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodCpto),'9999999999999999999999990.99'));
                ELSIF NVL(nIdNcr,0) != 0 THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr, cCodCpto),'9999999999999999999999990.99'));
                END IF;
                IF cValorAtributo = '0' THEN
                    cValorAtributo := NULL;
                END IF;
            WHEN 'CONVAL09' THEN
                NULL;
            WHEN 'CONVAL10' THEN
                NULL;
            WHEN 'CONITVAL01' THEN
                IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodCpto),'9999999999999999999999990.99'));
                ELSIF NVL(nIdNcr,0) != 0 THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr, cCodCpto),'9999999999999999999999990.99'));
                END IF;
                IF cValorAtributo = '0' THEN
                    cValorAtributo := NULL;
                END IF;
            WHEN 'CONITVAL02' THEN
                -- AGREGAR CODIGO DE FACTURACION ELECTRONICA A CATALOGO DE CONCEPTOS AL IMPUESTO IVASIN
                NULL;
            WHEN 'CONITVAL03' THEN
                IF OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto) <> 0 THEN
                    cValorAtributo := 'Tasa'; ---hacer dinamico
                END IF;
            WHEN 'CONITVAL04' THEN
                cTipoFactor := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaConit,'TipoFactor');
                IF cTipoFactor = 'Tasa' THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto)/100,'9999999999999999999999990.99'));
                END IF;
            WHEN 'CONITVAL05' THEN
                IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_IMPUESTO_FACT_ELECT(nIdFactura,cCodCpto),'9999999999999999999999990.99'));
                ELSIF NVL(nIdNcr,0) != 0 THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_IMPUESTO_FACT_ELECT(nIdNcr,cCodCpto),'9999999999999999999999990.99'));
                END IF;
                IF cValorAtributo = '0' THEN
                    cValorAtributo := NULL;
                END IF;
            WHEN 'CONIRVAL01' THEN
                NULL;
            WHEN 'CONIRVAL02' THEN
                NULL;
            WHEN 'CONIRVAL03' THEN
                NULL;
            WHEN 'CONIRVAL04' THEN
                NULL;
            WHEN 'CONIRVAL05' THEN
                NULL;
            WHEN 'CUPVAL01' THEN
                NULL;
            WHEN 'INADVAL01' THEN
                NULL;
            WHEN 'RETVAL01' THEN
                NULL;
            WHEN 'RETVAL02' THEN
                NULL;
            WHEN 'TRAVAL01' THEN
                -- AGREGAR CODIGO DE FACTURACION ELECTRONICA A CATALOGO DE CONCEPTOS AL IMPUESTO IVASIN
                NULL;
            WHEN 'TRAVAL02' THEN
                IF OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto) <> 0 THEN
                    cValorAtributo := 'Tasa'; ---hacer dinamico
                END IF;
            WHEN 'TRAVAL03' THEN
                cTipoFactor := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaConit,'TipoFactor');
                IF cTipoFactor = 'Tasa' THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto)/100,'9999999999999999999999990.99'));
                END IF;
            WHEN 'TRAVAL04' THEN
                IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodImpto),'9999999999999999999999990.99'));
                ELSIF NVL(nIdNcr,0) != 0 THEN
                    cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr,cCodImpto),'9999999999999999999999990.99'));
                END IF;
            WHEN 'ADIVAL01' THEN
                cValorAtributo := cNumPolUnico;
            WHEN 'ADIVAL02' THEN
                NULL;
            WHEN 'ADIVAL03' THEN
                cValorAtributo := OC_EMPRESAS_DE_SEGUROS.NOMBRE_EMPRESA(nCodCia,nCodEmpresa);
            WHEN 'ADIVAL04' THEN
                cValorAtributo := OC_EMPRESAS_DE_SEGUROS.TELEFONO(nCodCia,nCodEmpresa);
            WHEN 'ADIVAL05' THEN
                cValorAtributo := OC_EMPRESAS_DE_SEGUROS.FAX(nCodCia,nCodEmpresa);
            WHEN 'ADIVAL06' THEN
                cValorAtributo := OC_EMPRESAS_DE_SEGUROS.EMAIL(nCodCia,nCodEmpresa);
            WHEN 'ADIVAL07' THEN
                cValorAtributo := OC_EMPRESAS.SITIO_WEB(nCodCia);
                IF cValorAtributo = 'SIN PAGINA WEB' THEN
                    cValorAtributo := NULL;
                END IF;
            WHEN 'PAGSVAL01' THEN
                NULL;
            WHEN 'PAGSVAL02' THEN
               BEGIN
                  SELECT 'S'
                    INTO cIndPlataforma
                    FROM POLIZAS P, COTIZACIONES C
                   WHERE P.CodCia               = C.CodCia
                     AND P.CodEmpresa           = C.CodEmpresa
                     AND P.Num_Cotizacion       = C.IdCotizacion
                     AND P.IdPoliza             = C.IdPoliza
                     AND P.CodCia               = nCodCia
                     AND P.CodEmpresa           = nCodEmpresa
                     AND P.IdPoliza             = nIdPoliza
                     AND C.IndCotizacionWeb     = 'S'
                     AND C.IndCotizacionBaseWeb = 'N';
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN 
                     cIndPlataforma := 'N';
               END;
                --cValorAtributo := TO_CHAR(SYSDATE,'yyyy-mm-dd')||'T'||TO_CHAR(SYSDATE,'hh:mm:ss');    --> JALV (-) 10/01/2022
                --> Inicia: JALV (-) 10/01/2022
                
              IF nIdProceso IS NOT NULL AND cIndDomiciliado = 'S' THEN
                  --Tomar campo indicado en COBRANZA MASIVA
                  SELECT  FechaCobro  --FecAplica 
                    INTO  dFecha_Pago_CM
                    FROM  DETALLE_DOMICI_REFERE
                   WHERE   idFactura = nIdFactura;
                  
                  cValorAtributo := TO_CHAR(dFecha_Pago_CM,'yyyy-mm-dd')||'T'||TO_CHAR(dFecha_Pago_CM,'hh:mm:ss');
              ELSIF NVL(cIndPlataforma,'N') = 'S' THEN
                  cValorAtributo := TO_CHAR(dFecPago,'yyyy-mm-dd')||'T'||TO_CHAR(dFecPago,'hh:mm:ss');
              ELSE
                  --Tomar dato de indicado en COBRANZA MANUAL
                  cValorAtributo := TO_CHAR(dFecha_Pago,'yyyy-mm-dd')||'T'||TO_CHAR(dFecha_Pago,'hh:mm:ss');
              END IF;
                --> Fin JALV (-) 10/01/2022
            WHEN 'PAGSVAL03' THEN
                cValorAtributo := OC_FACT_ELECT_FORMA_PAGO.FORMA_PAGO_FACT_ELECT(nCodCia,cFormaPago);
            WHEN 'PAGSVAL04' THEN
                cValorAtributo := OC_MONEDA.CODIGO_FACTURACION_ELECTRONICA(cCodMoneda);
            WHEN 'PAGSVAL05' THEN
                IF cCodMoneda != 'PS' THEN
                    cValorAtributo := TRIM(TO_CHAR(nTasaCambio,'9999999999999999999999990.99'));
                END IF;
            WHEN 'PAGSVAL06' THEN
                cValorAtributo := TRIM(TO_CHAR(nMontoPago,'9999999999999999999999990.99'));
            WHEN 'PAGSVAL07' THEN
                cValorAtributo := REPLACE(cNumDocPago,'/','');
            WHEN 'PAGSVAL08' THEN
                NULL;
            WHEN 'PAGSVAL09' THEN
                NULL;
            WHEN 'PAGSVAL10' THEN
                NULL;
            WHEN 'PAGSVAL11' THEN
                NULL;
            WHEN 'PAGSVAL12' THEN
                NULL;
            WHEN 'PAGSVAL13' THEN
                NULL;
            WHEN 'PAGSVAL14' THEN
                NULL;
            WHEN 'PAGSVAL15' THEN
                NULL;
            WHEN 'PAGSVAL16' THEN
                NULL;
            WHEN 'PAGSDOCRELVAL01' THEN
                cValorAtributo := OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'); -- CUANDO SE PAGA SE BUSCA EL UUID DE EMISION
                IF cValorAtributo IS NULL THEN
                    RAISE_APPLICATION_ERROR(-20225,'No Es Posible Generar El Timbre De Pago Ya Que No Existe Un UUID De Emisión De La Factura'||nIdFactura||' Por Favor Emita La Facturación Electrónica Para La Emisión Del Recibo');
                END IF;
            WHEN 'PAGSDOCRELVAL02' THEN
                cValorAtributo :=  OC_FACT_ELECT_DETALLE_TIMBRE.SERIE(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'));
            WHEN 'PAGSDOCRELVAL03' THEN
                cValorAtributo := OC_FACT_ELECT_DETALLE_TIMBRE.FOLIO_FISCAL(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'));
            WHEN 'PAGSDOCRELVAL04' THEN
                cValorAtributo := OC_MONEDA.CODIGO_FACTURACION_ELECTRONICA(cCodMoneda);
            WHEN 'PAGSDOCRELVAL05' THEN
                NULL;
            WHEN 'PAGSDOCRELVAL06' THEN
                NULL;
            WHEN 'PAGSDOCRELVAL07' THEN
                NULL;
            WHEN 'PAGSDOCRELVAL08' THEN
                SELECT NVL(TRIM(TO_CHAR(Monto_Fact_Local,'9999999999999999999999990.99')),'0.00')
                  INTO cValorAtributo
                  FROM FACTURAS
                 WHERE IdFactura = nIdFactura;
            WHEN 'PAGSDOCRELVAL09' THEN
                cValorAtributo := TRIM(TO_CHAR(nMontoPago,'9999999999999999999999990.99'));
            WHEN 'PAGSDOCRELVAL10' THEN
                cValorAtributo := TRIM(TO_CHAR(TO_NUMBER(OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsDocRel,'ImpSaldoAnt')) - TO_NUMBER(OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsDocRel,'ImpPagado')),'9999999999999999999999990.99'));
        END CASE;
        RETURN RTRIM(LTRIM(TO_CHAR(cValorAtributo)));
    END GENERA_VALOR_ATRIBUTO;

END OC_DET_FACT_ELECT_CONF_DOCTO;
/

--
-- OC_DET_FACT_ELECT_CONF_DOCTO  (Synonym) 
--
--  Dependencies: 
--   OC_DET_FACT_ELECT_CONF_DOCTO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_DET_FACT_ELECT_CONF_DOCTO FOR SICAS_OC.OC_DET_FACT_ELECT_CONF_DOCTO
/


GRANT EXECUTE ON SICAS_OC.OC_DET_FACT_ELECT_CONF_DOCTO TO PUBLIC
/

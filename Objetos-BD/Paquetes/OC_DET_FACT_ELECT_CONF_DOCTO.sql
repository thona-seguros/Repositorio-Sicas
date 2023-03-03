CREATE OR REPLACE PACKAGE OC_DET_FACT_ELECT_CONF_DOCTO IS

-- HOMOLOGACION VIFLEX                                      20220301 JMMD

FUNCTION  EXTRAE_VALOR_ATRIBUTO(cLinea IN VARCHAR2,cCodAtributo IN VARCHAR2) RETURN VARCHAR2;
FUNCTION  GENERA_VALOR_ATRIBUTO (nIdFactura IN NUMBER,nIdNcr IN NUMBER DEFAULT NULL,nCodCia IN NUMBER,nCodEmpresa IN NUMBER,
                                  cProceso IN VARCHAR2,cCodIdLinea IN VARCHAR2,cCodAtributo IN VARCHAR2,
                                  cTipoCfdi IN VARCHAR2,cCodCpto IN VARCHAR2 DEFAULT NULL, cCodRutinaCalc VARCHAR2,
                                  cIndRelaciona VARCHAR2, cCodTipoPlan VARCHAR2 DEFAULT NULL, cIndExentoImp VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

END OC_DET_FACT_ELECT_CONF_DOCTO;
/
CREATE OR REPLACE PACKAGE BODY OC_DET_FACT_ELECT_CONF_DOCTO IS

-- HOMOLOGACION VIFLEX                                      20220301 JMMD

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
                                  cIndRelaciona VARCHAR2, cCodTipoPlan VARCHAR2 DEFAULT NULL, cIndExentoImp VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
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
dFecha_Pago             VARCHAR(50);                           --> JALV(+) 10/01/2022
dFecha_Pago_CM          DATE;                           --> JALV(+) 10/01/2022
cIndPlataforma          VARCHAR2(1);
cCrel                   VARCHAR2(500);
nIndFactCteRfcGenerico  FACTURAS.IndFactCteRfcGenerico%TYPE;
cIndFacturaPol          POLIZAS.IndFacturaPol%TYPE;
cCodObjetoImp           POLIZAS.CodObjetoImp%TYPE;
cCodUsoCFDI             POLIZAS.CodUsoCFDI%TYPE;
nIdRegFisSat            PERSONA_NATURAL_JURIDICA.IdRegFisSat%TYPE;
cNum_Tributario         PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
cUuid                   FACT_ELECT_DETALLE_TIMBRE.Uuid%TYPE;
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
                ReciboPago, IdProceso, IndDomiciliado,    --> JALV(+) 10/01/2022
                IndFactCteRfcGenerico
           INTO cCodMoneda,nTasaCambio,cCodCliente,
                cTipoDocIdentificacion,cNumDocIdentificacion,
                nIdPoliza,nIdDetPol,nIdTransaccion,
                nIdTransaccionAnu,nIdEndoso,dFecPago,
                dFecha_Pago, nIdProceso, cIndDomiciliado,    --> JALV(+) 10/01/2022
                nIndFactCteRfcGenerico
           FROM (
                 SELECT F.Cod_Moneda,F.Tasa_Cambio, DECODE(NVL(IndFactCteRfcGenerico,'N'), 'S', F.CodCliRfcGenerico, F.CodCliente) CodCliente,
                        C.Tipo_Doc_Identificacion,C.Num_Doc_Identificacion,
                        F.IdPoliza,F.IDetpol,F.IdTransaccion,
                        F.IdTransaccionAnu,IdEndoso,F.FecPago,
                        ReciboPago, IdProceso, IndDomiciliado,    --> JALV(+) 10/01/2022
                        F.IndFactCteRfcGenerico
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
                        ReciboPago, IdProceso, IndDomiciliado,    --> JALV(+) 10/01/2022
                        F.IndFactCteRfcGenerico
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
  
   IF NVL(nIndFactCteRfcGenerico,'N') = 'S' THEN
      BEGIN
         SELECT C.Tipo_Doc_Identificacion, C.Num_Doc_Identificacion
           INTO cTipoDocIdentificacion, cNumDocIdentificacion
           FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P 
          WHERE C.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
            AND C.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
            AND C.CodCliente              = cCodCliente;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'Error: NO se puede determinar datos de cliente para facturación de venta al publico en general');
      END;
   END IF;
   ----DATOS GENERALES DE POLIZA
   BEGIN
      SELECT DirecRes,CodPaisRes,CodProvRes,CodDistRes,CodCorrRes,
             CodPosRes,CodColRes,NumInterior,NumExterior,IdDirecAviCob,
             IdTipoSeg, NumPolUnico, IndFacturaPol
        INTO cDirecRes,cCodPaisRes,cCodProvRes,cCodDistRes,cCodCorrRes,
             cCodPosRes,cCodColRes,cNumInterior,cNumExterior,nIdDirecAviCob,
             cIdTipoSeg, cNumPolUnico, cIndFacturaPol
        FROM (
             SELECT DISTINCT REPLACE(REPLACE(P.DirecRes,CHR(13),' '),CHR(10),' ') DirecRes, P.CodPaisRes, P.CodProvRes, P.CodDistRes, P.CodCorrRes,
                    P.CodPosRes, P.CodColRes,P.NumInterior, P.NumExterior,0 IdDirecAviCob, D.IdTipoSeg, PO.NumPolUnico, PO.IndFacturaPol
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
                    P.CodPosRes, P.CodColRes, P.NumInterior, P.NumExterior,NVL(D.IdDirecAviCob,0) IdDirecAviCob, D.IdTipoSeg, PO.NumPolUnico, PO.IndFacturaPol
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
      BEGIN
         SELECT REPLACE(REPLACE(Direccion,CHR(13),' '),CHR(10),' ') DirecRes,
                NumExterior, NumInterior, Codigo_Postal,
                OC_COLONIA.DESCRIPCION_COLONIA(CodPais, CodEstado, CodCiudad, CodMunicipio, Codigo_Postal, CodAsentamiento) Colonia,
                OC_DISTRITO.NOMBRE_DISTRITO(CodPais, CodEstado, CodCiudad) CiudadLocalidad,
                OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(CodPais, CodEstado, CodCiudad, CodMunicipio) Municipio,
                OC_PROVINCIA.NOMBRE_PROVINCIA(CodPais, CodEstado) Estado,
                OC_PAIS.NOMBRE_PAIS(CodPais),
                CodPais
           INTO cDirecRes,cNumExterior,cNumInterior,cCodPosRes,
                cDescColonia,cDescCiudad,DescMunicipio,cDescEstado,cDescPais,
                cCodPaisRes
           FROM DIRECCIONES_PNJ D
          WHERE Tipo_Doc_Identificacion   = cTipoDocIdentificacion
            AND Num_Doc_Identificacion    = cNumDocIdentificacion
          --AND Correlativo_Direccion   = nIdDirecAviCob;
            AND Tipo_Direccion            = 'FISCAL';
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
      /*IF nIdDirecAviCob = 0 THEN
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
                --AND Correlativo_Direccion   = nIdDirecAviCob;
                AND Tipo_Direccion    = 'FISCAL';
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
      END IF;*/
   --ELSIF cCodIdLinea = 'CONIT' OR cCodIdLinea = 'TRA' THEN
   ELSIF cCodIdLinea IN ('CONIT', 'TRA', 'PAGSPDOCIMTRA', 'PAGSPIMTRA')THEN
      cCodImpto := OC_FACT_ELECT_CONF_DOCTO.CONCEPTO_IMPUESTO(nCodCia, cProceso ,cCodIdLinea);
   END IF;
   
   ---RFC
   BEGIN
      SELECT Num_Tributario
        INTO cNum_Tributario
        FROM PERSONA_NATURAL_JURIDICA
       WHERE Tipo_Doc_Identificacion = cTipoDocIdentificacion
         AND Num_Doc_Identificacion  = cNumDocIdentificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No es posible identificar el RFC de la persona con la identificacion '||TRIM(cTipoDocIdentificacion)||'-'||TRIM(cNumDocIdentificacion));
   END;
   

   CASE cCodRutinaCalc
      WHEN 'COMVAL01' THEN
         NULL;
      WHEN 'COMVAL02' THEN
         cValorAtributo := OC_FACT_ELECT_SERIES_FOLIOS.SERIE(nCodCia,cTipoCfdi,cTipoComprobante);
      WHEN 'COMVAL03' THEN
         cSerie         := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaCom,'serie');
         cValorAtributo := TO_CHAR(OC_FACT_ELECT_SERIES_FOLIOS.FOLIO(nCodCia,cTipoCfdi,cTipoComprobante,cSerie));
      WHEN 'COMVAL04' THEN
         cValorAtributo := TO_CHAR(SYSDATE,'yyyy-mm-dd')||'T'||TO_CHAR((SYSDATE - 10 / (24 * 60)),'HH24:MI:SS');
      WHEN 'COMVAL05' THEN
         NULL; --- ESTE CAMPO ES FIJO EN LA CONFIGURACION
      WHEN 'COMVAL06' THEN
         IF cNum_Tributario != 'XAXX010101000' THEN
            cValorAtributo := 'EFECTOS FISCALES AL PAGO';
         ELSE
            cValorAtributo := NULL;
         END IF;--EFECTOS FISCALES AL PAGO
      WHEN 'COMVAL07' THEN
         IF cTipoComprobante = 'P' THEN
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
         IF cTipoComprobante = 'P' THEN
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
         NULL;
      WHEN 'COMVAL14' THEN
         IF cNum_Tributario != 'XAXX010101000' THEN
            cValorAtributo := 'PPD';
         ELSE
            cValorAtributo := 'PUE';
         END IF;--EFECTOS FISCALES AL PAGO
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
      WHEN 'IGLVAL01' THEN
         NULL; --cValorAtributo := '04';
      WHEN 'IGLVAL02' THEN
         SELECT TO_CHAR(LPAD(EXTRACT(MONTH FROM SYSDATE),2,'0')) INTO cValorAtributo FROM DUAL;
      WHEN 'IGLVAL03' THEN
         SELECT TO_CHAR(EXTRACT(YEAR FROM SYSDATE)) INTO cValorAtributo FROM DUAL;
      WHEN 'CRELSVAL01' THEN
         IF cProceso = 'EMI' AND NVL(nIdFactura,0) != 0 THEN
              -- CAPELEXX
              -- SE BUSCA SI EXISTE RELACION DE UNA FACTURA QUE SERA REMPLAZADAPOR UNA ANULACIÓN
            IF OC_FACTURAS.FACTURA_RELACIONADA_UUID_CANC(nCodCia, nIdFactura) IS NOT NULL THEN
               cValorAtributo := '04';
            END IF;
         END IF;
      WHEN 'CRELVAL01' THEN
         IF cProceso = 'PAG' AND NVL(nIdFactura,0) != 0 THEN                
            cValorAtributo := OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'); -- CUANDO SE PAGA SE BUSCA EL UUID DE EMISION
            IF cValorAtributo IS NULL THEN
               RAISE_APPLICATION_ERROR(-20225,'No Es Posible Generar El Timbre De Pago Ya Que No Existe Un UUID De Emisión De La Factura'||nIdFactura||' Por Favor Emita La Facturación Electrónica Para La Emisión Del Recibo');
            END IF;
         ELSIF cProceso = 'EMI' AND NVL(nIdFactura,0) != 0 THEN
            cCrel := OC_FACTURAS.FACTURA_RELACIONADA_UUID_CANC(nCodCia, nIdFactura);
            IF cCrel IS NOT NULL THEN                        
               cValorAtributo := cCrel;                        
            END IF;
         END IF;
      WHEN 'EMIVAL01' THEN
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
         --DBMS_OUTPUT.PUT_LINE(OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc'));
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc') LIKE '%XAXX010101000%' THEN
            cValorAtributo := 'PUBLICO EN GENERAL';
         ELSE
            cValorAtributo := REPLACE(CAMBIA_ACENTOS(OC_PERSONA_NATURAL_JURIDICA.RAZON_SOCIAL_FACT(cTipoDocIdentificacion,cNumDocIdentificacion)),CHR(38),CHR(38)||'amp;');
         END IF;
          --cValorAtributo := CAMBIA_ACENTOS(OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion,cNumDocIdentificacion));
      WHEN 'RECVAL03' THEN
         NULL;
      WHEN 'RECVAL04' THEN
         --- SI FACTURA POR POLIZA ENTONCES TOMA EL VALOR DEL USO DE CFDI DE LA POLIZA, SI FACTURA POR SUB GRUPO TOMARÁ EL VALOR DEL USO DEL CFDI
         --- DEL SUB GRUPO CORRESPONDIENTE DEL RECIBO Y/O NOTA DE CREDITO
         
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc') LIKE '%XAXX010101000%' THEN
            cCodUsoCFDI := 'S01';
         ELSE
            IF NVL(cIndFacturaPol,'N') = 'S' THEN
               BEGIN
                  SELECT NVL(CodUsoCFDI,'G03')
                    INTO cCodUsoCFDI
                    FROM POLIZAS
                   WHERE CodCia     = nCodCia
                     AND CodEmpresa = nCodEmpresa
                     AND IdPoliza   = nIdPoliza;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determianr el Uso de CFDI para la póliza '||cNumPolUnico||', Por favor valide la información en la póliza');
               END;
            ELSIF NVL(cIndFacturaPol,'N') = 'N' THEN
               BEGIN
                  SELECT NVL(CodUsoCFDI,'G03')
                    INTO cCodUsoCFDI
                    FROM DETALLE_POLIZA
                   WHERE CodCia     = nCodCia
                     AND CodEmpresa = nCodEmpresa
                     AND IdPoliza   = nIdPoliza
                     AND IDetPol    = nIdDetPol;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determianr el Uso de CFDI para la póliza '||cNumPolUnico||' Sub Grupo '||nIdDetPol||', Por favor valide la información en la póliza y sub geupo correspondiente');
               END;
            END IF;
         END IF;
         cValorAtributo := cCodUsoCFDI; 
      WHEN 'RECVAL05' THEN
         ---- REGIMEN CONTRIBUYENTE RECEPTOR
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc') LIKE '%XAXX010101000%' THEN
            cValorAtributo := TO_CHAR(616); --- HACER DINAMICO, PARA VENTA AL PUBLICO EN GENERAL EL REGIMEN DEBE SER EL 616
         ELSE         
            nIdRegFisSat:= OC_PERSONA_NATURAL_JURIDICA.REGIMEN_FISCAL(cTipoDocIdentificacion,cNumDocIdentificacion);
            IF nIdRegFisSat != 0 THEN
               cValorAtributo := TO_CHAR(nIdRegFisSat);
            ELSE
               RAISE_APPLICATION_ERROR(-20225,'Cliente no tiene asignado el régimen fiscal, por favor complemente la información del cliente y vuelve a generar la factura');
            END IF;
         END IF;
      WHEN 'RECVAL06' THEN
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
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc') LIKE '%XAXX010101000%' THEN
            cValorAtributo := TO_CHAR(54910); --- hacer dinamico, si se genera factura para venta al publico en general el CP debe ser el del emisor
         ELSE
            cValorAtributo := cCodPosRes;
         END IF;
      WHEN 'CONVAL01' THEN
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc') LIKE '%XAXX010101000%' THEN
            cValorAtributo := '01010101';
         ELSE
            cValorAtributo := OC_TIPOS_DE_SEGUROS.CLAVE_FACT_ELECTRONICA(nCodCia,nCodEmpresa,cIdTipoSeg, cCodTipoPlan);
         END IF;
      WHEN 'CONVAL02' THEN
         cValorAtributo := cCodCpto;
         /*IF NVL(nIdFactura,0) != 0 THEN
            cValorAtributo := TO_CHAR(nIdFactura);
         ELSIF NVL(nIdNcr,0) != 0 THEN
            cValorAtributo := TO_CHAR(nIdNcr);
         END IF;*/
      WHEN 'CONVAL03' THEN
         NULL;
      WHEN 'CONVAL04' THEN
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc') LIKE '%XAXX010101000%' THEN
            cValorAtributo := 'ACT';
         ELSE
            cValorAtributo := OC_FACT_ELECT_CLAVE_UNIDAD.CLAVE_UNIDAD(nCodCia,OC_TIPOS_DE_SEGUROS.CLAVE_FACT_ELECTRONICA(nCodCia,nCodEmpresa,cIdTipoSeg, cCodTipoPlan));
            IF cValorAtributo = '0' THEN
               cValorAtributo := NULL;
            END IF;
         END IF;
      WHEN 'CONVAL05' THEN
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc') LIKE '%XAXX010101000%' THEN
            cValorAtributo := NULL;
         ELSE 
            cValorAtributo := cCodCpto;
         END IF;
      WHEN 'CONVAL06' THEN
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaRec, 'rfc') LIKE '%XAXX010101000%' THEN
            cValorAtributo := 'Venta';
         ELSE
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
         END IF;
      WHEN 'CONVAL07' THEN
         IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
            cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodCpto, cCodTipoPlan),'9999999999999999999999990.99'));
         ELSIF NVL(nIdNcr,0) != 0 THEN
            cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr, cCodCpto),'9999999999999999999999990.99'));
         END IF;
         IF cValorAtributo = '0' THEN
            cValorAtributo := NULL;
         END IF;
      WHEN 'CONVAL08' THEN
         IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
            cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodCpto, cCodTipoPlan),'9999999999999999999999990.99'));
         ELSIF NVL(nIdNcr,0) != 0 THEN
            cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr, cCodCpto),'9999999999999999999999990.99'));
         END IF;
         IF cValorAtributo = '0' THEN
            cValorAtributo := NULL;
         END IF;
      WHEN 'CONVAL09' THEN
         NULL;
      WHEN 'CONVAL10' THEN
          --- OBJETO DE IMPUESTO
          --- SI LA POLIZA FACTURA POR POLIZA, ENTONCES SE TOMA OBJETO DE IMPUESTO DE LA POLIZA
          --- SI LA POLIZA FACTURA POR SUBGRUPO, ENTONCES SE TOMA EL OBJETO DE IMPUESTO DEL SUBGRUPO CORRESPONDIENTE AL RECIBO QUE SE ESTÁ FACTURANDO
         IF NVL(cIndFacturaPol,'N') = 'S' THEN
            BEGIN
               SELECT NVL(CodObjetoImp,'02')
                 INTO cCodObjetoImp
                 FROM POLIZAS
                WHERE CodCia     = nCodCia
                  AND CodEmpresa = nCodEmpresa
                  AND IdPoliza   = nIdPoliza;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determianr el Uso de CFDI para la póliza '||cNumPolUnico||', Por favor valide la información en la póliza');
            END;
         ELSIF NVL(cIndFacturaPol,'N') = 'N' THEN
            BEGIN
               SELECT NVL(CodObjetoImp,'02')
                 INTO cCodObjetoImp
                 FROM DETALLE_POLIZA
                WHERE CodCia     = nCodCia
                  AND CodEmpresa = nCodEmpresa
                  AND IdPoliza   = nIdPoliza
                  AND IDetPol    = nIdDetPol;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determianr el Uso de CFDI para la póliza '||cNumPolUnico||' Sub Grupo '||nIdDetPol||', Por favor valide la información en la póliza y sub geupo correspondiente');
            END;
         END IF;
         cValorAtributo := cCodObjetoImp; 
      WHEN 'CONVAL11' THEN
         NULL;
      WHEN 'CONVAL12' THEN
         NULL;
      WHEN 'PAGSTVAL01' THEN
         cValorAtributo := NULL; --LTRIM(TO_CHAR(0,'9999999999999999999990D90'));
      WHEN 'PAGSTVAL02' THEN
         cValorAtributo := NULL; --LTRIM(TO_CHAR(0,'9999999999999999999990D90'));
      WHEN 'PAGSTVAL03' THEN
         cValorAtributo := NULL; --LTRIM(TO_CHAR(0,'9999999999999999999990D90'));
      WHEN 'PAGSTVAL04' THEN
         IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nIdTransaccion, 'IVASIN') = 'N' THEN -- cCodCpto)
            cValorAtributo := NULL;
         ELSE
            --cUuid := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc,'IdDocumento');
            SELECT TO_CHAR(SUM(DF.Monto_Det_Moneda), '9999999999999999999990D90')
              INTO cValorAtributo
              FROM FACTURAS F, DETALLE_FACTURAS DF, FACT_ELECT_DETALLE_TIMBRE D
             WHERE F.IdFactura         = nIdFactura
               AND F.CodCia            = nCodCia
               --AND D.Uuid              = cUuid
               AND D.CodRespuestaSat   = '201'
               AND D.CodProceso        = 'EMI'
               AND F.IdFactura         = DF.IdFactura
               AND F.CodCia            = D.CodCia
               AND F.IdFactura         = D.IdFactura
               AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(D.CodCia, D.CodEmpresa, D.IdFactura, D.IdNcr, D.Uuid) = 'N'
               AND DF.CodCpto         != 'IVASIN';
         END IF;
      WHEN 'PAGSTVAL05' THEN
         IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nIdTransaccion, 'IVASIN') = 'N' THEN -- cCodCpto)
            cValorAtributo := NULL;
         ELSE
            cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, 'IVASIN', cCodTipoPlan),'9999999999999999999999990.99'));
         END IF;
      WHEN 'PAGSTVAL06' THEN
         cValorAtributo := NULL; --LTRIM(TO_CHAR(0,'9999999999999999999990D90'));
      WHEN 'PAGSTVAL07' THEN
         cValorAtributo := NULL; --LTRIM(TO_CHAR(0,'9999999999999999999990D90'));
      WHEN 'PAGSTVAL08' THEN
         cValorAtributo := NULL; --LTRIM(TO_CHAR(0,'9999999999999999999990D90'));
      WHEN 'PAGSTVAL09' THEN
         cValorAtributo := NULL; --LTRIM(TO_CHAR(0,'9999999999999999999990D90'));
      WHEN 'PAGSTVAL10' THEN
         IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nIdTransaccion, 'IVASIN') = 'S' THEN -- cCodCpto)
            cValorAtributo := NULL;
         ELSE
            --cUuid := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc,'IdDocumento');
            SELECT TO_CHAR(SUM(DF.Monto_Det_Moneda), '9999999999999999999990D90')
              INTO cValorAtributo
              FROM FACTURAS F, DETALLE_FACTURAS DF, FACT_ELECT_DETALLE_TIMBRE D
             WHERE F.IdFactura         = nIdFactura
               AND F.CodCia            = nCodCia
               --AND D.Uuid              = cUuid
               AND D.CodRespuestaSat   = '201'
               AND D.CodProceso        = 'EMI'
               AND F.IdFactura         = DF.IdFactura
               AND F.CodCia            = D.CodCia
               AND F.IdFactura         = D.IdFactura
               AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(D.CodCia, D.CodEmpresa, D.IdFactura, D.IdNcr, D.Uuid) = 'N'
               AND DF.CodCpto         != 'IVASIN';
         END IF;
      WHEN 'PAGSTVAL11' THEN
         --cUuid := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc,'IdDocumento');
         SELECT TO_CHAR(SUM(DF.Monto_Det_Moneda), '9999999999999999999990D90')
           INTO cValorAtributo
           FROM FACTURAS F, DETALLE_FACTURAS DF, FACT_ELECT_DETALLE_TIMBRE D
          WHERE F.IdFactura         = nIdFactura
            AND F.CodCia            = nCodCia
            --AND D.Uuid              = cUuid
            AND D.CodRespuestaSat   = '201'
            AND D.CodProceso        = 'EMI'
            AND F.IdFactura         = DF.IdFactura
            AND F.CodCia            = D.CodCia
            AND F.IdFactura         = D.IdFactura
            AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(D.CodCia, D.CodEmpresa, D.IdFactura, D.IdNcr, D.Uuid) = 'N'
            --AND DF.CodCpto         != 'IVASIN'
            ;
      WHEN 'CONITVAL01' THEN
         IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' /*AND cCodCpto != 'EXENTO'*/ THEN
            cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodCpto, cCodTipoPlan),'9999999999999999999999990.99'));
            --cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodImpto, cCodTipoPlan),'9999999999999999999999990.99'));
         ELSIF NVL(nIdNcr,0) != 0 /*AND cCodCpto != 'EXENTO'*/ THEN
            cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr, cCodCpto),'9999999999999999999999990.99'));
            --cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr, cCodImpto),'9999999999999999999999990.99'));
         END IF;
         IF cValorAtributo = '0' THEN
            cValorAtributo := NULL;
         END IF;
      WHEN 'CONITVAL02' THEN
         -- AGREGAR CODIGO DE FACTURACION ELECTRONICA A CATALOGO DE CONCEPTOS AL IMPUESTO IVASIN
         NULL;
      WHEN 'CONITVAL03' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := 'Exento';
         ELSE
            IF OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto) <> 0 THEN
               cValorAtributo := 'Tasa'; ---hacer dinamico
            END IF;
         END IF;
      WHEN 'CONITVAL04' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := NULL;
         ELSE
            cTipoFactor := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaConit,'TipoFactor');
            IF cTipoFactor = 'Tasa' THEN
               cValorAtributo := TRIM(TO_CHAR(OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto)/100,'9999999999999999999999990.99'));
            END IF;
         END IF;
      WHEN 'CONITVAL05' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := NULL;
         ELSE
            IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
               cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_IMPUESTO_FACT_ELECT(nIdFactura,cCodCpto, cCodTipoPlan),'9999999999999999999999990.99'));
            ELSIF NVL(nIdNcr,0) != 0 THEN
               cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_IMPUESTO_FACT_ELECT(nIdNcr,cCodCpto),'9999999999999999999999990.99'));
            END IF;
            IF cValorAtributo = '0' THEN
               cValorAtributo := NULL;
            END IF;
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
         IF NVL(nIdFactura,0) != 0 THEN
            cValorAtributo := TO_CHAR(OC_FACTURAS.MONTO_BASE_IMPUESTO(nCodCia, nIdFactura));
         ELSE
            cValorAtributo := TO_CHAR(OC_NOTAS_DE_CREDITO.MONTO_BASE_IMPUESTO(nCodCia, nIdNcr));
            DBMS_OUTPUT.PUT_LINE(cValorAtributo);
         END IF;
      WHEN 'TRAVAL02' THEN
          -- AGREGAR CODIGO DE FACTURACION ELECTRONICA A CATALOGO DE CONCEPTOS AL IMPUESTO IVASIN
         NULL;
      WHEN 'TRAVAL03' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN  
            cValorAtributo := 'Exento';
         ELSE
            IF OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto) <> 0 THEN
               cValorAtributo := 'Tasa'; ---hacer dinamico
            END IF;
         END IF;
      WHEN 'TRAVAL04' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := NULL;
         ELSE
            cTipoFactor := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaConit,'TipoFactor');
            IF cTipoFactor = 'Tasa' THEN
               cValorAtributo := TRIM(TO_CHAR(OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto)/100,'9999999999999999999999990.99'));
            END IF;
         END IF;
      WHEN 'TRAVAL05' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := NULL;
         ELSE
            IF NVL(nIdFactura,0) != 0 AND cProceso = 'EMI' THEN
               cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodImpto, cCodTipoPlan),'9999999999999999999999990.99'));
            ELSIF NVL(nIdNcr,0) != 0 THEN
               cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_NOTAS_DE_CREDITO.MONTO_CONCEPTO_FACT_ELECT(nIdNcr,cCodImpto),'9999999999999999999999990.99'));
            END IF;
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
      /*WHEN 'ADIVAL07' THEN --  PARA LA VERSION 4.0 YA NO APLICA
          cValorAtributo := OC_EMPRESAS.SITIO_WEB(nCodCia);
          IF cValorAtributo = 'SIN PAGINA WEB' THEN
              cValorAtributo := NULL;
          END IF;*/
      WHEN 'PAGSPVAL01' THEN
         NULL;
      WHEN 'PAGSPVAL02' THEN
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
   
         IF nIdProceso IS NOT NULL OR NVL(cIndDomiciliado,'N') = 'S' THEN
            --Tomar campo indicado en COBRANZA MASIVA
            SELECT  FechaCobro  --FecAplica
              INTO  dFecha_Pago_CM
              FROM  DETALLE_DOMICI_REFERE
             WHERE  idFactura = nIdFactura
               AND  ESTADO    = 'PAG';   -- 31/03/2022 SE AGREGO ESTA CONDICION 
                      
            cValorAtributo := TO_CHAR(dFecha_Pago_CM,'yyyy-mm-dd')||'T'||TO_CHAR(dFecha_Pago_CM,'hh24:mm:ss');
         ELSIF NVL(cIndPlataforma,'N') = 'S' THEN
            --cValorAtributo := TO_CHAR(dFecPago,'yyyy-mm-dd')||'T'||TO_CHAR(dFecPago,'hh:mm:ss');
            cValorAtributo := TO_CHAR(TO_DATE(dFecPago,'DD/MM/RRRR'),'yyyy-mm-dd')||'T'||TO_CHAR(TO_DATE(dFecPago,'DD/MM/RRRR'),'hh:mm:ss');
         ELSE
            --Tomar dato de indicado en COBRANZA MANUAL
            --cValorAtributo := TO_CHAR(dFecha_Pago,'yyyy-mm-dd')||'T'||TO_CHAR(dFecha_Pago,'hh:mm:ss');
            cValorAtributo := TO_CHAR(TO_DATE(dFecha_Pago,'DD/MM/RRRR'),'yyyy-mm-dd')||'T'||TO_CHAR(TO_DATE(dFecha_Pago,'DD/MM/RRRR'),'hh:mm:ss');
         END IF;
          --> Fin JALV (-) 10/01/2022
      WHEN 'PAGSPVAL03' THEN
         cValorAtributo := OC_FACT_ELECT_FORMA_PAGO.FORMA_PAGO_FACT_ELECT(nCodCia,cFormaPago);
      WHEN 'PAGSPVAL04' THEN
         cValorAtributo := OC_MONEDA.CODIGO_FACTURACION_ELECTRONICA(cCodMoneda);
      WHEN 'PAGSPVAL05' THEN
         ---cValorAtributo := TRIM(TO_CHAR(nTasaCambio,'9999999999999999999999990.99'));
         IF cCodMoneda != 'PS' THEN
            cValorAtributo := TRIM(TO_CHAR(nTasaCambio,'9999999999999999999999990.99'));
         ELSE
            cValorAtributo := TO_CHAR(nTasaCambio);
         END IF;
      WHEN 'PAGSPVAL06' THEN
         cValorAtributo := TRIM(TO_CHAR(nMontoPago,'9999999999999999999999990.99'));
      WHEN 'PAGSPVAL07' THEN
         cValorAtributo := REPLACE(cNumDocPago,'/','');
      WHEN 'PAGSPVAL08' THEN
         NULL;
      WHEN 'PAGSPVAL09' THEN
         NULL;
      WHEN 'PAGSPVAL10' THEN
         NULL;
      WHEN 'PAGSPVAL11' THEN
         NULL;
      WHEN 'PAGSPVAL12' THEN
         NULL;
      WHEN 'PAGSPVAL13' THEN
         NULL;
      WHEN 'PAGSPVAL14' THEN
         NULL;
      WHEN 'PAGSPVAL15' THEN
         NULL;
      WHEN 'PAGSPVAL16' THEN
         NULL;
      WHEN 'PAGSPDOCVAL01' THEN
         cValorAtributo := OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'); -- CUANDO SE PAGA SE BUSCA EL UUID DE EMISION
         IF cValorAtributo IS NULL THEN
            RAISE_APPLICATION_ERROR(-20225,'No Es Posible Generar El Timbre De Pago Ya Que No Existe Un UUID De Emisión De La Factura'||nIdFactura||' Por Favor Emita La Facturación Electrónica Para La Emisión Del Recibo');
         END IF;
      WHEN 'PAGSPDOCVAL02' THEN
         cValorAtributo :=  OC_FACT_ELECT_DETALLE_TIMBRE.SERIE(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'));
      WHEN 'PAGSPDOCVAL03' THEN
         cValorAtributo := OC_FACT_ELECT_DETALLE_TIMBRE.FOLIO_FISCAL(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'));
      WHEN 'PAGSPDOCVAL04' THEN
         cValorAtributo := OC_MONEDA.CODIGO_FACTURACION_ELECTRONICA(cCodMoneda);
      WHEN 'PAGSPDOCVAL05' THEN
         cValorAtributo := '1';
      WHEN 'PAGSPDOCVAL06' THEN
         NULL;
      WHEN 'PAGSPDOCVAL07' THEN
         NULL;
      WHEN 'PAGSPDOCVAL08' THEN
         SELECT NVL(TRIM(TO_CHAR(Monto_Fact_Local,'9999999999999999999999990.99')),'0.00')
           INTO cValorAtributo
           FROM FACTURAS
          WHERE IdFactura = nIdFactura;
      WHEN 'PAGSPDOCVAL09' THEN
         cValorAtributo := TRIM(TO_CHAR(nMontoPago,'9999999999999999999999990.99'));
      WHEN 'PAGSPDOCVAL10' THEN
         cValorAtributo := TRIM(TO_CHAR(TO_NUMBER(OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc,'ImpSaldoAnt')) - TO_NUMBER(OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc,'ImpPagado')),'9999999999999999999999990.99'));
      WHEN 'PAGSPDOCVAL11' THEN
         IF NVL(cIndFacturaPol,'N') = 'S' THEN
            BEGIN
               SELECT NVL(CodObjetoImp,'02')
                 INTO cCodObjetoImp
                 FROM POLIZAS
                WHERE CodCia     = nCodCia
                  AND CodEmpresa = nCodEmpresa
                  AND IdPoliza   = nIdPoliza;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determianr el Uso de CFDI para la póliza '||cNumPolUnico||', Por favor valide la información en la póliza');
            END;
         ELSIF NVL(cIndFacturaPol,'N') = 'N' THEN
            BEGIN
               SELECT NVL(CodObjetoImp,'02')
                 INTO cCodObjetoImp
                 FROM DETALLE_POLIZA
                WHERE CodCia     = nCodCia
                  AND CodEmpresa = nCodEmpresa
                  AND IdPoliza   = nIdPoliza
                  AND IDetPol    = nIdDetPol;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determianr el Uso de CFDI para la póliza '||cNumPolUnico||' Sub Grupo '||nIdDetPol||', Por favor valide la información en la póliza y sub geupo correspondiente');
            END;
         END IF;
         cValorAtributo := cCodObjetoImp;
      WHEN 'PAGSPDOCIMTRAVAL01' THEN
         cUuid := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc,'IdDocumento');
         SELECT TO_CHAR(SUM(DF.Monto_Det_Moneda), '9999999999999999999990D90')
           INTO cValorAtributo
           FROM FACTURAS F, DETALLE_FACTURAS DF, FACT_ELECT_DETALLE_TIMBRE D
          WHERE F.IdFactura         = nIdFactura
            AND F.CodCia            = nCodCia
            AND D.Uuid              = cUuid
            AND D.CodRespuestaSat   = '201'
            AND D.CodProceso        = 'EMI'
            AND F.IdFactura         = DF.IdFactura
            AND F.CodCia            = D.CodCia
            AND F.IdFactura         = D.IdFactura
            AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(D.CodCia, D.CodEmpresa, D.IdFactura, D.IdNcr, D.Uuid) = 'N'
            AND DF.CodCpto         != cCodImpto;
      WHEN 'PAGSPDOCIMTRAVAL02' THEN
         cValorAtributo := NULL;
      WHEN 'PAGSPDOCIMTRAVAL03' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN  
            cValorAtributo := 'Exento';
         ELSE
            IF OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto) <> 0 THEN
               cValorAtributo := 'Tasa'; ---hacer dinamico
            END IF;
         END IF;
      WHEN 'PAGSPDOCIMTRAVAL04' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := NULL;
         ELSE
            cTipoFactor := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDocImTra,'TipoFactorDR');
            IF cTipoFactor = 'Tasa' THEN
               cValorAtributo := TRIM(TO_CHAR(OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto)/100,'9999999999999999999999990.99'));
            END IF;
         END IF;
      WHEN 'PAGSPDOCIMTRAVAL05' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := NULL;
         ELSE
            IF NVL(nIdFactura,0) != 0 AND cProceso = 'PAG' THEN
               cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodImpto, cCodTipoPlan),'9999999999999999999999990.99'));
            END IF;
         END IF;
      WHEN 'PAGSPIMTRAVAL01' THEN
         cUuid := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc,'IdDocumento');
         SELECT TO_CHAR(SUM(DF.Monto_Det_Moneda), '9999999999999999999990D90')
           INTO cValorAtributo
           FROM FACTURAS F, DETALLE_FACTURAS DF, FACT_ELECT_DETALLE_TIMBRE D
          WHERE F.IdFactura         = nIdFactura
            AND F.CodCia            = nCodCia
            AND D.Uuid              = cUuid
            AND D.CodRespuestaSat   = '201'
            AND D.CodProceso        = 'EMI'
            AND F.IdFactura         = DF.IdFactura
            AND F.CodCia            = D.CodCia
            AND F.IdFactura         = D.IdFactura
            AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(D.CodCia, D.CodEmpresa, D.IdFactura, D.IdNcr, D.Uuid) = 'N'
            AND DF.CodCpto         != cCodImpto;
         --cValorAtributo := LTRIM(TO_CHAR(0,'9999999999999999999990D90'));
      WHEN 'PAGSPIMTRAVAL02' THEN
         cValorAtributo := NULL;
      WHEN 'PAGSPIMTRAVAL03' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN  
            cValorAtributo := 'Exento';
         ELSE
            IF OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto) <> 0 THEN
               cValorAtributo := 'Tasa'; ---hacer dinamico
            END IF;
         END IF;
      WHEN 'PAGSPIMTRAVAL04' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := NULL;
         ELSE
            cTipoFactor := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPImTra,'TipoFactorP');
            IF cTipoFactor = 'Tasa' THEN
               cValorAtributo := TRIM(TO_CHAR(OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodImpto)/100,'9999999999999999999999990.99'));
            END IF;
         END IF;
      WHEN 'PAGSPIMTRAVAL05' THEN
         IF NVL(cIndExentoImp,'N') = 'S' THEN 
            cValorAtributo := NULL;
         ELSE
            IF NVL(nIdFactura,0) != 0 AND cProceso = 'PAG' THEN
               cValorAtributo := TRIM(TO_CHAR(OC_DETALLE_FACTURAS.MONTO_CONCEPTO_FACT_ELECT(nIdFactura, cCodImpto, cCodTipoPlan),'9999999999999999999999990.99'));
            END IF;
         END IF;
      ELSE NULL;
   END CASE;
   RETURN RTRIM(LTRIM(TO_CHAR(cValorAtributo)));
END GENERA_VALOR_ATRIBUTO;

END OC_DET_FACT_ELECT_CONF_DOCTO;
/

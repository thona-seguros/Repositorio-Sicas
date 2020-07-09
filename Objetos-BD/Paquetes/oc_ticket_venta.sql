--
-- OC_TICKET_VENTA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   XMLSEQUENCE ()
--   XMLTYPE (Type)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   XMLSEQUENCE (Synonym)
--   XMLTYPE (Synonym)
--   XMLTYPE (Synonym)
--   OC_AGENTES_DISTRIBUCION_POLIZA (Package)
--   GT_WEB_SERVICES (Package)
--   POLIZAS (Table)
--   COTIZACIONES (Table)
--   COTIZACIONES_DETALLE (Table)
--   OC_TICKET_POLIZA (Package)
--   OC_TICKET_POLIZA_ASEGURADO (Package)
--   OC_TICKET_POLIZA_BENEFICIARIO (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   AGENTES_DETALLES_POLIZAS (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   AGENTES_DISTRIBUCION_POLIZA (Table)
--   ASEGURADO (Table)
--   REGLA_SA_COBER (Table)
--   OC_DETALLE_POLIZA (Package)
--   CLAUSULAS_POLIZA (Table)
--   CLIENTES (Table)
--   COBERT_ACT_ASEG (Table)
--   TASAS_CAMBIO (Table)
--   OC_GENERALES (Package)
--   OC_PERSONA_NATURAL_JURIDICA (Package)
--   OC_POLIZAS (Package)
--   OC_ASEGURADO (Package)
--   OC_ASEGURADO_CERTIFICADO (Package)
--   OC_BENEFICIARIO (Package)
--   OC_COBERT_ACT_ASEG (Package)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--   FACT_ELECT_DETALLE_TIMBRE (Table)
--   TICKET_POLIZA_ASEGURADO (Table)
--   TICKET_POLIZA_BENEFICIARIO (Table)
--   TICKET_VENTA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TICKET_VENTA AS
    PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, cCodSucursal VARCHAR2, nNumeroCelular NUMBER, dFechaCompra DATE);
    PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, cCodSucursal VARCHAR2, nNumeroCelular NUMBER, dFechaCompra DATE);
    FUNCTION SUCURSAL(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, nNumeroCelular NUMBER) RETURN VARCHAR2;
    PROCEDURE REGISTRAR(nCodCia NUMBER, nCodEmpresa NUMBER, xVenta XMLTYPE, xTicketPolAseg XMLTYPE, xBenef XMLTYPE, xRegistro OUT XMLTYPE);
    FUNCTION ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, cNombre VARCHAR2, 
                       cApePaterno VARCHAR2, cApeMaterno VARCHAR2, dFecNacimiento DATE, 
                       cSexo VARCHAR2, nTelRes NUMBER) RETURN NUMBER;
    PROCEDURE CONSULTA_TICKETS(pCodCia      NUMBER, 
                                       pCodEmpresa  NUMBER, 
                                       pCodCliente  NUMBER, 
                                       pFecRegistro DATE,
                                       xmlReturn out XMLTYPE);                   
    PROCEDURE TICKET_POLIZA(pCodCia         NUMBER, 
                            pCodEmpresa     NUMBER, 
                            pCodCliente     NUMBER, 
                            pFecRegistro    DATE,
                            xmlReturn out XMLTYPE);
   PROCEDURE GENERA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, dFechaRegistro DATE);
END OC_TICKET_VENTA;
/

--
-- OC_TICKET_VENTA  (Package Body) 
--
--  Dependencies: 
--   OC_TICKET_VENTA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TICKET_VENTA AS
PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, cCodSucursal VARCHAR2, nNumeroCelular NUMBER, dFechaCompra DATE) IS
BEGIN
  -- EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   INSERT INTO TICKET_VENTA (CodCia, CodEmpresa, CodCliente, CodSucursal, NumeroCelular, FechaCompra, CodUsuario, FecRegistro)
                   VALUES (nCodCia, nCodEmpresa, nCodCliente, cCodSucursal, nNumeroCelular, TO_DATE(dFechaCompra,'DD/MM/YYYY'), USER,  TRUNC(SYSDATE));
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      UPDATE TICKET_VENTA
         SET CodUsuario    = USER,
             FecRegistro   = TRUNC(SYSDATE),
             FechaCompra   = dFechaCompra
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCliente    = nCodCliente 
         AND CodSucursal   = cCodSucursal 
         AND NumeroCelular = nNumeroCelular
         AND TO_DATE(FechaCompra,'DD/MM/YYYY')   = TO_DATE(dFechaCompra,'DD/MM/YYYY');
END INSERTAR;
    --
PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, cCodSucursal VARCHAR2, nNumeroCelular NUMBER, dFechaCompra DATE) IS
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   DELETE TICKET_VENTA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND CodCliente    = nCodCliente 
      AND CodSucursal   = cCodSucursal 
      AND NumeroCelular = nNumeroCelular
      AND FechaCompra   = dFechaCompra;
END ELIMINAR;
--
FUNCTION SUCURSAL(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, nNumeroCelular NUMBER) RETURN VARCHAR2 IS
cCodSucursal   TICKET_VENTA.CodSucursal%TYPE;
BEGIN 
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   BEGIN
      SELECT CodSucursal
        INTO cCodSucursal
        FROM TICKET_VENTA
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND CodCliente       = nCodCliente
         AND NumeroCelular    = nNumeroCelular;
   END;
   RETURN cCodSucursal;
END SUCURSAL;
    --
PROCEDURE REGISTRAR(nCodCia NUMBER, nCodEmpresa NUMBER, xVenta XMLTYPE, xTicketPolAseg XMLTYPE, xBenef XMLTYPE, xRegistro OUT XMLTYPE) IS
xRestultado       XMLTYPE;
nCodCliente       TICKET_VENTA.CodCliente%TYPE;
cCodSucursal      TICKET_VENTA.CodSucursal%TYPE;
nNumeroCelular    TICKET_VENTA.NumeroCelular%TYPE; 
dFechaCompra      TICKET_VENTA.FechaCompra%TYPE;
dFecRegistro      TICKET_VENTA.FecRegistro%TYPE;
nRegistroAseg     NUMBER;
nRegistroBenef    NUMBER;
cVenta            CLOB;
nCodAsegurado     TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE;
dFecIniVig        POLIZAS.FecIniVig%TYPE;

CURSOR VENTA_Q IS
   SELECT OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza) NumPolUnico, 
          A.IdPoliza, A.IDetPol, A.CodAsegurado
     FROM TICKET_VENTA T, TICKET_POLIZA_ASEGURADO A
    WHERE T.CodCia               = nCodCia
      AND T.CodEmpresa           = nCodEmpresa
      AND T.CodCliente           = nCodCliente
      AND T.CodSucursal          = cCodSucursal
      AND T.NumeroCelular        = nNumeroCelular
      AND TO_DATE(T.FechaCompra,'DD/MM/YYYY')   = TO_DATE(dFechaCompra,'DD/MM/YYYY')
      AND TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(dFecRegistro,'DD/MM/YYYY')
      AND A.CodAsegurado         = nCodAsegurado
      AND T.CodCia               = A.CodCia
      AND T.CodEmpresa           = A.CodEmpresa
      AND T.CodCliente           = A.CodCliente
      AND T.CodSucursal          = A.CodSucursal
      AND T.NumeroCelular        = A.NumeroCelular
      AND T.FechaCompra          = A.FechaCompra
    GROUP BY OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza), A.IdPoliza, A.IDetPol, A.CodAsegurado;

CURSOR TICKETS_Q IS
   SELECT A.NumeroTicket, A.NumeroConsecutivo, A.FechaRegistro
     FROM TICKET_VENTA T, TICKET_POLIZA_ASEGURADO A
    WHERE T.CodCia               = nCodCia
      AND T.CodEmpresa           = nCodEmpresa
      AND T.CodCliente           = nCodCliente
      AND T.CodSucursal          = cCodSucursal
      AND T.NumeroCelular        = nNumeroCelular
      AND TO_DATE(T.FechaCompra,'DD/MM/YYYY')   = TO_DATE(dFechaCompra,'DD/MM/YYYY')
      AND TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(dFecRegistro,'DD/MM/YYYY')
      AND A.CodAsegurado         = nCodAsegurado
      AND T.CodCia               = A.CodCia
      AND T.CodEmpresa           = A.CodEmpresa
      AND T.CodCliente           = A.CodCliente
      AND T.CodSucursal          = A.CodSucursal
      AND T.NumeroCelular        = A.NumeroCelular
      AND T.FechaCompra          = A.FechaCompra;
BEGIN 
EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
 dFecRegistro   := TRUNC(SYSDATE);
 --- REGISTRO TICKET VENTA
 FOR xRowXml IN (SELECT EXTRACT (VALUE (t), '//DATA') Venta
                   FROM TABLE (XMLSEQUENCE (EXTRACT (xVenta, '*'))) t) LOOP
    FOR Venta IN (SELECT EXTRACTVALUE (VALUE (t), '/DATA/CodCliente') CodCliente,
                         EXTRACTVALUE (VALUE (t), '/DATA/CodSucursal') CodSucursal,
                         EXTRACTVALUE (VALUE (t), '/DATA/NumeroCelular') NumeroCelular,
                         EXTRACTVALUE (VALUE (t), '/DATA/FechaCompra') FechaCompra,
                         EXTRACTVALUE (VALUE (t), '/DATA/CodAsegurado') CodAsegurado,
                  EXTRACT(VALUE (t),'/DATA') Venta                                
                        FROM   table (XMLSEQUENCE (EXTRACT (xRowXml.Venta,
                                                  '/DATA'))) t) LOOP
       OC_TICKET_VENTA.INSERTAR(nCodCia, nCodEmpresa, Venta.CodCliente, Venta.CodSucursal, Venta.NumeroCelular, TO_DATE(Venta.FechaCompra,'DD/MM/YYYY'));
       nCodCliente    := Venta.CodCliente;
       cCodSucursal   := Venta.CodSucursal;
       nNumeroCelular := Venta.NumeroCelular;
       dFechaCompra   := Venta.FechaCompra;
       nCodAsegurado  := Venta.CodAsegurado;
    END LOOP;
 END LOOP;

 --- REGISTRO TICKET POLIZA ASEGURADO
 nRegistroAseg := OC_TICKET_POLIZA_ASEGURADO.REGISTRAR(nCodCia, nCodEmpresa, xTicketPolAseg);

 --- REGISTRO TICKET POLIZA BENEFICIARIO
 nRegistroBenef := OC_TICKET_POLIZA_BENEFICIARIO.REGISTRAR( nCodCia, nCodEmpresa, xBenef);

 IF nRegistroAseg = 0 THEN 
    RAISE_APPLICATION_ERROR(-20100,'Error al Registrar Tickets, por favor valide la Información');
 ELSIF nRegistroBenef = 0 THEN
    RAISE_APPLICATION_ERROR(-20100,'Error al Registrar Beneficiarios, por favor valide la Información');
 END IF;

 cVenta   := '<?xml version="1.0"?> <DATA>';
 FOR W IN VENTA_Q LOOP
    dFecIniVig := OC_POLIZAS.INICIO_VIGENCIA(nCodCia , nCodEmpresa , W.IdPoliza);
    cVenta     := cVenta || '<NUMPOLUNICO>'  || W.NumPolUnico  || '</NUMPOLUNICO>';
    cVenta     := cVenta || '<CONSECUTIVO>'  || W.IdPoliza     || '</CONSECUTIVO>';
    cVenta     := cVenta || '<FECINIVIG>'    || dFecIniVig     || '</FECINIVIG>';
    cVenta     := cVenta || '<IDETPOL>'      || W.IDetPol      || '</IDETPOL>';
    cVenta     := cVenta || '<CODASEGURADO>' || W.CodAsegurado || '</CODASEGURADO>';
    FOR X IN TICKETS_Q LOOP
       cVenta   := cVenta || '<TICKETS>';
       cVenta   := cVenta || '<NUMEROTICKET>'       || X.NumeroTicket       || '</NUMEROTICKET>';
       cVenta   := cVenta || '<NUMEROCONSECUTIVO>'  || X.NumeroConsecutivo  || '</NUMEROCONSECUTIVO>';
       cVenta   := cVenta || '<FECHAREGISTRO>'      || X.FechaRegistro      || '</FECHAREGISTRO>';
       cVenta   := cVenta || '</TICKETS>';
    END LOOP;
 END LOOP;
 cVenta      := cVenta || '</DATA>';
 xRestultado := XMLType(cVenta);

 SELECT XMLROOT (xRestultado, VERSION '1.0" encoding="UTF-8')
   INTO xRegistro
   FROM DUAL;     
EXCEPTION
 WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20100,'Error En el Registro de la Información '||SQLCODE||' - '||SQLERRM);
END;
    --
FUNCTION ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, cNombre VARCHAR2, 
                  cApePaterno VARCHAR2, cApeMaterno VARCHAR2, dFecNacimiento DATE, 
                  cSexo VARCHAR2, nTelRes NUMBER) RETURN NUMBER IS
nCodAsegurado                 SICAS_OC.ASEGURADO.COD_ASEGURADO%TYPE;
cNumDocIdentificacion         SICAS_OC.ASEGURADO.Num_Doc_Identificacion%TYPE; 
cTipoDocIdentificacion        SICAS_OC.ASEGURADO.Tipo_Doc_Identificacion%TYPE := 'RFC';  
cNumDocIdentCont              SICAS_OC.ASEGURADO.Num_Doc_Identificacion%TYPE;
cTipoDocIdentCont             SICAS_OC.ASEGURADO.Tipo_Doc_Identificacion%TYPE;
cDirecRes                     PERSONA_NATURAL_JURIDICA.DirecRes%TYPE;
cNumInterior                  PERSONA_NATURAL_JURIDICA.NumInterior%TYPE;
cNumExterior                  PERSONA_NATURAL_JURIDICA.NumExterior%TYPE;
cCodPaisRes                   PERSONA_NATURAL_JURIDICA.CodPaisRes%TYPE;
cCodProvRes                   PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE;
cCodDistRes                   PERSONA_NATURAL_JURIDICA.CodDistRes%TYPE;
cCodCorrRes                   PERSONA_NATURAL_JURIDICA.CodCorrRes%TYPE;
cCodPosRes                    PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE;
--cCodColonia                   PERSONA_NATURAL_JURIDICA.CodColonia%TYPE;
cTelRes                       PERSONA_NATURAL_JURIDICA.TelRes%TYPE;
cEmail                        PERSONA_NATURAL_JURIDICA.Email%TYPE;
cLadaTelRes                   PERSONA_NATURAL_JURIDICA.LadaTelRes%TYPE;
BEGIN
EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   BEGIN
      SELECT Num_Doc_Identificacion, Tipo_Doc_Identificacion
        INTO cNumDocIdentCont, cTipoDocIdentCont
        FROM CLIENTES
       WHERE CodCliente = nCodCliente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Fue posible determinar los datos del Cliente de Facturacion ');
   END;
   BEGIN
      SELECT DirecRes, NumInterior, NumExterior, CodPaisRes, CodProvRes,
             CodDistRes, CodCorrRes, CodPosRes, Email, LadaTelRes
        INTO cDirecRes, cNumInterior, cNumExterior, cCodPaisRes, cCodProvRes,
             cCodDistRes, cCodCorrRes, cCodPosRes, cEmail, cLadaTelRes
        FROM PERSONA_NATURAL_JURIDICA
       WHERE Tipo_Doc_Identificacion   = cTipoDocIdentCont
         AND Num_Doc_Identificacion    = cNumDocIdentCont;
   END;
   cNumDocIdentificacion := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(cNombre, cApePaterno, cApeMaterno, dFecNacimiento, 'FISICA');

   IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentificacion, cNumDocIdentificacion) = 'N' THEN
      OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(cTipoDocIdentificacion,                --cTipo_Doc_Identificacion
                                                 cNumDocIdentificacion,  --cNum_Doc_Identificacion
                                                 cNombre,                --cNombre
                                                 cApePaterno,            --cApellidoPat
                                                 cApeMaterno,            --cApellidoMat
                                                 NULL,                   --cApeCasada
                                                 cSexo,                  --cSexo
                                                 NULL,                   --cEstadoCivil
                                                 dFecNacimiento,         --dFecNacimiento
                                                 cDirecRes,              --cDirecRes
                                                 cNumInterior,            --cNumInterior
                                                 cNumExterior,           --cNumExterior
                                                 cCodPaisRes,            --cCodPaisRes
                                                 cCodProvRes,            --OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,16,','),  --cCodProvRes
                                                 cCodDistRes,            --cCodDistRes       
                                                 cCodCorrRes,            --cCodCorrRes
                                                 cCodPosRes,             --cCodPosRes
                                                 NULL,                   ---cCodColonia,  --cCodColonia
                                                 TO_CHAR(nTelRes),                --cTelRes
                                                 cEmail,                 --cEmail
                                                 cLadaTelRes);           --cLadaTelRes

      nCodAsegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion, cNumDocIdentificacion);
      IF nCodAsegurado = 0 THEN
         nCodAsegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion, cNumDocIdentificacion);
      END IF;                                                                   
   ELSE
      nCodAsegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion, cNumDocIdentificacion);
      IF nCodAsegurado = 0 THEN
         nCodAsegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion, cNumDocIdentificacion);
      END IF; 
   END IF;
   RETURN nCodAsegurado;
END ASEGURADO;              
    --
PROCEDURE CONSULTA_TICKETS(pCodCia      NUMBER, 
                           pCodEmpresa  NUMBER, 
                           pCodCliente  NUMBER, 
                           pFecRegistro DATE,
                           xmlReturn out XMLTYPE) IS

TextXML         clob := empty_clob();
LIN             clob := empty_clob();
LINDETA         clob := empty_clob();
LINFINAL        clob := empty_clob();

CURSOR Q_TICKET IS
   SELECT T.CodCia, T.CodEmpresa, A.CodCliente, NVL(A.IdFactura, 0) IdFactura,
          OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza) NumPolUnico, NVL(F.Monto_Fact_Moneda, 0) Monto_Moneda,
          T.FecRegistro, E.UUID, A.IdPoliza,
          XMLELEMENT("FACTURA",  NULL,             
                          XMLELEMENT("IDFACTURA",        NVL(A.IdFactura, 0)),
                          XMLELEMENT("NUMPOLUNICO",      OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza)),
                          XMLELEMENT("MONTO_MONEDA",     NVL(F.Monto_Fact_Moneda, 0)) ,
                          XMLELEMENT("FECREGISTRO",      T.FecRegistro),
                          XMLELEMENT("UUID",             E.UUID),
                          XMLELEMENT("XELEMTDETA",       'XELEMTDETA')
                  ) XMLDATOS        
     FROM TICKET_VENTA T, TICKET_POLIZA_ASEGURADO A,
          FACTURAS F, FACT_ELECT_DETALLE_TIMBRE E
    WHERE T.CodCia               = pCodCia
      AND T.CodEmpresa           = pCodEmpresa
      AND T.CodCliente           = pCodCliente
      AND F.StsFact              = 'EMI'
      AND TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(pFecRegistro,'DD/MM/YYYY')
      AND T.CodCia               = A.CodCia
      AND T.CodEmpresa           = A.CodEmpresa
      AND T.CodCliente           = A.CodCliente
      AND T.CodSucursal          = A.CodSucursal
      AND T.NumeroCelular        = A.NumeroCelular
      AND T.FechaCompra          = A.FechaCompra
      AND F.CodCia               = A.CodCia
      AND F.IdFactura            = A.IdFactura
      AND F.IdPoliza             = A.IdPoliza
      AND F.CodCia               = E.CodCia(+)
      --AND F.CodEmpresa           = E.CodEmpresa(+)
      AND F.IdFactura            = E.IdFactura(+)
    GROUP BY T.CodCia, T.CodEmpresa, A.CodCliente, NVL(A.IdFactura, 0),
          OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza), T.FecRegistro, 
          A.IdPoliza, E.UUID, F.Monto_Fact_Moneda;

--  SELECT T.CODCIA,
--         T.CODEMPRESA,
--         A.CodCliente,
--         NVL(A.IDFACTURA, 0) IDFACTURA,
--         OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza) NumPolUnico,   
--         SUM(NVL(F.MONTO_FACT_MONEDA, 0)) MONTO_MONEDA,
--         T.FECREGISTRO,
--         MAX(E.UUID) UUID,        
--         XMLELEMENT("FACTURA",  NULL,             
--                    XMLELEMENT("IDFACTURA",        NVL(A.IDFACTURA, 0)),
--                    XMLELEMENT("NUMPOLUNICO",      OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza)),
--                    XMLELEMENT("MONTO_MONEDA",     SUM(NVL(F.MONTO_FACT_MONEDA, 0)) ),
--                    XMLELEMENT("FECREGISTRO",      T.FECREGISTRO),
--                    XMLELEMENT("UUID",             MAX(E.UUID)),
--                    XMLELEMENT("XELEMTDETA",       'XELEMTDETA')
--                  ) XMLDATOS        
--    FROM TICKET_VENTA T INNER JOIN TICKET_POLIZA_ASEGURADO   A  ON T.CodCia               = A.CodCia
--                                                               AND T.CodEmpresa           = A.CodEmpresa
--                                                               AND T.CodCliente           = A.CodCliente
--                                                               AND T.CodSucursal          = A.CodSucursal
--                                                               AND T.NumeroCelular        = A.NumeroCelular
--                                                               AND T.FechaCompra          = A.FechaCompra
--                        LEFT  JOIN FACTURAS                  F  ON F.IDFACTURA            = NVL(A.IDFACTURA, 0) 
--                                                               AND F.IdPoliza             = A.IdPoliza
--                                                               AND F.StsFact              = 'EMI'
--                        LEFT  JOIN FACT_ELECT_DETALLE_TIMBRE E  ON E.CodCia               = A.CodCia
--                                                               AND E.CodEmpresa           = A.CodEmpresa
--                                                               AND E.IDFACTURA            = F.IDFACTURA                                                          
--   WHERE 
--         T.CodCia               = pCodCia          
--     AND T.CodEmpresa           = pCodEmpresa
--     AND T.CodCliente           = pCodCliente
--     AND TRUNC(T.FecRegistro)   = pFecRegistro      
--    GROUP BY
--         T.CODCIA,
--         T.CODEMPRESA,
--         A.CodCliente,
--         NVL(A.IDFACTURA, 0) ,
--         OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza),   
--         T.FECREGISTRO;
L_TICKET Q_TICKET%ROWTYPE ;


  CURSOR Q_DETA (ppCodCia NUMBER, 
                 ppCodEmpresa NUMBER, 
                 ppCodCliente NUMBER, 
                 ppFecRegistro DATE) IS
      SELECT XMLELEMENT("TICKET",  NULL,             
                       XMLELEMENT("NUMEROCELULAR",      A.NUMEROCELULAR),
                       XMLELEMENT("NUMEROTICKET",       A.NUMEROTICKET),
                       XMLELEMENT("NUMEROCONSECUTIVO",  A.NUMEROCONSECUTIVO),
                       XMLELEMENT("FECHACOMPRA",        A.FECHACOMPRA),
                       XMLELEMENT("SUCURSAL",           T.CODSUCURSAL),
                       XMLELEMENT("NUM_CERT",           A.IDETPOL)
                   ) XELEMTDETA
       FROM TICKET_VENTA T INNER JOIN TICKET_POLIZA_ASEGURADO A    ON T.CodCia               = A.CodCia
                                                                  AND T.CodEmpresa           = A.CodEmpresa
                                                                  AND T.CodCliente           = A.CodCliente
                                                                  AND T.CodSucursal          = A.CodSucursal
                                                                  AND T.NumeroCelular        = A.NumeroCelular   
                                                                  AND T.FechaCompra          = A.FechaCompra
      WHERE T.CodCia               = ppCodCia
        AND T.CodEmpresa           = ppCodEmpresa
        AND T.CodCliente           = ppCodCliente
        AND TRUNC(T.FecRegistro)   = ppFecRegistro;    

  L_DETA Q_DETA%ROWTYPE ;

BEGIN

EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
  TextXML := '<?xml version="1.0" encoding="UTF-8" ?>' || CHR(10) || '<DATOS>' || CHR(10) ;


  OPEN Q_TICKET;
  LOOP
      FETCH Q_TICKET INTO L_TICKET;
      EXIT WHEN Q_TICKET%NOTFOUND;

       LIN :=  L_TICKET.XMLDATOS.getclobval()  || CHR(10);
       LINDETA := CHR(10) || '<TICKETS>' || CHR(10);

       OPEN Q_DETA (L_TICKET.CODCIA, 
                    L_TICKET.CODEMPRESA, 
                    L_TICKET.CodCliente, 
                    L_TICKET.FecRegistro);        
          LOOP
              FETCH Q_DETA INTO L_DETA;
              EXIT WHEN Q_DETA%NOTFOUND;    
              --  
              LINDETA := LINDETA || L_DETA.XELEMTDETA.getclobval();
              --                
          END LOOP;
          CLOSE Q_DETA;
          --
          LINDETA := LINDETA || CHR(10) || '</TICKETS>' || CHR(10);                              
          --
          LIN :=  GT_WEB_SERVICES.REPLACE_CLOB(LIN, '<XELEMTDETA>XELEMTDETA</XELEMTDETA>', LINDETA);

      LINFINAL := LINFINAL || LIN || CHR(10);
  END LOOP;
  CLOSE Q_TICKET;          
  TextXML := TextXML || LINFINAL || '</DATOS>' || CHR(10);                          
  xmlReturn := xmltype(TextXML);
END CONSULTA_TICKETS;
    --
PROCEDURE TICKET_POLIZA(pCodCia           NUMBER, 
                        pCodEmpresa       NUMBER, 
                        pCodCliente       NUMBER, 
                        pFecRegistro      DATE,
                        XMLReturn   OUT   XMLTYPE) IS

--TextXML      clob := empty_clob();
--LIN          clob := empty_clob();
cResultado   CLOB;
xResultado   XMLTYPE;   

CURSOR Q_TICKET IS
   SELECT DISTINCT A.IdPoliza, A.IDetPol,
          OC_POLIZAS.NUMERO_UNICO(A.CodCia, A.IdPoliza) NumPolUnico,
          A.NumeroCelular, D.FecIniVig, TRUNC(D.FecFinVig) FecFinVig, A.CodAsegurado,          
          OC_ASEGURADO.NOMBRE_ASEGURADO(A.CODCIA, A.CODEMPRESA, A.CODASEGURADO) Nombre
     FROM TICKET_POLIZA_ASEGURADO A INNER JOIN DETALLE_POLIZA  D ON D.CodCia     = A.CodCia
                                                                AND D.IdPoliza   = A.IdPoliza
                                                                AND D.IDetPol    = A.IDetPol                                                                                                                                   
    WHERE A.CodCia                              = pCodCia
      AND A.CodEmpresa                          = pCodEmpresa
      AND A.CodCliente                          = pCodCliente
      AND TO_DATE(A.FechaRegistro,'DD/MM/YYYY') = pFecRegistro;
--            
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   cResultado := '<?xml version="1.0"?> <DATA>';
   FOR W IN Q_TICKET LOOP
      cResultado := cResultado || '<SUBGRUPO>';
      cResultado := cResultado || '<IdPoliza>'     || W.IdPoliza     || '</IdPoliza>';
      cResultado := cResultado || '<NumPolUnico>'  || W.NumPolUnico  || '</NumPolUnico>';
      cResultado := cResultado || '<IDetPol>'      || W.IDetPol      || '</IDetPol>';
      cResultado := cResultado || '<NumeroCelular>'|| W.NumeroCelular|| '</NumeroCelular>';
      cResultado := cResultado || '<FecIniVig>'    || W.FecIniVig    || '</FecIniVig>';
      cResultado := cResultado || '<FecFinVig>'    || W.FecFinVig    || '</FecFinVig>';
      cResultado := cResultado || '<CodAsegurado>' || W.CodAsegurado || '</CodAsegurado>';
      cResultado := cResultado || '<Nombre>'       || W.Nombre       || '</Nombre>';
      cResultado := cResultado || '</SUBGRUPO>';
   END LOOP;      
   cResultado  := cResultado || '</DATA>';
   xResultado  := XMLType(cResultado);    

   SELECT XMLROOT (xResultado, VERSION '1.0" encoding="UTF-8')
     INTO XMLReturn
     FROM DUAL;    
END TICKET_POLIZA;
    --    
PROCEDURE GENERA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER, dFechaRegistro DATE) IS
nIdPoliza               POLIZAS.IdPoliza%TYPE;
nIDetPol                DETALLE_POLIZA.IDetPol%TYPE;
cCodMoneda              POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob                DETALLE_POLIZA.PlanCob%TYPE;
nPorcComis              POLIZAS.PorcComis%TYPE;
cCodPromotor            DETALLE_POLIZA.CodPromotor%TYPE;
nCodAgente              POLIZAS.Cod_agente%TYPE;
nIdCotizacion           COTIZACIONES.IdCotizacion%TYPE;
nIDetCotizacion         COTIZACIONES_DETALLE.IDetCotizacion%TYPE := 1;
nSumaAsegurada          COBERT_ACT_ASEG.Sumaasegcalculada%TYPE;
nCodAsegurado           TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE;
nTasaCambio             TASAS_CAMBIO.Tasa_Cambio%TYPE;
cCodPlanPago            POLIZAS.CodPlanPago%TYPE;
dFecIniVig              POLIZAS.FecIniVig%TYPE;
dFecFinVig              POLIZAS.FecFinVig%TYPE;
nPorc_Com_Proporcional  AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nIdFactura              FACTURAS.IdFactura%TYPE;

CURSOR TICKET_VENTA IS
   SELECT A.IdPoliza
     FROM TICKET_VENTA T, TICKET_POLIZA_ASEGURADO A
    WHERE T.CodCia               = nCodCia
      AND T.CodEmpresa           = nCodEmpresa
      AND T.CodCliente           = nCodCliente
      AND TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(dFechaRegistro,'DD/MM/YYYY')
      AND T.CodCia               = A.CodCia
      AND T.CodEmpresa           = A.CodEmpresa
      AND T.CodCliente           = A.CodCliente
      AND T.CodSucursal          = A.CodSucursal
      AND T.NumeroCelular        = A.NumeroCelular
      AND TO_DATE(T.FechaCompra,'DD/MM/YYYY')   = TO_DATE(A.FechaCompra,'DD/MM/YYYY')
      AND TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(A.FechaRegistro,'DD/MM/YYYY')
    GROUP BY A.IdPoliza;

CURSOR TICKETPOLASEG_Q IS
   SELECT OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza) NumPolUnico, 
          A.IdPoliza, A.IDetPol, A.CodAsegurado, COUNT(A.NumeroConsecutivo) VecesAseguramiento,
          T.FecRegistro, A.NumeroCelular, A.FechaCompra
     FROM TICKET_VENTA T, TICKET_POLIZA_ASEGURADO A
    WHERE T.CodCia               = nCodCia
      AND T.CodEmpresa           = nCodEmpresa
      AND T.CodCliente           = nCodCliente
      AND TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(dFechaRegistro,'DD/MM/YYYY')
      AND T.CodCia               = A.CodCia
      AND T.CodEmpresa           = A.CodEmpresa
      AND T.CodCliente           = A.CodCliente
      AND T.CodSucursal          = A.CodSucursal
      AND T.NumeroCelular        = A.NumeroCelular
      AND TO_DATE(T.FechaCompra,'DD/MM/YYYY')   = TO_DATE(A.FechaCompra,'DD/MM/YYYY')
      AND TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(A.FechaRegistro,'DD/MM/YYYY')
    GROUP BY OC_POLIZAS.NUMERO_UNICO(T.CodCia, A.IdPoliza), A.IdPoliza, 
          A.IDetPol, A.CodAsegurado, T.FecRegistro, A.NumeroCelular,
          A.FechaCompra
    ORDER BY A.IdPoliza, A.IDetPol;

CURSOR BENEF_Q IS
   SELECT NumBeneficiario, NombreBenef, ApePatBenef, ApeMatBenef, SexoBenef,
          FecNacBenef, PorcPartBenef, FecAltaBenef, CodParentBenef
     FROM TICKET_POLIZA_BENEFICIARIO
    WHERE CodCia        = nCodCia
      AND CodCliente    = nCodCliente
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
    ORDER BY NumBeneficiario;

CURSOR COMI_Q IS
      SELECT NVL(SUM(Porc_Com_Proporcional),0) Porc_Com_Proporcional, NVL(SUM(Porc_Com_Distribuida),0) Porc_Com_Distribuida, NVL(SUM(Porc_Comision_Agente),0) Porc_Comision_Agente,
             CodNivel, NVL(SUM(Porc_Comision_Plan),0) Porc_Comision_Plan, Cod_Agente_Jefe, Origen, Cod_Agente, Cod_Agente_Distr
        FROM AGENTES_DISTRIBUCION_COMISION
       WHERE Cod_Agente        = nCodAgente
         AND Cod_Agente_Distr  = nCodAgente
         AND IDetPol           = 1
         AND IdPoliza          = nIdPoliza
         AND CodCia            = nCodCia
       GROUP BY CodNivel,Cod_Agente_Jefe, Origen, Cod_Agente, Cod_Agente_Distr;  

CURSOR REGLA_SA_Q IS
   SELECT IdPoliza, IDetPol,CodCobert
     FROM COBERT_ACT_ASEG
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetpol;       
BEGIN
   FOR W IN TICKET_VENTA LOOP
      --DBMS_OUTPUT.PUT_LINE ('ENTRA POLIZA');
      nIdPoliza   := W.IdPoliza;
      BEGIN
         SELECT Cod_Moneda, Num_Cotizacion, CodPlanPago,
                Cod_Agente, FecIniVig, FecFinVig
           INTO cCodMoneda, nIdCotizacion, cCodPlanPago,
                nCodAgente, dFecIniVig, dFecFinVig
           FROM POLIZAS
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;
      END;
      BEGIN
         SELECT IdTipoSeg, PlanCob
           INTO cIdTipoSeg, cPlanCob
           FROM DETALLE_POLIZA
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;
      END;
      BEGIN
         SELECT NVL(PorcComisAgte,0)
           INTO nPorcComis
           FROM COTIZACIONES
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdCotizacion  = nIdCotizacion;
      END;

      nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(dFechaRegistro));
      --nPorcComis     := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(nCodCia, nCodEmpresa, cIdTipoSeg);
      --cCodPlanPago   := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(nCodCia, nCodEmpresa, cIdTipoSeg);
       BEGIN
         SELECT NVL(Porc_Com_Proporcional,0)
           INTO nPorc_Com_Proporcional
           FROM AGENTES_DISTRIBUCION_POLIZA
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND Cod_Agente = nCodAgente;
      END;
      IF nPorc_Com_Proporcional <> 100 THEN
      --- SI LA COMISION NO ES DEL 100%, SE RECALCULA CON EL PORCENTAJE DE COMISION DE LA POLIZA
         OC_AGENTES_DISTRIBUCION_POLIZA.RECALCULA_COMISION(nCodCia, nCodEmpresa, nIdPoliza, nCodAgente);
      END IF;

      --- QUITA GENERACION DERECHOS DE POLIZA
      UPDATE POLIZAS
         SET IndCalcDerechoEmis = 'N'
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza;

      --- ACTUALIZA VIGENCIAS DE CLAUSULAS DE POLIZA
      UPDATE CLAUSULAS_POLIZA
         SET Inicio_Vigencia  = dFecIniVig,
             Fin_Vigencia     = dFecFinVig
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza;

      FOR X IN TICKETPOLASEG_Q LOOP
         nCodAsegurado := X.CodAsegurado;
         IF OC_DETALLE_POLIZA.EXISTE_POLIZA_DETALLE(nCodCia, nCodEmpresa, nIdPoliza, TRIM(TO_CHAR(X.IDetPol))) = 'S' AND X.IDetPol = 1 THEN
            DELETE DETALLE_POLIZA 
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdPoliza   = nIdPoliza
               AND IDetPol    = X.IDetPol;
         END IF;
         nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(nCodCia, nCodEmpresa,cIdTipoSeg,cPlanCob,
                                                           nIdPoliza, nTasaCambio, nPorcComis, X.CodAsegurado,
                                                           cCodPlanPago, TRIM(TO_CHAR(X.IDetPol)), cCodPromotor, dFecIniVig);
         IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdpoliza, nIDetPol, nCodAsegurado) = 'N' THEN
            OC_ASEGURADO_CERTIFICADO.INSERTA(nCodCia, nIdpoliza, nIDetPol, nCodAsegurado, 0);
         ELSE
            RAISE_APPLICATION_ERROR(-20225,'Asegurado No. : ' || X.CodAsegurado || ' Duplicado en Certificado No. ' || nIDetPol);
         END IF;  
         IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA (nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIDetPol, nCodAsegurado) = 'N' THEN
            OC_TICKET_POLIZA_ASEGURADO.CARGA_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIdPoliza, nIDetPol,  nCodAsegurado, cIdTipoSeg, cPlanCob, X.VecesAseguramiento);
         END IF;

         FOR Z IN BENEF_Q LOOP
            OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPoliza, nIDetPol, nCodAsegurado, Z.NumBeneficiario, 
                                                 Z.NombreBenef||' '||Z.ApePatBenef||' '||Z.ApeMatBenef, Z.PorcPartBenef, 
                                                 Z.CodParentBenef, Z.SexoBenef, Z.FecNacBenef, 'N');
         END LOOP;
         OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);

         FOR J IN REGLA_SA_Q LOOP
            INSERT INTO REGLA_SA_COBER
                 VALUES (nCodCia,nCodEmpresa,J.IDPOLIZA,J.IDETPOL,J.CODCOBERT,'VECES ASEGURAMIENTO','ACT',USER,TRUNC(SYSDATE));
         END LOOP;
         ---- COMISIONES
         DELETE AGENTES_DETALLES_POLIZAS 
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol
            AND Cod_Agente = nCodAgente;

         DELETE AGENTES_DISTRIBUCION_COMISION
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol
            AND Cod_Agente = nCodAgente;

         OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR_DETALLE(nCodCia, nIdPoliza, nIDetPol);
      END LOOP;
      ----- CAMBIAR FECHA DE VIGENCIA DE ENDOSOS ----
      OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
      OC_POLIZAS.EMITIR_POLIZA(nCodCia, nIdPoliza, nCodEmpresa);

      BEGIN
         SELECT IdFactura
           INTO nIdFactura
           FROM FACTURAS
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza;
      END;

      FOR X IN TICKETPOLASEG_Q LOOP
         nCodAsegurado  := X.CodAsegurado;
         nIDetPol       := X.IDetPol;

         OC_TICKET_POLIZA_ASEGURADO.EMITIR(nCodCia, nCodEmpresa, nCodCliente, X.NumeroCelular, X.FechaCompra, 
                                           dFechaRegistro, nCodAsegurado, nIdPoliza, nIDetPol);
         OC_TICKET_POLIZA_BENEFICIARIO.EMITIR(nCodCia, nCodEmpresa, nCodCliente, nIdPoliza, nIDetPol, nCodAsegurado, NULL);                                           
         OC_TICKET_POLIZA_ASEGURADO.ASIGNA_FACTURA(nCodCia, nCodEmpresa, nCodCliente, X.NumeroCelular, X.FechaCompra, 
                                                   dFechaRegistro, nCodAsegurado, nIdPoliza, nIDetPol, nIdFactura);
      END LOOP;

      OC_TICKET_POLIZA.EMITIR(nCodCia, nCodEmpresa, nCodCliente, nIdPoliza, dFecIniVig);
   END LOOP;
END GENERA_POLIZA;

END OC_TICKET_VENTA;
/

--
-- OC_TICKET_VENTA  (Synonym) 
--
--  Dependencies: 
--   OC_TICKET_VENTA (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_TICKET_VENTA FOR SICAS_OC.OC_TICKET_VENTA
/


GRANT EXECUTE ON SICAS_OC.OC_TICKET_VENTA TO PUBLIC
/

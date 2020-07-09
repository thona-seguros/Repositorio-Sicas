--
-- GT_FAI_SERVICIOS_PORTAL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   XMLTYPE (Type)
--   DUAL (Synonym)
--   XMLAGG (Synonym)
--   XMLTYPE (Synonym)
--   XMLTYPE (Synonym)
--   SYS_IXMLAGG (Function)
--   POLIZAS (Table)
--   FAI_CONCENTRADORA_FONDO (Table)
--   FAI_FONDOS_DETALLE_POLIZA (Table)
--   FAI_SERVICIOS_PORTAL (Table)
--   GT_FAI_CONCENTRADORA_FONDO (Package)
--   GT_FAI_FONDOS_DETALLE_POLIZA (Package)
--   GT_FAI_MOVIMIENTOS_FONDOS (Package)
--   GT_FAI_TIPOS_DE_FONDOS (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_TRANSACCION (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   CLIENTES (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT (Table)
--   OC_GENERALES (Package)
--   OC_MONEDA (Package)
--   OC_PERSONA_NATURAL_JURIDICA (Package)
--   OC_PLAN_COBERTURAS (Package)
--   OC_ASEGURADO (Package)
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--   OC_CLIENTES (Package)
--   OC_COBERTURAS_DE_SEGUROS (Package)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_SERVICIOS_PORTAL AS
   FUNCTION NUMERO_CONSULTA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER) RETURN NUMBER;
   FUNCTION XML_SERVICIO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdConsultaServicio IN NUMBER, 
                         cCodServicio IN VARCHAR2) RETURN XMLTYPE;
   PROCEDURE INSERTAR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cCodServicio IN VARCHAR2, 
                      dFechaConsulta IN DATE, xXmlConsulta IN XMLTYPE);
--    PROCEDURE VALIDA_LOGIN(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
--                           cRfc IN VARCHAR2, cNumPolUnico VARCHAR2, nExiste OUT NUMBER);
   PROCEDURE VALIDA_LOGIN(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
                          cRfc IN VARCHAR2, nExiste OUT NUMBER);                           
   PROCEDURE CLIENTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
                     xDatosCliente OUT XMLTYPE); 
   PROCEDURE POLIZAS_CLIENTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
                             cRfc IN VARCHAR2, nIdPoliza IN NUMBER, xPolizasCliente OUT XMLTYPE); 
   PROCEDURE PRINCIPAL(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, 
                       dFechaDesde IN DATE, dFechaHasta IN DATE, xPrincipal OUT XMLTYPE);
   PROCEDURE MOVIMIENTOS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, 
                         dFechaDesde IN DATE, dFechaHasta IN DATE, xMovimientos OUT XMLTYPE);
   PROCEDURE MOVIMIENTOS_POR_FONDO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, 
                         dFechaDesde IN DATE, dFechaHasta IN DATE, xMovimientos OUT XMLTYPE); 
   PROCEDURE INTEGRACION_SALDO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, 
                         dFechaDesde IN DATE, dFechaHasta IN DATE, xIntegraSaldo OUT XMLTYPE);
   PROCEDURE LISTADO_POLIZAS (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, xListaPolizas OUT XMLTYPE);                     
END GT_FAI_SERVICIOS_PORTAL;
/

--
-- GT_FAI_SERVICIOS_PORTAL  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_SERVICIOS_PORTAL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_SERVICIOS_PORTAL AS
FUNCTION NUMERO_CONSULTA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER) RETURN NUMBER IS
    nIdConsultaServicio FAI_SERVICIOS_PORTAL.IdConsultaServicio%TYPE;
BEGIN
   SELECT NVL(MAX(IdConsultaServicio),0) + 1
     INTO nIdConsultaServicio
     FROM FAI_SERVICIOS_PORTAL
    WHERE CodCia     = nCodCia 
      AND CodEmpresa = nCodEmpresa;
   RETURN nIdConsultaServicio;
END NUMERO_CONSULTA;

FUNCTION XML_SERVICIO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdConsultaServicio IN NUMBER, 
                      cCodServicio IN VARCHAR2) RETURN XMLTYPE IS
xXmlConsulta FAI_SERVICIOS_PORTAL.XmlConsulta%TYPE;                      
BEGIN
    SELECT XmlConsulta
      INTO xXmlConsulta
      FROM FAI_SERVICIOS_PORTAL
     WHERE CodCia               = nCodCia 
       AND CodEmpresa           = nCodEmpresa
       AND IdConsultaServicio   = nIdConsultaServicio
       AND CodServicio          = cCodServicio;
    RETURN xXmlConsulta;
END XML_SERVICIO;
    
PROCEDURE INSERTAR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cCodServicio IN VARCHAR2, 
                   dFechaConsulta IN DATE, xXmlConsulta IN XMLTYPE) IS
nIdConsultaServicio FAI_SERVICIOS_PORTAL.IdConsultaServicio%TYPE;                   
BEGIN
    nIdConsultaServicio := GT_FAI_SERVICIOS_PORTAL.NUMERO_CONSULTA(nCodCia, nCodEmpresa);
    INSERT INTO FAI_SERVICIOS_PORTAL(CodCia, CodEmpresa, IdConsultaServicio, CodServicio, FechaConsulta, CodUsuario, XmlConsulta)
                              VALUES(nCodCia, nCodEmpresa, nIdConsultaServicio, cCodServicio, dFechaConsulta, USER, xXmlConsulta);
END INSERTAR;

--PROCEDURE VALIDA_LOGIN(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
--                       cRfc IN VARCHAR2, cNumPolUnico VARCHAR2, nExiste OUT NUMBER) IS
PROCEDURE VALIDA_LOGIN(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
                       cRfc IN VARCHAR2, nExiste OUT NUMBER) IS              
BEGIN
    BEGIN
        SELECT 1 --PO.IdPoliza
          INTO nExiste
          FROM POLIZAS PO,CLIENTES C,PERSONA_NATURAL_JURIDICA P
         WHERE C.CodCliente                                    = nCodCliente
           AND NVL(P.Num_Tributario,C.Num_Doc_Identificacion)  = NVL(cRfc,C.Num_Doc_Identificacion)
           --AND PO.IdPoliza                = nIdPoliza
           --AND PO.NumPolUnico                                   = cNumPolUnico
           AND PO.StsPoliza                                    = 'EMI'
           AND PO.CodCliente                                   = C.CodCliente
           AND C.Tipo_Doc_Identificacion                       = P.Tipo_Doc_Identificacion
           AND C.Num_Doc_Identificacion                        = P.Num_Doc_Identificacion
           AND NVL(PO.IndManejaFondos,'N')                     = 'S' ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            nExiste := 0;
        WHEN TOO_MANY_ROWS THEN
            nExiste := 1;
    END;
END VALIDA_LOGIN;

PROCEDURE CLIENTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
                  xDatosCliente OUT XMLTYPE) IS
xPrevDatCli      XMLTYPE;   
cCodServicio        FAI_SERVICIOS_PORTAL.CodServicio%TYPE := 'INFCTE'; 
BEGIN
  BEGIN
        SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("InfoCliente", 
                                                     XMLElement("NombreCliente",TRIM(OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(P.Tipo_Doc_Identificacion, P.Num_Doc_Identificacion))),
                                                     XMLElement("Rfc",NVL(P.Num_Tributario,C.Num_Doc_Identificacion)),
                                                     XMLElement("Email",NVL(CE.EMAIL,'NAN'))
                                                  )
                                       )
                                 ) 
                           )
          INTO xPrevDatCli
          FROM CLIENTES C,PERSONA_NATURAL_JURIDICA P,
               CORREOS_ELECTRONICOS_PNJ CE
         WHERE C.CodCliente               = nCodCliente
           --AND C.Num_Doc_Identificacion   = cRfc
           AND C.Tipo_Doc_Identificacion  = P.Tipo_Doc_Identificacion
           AND C.Num_Doc_Identificacion   = P.Num_Doc_Identificacion
           AND C.Tipo_Doc_Identificacion  = CE.Tipo_Doc_Identificacion(+)
           AND C.Num_Doc_Identificacion   = CE.Num_Doc_Identificacion(+)
           AND CE.Email_Principal(+)      = 'S';  
    END;
    SELECT XMLROOT (xPrevDatCli, VERSION '1.0" encoding="UTF-8')
      INTO xDatosCliente
      FROM DUAL;
    
    GT_FAI_SERVICIOS_PORTAL.INSERTAR(nCodCia, nCodEmpresa, cCodServicio, TRUNC(SYSDATE), xDatosCliente);
END CLIENTE;

PROCEDURE POLIZAS_CLIENTE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, 
                          cRfc IN VARCHAR2, nIdPoliza IN NUMBER, xPolizasCliente OUT XMLTYPE) IS
xPrevPolCli      XMLTYPE;   
cCodServicio     FAI_SERVICIOS_PORTAL.CodServicio%TYPE := 'POLCTE';   
dFecProxCargo    FACTURAS.FecVenc%TYPE;
cCodCobertura    COBERTURAS_DE_SEGUROS.CodCobert%TYPE;
cDescCobert      COBERTURAS_DE_SEGUROS.DescCobert%TYPE;
nSumaAsegurada   COBERTURAS_DE_SEGUROS.SumaAsegurada%TYPE;
BEGIN
    SELECT MIN(F.FecVenc)
      INTO dFecProxCargo
      FROM FACTURAS F
     WHERE F.IdPoliza                                   = nIdPoliza
       AND F.StsFact                                    = 'EMI'
       AND OC_TRANSACCION.ID_PROCESO(F.IdTransaccion)  IN (7,18);
       
    BEGIN
        SELECT CodCobert,SumaAseg_Local,OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert)
          INTO cCodCobertura,nSumaAsegurada,cDescCobert
          FROM COBERT_ACT
         WHERE CodCia     = nCodCia
           AND CodEmpresa = nCodEmpresa
           AND IdPoliza   = nIdPoliza
           AND CodCobert  = 'FALLEC'; 
    END;
       
    BEGIN
        SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("PolizasCliente", 
                                                     XMLElement("NumerodePoliza",P.IdPoliza),
                                                     XMLElement("FolioPoliza",P.NumPolUnico),
                                                     XMLElement("FechaInicioVigencia",P.FecIniVig),
                                                     XMLElement("FechaFinVigencia",P.FecFinVig),
                                                     XMLElement("Producto",OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, DP.IdTipoSeg)),
                                                     XMLElement("Moneda",OC_MONEDA.DESCRIPCION_MONEDA(P.Cod_Moneda)),
                                                     XMLElement("FechaProximoCargo",dFecProxCargo),
                                                     XMLElement("FechaConsulta",TRUNC(SYSDATE)),
                                                     XMLElement("CodCobertura",cCodCobertura),
                                                     XMLElement("DescCobertura",cDescCobert),
                                                     XMLElement("SumaAsegurada",nSumaAsegurada)
                                                  )
                                       )
                                 ) 
                           )
          INTO xPrevPolCli
          FROM POLIZAS P, DETALLE_POLIZA DP,
               CLIENTES C
         WHERE P.CodCia                 = nCodCia
           AND P.CodEmpresa             = nCodEmpresa
           AND P.IdPoliza               = nIdPoliza
           AND P.CodCliente             = nCodCliente
           AND C.Num_Doc_Identificacion = NVL(cRfc,C.Num_Doc_Identificacion)
           AND P.StsPoliza              = 'EMI'
           AND P.CodCia                 = DP.CodCia
           AND P.CodEmpresa             = DP.CodEmpresa
           AND P.IdPoliza               = DP.IdPoliza
           AND P.CodCliente             = C.CodCliente
           AND GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(P.CodCia, P.CodEmpresa, P.IdPoliza, DP.IDetPol, DP.Cod_Asegurado) = 'S';
    END;
    SELECT XMLROOT (xPrevPolCli, VERSION '1.0" encoding="UTF-8')
      INTO xPolizasCliente
      FROM DUAL;
    
    GT_FAI_SERVICIOS_PORTAL.INSERTAR(nCodCia, nCodEmpresa, cCodServicio, TRUNC(SYSDATE), xPolizasCliente);
END POLIZAS_CLIENTE;

PROCEDURE PRINCIPAL(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, 
                    dFechaDesde IN DATE, dFechaHasta IN DATE, xPrincipal OUT XMLTYPE) IS
xPrevPrincipal      XMLTYPE;   
cCodServicio        FAI_SERVICIOS_PORTAL.CodServicio%TYPE := 'PRINC'; 
BEGIN
    BEGIN
        SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("Principal", 
                                                     XMLElement("NombreCliente",OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)),
                                                     XMLElement("NumeroCliente",P.Codcliente),
                                                     XMLElement("NombreContratante",OC_ASEGURADO.NOMBRE_ASEGURADO(F.CodCia, F.CodEmpresa, F.CodAsegurado)),
                                                     XMLElement("NumeroContratante",F.CodAsegurado), 
                                                     XMLElement("Poliza",F.IdPoliza),
                                                     XMLElement("TipoFondo",F.TipoFondo),
                                                     XMLElement("FondoPoliza",GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(F.CodCia,F.CodEmpresa, F.TipoFondo)),
                                                     XMLElement("PorcentajeFondo",F.PorcFondo),
                                                     XMLElement("SaldoPoliza",(GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(F.CodCia, F.CodEmpresa,F.IdPoliza, F.IDetPol, F.CodAsegurado, F.IdFondo, dFechaHasta)))
                                                  )
                                       )
                                 ) 
                           )
          INTO xPrevPrincipal
          FROM FAI_FONDOS_DETALLE_POLIZA F,
               POLIZAS                   P,
               DETALLE_POLIZA            D
         WHERE P.CodCia           = nCodCia
           AND P.CodEmpresa       = nCodEmpresa 
           AND F.FecEmision BETWEEN dFechaDesde AND dFechaHasta
           AND F.IdPoliza         = nIdPoliza 
           AND P.IdPoliza         = F.IdPoliza
           AND D.IdPoliza         = F.IdPoliza
           AND D.IDetPol          = F.IDetPol;  
    END;
    SELECT XMLROOT (xPrevPrincipal, VERSION '1.0" encoding="UTF-8')
      INTO xPrincipal
      FROM DUAL;
    
    GT_FAI_SERVICIOS_PORTAL.INSERTAR(nCodCia, nCodEmpresa, cCodServicio, TRUNC(SYSDATE), xPrincipal);
END PRINCIPAL;

PROCEDURE MOVIMIENTOS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, 
                      dFechaDesde IN DATE, dFechaHasta IN DATE, xMovimientos OUT XMLTYPE) IS
xPrevMovimientos    XMLTYPE;   
cCodServicio        FAI_SERVICIOS_PORTAL.CodServicio%TYPE := 'MOVTOS'; 
BEGIN
    BEGIN
        SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("Movimientos", 
                                                     XMLElement("Fecha",FecMovimiento),
                                                     XMLElement("Identificador",IdMovimiento),
                                                     XMLElement("Transaccion",IdTransaccion),
                                                     XMLElement("MontoMN",MontoMovMoneda), 
                                                     XMLElement("TipoCambio",TasaCambio),
                                                     XMLElement("Poliza",IdPoliza),
                                                     XMLElement("Fondo",Fondo),
                                                     XMLElement("Movimiento",DescMovimiento)
                                                  )
                                       )
                                 ) 
                           )
          INTO xPrevMovimientos
          FROM (  
                SELECT P.IdPoliza,
                       GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(P.CodCia, P.CodEmpresa, GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(F.IdFondo)) Fondo,
                       F.FecMovimiento,
                       OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(1, F.CodCptoMov) DescMovimiento,
                       F.IdTransaccion,
                       F.MontoMovMoneda,
                       OC_GENERALES.FUN_TASA_CAMBIO(F.CodMonedaPago, F.FecMovimiento) TasaCambio,
                       F.MontoMovLocal,
                       '0' Unidades,
                       '0.00' ValorMnUnidades,
                       F.IdMovimiento
                  FROM FAI_CONCENTRADORA_FONDO F,
                       POLIZAS P,
                       DETALLE_POLIZA D
                 WHERE P.CodCia              = nCodCia
                   AND P.CodEmpresa          = nCodEmpresa 
                   AND F.FecMovimiento BETWEEN dFechaDesde AND dFechaHasta
                   AND F.IdPoliza            = nIdPoliza 
                   AND P.IdPoliza            = F.IdPoliza
                   AND D.IdPoliza            = F.IdPoliza
                   AND D.IDetPol             = F.IDetPol 
                   AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(nCodCia, nCodEmpresa, GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO (F.IdFondo), F.CodCptoMov) NOT IN ('IN','IT','RE')
                 UNION
                SELECT P.IdPoliza,
                       GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(P.CodCia, P.CodEmpresa, GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(F.IdFondo)) Fondo,
                       TRUNC(LAST_DAY(SYSDATE))  FecMovimiento,
                       OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(1, F.CodCptoMov) DescMovimiento,
                       0 IdTransaccion,
                       SUM(F.MontoMovMoneda) MontoMovMoneda,
                       1 TasaCambio,
                       SUM(F.MontoMovLocal) MontoMovLocal,
                       '0' Unidades,
                       '0.00' ValorMnUnidades,
                       0 IdMovimiento
                  FROM FAI_CONCENTRADORA_FONDO F,
                       POLIZAS P,
                       DETALLE_POLIZA D
                 WHERE P.CodCia              = nCodCia
                   AND P.CodEmpresa          = nCodEmpresa 
                   AND F.FecMovimiento BETWEEN dFechaDesde AND dFechaHasta
                   AND F.IdPoliza            = nIdPoliza 
                   AND P.IdPoliza            = F.IdPoliza
                   AND D.IdPoliza            = F.IdPoliza
                   AND D.IDetPol             = F.IDetPol
                   AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(nCodCia, nCodEmpresa, GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO (F.IdFondo), F.CodCptoMov) IN ('IN','RE')
                 GROUP BY P.IdPoliza, P.CodCia, P.CodEmpresa, F.CodMonedaPago, F.CodCptoMov, 
                       F.IdFondo, GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(P.CodCia, P.CodEmpresa, GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(F.IdFondo)), TRUNC(LAST_DAY(SYSDATE)), 
                       OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(1, F.CodCptoMov), 0, 1, '0', '0.00')
         ORDER BY IdMovimiento;  
    END;
    SELECT XMLROOT (xPrevMovimientos, VERSION '1.0" encoding="UTF-8')
      INTO xMovimientos
      FROM DUAL;
    
    GT_FAI_SERVICIOS_PORTAL.INSERTAR(nCodCia, nCodEmpresa, cCodServicio, TRUNC(SYSDATE), xMovimientos);
END MOVIMIENTOS;

PROCEDURE MOVIMIENTOS_POR_FONDO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, 
                               dFechaDesde IN DATE, dFechaHasta IN DATE, xMovimientos OUT XMLTYPE) IS
xPrevMovimientos    XMLTYPE;   
cCodServicio        FAI_SERVICIOS_PORTAL.CodServicio%TYPE := 'MVFOND'; 
BEGIN
    BEGIN
        SELECT XMLElement("DATA",
                          XMLAGG(
                           XMLCONCAT(
                            XMLElement("MovimientosFondos", 
                              XMLElement("Identificador_Fondo",A.IdFondo),
                              XMLElement("Poliza",A.IdPoliza),
                              XMLElement("NombreContratante",OC_ASEGURADO.NOMBRE_ASEGURADO(A.CodCia, A.CodEmpresa, A.CodAsegurado)),
                              XMLElement("TipoFondo",A.TipoFondo),
                              XMLElement("NombreFondo",GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(A.CodCia,A.CodEmpresa, A.TipoFondo)),
                              XMLElement("Moneda",B.Cod_Moneda),
                              XMLElement("PrimaNeta",B.PrimaNeta_Local), 
                              XMLElement("DescripcionPlan",OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A.CodCia, A.CodEmpresa,C.IdTipoSeg, C.PlanCob )),
                              XMLElement("AporteAdicional",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'AA', dFechaDesde,dFechaHasta)),
                              XMLElement("Ajuste",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'AJ', dFechaDesde,dFechaHasta)),
                              XMLElement("AporteInicial",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'AP', dFechaDesde,dFechaHasta)),
                              XMLElement("Bono",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'BO', dFechaDesde,dFechaHasta)),
                              XMLElement("Cargo",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'CA', dFechaDesde,dFechaHasta)),
                              XMLElement("CobroDePrimas",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'CP', dFechaDesde,dFechaHasta)),
                              XMLElement("Honorarios",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'HO', dFechaDesde,dFechaHasta)),
                              XMLElement("Inflacion",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'IF', dFechaDesde,dFechaHasta)),
                              XMLElement("Impuestos",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'IM', dFechaDesde,dFechaHasta)),
                              XMLElement("Interes",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'IN', dFechaDesde,dFechaHasta)),
                              XMLElement("InteresFondoParaThona",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'IT', dFechaDesde,dFechaHasta)),
                              XMLElement("Retencion",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'RE', dFechaDesde,dFechaHasta)),
                              XMLElement("RetiroParcial",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'RP', dFechaDesde,dFechaHasta)),
                              XMLElement("RetiroTotal",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'RT', dFechaDesde,dFechaHasta)),
                              XMLElement("Reversion",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'RV', dFechaDesde,dFechaHasta)),
                              XMLElement("RetiroExtemporaneo",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'RX', dFechaDesde,dFechaHasta)),
                              XMLElement("Traspaso",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(A.CodCia, A.CodEmpresa, A.IdPoliza, A.IDetPol, A.CodAsegurado, A.IdFondo,'TR', dFechaDesde,dFechaHasta))                                                     
                                       )
                                     )
                                 ) 
                           )
          INTO xPrevMovimientos                                                                                                                                                                                                                                                                                                                                                                                               
          FROM FAI_FONDOS_DETALLE_POLIZA A,
               POLIZAS                   B,
               DETALLE_POLIZA            C
         WHERE A.CodCia           = nCodCia
           AND A.CodEmpresa       = nCodEmpresa 
           AND A.FecEmision BETWEEN dFechaDesde AND  dFechaHasta
           AND A.IdPoliza         = nIdPoliza
           AND A.StsFondo    NOT IN ('SOLICI')   
           AND B.IdPoliza         = A.IdPoliza
           AND C.idpoliza         = A.IdPoliza 
          GROUP BY A.IdFondo, A.IdPoliza, A.CodAsegurado, A.TipoFondo, 
               A.CodCia, A.CodEmpresa, B.Cod_Moneda, B.PrimaNeta_Local,
               C.IdTipoSeg, C.PlanCob, A.IDetPol;
    END;
    SELECT XMLROOT (xPrevMovimientos, VERSION '1.0" encoding="UTF-8')
      INTO xMovimientos
      FROM DUAL;
    
    GT_FAI_SERVICIOS_PORTAL.INSERTAR(nCodCia, nCodEmpresa, cCodServicio, TRUNC(SYSDATE), xMovimientos);
END MOVIMIENTOS_POR_FONDO;

PROCEDURE INTEGRACION_SALDO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, 
                      dFechaDesde IN DATE, dFechaHasta IN DATE, xIntegraSaldo OUT XMLTYPE) IS
xPrevIntegraSaldo   XMLTYPE;   
cCodServicio        FAI_SERVICIOS_PORTAL.CodServicio%TYPE := 'INTEGR'; 
BEGIN
    BEGIN
        SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("IntegracionSaldo", 
                                                     XMLElement("TipoFondo",GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(P.CodCia, P.CodEmpresa, FD.TipoFondo)),
                                                     XMLElement("TotalAportacionesPesos",GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(P.CodCia, P.CodEmpresa, P.IdPoliza, FD.IDetPol, FD.CodAsegurado, FD.IdFondo, 'AA', dFechaDesde, dFechaHasta) +
                                                                                         GT_FAI_CONCENTRADORA_FONDO.MONTO_CONCEPTO(P.CodCia, P.CodEmpresa, P.IdPoliza, FD.IDetPol, FD.CodAsegurado, FD.IdFondo, 'AP', dFechaDesde, dFechaHasta)),
                                                     XMLElement("ValorFondoOriginal",FD.MtoAporteInilocal),
                                                     XMLElement("MonedaFondo",OC_MONEDA.DESCRIPCION_MONEDA(GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(P.CodCia, P.CodEmpresa, FD.TipoFondo))), 
                                                     XMLElement("TipoCambio",OC_GENERALES.TASA_DE_CAMBIO(GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(P.CodCia, P.CodEmpresa, FD.TipoFondo), dFechaHasta)),
                                                     --XMLElement("Saldo",FD.MtoAporteInilocal * OC_GENERALES.TASA_DE_CAMBIO(GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(P.CodCia, P.CodEmpresa, FD.TipoFondo), dFechaHasta))
                                                     XMLElement("Saldo",GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(FD.CodCia, FD.CodEmpresa,FD.IdPoliza, FD.IDetPol, FD.CodAsegurado, FD.IdFondo, dFechaHasta))  
                                                     ----Fecha Próximo Cargo
                                                  )
                                       )
                                 ) 
                           )
          INTO xPrevIntegraSaldo
          FROM FAI_FONDOS_DETALLE_POLIZA FD,
               POLIZAS P,
               DETALLE_POLIZA DP
         WHERE P.CodCia              = nCodCia
           AND P.CodEmpresa          = nCodEmpresa 
           AND P.IdPoliza            = nIdPoliza
           AND FD.FecEmision BETWEEN dFechaDesde AND dFechaHasta
           AND P.CodCia              = DP.CodCia
           AND P.CodEmpresa          = DP.CodEmpresa
           AND P.IdPoliza            = DP.IdPoliza 
           AND DP.CodCia             = FD.CodCia
           AND DP.CodEmpresa         = FD.CodEmpresa
           AND DP.IdPoliza           = FD.IdPoliza 
           AND DP.IDetPol            = FD.IDetPol;
    END;
    SELECT XMLROOT (xPrevIntegraSaldo, VERSION '1.0" encoding="UTF-8')
      INTO xIntegraSaldo
      FROM DUAL;
    
    GT_FAI_SERVICIOS_PORTAL.INSERTAR(nCodCia, nCodEmpresa, cCodServicio, TRUNC(SYSDATE), xIntegraSaldo);
END INTEGRACION_SALDO;

PROCEDURE LISTADO_POLIZAS (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nCodCliente IN NUMBER, xListaPolizas OUT XMLTYPE) IS
xPrevListaPolizas   XMLTYPE;   
cCodServicio        FAI_SERVICIOS_PORTAL.CodServicio%TYPE := 'LSTPOL'; 
BEGIN
   BEGIN
      SELECT XMLElement("DATA",
                           XMLAGG(
                              XMLCONCAT(
                                        XMLElement("PolizasCliente", 
                                                     XMLElement("NumerodePoliza",PO.IdPoliza),
                                                     XMLElement("FolioPoliza",PO.NumPolUnico),
                                                     XMLElement("FecIniVig",TO_CHAR(PO.FecIniVig,'DD/MM/YYYY')),
                                                     XMLElement("FecFinVig",TO_CHAR(PO.FecFinVig,'DD/MM/YYYY'))
                                                  )
                                       )
                                 ) 
                           )
        INTO xPrevListaPolizas
        FROM POLIZAS PO,CLIENTES C,PERSONA_NATURAL_JURIDICA P
       WHERE C.CodCliente                                    = nCodCliente
         AND PO.StsPoliza                                    = 'EMI'
         AND PO.CodCliente                                   = C.CodCliente
         AND C.Tipo_Doc_Identificacion                       = P.Tipo_Doc_Identificacion
         AND C.Num_Doc_Identificacion                        = P.Num_Doc_Identificacion
         AND NVL(PO.IndManejaFondos,'N')                     = 'S' ;
   END;
   SELECT XMLROOT (xPrevListaPolizas, VERSION '1.0" encoding="UTF-8')
     INTO xListaPolizas
     FROM DUAL;
   
   GT_FAI_SERVICIOS_PORTAL.INSERTAR(nCodCia, nCodEmpresa, cCodServicio, TRUNC(SYSDATE), xListaPolizas);
END LISTADO_POLIZAS;

END GT_FAI_SERVICIOS_PORTAL;
/

--
-- GT_FAI_SERVICIOS_PORTAL  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_SERVICIOS_PORTAL (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_SERVICIOS_PORTAL FOR SICAS_OC.GT_FAI_SERVICIOS_PORTAL
/


GRANT EXECUTE ON SICAS_OC.GT_FAI_SERVICIOS_PORTAL TO PUBLIC
/

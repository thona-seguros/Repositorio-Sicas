--
-- OC_FACT_ELECT_REPORTE_PORTAL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   XMLTYPE (Type)
--   XQSEQUENCE ()
--   UTL_HTTP (Synonym)
--   DBMS_LOB (Synonym)
--   DBMS_OUTPUT (Synonym)
--   XMLTYPE (Synonym)
--   XQSEQUENCE (Synonym)
--   OC_AGENTES (Package)
--   OC_AGE_DISTRIBUCION_COMISION (Package)
--   POLIZAS (Table)
--   OC_VALORES_DE_LISTAS (Package)
--   PARAMETROS_GLOBALES (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   AGENTES (Table)
--   AGENTE_POLIZA (Table)
--   ASEGURADO (Table)
--   OC_GENERALES (Package)
--   OC_PLAN_COBERTURAS (Package)
--   OC_PLAN_DE_PAGOS (Package)
--   OC_ASEGURADO (Package)
--   OC_CLIENTES (Package)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--   FACT_ELECT_DETALLE_TIMBRE (Table)
--   FACT_ELECT_REPORTE_PORTAL (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACT_ELECT_REPORTE_PORTAL AS
    FUNCTION  NUMERO_ENVIO(nCodCia NUMBER) RETURN NUMBER;
    PROCEDURE GENERAR(nCodCia NUMBER, dFecFactIni DATE, dFecFactFin DATE ) ;
    FUNCTION  ACTUALIZA_WS (nCodCia NUMBER,cInsertWS VARCHAR2) RETURN VARCHAR2;
    PROCEDURE INSERTA(nCodCia NUMBER, cRFC VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER, 
                        cCodAgente NUMBER, cCodPromotor NUMBER, cCodRegional NUMBER,
                        cInsertGenerado VARCHAR2, cCodRespuestaWs VARCHAR2);
END OC_FACT_ELECT_REPORTE_PORTAL;
/

--
-- OC_FACT_ELECT_REPORTE_PORTAL  (Package Body) 
--
--  Dependencies: 
--   OC_FACT_ELECT_REPORTE_PORTAL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACT_ELECT_REPORTE_PORTAL AS
    FUNCTION  NUMERO_ENVIO(nCodCia NUMBER) RETURN NUMBER IS
        nIdEnvio  FACT_ELECT_REPORTE_PORTAL.IdEnvio%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(MAX(IdEnvio),0) + 1
              INTO nIdEnvio
              FROM FACT_ELECT_REPORTE_PORTAL
             WHERE CodCia     = nCodCia;
        EXCEPTION
            WHEN NO_dATA_FOUND THEN
                nIdEnvio:= 1;
        END;
        RETURN nIdEnvio;
    END NUMERO_ENVIO;
    PROCEDURE GENERAR(nCodCia NUMBER, dFecFactIni DATE,dFecFactFin DATE ) IS
        cInsertWS       VARCHAR2(32000);
        cSeparaCampo    VARCHAR2(1)     := ',';
        cSeparaReg      VARCHAR2(1)     := '|';
        cCharVarchar2   VARCHAR2(1)     := '''';
        cTableWorking   VARCHAR2(100)   := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '037');
        cRespWS         VARCHAR2(100);
        cCamposTable    VARCHAR2(30000);
        cWhereDupVal    VARCHAR2(30000);
        CURSOR FACTELECT_Q IS
 SELECT P.CodCia,P.CodEmpresa,P.IdPoliza Consecutivo,
                   P.NumPolUnico Poliza,P.CodAgrupador Agrupador,
                   OC_VALORES_DE_LISTAS.BUSCA_LVALOR ('SUBRAMOS',OC_PLAN_COBERTURAS.CODIGO_SUBRAMO (P.CodCia,P.CodEmpresa,DP.IdTipoSeg,DP.PlanCob)) Ramo,
                   REPLACE(REPLACE (OC_CLIENTES.NOMBRE_CLIENTE (P.CodCliente), '''', ' '),CHR(09)) Contratante,
                   TO_CHAR(P.FecIniVig,'YYYY-MM-DD') Inicio_Vig,TO_CHAR(P.FecFinVig,'YYYY-MM-DD') Fin_Vig,
                   OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN (P.CodCia,P.CodEmpresa,P.CodPlanPago) Plan_Pago,
                   DP.IDetPol Num_Subgrupo,
                   TRIM(CONCAT (OC_VALORES_DE_LISTAS.BUSCA_LVALOR ('ESTADOS', P.StsPoliza) || ' ',
                           DECODE (P.MotivAnul,NULL, '',OC_VALORES_DE_LISTAS.BUSCA_LVALOR ('MTOANUFA', P.MotivAnul)))) Status,
                   TO_CHAR(P.FecSts,'YYYY-MM-DD') Fecha_Status,DECODE(A.Cod_Agente,502,85502,505,85505,507,85507,A.Cod_Agente) Codigo_Agente,
                   OC_AGENTES.NOMBRE_AGENTE (P.CodCia, A.Cod_Agente) Nombre_Agente,
                   OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,2,A.Cod_Agente) Codigo_Promotor,
                   OC_AGENTES.NOMBRE_AGENTE (P.CodCia,OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,2,A.Cod_Agente)) Nombre_Promotor,
                   OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,1,A.Cod_Agente) Codigo_Direccion,
                   OC_AGENTES.NOMBRE_AGENTE (P.CodCia,OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,1,A.Cod_Agente)) Nombre_Direccion,
                   REPLACE (OC_CLIENTES.IDENTIFICACION_TRIBUTARIA (F.codcliente),'''',' ') RFC,
                   P.IdPoliza||REPLACE (OC_CLIENTES.IDENTIFICACION_TRIBUTARIA (F.codcliente),'''',' ')||DP.IDetPol||DECODE(A.Cod_Agente,502,85502,505,85505,507,85507,A.Cod_Agente)||OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,2,A.Cod_Agente)||OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,1,A.Cod_Agente) Rep_UID
              FROM POLIZAS P,DETALLE_POLIZA DP,AGENTE_POLIZA AP,
                   AGENTES A,FACTURAS F,
                   CLIENTES CLI, 
                   PERSONA_NATURAL_JURIDICA PNJ
             WHERE (    P.StsPoliza = 'EMI'
                     OR (P.StsPoliza = 'ANU'
                    AND P.MotivAnul IN ('FPA','COT','CAFP')))
               AND P.IdPoliza    = DP.IdPoliza
               AND P.IndFacturaPol     = 'S'
               AND AP.CodCia     = P.CodCia
               AND AP.IdPoliza   = P.IdPoliza
               AND AP.Cod_Agente = A.Cod_Agente
               AND A.CodCia      = P.CodCia
               AND F.CodCia      = P.CodCia
               AND F.IdPoliza    = DP.IdPoliza
               AND F.IDetPol     = DP.IDetPol
               AND F.FecSts      BETWEEN dFecFactIni AND dFecFactFin
               AND CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
               AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
               AND CLI.CodCliente              = F.codcliente                       
               AND EXISTS (SELECT 1
                             FROM FACT_ELECT_DETALLE_TIMBRE FE
                            WHERE UUID IS NOT NULL
                              AND CodCia = P.CodCia
                              AND FE.IDFACTURA = F.IDFACTURA
                              )                              
               AND NOT EXISTS (SELECT 1
                                 FROM FACT_ELECT_REPORTE_PORTAL RP
                                WHERE RP.CodCia = nCodCia
                                  AND RP.IDPOLIZA = P.IDPOLIZA
                                  AND RP.IDETPOL  = DP.IDETPOL 
                                  and rp.rfc = DECODE(  NVL(LTRIM(RTRIM(pnj.num_tributario)),'N'),'N',pnj.num_doc_identificacion,pnj.num_tributario))
               --AND F.IDFACTURA = 352389
             GROUP BY P.CodCia,P.CodEmpresa,P.IdPoliza,P.NumPolUnico,P.CodAgrupador,
                   DP.IdTipoSeg,DP.PlanCob,P.CodCliente,P.FecIniVig,P.FecFinVig,
                   P.CodPlanPago,DP.IDetPol,P.StsPoliza,P.MotivAnul,P.FecSts,
                   A.Cod_Agente,F.codcliente                   
             UNION              
            SELECT P.CodCia,P.CodEmpresa,P.IdPoliza Consecutivo,
                   P.NumPolUnico Poliza,P.CodAgrupador Agrupador,
                   OC_VALORES_DE_LISTAS.BUSCA_LVALOR ('SUBRAMOS',OC_PLAN_COBERTURAS.CODIGO_SUBRAMO (P.CodCia,P.CodEmpresa,DP.IdTipoSeg,DP.PlanCob)) Ramo,
                   REPLACE(REPLACE (OC_CLIENTES.NOMBRE_CLIENTE (P.CodCliente), '''', ' '),CHR(09)) Contratante,
                   TO_CHAR(P.FecIniVig,'YYYY-MM-DD') Inicio_Vig,TO_CHAR(P.FecFinVig,'YYYY-MM-DD') Fin_Vig,
                   OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN (P.CodCia,P.CodEmpresa,P.CodPlanPago) Plan_Pago,
                   DP.IDetPol Num_Subgrupo,
                   TRIM(CONCAT (OC_VALORES_DE_LISTAS.BUSCA_LVALOR ('ESTADOS', P.StsPoliza) || ' ',
                           DECODE (P.MotivAnul,NULL, '',OC_VALORES_DE_LISTAS.BUSCA_LVALOR ('MTOANUFA', P.MotivAnul)))) Status,
                   TO_CHAR(P.FecSts,'YYYY-MM-DD') Fecha_Status,DECODE(A.Cod_Agente,502,85502,505,85505,507,85507,A.Cod_Agente) Codigo_Agente,
                   OC_AGENTES.NOMBRE_AGENTE (P.CodCia, A.Cod_Agente) Nombre_Agente,
                   OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,2,A.Cod_Agente) Codigo_Promotor,
                   OC_AGENTES.NOMBRE_AGENTE (P.CodCia,OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,2,A.Cod_Agente)) Nombre_Promotor,
                   OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,1,A.Cod_Agente) Codigo_Direccion,
                   OC_AGENTES.NOMBRE_AGENTE (P.CodCia,OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,1,A.Cod_Agente)) Nombre_Direccion,
                   REPLACE(OC_ASEGURADO.IDENTIFICACION_TRIBUTARIA_ASEG (P.CodCia,P.CodEmpresa,ASG.Cod_Asegurado),'''',' ') RFC,
                   P.IdPoliza||REPLACE (OC_ASEGURADO.IDENTIFICACION_TRIBUTARIA_ASEG (P.CodCia,P.CodEmpresa,ASG.Cod_Asegurado),'''',' ')||DP.IDetPol||DECODE(A.Cod_Agente,502,85502,505,85505,507,85507,A.Cod_Agente)||OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,2,A.Cod_Agente)||OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,P.IdPoliza,DP.IDetPol,1,A.Cod_Agente) Rep_UID
              FROM POLIZAS P,DETALLE_POLIZA DP,ASEGURADO ASG, PERSONA_NATURAL_JURIDICA PNJ,AGENTE_POLIZA AP,
                   AGENTES A,FACTURAS F,
                   ASEGURADO ASE, 
                   PERSONA_NATURAL_JURIDICA PNJA
             WHERE PNJ.Num_Doc_Identificacion  = ASG.Num_Doc_Identificacion
               AND PNJ.Tipo_Doc_Identificacion = ASG.Tipo_Doc_Identificacion
               AND ASG.Cod_Asegurado      = DP.Cod_Asegurado
               AND (    P.StsPoliza = 'EMI'
                     OR (P.StsPoliza = 'ANU'
                    AND P.MotivAnul IN ('FPA','COT','CAFP')))
               AND P.IdPoliza       = DP.IdPoliza
               AND P.IndFacturaPol  = 'N'
               AND AP.CodCia        = P.CodCia
               AND AP.IdPoliza      = P.IdPoliza
               AND AP.Cod_Agente    = A.Cod_Agente
               AND A.CodCia         = P.CodCia
               AND F.CodCia         = P.CodCia
               AND F.IdPoliza       = DP.IdPoliza
               AND F.IDetPol        = DP.IDetPol
               AND ASE.Cod_Asegurado           = ASG.Cod_Asegurado
               AND ASE.CodCia                  = P.CodCia
               AND ASE.CodEmpresa              = P.CodEmpresa
               AND PNJA.Num_Doc_Identificacion  = ASE.Num_Doc_Identificacion
               AND PNJA.Tipo_Doc_Identificacion = ASE.Tipo_Doc_Identificacion
               AND F.FecSts         BETWEEN dFecFactIni AND dFecFactFin
               AND EXISTS (SELECT 1
                             FROM FACT_ELECT_DETALLE_TIMBRE FE
                            WHERE UUID IS NOT NULL
                              AND CodCia = P.CodCia
                              AND FE.IDFACTURA = F.IDFACTURA)
               AND NOT EXISTS (SELECT 1
                                        FROM FACT_ELECT_REPORTE_PORTAL RP
                                       WHERE RP.CodCia =   P.CODCIA
                                         AND RP.IDPOLIZA = P.IDPOLIZA
                                         AND RP.IDETPOL  = DP.IDETPOL
                                         AND RP.RFC = DECODE(PNJA.Tipo_Doc_Identificacion,'RFC',PNJA.Num_Doc_Identificacion,PNJA.Num_Tributario))
               --AND P.IDPOLIZA IN (22556)
             GROUP BY P.CodCia,P.CodEmpresa,P.IdPoliza,P.NumPolUnico,P.CodAgrupador,
                   DP.IdTipoSeg,DP.PlanCob,P.CodCliente,P.FecIniVig,P.FecFinVig,
                   P.CodPlanPago,DP.IDetPol,P.StsPoliza,P.MotivAnul,P.FecSts,
                   A.Cod_Agente,F.codcliente, ASG.Cod_Asegurado     ;

    BEGIN
        cCamposTable:=            ' (Rep_Uid,Consecutivo,Numero_Poliza,Agrupador,Ramo,'
                       ||CHR(10)||'  Contratante,Fecha_Inicio_Vigencia,Fecha_Fin_Vigencia,Plan_Pago,Num_Subgrupo,'
                       ||CHR(10)||'  Estatus,Fecha_Estatus,Codigo_Agente,Nombre_Agente,Codigo_Promotor,'
                       ||CHR(10)||'  Nombre_Promotor,Codigo_Direccion,Nombre_Direccion,Rfc,Fecha_Elaboracion_Reporte)'||CHR(10);
        cWhereDupVal:= 'WHERE NOT EXISTS (SELECT Rep_Uid FROM TBL_TR_REPORTES_AG_CARTFACT WHERE Rep_Uid = ';

        FOR W IN FACTELECT_Q LOOP
            cInsertWS := NULL;
            cInsertWS := cInsertWS||'INSERT INTO '||cTableWorking||cCamposTable||'SELECT * FROM (SELECT ';
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Rep_UID         ||cCharVarchar2||' as "Rep_UID"'          ||cSeparaCampo;
            cInsertWS := cInsertWS||                W.Consecutivo                    ||' as "Consecutivo"'      ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Poliza          ||cCharVarchar2||' as "Poliza"'           ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Agrupador       ||cCharVarchar2||' as "Agrupador"'        ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Ramo            ||cCharVarchar2||' as "Ramo"'             ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Contratante     ||cCharVarchar2||' as "Contratante"'      ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Inicio_Vig      ||cCharVarchar2||' as "Inicio_Vig"'       ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Fin_Vig         ||cCharVarchar2||' as "Fin_Vig"'          ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Plan_Pago       ||cCharVarchar2||' as "Plan_Pago"'        ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Num_Subgrupo    ||cCharVarchar2||' as "Num_Subgrupo"'     ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Status          ||cCharVarchar2||' as "Status"'           ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Fecha_Status    ||cCharVarchar2||' as "Fecha_Status"'     ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Codigo_Agente   ||cCharVarchar2||' as "Codigo_Agente"'    ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Nombre_Agente   ||cCharVarchar2||' as "Nombre_Agente"'    ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Codigo_Promotor ||cCharVarchar2||' as "Codigo_Promotor"'  ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Nombre_Promotor ||cCharVarchar2||' as "Nombre_Promotor"'  ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Codigo_Direccion||cCharVarchar2||' as "Codigo_Direccion"' ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.Nombre_Direccion||cCharVarchar2||' as "Nombre_Direccion"' ||cSeparaCampo;
            cInsertWS := cInsertWS||cCharVarchar2 ||W.RFC             ||cCharVarchar2||' as "RFC"'              ||cSeparaCampo;
            cInsertWS := cInsertWS||'NOW()) AS TMP';
            cInsertWS := cInsertWS||CHR(10)||cWhereDupVal||cCharVarchar2||W.Rep_UID||cCharVarchar2||CHR(10)||') LIMIT 1;';

            cRespWS := OC_FACT_ELECT_REPORTE_PORTAL.ACTUALIZA_WS(nCodCia, cInsertWS);
            OC_FACT_ELECT_REPORTE_PORTAL.INSERTA(nCodCia,W.RFC,W.Consecutivo,W.Num_Subgrupo,W.Codigo_Agente,W.Codigo_Promotor,W.Codigo_Direccion,cInsertWS,cRespWS);
        END LOOP;
    END GENERAR;
    FUNCTION  ACTUALIZA_WS (nCodCia NUMBER,cInsertWS VARCHAR2) RETURN VARCHAR2 IS
        cSoapRequest    VARCHAR2(30000);
        cUserSoap       VARCHAR2(100)   := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '034');
        cPwdSoap        VARCHAR2(100)   := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '035');
        cParamBeforeIns VARCHAR2(20)    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '036');
        cTableWorking   VARCHAR2(100)   := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '037');
        eHttpReq        UTL_HTTP.req;
        eHttpResp       UTL_HTTP.resp;
        BreqLength      BINARY_INTEGER;
        cClobXml        XMLType;
        cStrTxt         VARCHAR2(30000);
        cRespWS         VARCHAR2(100);
        cWSDLPortal     PARAMETROS_GLOBALES.Descripcion%TYPE;
    BEGIN
        cWSDLPortal := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'033');
        cSoapRequest :=
        '<?xml version="1.0" encoding="utf-8"?>
         <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
          <soap12:Header>
            <Autenticador xmlns="http://tempuri.org/">
              <strUsuario>'||cUserSoap||'</strUsuario>
              <strClave>'||cPwdSoap||'</strClave>
            </Autenticador>
          </soap12:Header>
          <soap12:Body>
            <InsertsFromString xmlns="http://tempuri.org/">
              <txtInserts>'||cInsertWS||'</txtInserts>
              <deleteBeforeInsert>'||cParamBeforeIns||'</deleteBeforeInsert>
              <workingTable>'||cTableWorking||'</workingTable>
            </InsertsFromString>
          </soap12:Body>
        </soap12:Envelope>';

        eHttpReq := UTL_HTTP.BEGIN_REQUEST (cWSDLPortal, 'POST', 'HTTP/1.1');
        UTL_HTTP.SET_BODY_CHARSET (eHttpReq, 'UTF8');
        UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Type', 'text/xml');
        BreqLength := DBMS_LOB.GETLENGTH(cSoapRequest);

        UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Length', BreqLength);
        UTL_HTTP.WRITE_TEXT (eHttpReq, cSoapRequest);

        eHttpResp := UTL_HTTP.GET_RESPONSE (eHttpReq);
        UTL_HTTP.READ_TEXT(eHttpResp,cStrTxt,32767);
        UTL_HTTP.END_RESPONSE(eHttpResp);
        cClobXml := XMLType.CREATEXML(cStrTxt);

        BEGIN
            SELECT NVL(InsertsFromStringResult,'SIN VALOR')
              INTO cRespWS
              FROM XMLTABLE(XMLNAMESPACES('http://www.w3.org/2003/05/soap-envelope' AS "SOAPENV",
                                          'http://www.w3.org/2001/XMLSchema-instance' AS "XMLSchemainstance",
                                          'http://www.w3.org/2001/XMLSchema' AS "XMLSchema",
                                          'http://tempuri.org/' AS "InsertsFromStringResponse"
                                         ),'/'
                                 PASSING cClobXml
                                 COLUMNS InsertsFromStringResult VARCHAR2(100) PATH '/');

            DBMS_OUTPUT.PUT_LINE(cRespWS);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cRespWS := 'SIN RESPUESTA';
        END;
        RETURN cRespWS;
    EXCEPTION
        WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
          DBMS_OUTPUT.PUT_LINE(cRespWS);
          UTL_HTTP.END_RESPONSE(eHttpResp);
          cRespWS := 'WS-999999';
          RETURN cRespWS;
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(cRespWS);
          UTL_HTTP.END_RESPONSE(eHttpResp);
          cRespWS := 'WS-999999';
          RETURN cRespWS;
    END ACTUALIZA_WS;
    PROCEDURE INSERTA(nCodCia NUMBER, cRFC VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                        cCodAgente NUMBER, cCodPromotor NUMBER, cCodRegional NUMBER,
                        cInsertGenerado VARCHAR2, cCodRespuestaWs VARCHAR2) IS
        nIdEnvio        FACT_ELECT_REPORTE_PORTAL.IdEnvio%TYPE;
        cEstatusEnvio   FACT_ELECT_REPORTE_PORTAL.EstatusEnvio%TYPE;
    BEGIN
        nIdEnvio := OC_FACT_ELECT_REPORTE_PORTAL.NUMERO_ENVIO(nCodCia);
        IF SUBSTR(cCodRespuestaWs,1,9) = 'WS-000000' THEN
            cEstatusEnvio := 'CORRECTO';
        ELSE
            cEstatusEnvio := 'ERROR';
        END IF;

        INSERT INTO FACT_ELECT_REPORTE_PORTAL(IdEnvio, CodCia, Rfc, IdPoliza, IDetPol, CodAgente,
                                              CodPromotor, CodRegional, InsertGenerado, CodRespuestaWs, EstatusEnvio, Fechaenvio)
                                      VALUES (nIdEnvio, nCodCia, cRFC, nIdPoliza, nIDetPol, cCodAgente,
                                              cCodPromotor, cCodRegional, cInsertGenerado, cCodRespuestaWs, cEstatusEnvio, TRUNC(SYSDATE));
    END INSERTA;

END OC_FACT_ELECT_REPORTE_PORTAL;
/

--
-- OC_FACT_ELECT_REPORTE_PORTAL  (Synonym) 
--
--  Dependencies: 
--   OC_FACT_ELECT_REPORTE_PORTAL (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_FACT_ELECT_REPORTE_PORTAL FOR SICAS_OC.OC_FACT_ELECT_REPORTE_PORTAL
/


GRANT EXECUTE ON SICAS_OC.OC_FACT_ELECT_REPORTE_PORTAL TO PUBLIC
/

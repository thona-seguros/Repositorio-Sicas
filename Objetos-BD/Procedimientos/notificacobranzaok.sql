--
-- NOTIFICACOBRANZAOK  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   UTL_TCP (Synonym)
--   DBMS_STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   POLIZAS (Table)
--   FAI_CONFIG_APORTE_FONDO_DET (Table)
--   FAI_FONDOS_DETALLE_POLIZA (Table)
--   OC_EMPRESAS (Package)
--   GT_FAI_CONFIG_APORTE_FONDO_DET (Package)
--   GT_FAI_FONDOS_DETALLE_POLIZA (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   DETALLE_DOMICI_REFERE (Table)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   OC_DETALLE_POLIZA (Package)
--   CLIENTES (Table)
--   OC_GENERALES (Package)
--   OC_MAIL (Package)
--   OC_PERSONA_NATURAL_JURIDICA (Package)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.NOTIFICACOBRANZAOK (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdFactura NUMBER) IS
nCodCliente             CLIENTES.CodCliente%TYPE;
cTipoDocIdentificacion  CLIENTES.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentificacion   CLIENTES.Num_Doc_Identificacion%TYPE;
cEmailCliente           CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
nCodAsegurado           DETALLE_POLIZA.Cod_Asegurado%TYPE;
dFecIniVig              POLIZAS.FecIniVig%TYPE;
cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob                DETALLE_POLIZA.PlanCob%TYPE;
nMontoPagoFact          DETALLE_DOMICI_REFERE.Monto%TYPE;
dFecAplica              DETALLE_DOMICI_REFERE.FecAplica%TYPE;
nNumCuota               FACTURAS.NumCuota%TYPE;
nAporteFondo             DETALLE_POLIZA.MontoAporteFondo%TYPE;
nIdFondo                 FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nPrimaNivelada           FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;

cSubject                VARCHAR2(10000);
cMessage                VARCHAR2(20000);
cEmailAuth              VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
cPwdEmail               VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
cEmailEnvio             VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
cCadenaLogo             VARCHAR2(200)     := ' <img src="http://www.thonaseguros.mx/images/Thona_Seguros.png" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="80" width="300"> ';
cAvisoImportante        VARCHAR2(1000)    := 'AVISO IMPORTANTE. Este correo electrónico y cualquier archivo que se adjunte al mismo, es propiedad de THONA Seguros S.A. de C.V., y podrá '||
                                             'contener información privada y privilegiada para uso exclusivo del destinatario. Si usted ha recibido este correo por error, por favor, notifique '||
                                             'al remitente y bórrelo. No está autorizado para copiar, retransmitir, utilizar o divulgar este mensaje ni los archivos adjuntos, de lo contrario '||
                                             'estará infringiendo leyes mexicanas y de otros países que se aplican rigurosamente.';
cHTMLHeader             VARCHAR2(2000)    := '<html>'                                                                     ||CHR(13)||
                                             '<head>'                                                                     ||CHR(13)||
                                             '<meta http-equiv="Content-Language" content="en/us"/>'                      ||CHR(13)||
                                             '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||CHR(13)||
                                                --'</head><body background="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" bgcolor="aqua" width="120" height="280">' ||CHR(13);
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
BEGIN
   BEGIN
      SELECT P.Codcliente,C.Tipo_Doc_Identificacion,C.Num_Doc_Identificacion,
             P.NumPolUnico,P.FecIniVig,DP.IdTipoSeg,DP.PlanCob,DP.Cod_Asegurado
        INTO nCodCliente,cTipoDocIdentificacion,cNumDocIdentificacion,
             cNumPolUnico,dFecIniVig,cIdTipoSeg,cPlanCob,nCodAsegurado
        FROM POLIZAS P,CLIENTES C,DETALLE_POLIZA DP
       WHERE P.CodCia       = nCodCia
         AND P.CodEmpresa   = nCodEmpresa
         AND P.IdPoliza     = nIdPoliza
         AND P.CodCliente   = C.CodCliente
         AND P.CodCia       = DP.CodCia
         AND P.CodEmpresa   = DP.CodEmpresa
         AND P.IdPoliza     = DP.IdPoliza;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20225,'No Es Posible Obtener Datos del Cliente Para la Póliza '||nIdPoliza);
   END;
   
   BEGIN
      SELECT NVL(F.Monto_Fact_Local,0),F.FecPago,NVL(F.NumCuota,0)
        INTO nMontoPagoFact,dFecAplica,nNumCuota
        FROM FACTURAS F
       WHERE F.IdFactura = nIdFactura 
         AND F.CodCia    = nCodCia
         AND F.StsFact   = 'PAG';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoPagoFact := 0;
         dFecAplica     := TRUNC(SYSDATE);
         nNumCuota      := 0;
   END;
           
           
   IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
      nAporteFondo   := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, nCodEmpresa, nIdPoliza,  nIDetPol);
      nIdFondo       := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado);
      IF NVL(nIdFondo,0) > 0 THEN
         nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo, nNumCuota);
      ELSE
         nPrimaNivelada := 0;
      END IF;
   ELSE
      nAporteFondo   := 0;
      nPrimaNivelada := 0;
   END IF;
            
   nMontoPagoFact := nMontoPagoFact + NVL(nAporteFondo,0) + NVL(nPrimaNivelada,0);
      
   cEmailCliente  := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentificacion, cNumDocIdentificacion);
   
   cSubject := 'Cobranza Exitosa Póliza '||cNumPolUnico||' Cliente '||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion);
   cMessage := cHTMLHeader                                                                                                                                                                      ||
               cTextoAlignDerecha||'Ref.: Cobranza exitosa  póliza '||cTextoRojoOpen||cNumPolUnico||cTextoClose||cTextoAlignDerechaClose                                                        ||cSaltoLinea||
               cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||
               'Hacemos de su conocimiento, que el pasado '||cTextoRojoOpen||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFecAplica))||cTextoClose||' '                                                   ||
               'se realizó el cobro a la cuenta bancaria que nos proporcionó de forma exitosa, correspondiente a la prima de seguro más aportación adicional por '                              ||
               cTextoRojoOpen||TO_CHAR(nMontoPagoFact,'$9,999.99')||cTextoClose||' '||'cubriendo el pago número '||cTextoRojoOpen||nNumCuota||cTextoClose                                       ||
               ', el cual se verá reflejado en su estado de cuenta, en las siguientes 72 hrs.'                                                                                                  ||cSaltoLinea||cSaltoLinea||
               'Agradecemos su atención y nos ponemos a sus órdenes para cualquier duda o aclaración  en el centro de Servicios a Asegurados, para todo lo relacionado con su plan '            ||
               cTextoAmarilloOpen||cTextoImportanteOpen||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||cTextoImportanteClose||cTextoClose                               ||
               ', en horarios de oficina, nuestro teléfono de contacto  (55) 44-33-89-00 opción 2, o bien por Correo electrónico mipolizaflex@thonaseguros.mx, donde con gusto lo atenderemos.' ||cSaltoLinea||cSaltoLinea||cSaltoLinea||
               cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||UTL_TCP.CRLF                                         ||cSaltoLinea||
               cCadenaLogo                                                                                                                                                                      ||cSaltoLinea||cSaltoLinea||
               cTextoSmall||cAvisoImportante||cTextoClose                                                                                                                                       ||cSaltoLinea||
               cHTMLFooter;
                  
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
   OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,/*'esaavedra@thonaseguros.mx'*/null,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
    
END NOTIFICACOBRANZAOK;
/

--
-- NOTIFICACOBRANZAOK  (Synonym) 
--
--  Dependencies: 
--   NOTIFICACOBRANZAOK (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM NOTIFICACOBRANZAOK FOR SICAS_OC.NOTIFICACOBRANZAOK
/


GRANT EXECUTE ON SICAS_OC.NOTIFICACOBRANZAOK TO PUBLIC
/

--
-- NOTIFICABIENVENIDA  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   UTL_TCP (Synonym)
--   POLIZAS (Table)
--   DETALLE_POLIZA (Table)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   CLIENTES (Table)
--   OC_EMPRESAS (Package)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_GENERALES (Package)
--   OC_MAIL (Package)
--   OC_PERSONA_NATURAL_JURIDICA (Package)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.NOTIFICABIENVENIDA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
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
             P.NumPolUnico,P.FecIniVig,DP.IdTipoSeg
        INTO nCodCliente,cTipoDocIdentificacion,cNumDocIdentificacion,
             cNumPolUnico,dFecIniVig,cIdTipoSeg
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
   
   cEmailCliente := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentificacion, cNumDocIdentificacion);
   
   cSubject := 'Bienvenido a Portal "Tus Fondos Thona" '||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion);
   cMessage := cHTMLHeader                                                                                                                                                                      ||
               cTextoAlignDerecha||'Ref.: Bienvenida al Portal "Tus Fondos Thona" Póliza '||cTextoImportanteOpen||cNumPolUnico||cTextoImportanteClose||cTextoAlignDerechaClose                  ||cSaltoLinea||
               cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||                  
               'Queremos darle la más cordial bienvenida a nuestro portal'||cTextoImportanteOpen||' "Tus Fondos Thona" '||cTextoImportanteClose                                                 ||
               'a partir de este momento podrá consultar aquí la información sobre tu póliza, estado de cuenta, movimientos entre otra información relevante.'                                  ||cSaltoLinea||cSaltoLinea||
               'Usted tendrá acceso al portal '||cTextoImportanteOpen||'"Tus Fondos Thona" '||cTextoImportanteClose||' accediendo a la liga:  '                                                 ||
               'http://inversiones.thonaseguros.mx/Account/Login  y  registrándose con su contraseña.'                                                                                          ||cSaltoLinea||cSaltoLinea||
               'Agradecemos su atención y nos ponemos a sus órdenes para cualquier duda o aclaración en el centro de Servicios a Asegurados, para todo lo relacionado con su plan '             ||
               cTextoAmarilloOpen||cTextoImportanteOpen||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||cTextoImportanteClose||cTextoClose                               ||
               ', en horario de lunes a jueves de 9:00 a 18:00 hrs. y viernes de 9:00 a 15:00 hrs, nuestro teléfono de contacto  (55) 44-33-89-00 opción 2, o bien por Correo electrónico '     ||
               'mipolizaflex@thonaseguros.mx, donde con gusto lo atenderemos.'                                                                                                                  ||cSaltoLinea||cSaltoLinea||cSaltoLinea||
               cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||UTL_TCP.CRLF                                         ||cSaltoLinea||
               cCadenaLogo                                                                                                                                                                      ||cSaltoLinea||cSaltoLinea||
               cSaltoLinea||cTextoSmall||cAvisoImportante||cTextoClose                                                                                                                          ||cSaltoLinea||
               cHTMLFooter;
                  
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
   OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,NULL,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
    
END NOTIFICABIENVENIDA;
/

--
-- NOTIFICACOTIZACION  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   UTL_TCP (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   OC_EMPRESAS (Package)
--   OC_GENERALES (Package)
--   OC_MAIL (Package)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.NotificaCotizacion( nCodCia          NUMBER
                                              , cEmailCC         VARCHAR2
                                              , cEmailCliente    VARCHAR2
                                              , cCodCotizador    VARCHAR2
                                              , cIdCotizaciones  VARCHAR2
                                              , cTipoAtencion    VARCHAR2
                                              , cTextoAdicional  VARCHAR2 ) IS
   cSubject                VARCHAR2(10000);
   cMessage                VARCHAR2(20000);
   cEmailAuth              VARCHAR2(100)    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
   cPwdEmail               VARCHAR2(100)    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
   cEmailEnvio             VARCHAR2(100)    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
   cCadenaLogo             VARCHAR2(200)    := ' <img src="http://www.thonaseguros.mx/images/Thona_Seguros.png" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="80" width="300"> ';
   cAvisoImportante        VARCHAR2(1000)   := 'AVISO IMPORTANTE. Este correo electrónico y cualquier archivo que se adjunte al mismo, son propiedad de THONA Seguros S.A. de C.V.,' ||
                                               ' y podrá contener información privada y privilegiada para uso exclusivo del destinatario. Si usted ha recibido este correo por error,' ||
                                               ' por favor, notifique al remitente y bórrelo. No está autorizado para copiar, retransmitir, utilizar o divulgar este mensaje ni los'   ||
                                               ' archivos adjuntos, de lo contrario estará infringiendo leyes mexicanas y de otros países que se aplican rigurosamente.';
   cHTMLHeader             VARCHAR2(2000)   := '<html>'                                                                     ||CHR(13)||
                                               '<head>'                                                                     ||CHR(13)||
                                               '<meta http-equiv="Content-Language" content="en/us"/>'                      ||CHR(13)||
                                               '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||CHR(13)||
                                               '</head><body>'                                                              ||CHR(13);
   cHTMLFooter             VARCHAR2(100)    := '</body></html>';
   cTextoAlignDerecha      VARCHAR2(50)     := '<P align="right">';
   cTextoAlignDerechaClose VARCHAR2(50)     := '</P>';
   cSaltoLinea             VARCHAR2(5)      := '<br>';
   cTextoImportanteOpen    VARCHAR2(10)     := '<strong>';
   cTextoImportanteClose   VARCHAR2(10)     := '</strong>';
   cTextoRojoOpen          VARCHAR2(100)    := '<FONT COLOR="red">';
   cTextoAmarilloOpen      VARCHAR2(100)    := '<FONT COLOR="#ffbf00">';
   cTextoClose             VARCHAR2(30)     := '</FONT>';
   cTextoSmallAzul         VARCHAR2(100)    := '<FONT SIZE="2" COLOR="blue">';
   cTextoSmallVerde        VARCHAR2(100)    := '<FONT SIZE="2" COLOR="green">';
   cError                  VARCHAR2(200);
BEGIN
   IF cTipoAtencion = 'S' THEN -- Solicitud de Atención
      cSubject := 'Solicitud de Actualización de Vigencia de Cotizaciones Vencidas';
      cMessage := cHTMLHeader ||
                  cTextoAlignDerecha || 'Cotizaciones de: ' || cTextoRojoOpen || cCodCotizador || cTextoClose || cTextoAlignDerechaClose || cSaltoLinea ||
                  'Estimados:' || cSaltoLinea || cSaltoLinea ||
                  'Por medio del presente, se solicita de su apoyo para actualizar la vigencia de las siguientes cotizaciones vencidas: ' || cTextoRojoOpen || cIdCotizaciones ||
                  cTextoClose || '.' ||  cSaltoLinea || cSaltoLinea ||
                  'De antemano agradezco su atención y quedo en espera de su información.' || cTextoClose || cSaltoLinea || cSaltoLinea || cSaltoLinea ||
                  cTextoImportanteOpen || cTextoSmallVerde || 'Este correo es generado de manera automática, por favor no lo responda.' || cTextoImportanteClose || UTL_TCP.CRLF ||
                  cSaltoLinea || cCadenaLogo || cSaltoLinea || cSaltoLinea || cSaltoLinea || cTextoImportanteOpen || cTextoSmallAzul || cAvisoImportante || cTextoClose || cTextoImportanteClose || cSaltoLinea ||
                  cHTMLFooter;
   ELSIF cTipoAtencion = 'A' THEN -- Solicitud Atendida
      cSubject := 'Atención de Solicitud de Actualización de Vigencia de Cotizaciones Vencidas';
      cMessage := cHTMLHeader ||
                  cTextoAlignDerecha || 'Cotizaciones de: ' || cTextoRojoOpen || cCodCotizador || cTextoClose || cTextoAlignDerechaClose || cSaltoLinea ||
                  'Estimados:' || cSaltoLinea || cSaltoLinea ||
                  'Por medio del presente, hacemos de su conocimiento que la cotización: ' || cTextoRojoOpen || cIdCotizaciones ||
                  cTextoClose || ' ya fue atendida.' ||  cSaltoLinea || cSaltoLinea;
                  --
                  IF cTextoAdicional IS NOT NULL THEN
                     cMessage := cMessage || cTextoAdicional ||  cSaltoLinea || cSaltoLinea;
                  END IF;
                  --
                  cMessage := cMessage || 'Saludos Cordiales.' || cTextoClose || cSaltoLinea || cSaltoLinea || cSaltoLinea ||
                  cTextoImportanteOpen || cTextoSmallVerde || 'Este correo es generado de manera automática, por favor no lo responda.' || cTextoImportanteClose || UTL_TCP.CRLF ||
                  cSaltoLinea || cCadenaLogo || cSaltoLinea || cSaltoLinea || cSaltoLinea || cTextoImportanteOpen || cTextoSmallAzul || cAvisoImportante || cTextoClose || cTextoImportanteClose || cSaltoLinea ||
                  cHTMLFooter;
   ELSIF cTipoAtencion = 'C' THEN -- Solicitud Cancelada
      cSubject := 'Cancelación de Solicitud de Actualización de Vigencia de Cotizaciones Vencidas';
      cMessage := cHTMLHeader ||
                  cTextoAlignDerecha || 'Cotizaciones de: ' || cTextoRojoOpen || cCodCotizador || cTextoClose || cTextoAlignDerechaClose || cSaltoLinea ||
                  'Estimados:' || cSaltoLinea || cSaltoLinea ||
                  'Por medio del presente, hacemos de su conocimiento que la cotización: ' || cTextoRojoOpen || cIdCotizaciones ||
                  cTextoClose || ' no procede y fue cancelada.' ||  cSaltoLinea || cSaltoLinea;
                  --
                  IF cTextoAdicional IS NOT NULL THEN
                     cMessage := cMessage || cTextoAdicional ||  cSaltoLinea || cSaltoLinea;
                  END IF;
                  --
                  cMessage := cMessage || 'Saludos Cordiales.' || cTextoClose || cSaltoLinea || cSaltoLinea || cSaltoLinea ||
                  cTextoImportanteOpen || cTextoSmallVerde || 'Este correo es generado de manera automática, por favor no lo responda.' || cTextoImportanteClose || UTL_TCP.CRLF ||
                  cSaltoLinea || cCadenaLogo || cSaltoLinea || cSaltoLinea || cSaltoLinea || cTextoImportanteOpen || cTextoSmallAzul || cAvisoImportante || cTextoClose || cTextoImportanteClose || cSaltoLinea ||
                  cHTMLFooter;
   END IF;   
   --                  
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
   OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,cEmailCC,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
END NotificaCotizacion;
/

--
-- NOTIFICACOTIZACION  (Synonym) 
--
--  Dependencies: 
--   NOTIFICACOTIZACION (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM NOTIFICACOTIZACION FOR SICAS_OC.NOTIFICACOTIZACION
/


GRANT EXECUTE ON SICAS_OC.NOTIFICACOTIZACION TO PUBLIC
/

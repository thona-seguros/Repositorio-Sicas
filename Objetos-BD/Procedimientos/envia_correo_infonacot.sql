--
-- ENVIA_CORREO_INFONACOT  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   OC_EMPRESAS (Package)
--   OC_ADICIONALES_EMPRESA (Package)
--   OC_GENERALES (Package)
--   OC_MAIL (Package)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.ENVIA_CORREO_INFONACOT(nCodCia           IN NUMBER,
                                                   cSubject          IN VARCHAR2,
                                                   cmensaje          IN VARCHAR2
                                                  ) IS
                                          
cMessage                VARCHAR2(4000);
-- PRODUCCION
cEmailAuth              VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');  
cPwdEmail               VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
-- PRUEBAS
--cEmailAuth              VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'041');
--cPwdEmail               VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'040');
--
cEmailEnvio             VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'039');
cError                  VARCHAR2(200);
cHTMLHeader             VARCHAR2(2000) := '<html><head><meta http-equiv="Content-Language" content="en-us" />'          ||CHR(13)||
                                          '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />'||CHR(13)||
                                          '</head><body>'                                                               ||CHR(13);
cHTMLFooter             VARCHAR2(100)  := '</body></html>';
cSaltoLinea             VARCHAR2(5)    := '<br>';
cTextoImportanteOpen    VARCHAR2(10)   := '<strong>';
cTextoImportanteClose   VARCHAR2(10)   := '</strong>';
BEGIN
  --
  cMessage  := cHTMLHeader||
               'A todos: '||cSaltoLinea||cSaltoLinea||
               '    '||CMENSAJE||cSaltoLinea||cSaltoLinea||
               cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||cSaltoLinea||
               ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '||cSaltoLinea||cHTMLFooter;
  --
  OC_MAIL.INIT_PARAM;
  OC_MAIL.cCtaEnvio   := cEmailAuth;
  OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
  --
  -- ENVIO DE CORREO        
  --
  OC_MAIL.SEND_EMAIL
   (NULL,        --P_DIRECTORY 
    cEmailAuth, --P_SENDER
    cEmailEnvio, --P_RECIPIENT
    NULL,        --P_CC
    NULL,        --BCC
    cSubject,    --P_SUBJECT
    CMessage,    --P_BODY
    NULL,        --P_ATTACHMENT1
    NULL,        --P_ATTACHMENT2
    NULL,        --P_ATTACHMENT3
    NULL,        --P_ATTACHMENT4
    cError       --P_ERROR
   );
   --
END ENVIA_CORREO_INFONACOT;
/

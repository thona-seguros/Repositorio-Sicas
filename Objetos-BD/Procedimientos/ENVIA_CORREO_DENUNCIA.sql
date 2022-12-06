CREATE OR REPLACE PROCEDURE ENVIA_CORREO_DENUNCIA(nCodCia           IN NUMBER,
                                                  cFolioDenuncia    IN VARCHAR2,
                                                  cErrorEnvio       OUT VARCHAR2
                                                  ) IS

  cEmail                       USUARIOS.EMAIL%TYPE;
  cPwdEmail                    VARCHAR2(100);
  cMiMail                      USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
  cSaltoLinea                  VARCHAR2(5)      := '<br>';
  cHTMLHeader                  VARCHAR2(2000)   := '<html>'                                                                     ||cSaltoLinea||
                                                   '<head>'                                                                     ||cSaltoLinea||
                                                   '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
                                                   '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||cSaltoLinea||
                                                   '</head><body>'                                                              ||cSaltoLinea;
   cHTMLFooter                 VARCHAR2(100)    := '</body></html>';
   cTextoAlignDerecha          VARCHAR2(50)     := '<P align="CENTER">';
   cTextoAlignDerechaClose     VARCHAR2(50)     := '</P>';
   cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
   cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
   cError                      VARCHAR2(1000);
   nDummy                      VARCHAR2(200);

   nLeidos                     NUMBER := 0;

   cSubject                    VARCHAR2(500);
   cTexto1                     VARCHAR2(500);
   cTexto2                     VARCHAR2(200);
   cTexto3                     VARCHAR2(150);
   cTexto4                     VARCHAR2(150);
   cTexto5                     VARCHAR2(150);
   cTexto6                     VARCHAR2(150);
   cTextoEnvio                 VARCHAR2(1000);

   cEmails                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;

 cCtasEmail  PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO%TYPE;
 nDummy         VARCHAR2(200);
-- cEmail    PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO%TYPE;
 
 CURSOR cCuentas is
   SELECT *
   FROM   VALORES_DE_LISTAS
   WHERE  CODLISTA = 'EMAILOPPRE';
	
BEGIN
  --
  cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
  cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
  
  -- se obtienen las cuentas de correo
  BEGIN
		FOR I IN cCuentas LOOP
	    cCtasEmail	:= I.DESCVALLST||';';
	  END LOOP;     
  END; 
    
  cSubject := 'Confirmaci�n recepci�n de denuncia';
  
  cTexto1  := 'Estimado colaborador. ';
  cTexto2  := 'Hemos recibido tu denuncia la cual se le asign� el folio no. ';
  cTexto3  := '. Se iniciar� la investigaci�n por el Oficial de Cumplimiento bajo una estricta confidencialidad.';
  cTexto4  := 'Agradecemos tu compromiso con Thona Seguros.';
  cTexto5  := 'Atentamente.';
  cTexto6  := 'Oficial de Cumplimiento.';
  
  cTextoEnvio := cHTMLHeader||cTexto1||cSaltoLinea||cSaltoLinea||cSaltoLinea||
                 cTexto2||cFolioDenuncia||cTexto3||cSaltoLinea||cSaltoLinea||
                 cTexto4||cSaltoLinea||cSaltoLinea||cTexto5||cSaltoLinea||cSaltoLinea||
                 cTexto6||cSaltoLinea||cSaltoLinea||cHTMLFooter;   
                 
  --
  OC_MAIL.INIT_PARAM;
  OC_MAIL.cCtaEnvio   := cEmail;
  OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
  --
  -- ENVIO DE CORREO
  --
  
  BEGIN 
    cErrorEnvio := 0;
    OC_MAIL.SEND_EMAIL(
        NULL,        --P_DIRECTORY
        cMiMail    , --P_SENDER
        cCtasEmail, --P_RECIPIENT
        NULL,        --P_CC
        NULL,        --BCC
        cSubject,    --P_SUBJECT
        cTextoEnvio,    --P_BODY
        NULL,        --P_ATTACHMENT1
        NULL,        --P_ATTACHMENT2
        NULL,        --P_ATTACHMENT3
        NULL,        --P_ATTACHMENT4
        cErrorEnvio  --P_ERROR
       );
       
   EXCEPTION WHEN OTHERS THEN
      cErrorEnvio := 'ERROR EN EL ENV�O DE LA DENUNCIA '||CFOLIODENUNCIA || '  ' ||SQLERRM;
      DBMS_OUTPUT.PUT_LINE('ERROR EN EL ENV�O DE LA DENUNCIA '||CFOLIODENUNCIA || '  ' ||SQLERRM);              
   END;
   --
END ENVIA_CORREO_DENUNCIA;
/
CREATE OR REPLACE PUBLIC SYNONYM ENVIA_CORREO_DENUNCIA FOR SICAS_OC.ENVIA_CORREO_DENUNCIA


GRANT EXECUTE ON SICAS_OC.ENVIA_CORREO_DENUNCIA TO PUBLIC
/
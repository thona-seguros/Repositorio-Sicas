CREATE OR REPLACE PACKAGE SICAS_OC.OC_CTRL_MAIL_NOTIFICACIONES IS
/*
Desarrollador: Luis Argenis Reynoso Alvarez
Fecha: 11/09/2023
Descripción: Registro de correos ViCapital para Bienvenida y Cobranza, mediante los Procedures
	de envío de correos
*/
  PROCEDURE SPINSERT(
                      PA_TIPO             IN    VARCHAR2,
                      PA_IDPOLIZA         IN    NUMBER,
                      PA_IDTIPOSEG        IN    VARCHAR2,
                      PA_IDETPOL          IN    NUMBER,
                      PA_IDFACTURA        IN    NUMBER DEFAULT 0,
                      PA_ADJUNTOS         IN    CLOB,
                      PA_DESTINATARIO     IN    VARCHAR2,
                      PA_CCOPIAS          IN    VARCHAR2,
                      PA_SUBJECT          IN    VARCHAR2,
                      PA_BODYMAIL         IN    VARCHAR2,
                      PA_RESPUESTA        IN    VARCHAR2,
                      PA_CODIGO           OUT   NUMBER,
                      PA_MENSAJE          OUT   VARCHAR2
                      );
                      
  PROCEDURE SPREENVIO(
                      PA_IDEVENTO         IN    NUMBER,
                      PA_EMAILDESTINO     IN    VARCHAR2,
                      PA_MAILSCC          IN    VARCHAR2,
                      PA_SUBJECT          IN    VARCHAR2,
                      PA_BODYMAIL         IN    VARCHAR2,
                      PA_CODIGO           OUT   NUMBER,
                      PA_MENSAJE          OUT   VARCHAR2
                      );
                      
END;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CTRL_MAIL_NOTIFICACIONES IS

/*
Desarrollador: Luis Argenis Reynoso Alvarez
Fecha: 11/09/2023
Descripción: Registro de correos ViCapital para Bienvenida y Cobranza, mediante los Procedures
	de envío de correos
*/

  PROCEDURE SPINSERT(
                      PA_TIPO             IN    VARCHAR2,
                      PA_IDPOLIZA         IN    NUMBER,
                      PA_IDTIPOSEG        IN    VARCHAR2,
                      PA_IDETPOL          IN    NUMBER,
                      PA_IDFACTURA        IN    NUMBER DEFAULT 0,
                      PA_ADJUNTOS         IN    CLOB,
                      PA_DESTINATARIO     IN    VARCHAR2,
                      PA_CCOPIAS          IN    VARCHAR2,
                      PA_SUBJECT          IN    VARCHAR2,
                      PA_BODYMAIL         IN    VARCHAR2,
                      PA_RESPUESTA        IN    VARCHAR2,
                      PA_CODIGO           OUT   NUMBER,
                      PA_MENSAJE          OUT   VARCHAR2
                      ) IS
  BEGIN
    INSERT INTO SICAS_OC.CTRL_MAIL_NOTIFICACIONES (
                                                IDENVIO,
                                                CODCIA,
                                                CODEMPRESA,
                                                TIPO,
                                                IDPOLIZA,
                                                IDTIPOSEG,
                                                IDETPOL,
                                                IDFACTURA,
                                                ADJUNTOS,
                                                DESTINATARIO,
                                                CCCOPIAS,
                                                SUBJECT,
                                                BODYMAIL,
                                                FECHAENVIO,
                                                NREENVIOS,
                                                RESPUESTA,
                                                FECHAMODIF,
                                                USRMODIF
                                              )
                                        VALUES(
                                                SICAS_OC.SEQ_CTRLMAIL_NOTIF.NEXTVAL, 
                                                1,
                                                1,
                                                PA_TIPO,
                                                PA_IDPOLIZA,
                                                PA_IDTIPOSEG,
                                                PA_IDETPOL,
                                                PA_IDFACTURA,
                                                PA_ADJUNTOS,
                                                PA_DESTINATARIO,
                                                PA_CCOPIAS,
                                                PA_SUBJECT,
                                                PA_BODYMAIL,
                                                SYSDATE,
                                                0,
                                                PA_RESPUESTA,
                                                SYSDATE,
                                                USER
                                                    );
    COMMIT;
    PA_CODIGO := 1;
    PA_MENSAJE := 'Proceso terminado con éxito.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      PA_CODIGO := SQLCODE;
      PA_MENSAJE := 'Ocurrió un error: '||SQLERRM;
  END;
  
  PROCEDURE SPREENVIO(
                      PA_IDEVENTO         IN    NUMBER,
                      PA_EMAILDESTINO     IN    VARCHAR2,
                      PA_MAILSCC          IN    VARCHAR2,
                      PA_SUBJECT          IN    VARCHAR2,
                      PA_BODYMAIL         IN    VARCHAR2,
                      PA_CODIGO           OUT   NUMBER,
                      PA_MENSAJE          OUT   VARCHAR2
                      ) IS
	cError                  VARCHAR2(200);
	cEmailAuth              VARCHAR2(100)   := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
	cPwdEmail               VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
	cEmailEnvio             VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(1,'042');
  
	BEGIN
    
		OC_MAIL.INIT_PARAM;
		OC_MAIL.cCtaEnvio   := cEmailAuth;
		OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
		OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,PA_EMAILDESTINO,PA_MAILSCC,NULL,PA_SUBJECT,PA_BODYMAIL,NULL,NULL,NULL,NULL,cError);

		UPDATE SICAS_OC.CTRL_MAIL_NOTIFICACIONES
		SET FECHAREENVIO = SYSDATE,
			NREENVIOS = NREENVIOS + 1,
			RESPUESTA = cError,
			FECHAMODIF = SYSDATE,
			USRMODIF = USER
		WHERE IDENVIO = PA_IDEVENTO;
		
		COMMIT;
    
		PA_CODIGO := 1;
		PA_MENSAJE := 'Reenvió terminado con éxito.';
      
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			PA_CODIGO := SQLCODE;
			PA_MENSAJE := 'Ocurrió un error: '||SQLERRM;
	END;
  
END;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_CTRL_MAIL_NOTIFICACIONES FOR SICAS_OC.OC_CTRL_MAIL_NOTIFICACIONES;
/

GRANT EXECUTE ON SICAS_OC.OC_CTRL_MAIL_NOTIFICACIONES TO PUBLIC;
/
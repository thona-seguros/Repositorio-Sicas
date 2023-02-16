CREATE OR REPLACE PACKAGE          OC_SENDMAIL IS
    PROCEDURE SEND_MAIL_AGENTES(cCtaEnvio IN VARCHAR2,cPwdEmail IN VARCHAR2,cEmail IN VARCHAR2,
                        cEmailAgen IN VARCHAR2,cEmailCC IN VARCHAR2 DEFAULT NULL,
                        cEmailBCC IN VARCHAR2 DEFAULT NULL,cSubject IN VARCHAR2,cMessage IN VARCHAR2);
END OC_SENDMAIL;
/

CREATE OR REPLACE PACKAGE BODY          OC_SENDMAIL IS

    PROCEDURE SEND_MAIL_AGENTES(cCtaEnvio IN VARCHAR2,cPwdEmail IN VARCHAR2,cEmail IN VARCHAR2,
                        cEmailAgen IN VARCHAR2,cEmailCC IN VARCHAR2 DEFAULT NULL,
                        cEmailBCC IN VARCHAR2 DEFAULT NULL,cSubject IN VARCHAR2,cMessage IN VARCHAR2) IS
    BEGIN
        OC_MAIL.INIT_PARAM;
        --OC_MAIL.cCtaEnvio       := cEmail;
        OC_MAIL.cCtaEnvio    := cCtaEnvio;
        OC_MAIL.cPwdCtaEnvio := cPwdEmail;
        OC_MAIL.MAIL(cEmail,cEmailAgen,cEmailCC,cEmailBCC,cSubject,cMessage);
    END SEND_MAIL_AGENTES;

END OC_SENDMAIL;

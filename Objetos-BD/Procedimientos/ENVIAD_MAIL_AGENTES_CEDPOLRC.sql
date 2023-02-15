PROCEDURE          ENVIAD_MAIL_AGENTES_CEDPOLRC  IS
PROCEDURE          ENVIAD_MAIL_AGENTES_CEDPOLRC  IS
  W_ID_TERMINAL               CONTROL_PROCESOS_AUTOMATICOS.ID_TERMINAL%TYPE;
  W_ID_TERMINAL               CONTROL_PROCESOS_AUTOMATICOS.ID_TERMINAL%TYPE;
  W_ID_USER                   CONTROL_PROCESOS_AUTOMATICOS.ID_USER%TYPE;
  W_ID_USER                   CONTROL_PROCESOS_AUTOMATICOS.ID_USER%TYPE;
  W_ID_ENVIO                  CONTROL_PROCESOS_AUTOMATICOS.ID_ENVIO%TYPE; 
  W_ID_ENVIO                  CONTROL_PROCESOS_AUTOMATICOS.ID_ENVIO%TYPE;
  nLeidos                     NUMBER := 0;
  nLeidos                     NUMBER := 0;
  cEmail                      USUARIOS.EMAIL%TYPE;  
----
  cPwdEmail                   VARCHAR2(100); 
  nProcesar                   NUMBER;
  cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';      
----
  cTextoEndosoEnv             ENDOSO_TXT_DET.TEXTO%TYPE;
  cEmail                      USUARIOS.EMAIL%TYPE;
  cEmailAgen                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cPwdEmail                   VARCHAR2(100);
  cEmailEjecutivo             CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
  cEmailJefe                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cTextoEndosoEnv             ENDOSO_TXT_DET.TEXTO%TYPE;
  dfechafinpago               DATE;
  cSaltoLinea                 VARCHAR2(5)      := '<br>';
  nenviar_mail                NUMBER := 0;
  cHTMLHeader                 VARCHAR2(2000)   := '<html>'                                                                     ||cSaltoLinea||
  cSubject                    VARCHAR2(500);
                                               '<head>'                                                                     ||cSaltoLinea||
  cTxtEstatusCed              VARCHAR2(1000);
                                               '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
  cTxtEstatusRc               VARCHAR2(1000);
                                               '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||cSaltoLinea||
  cSubjectCed                 VARCHAR2(1000) := 'Notificación Vencimiento de Cédula: ';
                                               '</head><body>'                                                              ||cSaltoLinea;
  cSubjectRc                  VARCHAR2(1000) := 'Notificación Vencimiento de Póliza RC: ';
   cHTMLFooter                VARCHAR2(100)    := '</body></html>';
  cSubjectCedRc               VARCHAR2(1000) := 'Notificación Vencimiento de Cédula y Póliza RC: ';
   cTextoAlignDerecha         VARCHAR2(50)     := '<P align="CENTER">';
  cTxtVencido                 VARCHAR2(1000) := 'vencida a partir del';
   cTextoAlignDerechaClose    VARCHAR2(50)     := '</P>';
  cTexto1                     VARCHAR2(10000):= 'Apreciable Conducto, ';
   cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
  cTexto2                     varchar2(10)   := ' Clave ';
   cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
  cTexto4                     varchar2(200)  := 'De acuerdo a nuestros registros identificamos que la Cedula de agentes que mantenemos en su expediente, esta  ';
   cError                      VARCHAR2(1000);
  cTexto5                     varchar2(150)  := 'Favor de gestionar su actualización  a través del portal Agentes Thona, proporcionando copia de documento vigente.';
----
  cTexto6                     varchar2(150)  := 'De acuerdo a nuestros registros identificamos que la poliza de Responsabilidad Civil que mantenemos en su expediente esta ';
  cEmailAgen                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cTexto7                     varchar2(250)  := ', por lo que solicitamos nos envie copia para su actualizacion.';
  cEmailEjecutivo             CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cTexto8                     varchar2(250)  := 'Lo anterior para dar cumplimiento al articulo 93 de la Ley de Instituciones de Seguros que dice: "Para el ejercicio de la actividad  de agentes de seguros o de agente de fianzas, se requerira autorizacion de la Comision"';                            
  cEmailJefe                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cTexto9                     varchar2(150)  := 'Agradecemos la atencion al presente';
  dfechafinpago               DATE;
  cTexto10                    varchar2(500)  := 'Lo anterior para dar cumplimiento al articulo 23 del Reglamento de Agentes de Seguros y Fianzas, que dice: "los agentes deberan contratar y mantener vigente un seguro de responsabilidad civil por errores y omisiones, por los montos, terminos y bajo las condiciones que la Comision establezca."';
  nenviar_mail                NUMBER := 0;
  cTexto11                    varchar2(500)  := 'Asi como del articulo 32.10.1 de la CUSF que indica: "Los agentes tienen la obligacion de contar con un contrato de seguro de responsabilidad civil por errores y omisiones"; articulo 32.10.2 III "Su cobertura debera ser ininterrumpida, sin dejar periodos al descubierto" 32.10.12 "Los agentes deberan informar a las Instituciones con las que celebren contratos mercantiles, que cuentan con el contrato de seguro de responsabilidad civil por errores y omisiones."';
  cSubject                    VARCHAR2(500);
  --
  cTxtEstatusCed              VARCHAR2(1000);
CURSOR AGENTES IS
  cTxtEstatusRc               VARCHAR2(1000);
 SELECT A.COD_AGENTE,                               A.TIPO_DOC_IDENTIFICACION RFC_AGENTE, 
  cSubjectCed                 VARCHAR2(1000) := 'Notificacion Vencimiento de Cedula: ';
        A.NUM_DOC_IDENTIFICACION NUM_DOC_AGENTE,    A.CODEJECUTIVO, 
  cSubjectRc                  VARCHAR2(1000) := 'Notificacion Vencimiento de Poliza RC: ';
        NVL(A.IDCUENTACORREO,1)IDCUENTACORREO,      A.INDSUJETOSUSP, 
  cSubjectCedRc               VARCHAR2(1000) := 'Notificacion Vencimiento de Cedula y Poliza RC: ';
        A.COD_AGENTE_JEFE,                          PNJA.EMAIL EMAIL_AGENTE, 
  cTxtVencido                 VARCHAR2(1000) := 'vencida a partir del';
        PNJ.EMAIL EMAIL_EJECUTIVO,                  ACA.TIPOCEDULA, 
  cTexto1                     VARCHAR2(10000):= 'Apreciable Conducto, ';
        ACA.FECVENCIMIENTO FINVENC_CEDULA,          ACA.FECVENCPOLRC VENC_POLRC,
  cTexto2                     varchar2(10)   := ' Clave ';
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(EC.TIPODOCIDENTEJEC,EC.NUMDOCIDENTEJEC)             NOMBRE_EJECUTIVO, 
  cTexto4                     varchar2(200)  := 'De acuerdo a nuestros registros identificamos que la Cédula de agentes que mantenemos en su expediente, está  ';
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.TIPO_DOC_IDENTIFICACION,A.NUM_DOC_IDENTIFICACION) NOMBRE_AGENTE
  cTexto5                     varchar2(150)  := 'Favor de gestionar su actualización  a través del portal Agentes Thona, proporcionando copia de documento vigente.';
   FROM AGENTES                   A,
  cTexto6                     varchar2(150)  := 'De acuerdo a nuestros registros identificamos que la póliza de Responsabilidad Civil que mantenemos en su expediente está ';
        EJECUTIVO_COMERCIAL       EC,
  cTexto7                     varchar2(250)  := ', por lo que solicitamos nos envie copia para su actualización.';
        PERSONA_NATURAL_JURIDICA  PNJA,
  cTexto8                     varchar2(250)  := 'Lo anterior para dar cumplimiento al artículo 93 de la Ley de Instituciones de Seguros que dice: "Para el ejercicio de la actividad de agentes de seguros o de agente de fianzas, se requerirá autorización de la Comisión"';
        PERSONA_NATURAL_JURIDICA  PNJ,
  cTexto9                     varchar2(150)  := 'Agradecemos la atención al presente';
        AGENTES_CEDULA_AUTORIZADA ACA
  cTexto10                    varchar2(500)  := 'Lo anterior para dar cumplimiento al artículo 23 del Reglamento de Agentes de Seguros y Fianzas, que dice: "los agentes deberán contratar y mantener vigente un seguro de responsabilidad civil por errores y omisiones, por los montos, términos y bajo las condiciones que la Comisión establezca."';
  WHERE PNJA.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION 
  cTexto11                    varchar2(500)  := 'Así como del artículo 32.10.1 de la CUSF que indica: "Los agentes tienen la obligación de contar con un contrato de seguro de responsabilidad civil por errores y omisiones"; artículo 32.10.2 III "Su cobertura deberá ser ininterrumpida, sin dejar periodos al descubierto" 32.10.12 "Los agentes deberán informar a las Instituciones con las que celebren contratos mercantiles, que cuentan con el contrato de seguro de responsabilidad civil por errores y omisiones."';
    AND PNJA.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION
  --
    --
CURSOR AGENTES IS
--  AND A.COD_AGENTE in(64,198,214,220,227,214,260,263,297,329,379,393,453,471,538,556,614,650,93,149,185,187)
 SELECT A.COD_AGENTE,                               A.TIPO_DOC_IDENTIFICACION RFC_AGENTE,
    --
        A.NUM_DOC_IDENTIFICACION NUM_DOC_AGENTE,    A.CODEJECUTIVO,
    AND EC.CODCIA       = A.CODCIA
        NVL(A.IDCUENTACORREO,1)IDCUENTACORREO,      A.INDSUJETOSUSP,
    AND EC.CODEJECUTIVO = A.CODEJECUTIVO
        A.COD_AGENTE_JEFE,                          PNJA.EMAIL EMAIL_AGENTE,
    --
        PNJ.EMAIL EMAIL_EJECUTIVO,                  ACA.TIPOCEDULA,
    AND PNJ.TIPO_DOC_IDENTIFICACION = EC.TIPODOCIDENTEJEC 
--        ACA.FECVENCIMIENTO FINVENC_CEDULA,          ACA.FECVENCPOLRC VENC_POLRC,
    AND PNJ.NUM_DOC_IDENTIFICACION = EC.NUMDOCIDENTEJEC
        '31/07/2022' FINVENC_CEDULA,          ACA.FECVENCPOLRC VENC_POLRC,
    --
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(EC.TIPODOCIDENTEJEC,EC.NUMDOCIDENTEJEC)             NOMBRE_EJECUTIVO,
    AND ACA.COD_AGENTE = A.COD_AGENTE
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.TIPO_DOC_IDENTIFICACION,A.NUM_DOC_IDENTIFICACION) NOMBRE_AGENTE
    AND (TRUNC(ACA.FECVENCIMIENTO) = TRUNC(SYSDATE)  OR 
   FROM AGENTES                   A,
         TRUNC(ACA.FECVENCPOLRC)   = TRUNC(SYSDATE) )  
        EJECUTIVO_COMERCIAL       EC,
  ORDER BY A.COD_AGENTE;
        PERSONA_NATURAL_JURIDICA  PNJA,
--
        PERSONA_NATURAL_JURIDICA  PNJ,
BEGIN
        AGENTES_CEDULA_AUTORIZADA ACA
  --
  WHERE PNJA.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
  -- BUSCA ORIGEN
    AND PNJA.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION
  --
    --
  BEGIN
--  AND A.COD_AGENTE in(64,198,214,220,227,214,260,263,297,329,379,393,453,471,538,556,614,650,93,149,185,187)
    SELECT SYS_CONTEXT('userenv', 'terminal'), 
    --
           USER
    AND EC.CODCIA       = A.CODCIA
      INTO W_ID_TERMINAL,
    AND EC.CODEJECUTIVO = A.CODEJECUTIVO
           W_ID_USER
    --
      FROM DUAL;
    AND PNJ.TIPO_DOC_IDENTIFICACION = EC.TIPODOCIDENTEJEC
    AND PNJ.NUM_DOC_IDENTIFICACION = EC.NUMDOCIDENTEJEC
  END;
  --
    --
    AND ACA.COD_AGENTE = A.COD_AGENTE
  BEGIN
    AND (TRUNC(ACA.FECVENCIMIENTO) = TRUNC(SYSDATE)  OR
    SELECT S.CAGE_NOM_CONCEP
      INTO W_ID_ENVIO
         TRUNC(ACA.FECVENCPOLRC)   = TRUNC(SYSDATE) )
      FROM SAI_CAT_GENERAL S
--------- JMMD20200303
    AND A.EST_AGENTE = 'ACT'
     WHERE S.CAGE_CD_CATALOGO = 15;
--------- JMMD20200303
  EXCEPTION
  ORDER BY A.COD_AGENTE;
    WHEN NO_DATA_FOUND THEN
         W_ID_ENVIO := 'ORIGEN INDEFINIDO';
--
    WHEN OTHERS THEN
BEGIN
  --
         W_ID_ENVIO := 'ORIGEN INDEFINIDO O';
  -- BUSCA ORIGEN
  END;
  --
  --
  INSERT INTO CONTROL_PROCESOS_AUTOMATICOS
  BEGIN
    SELECT SYS_CONTEXT('userenv', 'terminal'),
  VALUES('ENVIA_MAIL_AGENTES_CEDPOLRC',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
           USER
  --
  COMMIT; 
      INTO W_ID_TERMINAL,
           W_ID_USER
  --    
  FOR X IN AGENTES LOOP
      FROM DUAL;
      --
  END;
      nLeidos      := nLeidos + 1;
  --
  BEGIN
      nenviar_mail := 0;
    SELECT S.CAGE_NOM_CONCEP
      cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
      INTO W_ID_ENVIO
      cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
      --
      FROM SAI_CAT_GENERAL S
      select MAX(F.FECFINVIG)
     WHERE S.CAGE_CD_CATALOGO = 15;
        into dfechafinpago
  EXCEPTION
        from facturas F
    WHEN NO_DATA_FOUND THEN
       WHERE stsfact = 'PAG'
         W_ID_ENVIO := 'ORIGEN INDEFINIDO';
         AND F.IDPOLIZA IN( SELECT AP.IDPOLIZA
    WHEN OTHERS THEN
                              FROM agente_poliza ap, 
         W_ID_ENVIO := 'ORIGEN INDEFINIDO O';
                                   polizas p
  END;
                             where p.idpoliza = ap.idpoliza
-------- JMMD20200625
  BEGIN
                               and ap.cod_agente = X.COD_AGENTE
                               and trunc(p.fecfinvig) >= trunc(sysdate));         
    SELECT S.CAGE_CVE_REG
      --    
      INTO nProcesar
      FROM SAI_CAT_GENERAL S
      IF  TRUNC(dfechafinpago) >= TRUNC(SYSDATE) THEN       
          BEGIN
     WHERE S.CAGE_CD_CATALOGO  = 1007
       AND S.CAGE_CD_CLAVE_SEG = 1
            SELECT PNJJ.EMAIL EMAIL_AGENTE 
       AND S.CAGE_CD_CLAVE_TER = 0;
              INTO cEmailJefe
              FROM AGENTES A, 
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
                   PERSONA_NATURAL_JURIDICA PNJJ
         nProcesar := 0;
             WHERE A.COD_AGENTE                 = X.COD_AGENTE_JEFE
    WHEN OTHERS THEN
               AND PNJJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION 
               AND PNJJ.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION;                 
         nProcesar := 0;
          EXCEPTION 
  END;
             WHEN NO_DATA_FOUND THEN

                  cEmailJefe := '';
  dbms_output.put_line('Valor del parametro nProcesar  '||nProcesar);
          END;
-------- JMMD20200625
          --   
  IF nProcesar = 1 THEN
  --
          dbms_output.put_line('mail del jefe '||cEmailJefe);                       
          --
      INSERT INTO CONTROL_PROCESOS_AUTOMATICOS
          IF X.EMAIL_AGENTE IS NULL THEN
      VALUES('ENVIAD_MAIL_AGENTES_CEDPOLRC',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
             cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(X.RFC_AGENTE,X.NUM_DOC_AGENTE);
      --
          ELSE
      COMMIT;
             cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(X.RFC_AGENTE,X.NUM_DOC_AGENTE,X.IdCuentaCorreo);
      --
          END IF;
      FOR X IN AGENTES LOOP
          --
          --
          cEmailEjecutivo := X.EMAIL_EJECUTIVO;
          nLeidos      := nLeidos + 1;
--          cEmailEjecutivo := NULL; --'jmmdcbt@prodigy.net.mx';          
          nenviar_mail := 0;
--          cEmailAgen      := 'jmarquez@thonaseguros.mx';
          cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
--          cEmailJefe      := NULL; --'juanmanuelmarquezd@gmail.com';  
          cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
          --               
          --
          nenviar_mail    := 0; 
    /*      select MAX(F.FECFINVIG)
          cTextoEndosoEnv := '';    
            into dfechafinpago
          cSubject        := '';   
            from facturas F
          --
           WHERE stsfact = 'PAG'
          IF (TRUNC(SYSDATE) = TRUNC(X.FINVENC_CEDULA) AND 
             AND F.IDPOLIZA IN( SELECT AP.IDPOLIZA
              TRUNC(SYSDATE) = TRUNC(x.VENC_POLRC))  THEN 
                                  FROM agente_poliza ap,
             cSubject        := cSubjectCedRc||X.NOMBRE_AGENTE;             
                                       polizas p
             cTxtEstatusCed  := cTxtVencido; 
                                 where p.idpoliza = ap.idpoliza
             cTxtEstatusRc   := cTxtVencido;
                                   and ap.cod_agente = X.COD_AGENTE
             nenviar_mail    := 1;  
                                   and trunc(p.fecfinvig) >= trunc(sysdate));
             cTextoEndosoEnv := cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto4||cTxtEstatusCed||' '||
          --
                                to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto8||chr(10)||chr(13)
          IF  TRUNC(dfechafinpago) >= TRUNC(SYSDATE) THEN     */
                                ||chr(10)||chr(13)||cTexto6||cTxtEstatusRc||' '
              BEGIN
                                ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto10||chr(10)||chr(13)||
                SELECT PNJJ.EMAIL EMAIL_AGENTE
                                cTexto11||chr(10)||chr(13)||cTexto5||chr(10)||chr(13)||cTexto9||W_ID_ENVIO;                
                  INTO cEmailJefe
             dbms_output.put_line('se enviara correo al agente '||x.cod_Agente);             
                  FROM AGENTES A,
             BEGIN
                       PERSONA_NATURAL_JURIDICA PNJJ
               OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                 WHERE A.COD_AGENTE                 = X.COD_AGENTE_JEFE
             EXCEPTION
                   AND PNJJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
               WHEN OTHERS THEN
                   AND PNJJ.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION;
                    dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
              EXCEPTION
             END;  
                 WHEN NO_DATA_FOUND THEN
          ELSE        
                      cEmailJefe := '';
             cSubject := cSubjectCed||X.NOMBRE_AGENTE;
              END;
             IF TRUNC(SYSDATE) = TRUNC(X.FINVENC_CEDULA)  THEN
              --
                cTxtEstatusCed := cTxtVencido;
              dbms_output.put_line('mail del jefe '||cEmailJefe);
                nenviar_mail := 1;
              --
             END IF;
              IF X.EMAIL_AGENTE IS NULL THEN
             --     
                BEGIN
             cTextoEndosoEnv :=  cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto4||cTxtEstatusCed||' '||
                 cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(X.RFC_AGENTE,X.NUM_DOC_AGENTE);
                                 to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto8||chr(10)||chr(13)||cTexto9||W_ID_ENVIO;
                EXCEPTION WHEN OTHERS THEN
             IF nenviar_mail = 1 THEN
                 dbms_output.put_line('mail GENERICO EJECUTIVO DE CUENTA '||X.EMAIL_EJECUTIVO);
                dbms_output.put_line('se envio correo al agente '||x.cod_Agente);             
                 cEmailAgen      := X.EMAIL_EJECUTIVO;
                END;
                BEGIN
              ELSE
                  OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                BEGIN
                EXCEPTION
                  WHEN OTHERS THEN
                 cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(X.RFC_AGENTE,X.NUM_DOC_AGENTE,X.IdCuentaCorreo);
                EXCEPTION WHEN OTHERS THEN
                       dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
                 dbms_output.put_line('mail GENERICO  '||X.EMAIL_AGENTE);
                END;  
                 cEmailAgen      := X.EMAIL_AGENTE;
             END IF;
                END;
             --    
             nenviar_mail    := 0; 
              END IF;
              --
             cTextoEndosoEnv := '';    
              cEmailEjecutivo := X.EMAIL_EJECUTIVO;
             cSubject        := '';   
-----              cEmailEjecutivo := NULL; --'jmmdcbt@prodigy.net.mx';
             --
             cSubject := cSubjectRc||X.NOMBRE_AGENTE;
-----              cEmailAgen      := 'jmarquez@thonaseguros.mx';
-----              cEmailJefe      := NULL; --'juanmanuelmarquezd@gmail.com';
             IF TRUNC(SYSDATE) = TRUNC(x.VENC_POLRC) THEN
              --
                cTxtEstatusRc := cTxtVencido;
              nenviar_mail    := 0;
                nenviar_mail := 1;
             END IF;  
              cTextoEndosoEnv := '';
             cTextoEndosoEnv := cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto6||cTxtEstatusRc||' '
              cSubject        := '';
              --
                                ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto10||chr(10)||chr(13)||
                                cTexto11||chr(10)||chr(13)||cTexto5||chr(10)||chr(13)||cTexto9||W_ID_ENVIO;
              dbms_output.put_line('jmmd X.FINVENC_CEDULA '||X.FINVENC_CEDULA);
/*              IF (TRUNC(SYSDATE) = TRUNC(X.FINVENC_CEDULA) AND
             IF nenviar_mail = 1 THEN  
                dbms_output.put_line('se envio correo al agente '||x.cod_agente);            
                  TRUNC(SYSDATE) = TRUNC(x.VENC_POLRC))  THEN
                BEGIN
                 cSubject        := cSubjectCedRc||X.NOMBRE_AGENTE;
                 cTxtEstatusCed  := cTxtVencido;
                  OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                EXCEPTION
                 cTxtEstatusRc   := cTxtVencido;
                 nenviar_mail    := 1;
                  WHEN OTHERS THEN
                 cTextoEndosoEnv := cHTMLHeader||cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||cSaltoLinea||cSaltoLinea||
                       dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
                                    cTexto4||cTxtEstatusCed||' '||to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||
                END;    
              END IF;    
                                    cSaltoLinea||cSaltoLinea||cTexto8||cSaltoLinea||cSaltoLinea||cTexto6||cTxtEstatusRc||' '
                                    ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||cSaltoLinea||cSaltoLinea||cTexto10||
          END IF;
        END IF;               
                                    cSaltoLinea||cSaltoLinea||
    END LOOP;
                                    cTexto11||cSaltoLinea||cSaltoLinea||cTexto5||cSaltoLinea||cSaltoLinea||cTexto9||W_ID_ENVIO
     --
                                    ||cSaltoLinea||cSaltoLinea||cHTMLFooter;
  EXCEPTION
                 dbms_output.put_line('se enviara correo al agente '||x.cod_Agente);
    ------------
    WHEN OTHERS THEN
  dbms_output.put_line('Error: '||SQLERRM);  
                 OC_MAIL.INIT_PARAM;
  END;    --
                 OC_MAIL.cCtaEnvio   := cEmail;
    --
                 OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
    --
                 BEGIN
                    OC_MAIL.SEND_EMAIL(NULL,cMiMail,cEmailAgen,cEmailEjecutivo,cEmailJefe,cSubject,cTextoEndosoEnv,NULL,NULL,NULL,NULL,cError);
                 EXCEPTION
                      WHEN OTHERS THEN
                           dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);
                 END;
    ------------
              ELSE
                 cSubject := cSubjectCed||X.NOMBRE_AGENTE;
                 IF TRUNC(SYSDATE) = TRUNC(X.FINVENC_CEDULA)  THEN
                    cTxtEstatusCed := cTxtVencido;
                    nenviar_mail := 1;
                 END IF;
                 --
                 cTextoEndosoEnv :=  cHTMLHeader||cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||cSaltoLinea||cSaltoLinea||
                                     cTexto4||cTxtEstatusCed||' '||
                                     to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||cSaltoLinea||cSaltoLinea||cTexto8||
                                     cSaltoLinea||cSaltoLinea||cTexto9||W_ID_ENVIO||
                                     cSaltoLinea||cSaltoLinea||cHTMLFooter;
                 IF nenviar_mail = 1 THEN
                    dbms_output.put_line('se envio correo al agente '||x.cod_Agente);
    ------------
                 OC_MAIL.INIT_PARAM;
    --
                 OC_MAIL.cCtaEnvio   := cEmail;
    --
                 OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
    --
                 BEGIN
                    OC_MAIL.SEND_EMAIL(NULL,cMiMail,cEmailAgen,cEmailEjecutivo,cEmailJefe,cSubject,cTextoEndosoEnv,NULL,NULL,NULL,NULL,cError);
                 EXCEPTION
                      WHEN OTHERS THEN
                           dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);
                 END;
    ------------
                 END IF;
                 --    */ -- jmmd 20200930  temporalmente mientras pasa la pandemia
                 nenviar_mail    := 0;
                 cTextoEndosoEnv := '';
                 cSubject        := '';
                 --
                 cSubject := cSubjectRc||X.NOMBRE_AGENTE;
                 IF TRUNC(SYSDATE) = TRUNC(x.VENC_POLRC) THEN
                    cTxtEstatusRc := cTxtVencido;
                    nenviar_mail := 1;
                 END IF;
                 cTextoEndosoEnv := cHTMLHeader||cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||cSaltoLinea||cSaltoLinea||
                                    cTexto6||cTxtEstatusRc||' '
                                    ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||cSaltoLinea||cSaltoLinea||cTexto10||
                                    cSaltoLinea||cSaltoLinea||
                                    cTexto11||cSaltoLinea||cSaltoLinea||cTexto5||cSaltoLinea||cSaltoLinea||cTexto9||W_ID_ENVIO||
                                    cSaltoLinea||cSaltoLinea||cHTMLFooter;
                 IF nenviar_mail = 1 THEN
                    dbms_output.put_line('se envio correo al agente '||x.cod_agente);
    ------------
                 OC_MAIL.INIT_PARAM;
    --
                 OC_MAIL.cCtaEnvio   := cEmail;
    --
                 OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
    --
                 BEGIN
                    OC_MAIL.SEND_EMAIL(NULL,cMiMail,cEmailAgen,cEmailEjecutivo,cEmailJefe,cSubject,cTextoEndosoEnv,NULL,NULL,NULL,NULL,cError);
                 EXCEPTION
                      WHEN OTHERS THEN
                           dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);
                 END;
    ------------

                  END IF;
 -- jmmd 20200930 temporalmente mientras pasa la pandemia             END IF;

        END LOOP;
  ELSE
    dbms_output.put_line('No se envia proceso por parametro nProcesar igual a cero '||nProcesar);
  END IF;
     --
  EXCEPTION
    WHEN OTHERS THEN
  dbms_output.put_line('Error: '||SQLERRM);
  END;

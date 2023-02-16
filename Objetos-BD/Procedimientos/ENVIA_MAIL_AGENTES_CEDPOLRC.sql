PROCEDURE ENVIA_MAIL_AGENTES_CEDPOLRC  IS
PROCEDURE          ENVIA_MAIL_AGENTES_CEDPOLRC  IS
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
-------- JMMD20200625
  nenviar_mail                NUMBER := 0;
  cSaltoLinea                 VARCHAR2(5)      := '<br>';
  cSubject                    VARCHAR2(500);
  cHTMLHeader                 VARCHAR2(2000)   := '<html>'                                                                     ||cSaltoLinea||
  cTxtEstatusCed              VARCHAR2(1000);
                                               '<head>'                                                                     ||cSaltoLinea||
  cTxtEstatusRc               VARCHAR2(1000);
                                               '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
  cSubjectCed                 VARCHAR2(1000) := 'Notificación Vencimiento de Cédula: ';
                                               '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||cSaltoLinea||
  cSubjectRc                  VARCHAR2(1000) := 'Notificación Vencimiento de Póliza RC: ';
                                               '</head><body>'                                                              ||cSaltoLinea;
  cSubjectCedRc               VARCHAR2(1000) := 'Notificación Vencimiento de Cédula y Póliza RC: ';
   cHTMLFooter                VARCHAR2(100)    := '</body></html>';
  cTxtVencido                 VARCHAR2(1000) := 'vencida a partir del';
   cTextoAlignDerecha         VARCHAR2(50)     := '<P align="CENTER">';
  cTxtXVencer                 VARCHAR2(1000) := 'por vencer el próximo';
   cTextoAlignDerechaClose    VARCHAR2(50)     := '</P>';
  cTexto1                     VARCHAR2(10000):= 'Apreciable Conducto, ';
   cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
  cTexto2                     varchar2(10)   := ' Clave ';
   cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
  cTexto4                     varchar2(200)  := 'De acuerdo a nuestros registros identificamos que la Cedula de agentes que mantenemos en su expediente, esta  ';
   cError                      VARCHAR2(1000);
  cTexto5                     varchar2(150)  := 'Favor de gestionar su actualización  a través del portal Agentes Thona, proporcionando copia de documento vigente.';
-------- JMMD20200625
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
  cTxtXVencer                 VARCHAR2(1000) := 'por vencer el próximo';
        ACA.FECVENCIMIENTO FINVENC_CEDULA,          ACA.FECVENCPOLRC VENC_POLRC,
  cTexto1                     VARCHAR2(10000):= 'Apreciable Conducto, ';
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(EC.TIPODOCIDENTEJEC,EC.NUMDOCIDENTEJEC)             NOMBRE_EJECUTIVO, 
  cTexto2                     varchar2(10)   := ' Clave ';
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.TIPO_DOC_IDENTIFICACION,A.NUM_DOC_IDENTIFICACION) NOMBRE_AGENTE
  cTexto4                     varchar2(200)  := 'De acuerdo a nuestros registros identificamos que la Cédula de agentes que mantenemos en su expediente, está  ';
   FROM AGENTES                   A,
  cTexto5                     varchar2(150)  := 'Favor de gestionar su actualización  a través del portal Agentes Thona, proporcionando copia de documento vigente.';
        EJECUTIVO_COMERCIAL       EC,
  cTexto6                     varchar2(150)  := 'De acuerdo a nuestros registros identificamos que la póliza de Responsabilidad Civil que mantenemos en su expediente está ';
        PERSONA_NATURAL_JURIDICA  PNJA,
  cTexto7                     varchar2(250)  := ', por lo que solicitamos nos envie copia para su actualización.';
        PERSONA_NATURAL_JURIDICA  PNJ,
  cTexto8                     varchar2(250)  := 'Lo anterior para dar cumplimiento al artículo 93 de la Ley de Instituciones de Seguros que dice: "Para el ejercicio de la actividad de agentes de seguros o de agente de fianzas, se requerirá autorización de la Comisión"';
        AGENTES_CEDULA_AUTORIZADA ACA
  cTexto9                     varchar2(150)  := 'Agradecemos la atención al presente';
  WHERE PNJA.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION 
  cTexto10                    varchar2(500)  := 'Lo anterior para dar cumplimiento al artículo 23 del Reglamento de Agentes de Seguros y Fianzas, que dice: "los agentes deberán contratar y mantener vigente un seguro de responsabilidad civil por errores y omisiones, por los montos, términos y bajo las condiciones que la Comisión establezca."';
    AND PNJA.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION
  cTexto11                    varchar2(500)  := 'Así como del artículo 32.10.1 de la CUSF que indica: "Los agentes tienen la obligación de contar con un contrato de seguro de responsabilidad civil por errores y omisiones"; artículo 32.10.2 III "Su cobertura deberá ser ininterrumpida, sin dejar periodos al descubierto" 32.10.12 "Los agentes deberán informar a las Instituciones con las que celebren contratos mercantiles, que cuentan con el contrato de seguro de responsabilidad civil por errores y omisiones."';
    --    
  --
--  AND A.COD_AGENTE in(64,198,214,220,227,214,260,263,297,329,379,393,453,471,538,556,614,650,93,149,185,187)
CURSOR AGENTES IS
    --
 SELECT A.COD_AGENTE,                               A.TIPO_DOC_IDENTIFICACION RFC_AGENTE,
    AND EC.CODCIA       = A.CODCIA
        A.NUM_DOC_IDENTIFICACION NUM_DOC_AGENTE,    A.CODEJECUTIVO,
    AND EC.CODEJECUTIVO = A.CODEJECUTIVO
        NVL(A.IDCUENTACORREO,1)IDCUENTACORREO,      A.INDSUJETOSUSP,
    --
        A.COD_AGENTE_JEFE,                          PNJA.EMAIL EMAIL_AGENTE,
    AND PNJ.TIPO_DOC_IDENTIFICACION = EC.TIPODOCIDENTEJEC 
        PNJ.EMAIL EMAIL_EJECUTIVO,                  ACA.TIPOCEDULA,
    AND PNJ.NUM_DOC_IDENTIFICACION  = EC.NUMDOCIDENTEJEC
--        ACA.FECVENCIMIENTO FINVENC_CEDULA,          ACA.FECVENCPOLRC VENC_POLRC,
    --
       '31/07/2022' FINVENC_CEDULA,          ACA.FECVENCPOLRC VENC_POLRC,
    AND ACA.COD_AGENTE       = A.COD_AGENTE
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(EC.TIPODOCIDENTEJEC,EC.NUMDOCIDENTEJEC)             NOMBRE_EJECUTIVO,
    AND (TRUNC(ACA.FECVENCIMIENTO) <= TRUNC(SYSDATE)  OR 
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.TIPO_DOC_IDENTIFICACION,A.NUM_DOC_IDENTIFICACION) NOMBRE_AGENTE
         TRUNC(ACA.FECVENCPOLRC)   <= TRUNC(SYSDATE) )  
   FROM AGENTES                   A,
  ORDER BY A.COD_AGENTE;
        EJECUTIVO_COMERCIAL       EC,
--
        PERSONA_NATURAL_JURIDICA  PNJA,
BEGIN
        PERSONA_NATURAL_JURIDICA  PNJ,
  --
        AGENTES_CEDULA_AUTORIZADA ACA
  -- BUSCA ORIGEN
  WHERE PNJA.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
  --
    AND PNJA.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION
  BEGIN
    --
    SELECT SYS_CONTEXT('userenv', 'terminal'), 
--  AND A.COD_AGENTE in(12,13,15,17,19,21)
           USER
    --
      INTO W_ID_TERMINAL,
    AND EC.CODCIA       = A.CODCIA
           W_ID_USER
    AND EC.CODEJECUTIVO = A.CODEJECUTIVO
    --
      FROM DUAL;
  END;
    AND PNJ.TIPO_DOC_IDENTIFICACION = EC.TIPODOCIDENTEJEC
    AND PNJ.NUM_DOC_IDENTIFICACION  = EC.NUMDOCIDENTEJEC
  --
    --
  BEGIN
    SELECT S.CAGE_NOM_CONCEP
    AND ACA.COD_AGENTE       = A.COD_AGENTE
      INTO W_ID_ENVIO
    AND (TRUNC(ACA.FECVENCIMIENTO) <= TRUNC(SYSDATE)  OR
         TRUNC(ACA.FECVENCPOLRC)   <= TRUNC(SYSDATE) )
      FROM SAI_CAT_GENERAL S
--------- jmmd20200303
     WHERE S.CAGE_CD_CATALOGO = 15;
    AND A.EST_AGENTE = 'ACT'
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
--------- JMMD20200303
         W_ID_ENVIO := 'ORIGEN INDEFINIDO';
  ORDER BY A.COD_AGENTE;
--
    WHEN OTHERS THEN
BEGIN
         W_ID_ENVIO := 'ORIGEN INDEFINIDO O';
  END;
  --
  --
  -- BUSCA ORIGEN
  --
  INSERT INTO CONTROL_PROCESOS_AUTOMATICOS
  BEGIN
  VALUES('ENVIA_MAIL_AGENTES_CEDPOLRC',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
  --
    SELECT SYS_CONTEXT('userenv', 'terminal'),
           USER
  COMMIT; 
  --    
      INTO W_ID_TERMINAL,
  FOR X IN AGENTES LOOP
           W_ID_USER
      --
      FROM DUAL;
  END;
      nLeidos         := nLeidos + 1;
  --
      nenviar_mail    := 0;
  BEGIN
      cTextoEndosoEnv := NULL;    
      cSubject        := NULL;            
    SELECT S.CAGE_NOM_CONCEP
      cEmail          := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
      INTO W_ID_ENVIO
      cPwdEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
      FROM SAI_CAT_GENERAL S
      --                
     WHERE S.CAGE_CD_CATALOGO = 15;
      select MAX(F.FECFINVIG)
  EXCEPTION
        into dfechafinpago
    WHEN NO_DATA_FOUND THEN
        from facturas F
         W_ID_ENVIO := 'ORIGEN INDEFINIDO';
       WHERE stsfact = 'PAG'
    WHEN OTHERS THEN
         W_ID_ENVIO := 'ORIGEN INDEFINIDO O';
         AND F.IDPOLIZA IN( SELECT AP.IDPOLIZA
  END;
                              FROM agente_poliza ap, 
                                   polizas p
  --
                             where p.idpoliza = ap.idpoliza
-------- JMMD20200625
                               and ap.cod_agente = X.COD_AGENTE
  BEGIN
    SELECT S.CAGE_CVE_REG
                               and trunc(p.fecfinvig) >= trunc(sysdate));        
      INTO nProcesar
      --        
      IF  TRUNC(dfechafinpago) >= SYSDATE THEN       
      FROM SAI_CAT_GENERAL S
     WHERE S.CAGE_CD_CATALOGO  = 1007
          BEGIN
       AND S.CAGE_CD_CLAVE_SEG = 2
            SELECT PNJJ.EMAIL EMAIL_AGENTE 
       AND S.CAGE_CD_CLAVE_TER = 0;
              INTO cEmailJefe
              FROM AGENTES A, 
  EXCEPTION
                   PERSONA_NATURAL_JURIDICA PNJJ
    WHEN NO_DATA_FOUND THEN
             WHERE A.COD_AGENTE                 = X.COD_AGENTE_JEFE
         nProcesar := 0;
               AND PNJJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION 
    WHEN OTHERS THEN
               AND PNJJ.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION;                 
         nProcesar := 0;
          EXCEPTION 
  END;

             WHEN NO_DATA_FOUND THEN
  dbms_output.put_line('Valor del parametro nProcesar  '||nProcesar);
                  cEmailJefe := '';
          END;
-------- JMMD20200625
  IF nProcesar = 1 THEN
          --   
      INSERT INTO CONTROL_PROCESOS_AUTOMATICOS
          dbms_output.put_line('mail del jefe '||cEmailJefe);    
      VALUES('ENVIA_MAIL_AGENTES_CEDPOLRC',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
          --
          IF X.EMAIL_AGENTE IS NULL THEN
      --
      COMMIT;
             cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(X.RFC_AGENTE,X.NUM_DOC_AGENTE);
          ELSE
      --
      FOR X IN AGENTES LOOP
             cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(X.RFC_AGENTE,X.NUM_DOC_AGENTE,X.IdCuentaCorreo);
          --
          END IF;
          nLeidos         := nLeidos + 1;
          --
          nenviar_mail    := 0;
          cEmailEjecutivo := X.EMAIL_EJECUTIVO;
          cTextoEndosoEnv := NULL;
--          cEmailEjecutivo := NULL; --'jmmdcbt@prodigy.net.mx';          
          cSubject        := NULL;
--          cEmailAgen      := 'jmarquez@thonaseguros.mx';
          cEmail          := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
--          cEmailJefe      := NULL; --'juanmanuelmarquezd@gmail.com';  
          --                     
          cPwdEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
          IF (TRUNC(SYSDATE) - TRUNC(X.VENC_POLRC)     > 0) AND
          --
             (TRUNC(SYSDATE) - TRUNC(X.FINVENC_CEDULA) > 0) THEN
    /*      select MAX(F.FECFINVIG)
             cSubject        := cSubjectCedRc||X.NOMBRE_AGENTE;             
            into dfechafinpago
             cTxtEstatusCed  := cTxtVencido; 
            from facturas F
           WHERE stsfact = 'PAG'
             cTxtEstatusRc   := cTxtVencido;
             AND F.IDPOLIZA IN( SELECT AP.IDPOLIZA
             nenviar_mail    := 1;  
                                  FROM agente_poliza ap,
             cTextoEndosoEnv := cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto4||cTxtEstatusCed||' '||
                                to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto8||chr(10)||chr(13)
                                       polizas p
                                ||chr(10)||chr(13)||cTexto6||cTxtEstatusRc||' '
                                 where p.idpoliza = ap.idpoliza
                                ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto10||chr(10)||chr(13)||
                                   and ap.cod_agente = X.COD_AGENTE
                                cTexto11||chr(10)||chr(13)||cTexto5||chr(10)||chr(13)||cTexto9||W_ID_ENVIO;                
                                   and trunc(p.fecfinvig) >= trunc(sysdate));
             dbms_output.put_line('se enviara correo al agente '||x.cod_Agente);             
          --
             BEGIN
          IF  TRUNC(dfechafinpago) >= SYSDATE THEN      */
               OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
              BEGIN
             EXCEPTION
                SELECT PNJJ.EMAIL EMAIL_AGENTE
               WHEN OTHERS THEN
                  INTO cEmailJefe
                    dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
                  FROM AGENTES A,
             END;  
                       PERSONA_NATURAL_JURIDICA PNJJ
          ELSE
                 WHERE A.COD_AGENTE                 = X.COD_AGENTE_JEFE
             nenviar_mail    := 0; 
                   AND PNJJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
             cTextoEndosoEnv := NULL;    
                   AND PNJJ.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION;
             cSubject        := NULL; 
              EXCEPTION
             IF TRUNC(SYSDATE) - TRUNC(X.FINVENC_CEDULA) > 0  THEN
                 WHEN NO_DATA_FOUND THEN
                  cSubject       := cSubjectCed||X.NOMBRE_AGENTE;               
                      cEmailJefe := '';
                  cTxtEstatusCed := cTxtVencido;
              END;
                  nenviar_mail   := 1;
              --
             ELSIF trunc(X.FINVENC_CEDULA) between TRUNC(SYSDATE)  and TRUNC(SYSDATE + 7) THEN   
              dbms_output.put_line('mail del jefe '||cEmailJefe);
                  cSubject       := cSubjectCed||X.NOMBRE_AGENTE;                     
              --
                  cTxtEstatusCed := cTxtXVencer;
              IF X.EMAIL_AGENTE IS NULL THEN
                  nenviar_mail   := 1;
                BEGIN
             END IF;
                 cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(X.RFC_AGENTE,X.NUM_DOC_AGENTE);
             --
                EXCEPTION WHEN OTHERS THEN
             IF nenviar_mail = 1 then
                 dbms_output.put_line('mail GENERICO EJECUTIVO DE CUENTA '||X.EMAIL_EJECUTIVO);
                cTextoEndosoEnv :=  cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto4||cTxtEstatusCed||' '||
                 cEmailAgen      := X.EMAIL_EJECUTIVO;
                                    to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto8||chr(10)||chr(13)||cTexto9||W_ID_ENVIO;
                END;
                dbms_output.put_line('se envio correo al agente '||x.cod_Agente);             
              ELSE
                BEGIN
                BEGIN
                  OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                 cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(X.RFC_AGENTE,X.NUM_DOC_AGENTE,X.IdCuentaCorreo);
                EXCEPTION
                EXCEPTION WHEN OTHERS THEN
                  WHEN OTHERS THEN
                 dbms_output.put_line('mail GENERICO  '||X.EMAIL_AGENTE);
                       dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
                 cEmailAgen      := X.EMAIL_AGENTE;
                END;  
                END;
                --
              END IF;
             END IF;    
              --
             --
              cEmailEjecutivo := X.EMAIL_EJECUTIVO;
             nenviar_mail    := 0; 
--              cEmailEjecutivo := NULL; --'jmmdcbt@prodigy.net.mx';
             cTextoEndosoEnv := NULL;    
--              cEmailAgen      := 'jmarquez@thonaseguros.mx';
             cSubject        := NULL;   
--              cEmailJefe      := NULL; --'juanmanuelmarquezd@gmail.com';
             --
              --
             IF TRUNC(SYSDATE) - TRUNC(x.VENC_POLRC) > 0 THEN
              dbms_output.put_line('jmmd X.FINVENC_CEDULA '||X.FINVENC_CEDULA);
                cSubject      := cSubjectRc||X.NOMBRE_AGENTE;               
/*              IF (TRUNC(SYSDATE) - TRUNC(X.VENC_POLRC)     > 0) AND
                cTxtEstatusRc := cTxtVencido;
                 (TRUNC(SYSDATE) - TRUNC(X.FINVENC_CEDULA) > 0) THEN
                nenviar_mail  := 1;
                 cSubject        := cSubjectCedRc||X.NOMBRE_AGENTE;
             ELSIF TRUNC(x.VENC_POLRC) BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE + 7) THEN 
                 cTxtEstatusCed  := cTxtVencido;
                cSubject      := cSubjectRc||X.NOMBRE_AGENTE;                         
                 cTxtEstatusRc   := cTxtVencido;
                cTxtEstatusRc := cTxtXVencer;
                 nenviar_mail    := 1;
                nenviar_mail  := 1;             
                 cTextoEndosoEnv := cHTMLHeader||cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||cSaltoLinea||cSaltoLinea||cTexto4||
             END IF;  
                                    cTxtEstatusCed||' '||to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||cSaltoLinea||cSaltoLinea||cTexto8
             --
                                    ||cSaltoLinea||cSaltoLinea||cSaltoLinea||cSaltoLinea||cTexto6||cTxtEstatusRc||' '
             IF nenviar_mail = 1 THEN  
                                    ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||cSaltoLinea||cSaltoLinea||cTexto10||cSaltoLinea||cSaltoLinea||
                cTextoEndosoEnv := cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto6||cTxtEstatusRc||' '
                                    cTexto11||cSaltoLinea||cSaltoLinea||cTexto5||cSaltoLinea||cSaltoLinea||cTexto9||W_ID_ENVIO
                                    ||cSaltoLinea||cSaltoLinea||cHTMLFooter;
                                   ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto10||chr(10)||chr(13)||
                                   cTexto11||chr(10)||chr(13)||cTexto5||chr(10)||chr(13)||cTexto9||W_ID_ENVIO;                 
                 dbms_output.put_line('se enviara correo al agente '||x.cod_Agente);
                dbms_output.put_line('se envio correo al agente '||x.cod_agente);            
    ------------
                 OC_MAIL.INIT_PARAM;
                BEGIN
    --
                  OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                 OC_MAIL.cCtaEnvio   := cEmail;
                EXCEPTION
                   WHEN OTHERS THEN
    --
                 OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
                   dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
    --
                END;    
             END IF;  
             begin
                 OC_MAIL.SEND_EMAIL(NULL,cMiMail,cEmailAgen,cEmailEjecutivo,cEmailJefe,cSubject,cTextoEndosoEnv,NULL,NULL,NULL,NULL,cError);
          END IF;  
        END IF;               
             exception when others then
                dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE || '  ' ||sqlerrm);
  END LOOP;
  --
             end;
EXCEPTION
    ------------
  WHEN OTHERS THEN
              ELSE
  dbms_output.put_line('Error: '||SQLERRM);  
                 nenviar_mail    := 0;
END;                 cTextoEndosoEnv := NULL;
                 cSubject        := NULL;
                 IF TRUNC(SYSDATE) - TRUNC(X.FINVENC_CEDULA) > 0  THEN
                      cSubject       := cSubjectCed||X.NOMBRE_AGENTE;
                      cTxtEstatusCed := cTxtVencido;
                      nenviar_mail   := 1;
                 ELSIF trunc(X.FINVENC_CEDULA) between TRUNC(SYSDATE)  and TRUNC(SYSDATE + 7) THEN
                      cSubject       := cSubjectCed||X.NOMBRE_AGENTE;
                      cTxtEstatusCed := cTxtXVencer;
                      nenviar_mail   := 1;
                 END IF;
                 --
                 IF nenviar_mail = 1 then
                    cTextoEndosoEnv :=  cHTMLHeader||cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||cSaltoLinea||cSaltoLinea||cTexto4
                                        ||cTxtEstatusCed||' '||to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7
                                        ||cSaltoLinea||cSaltoLinea||cTexto8||cSaltoLinea||cSaltoLinea||cTexto9||W_ID_ENVIO
                                        ||cSaltoLinea||cSaltoLinea||cHTMLFooter;
                    dbms_output.put_line('se envio correo al agente '||x.cod_Agente);
    ------------
                 OC_MAIL.INIT_PARAM;
    --
                 OC_MAIL.cCtaEnvio   := cEmail;
    --
                 OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
    --
             begin
                 OC_MAIL.SEND_EMAIL(NULL,cMiMail,cEmailAgen,cEmailEjecutivo,cEmailJefe,cSubject,cTextoEndosoEnv,NULL,NULL,NULL,NULL,cError);
             exception when others then
                dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE || '  ' ||sqlerrm);
             end;
    ------------
                    --
                 END IF;    */ -- jmmd20200930 temporalmente mientras pasa la pandemia
                 --
                 nenviar_mail    := 0;
                 cTextoEndosoEnv := NULL;
                 cSubject        := NULL;
                 --
                 IF TRUNC(SYSDATE) - TRUNC(x.VENC_POLRC) > 0 THEN
                    cSubject      := cSubjectRc||X.NOMBRE_AGENTE;
                    cTxtEstatusRc := cTxtVencido;
                    nenviar_mail  := 1;
                 ELSIF TRUNC(x.VENC_POLRC) BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE + 7) THEN
                    cSubject      := cSubjectRc||X.NOMBRE_AGENTE;
                    cTxtEstatusRc := cTxtXVencer;
                    nenviar_mail  := 1;
                 END IF;
                 --
                 IF nenviar_mail = 1 THEN
                    cTextoEndosoEnv := cHTMLHeader||cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||cSaltoLinea||cSaltoLinea||cTexto6||
                                       cTxtEstatusRc||' '||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||cSaltoLinea||cSaltoLinea||
                                       cTexto10||cSaltoLinea||cSaltoLinea||cTexto11||cSaltoLinea||cSaltoLinea||cTexto5
                                       ||cSaltoLinea||cSaltoLinea||cTexto9||W_ID_ENVIO
                                       ||cSaltoLinea||cSaltoLinea||cHTMLFooter;
                    dbms_output.put_line('se envio correo al agente '||x.cod_agente);

    ------------
                 OC_MAIL.INIT_PARAM;
    --
                 OC_MAIL.cCtaEnvio   := cEmail;
    --
                 OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
    --
             begin
                 OC_MAIL.SEND_EMAIL(NULL,cMiMail,cEmailAgen,cEmailEjecutivo,cEmailJefe,cSubject,cTextoEndosoEnv,NULL,NULL,NULL,NULL,cError);
             exception when others then
                dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE || '  ' ||sqlerrm);
             end;
    ------------
                 END IF;
  --            END IF;  jmmd20200930 temporalmente mientras pasa la pandemia
    --        END IF;
      END LOOP;
    --
    ELSE
      dbms_output.put_line('No se envia proceso por parametro nProcesar igual a cero '||nProcesar);
    END IF;
    --
  EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line('Error: '||SQLERRM);
  END;

CREATE OR REPLACE PROCEDURE ENVIA_MAIL_AGENTES_CEDPOLRC  IS
  W_ID_TERMINAL               CONTROL_PROCESOS_AUTOMATICOS.ID_TERMINAL%TYPE;
  W_ID_USER                   CONTROL_PROCESOS_AUTOMATICOS.ID_USER%TYPE;
  W_ID_ENVIO                  CONTROL_PROCESOS_AUTOMATICOS.ID_ENVIO%TYPE; 
  nLeidos                     NUMBER := 0;
  cEmail                      USUARIOS.EMAIL%TYPE;  
  cPwdEmail                   VARCHAR2(100); 
  cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';      
  cTextoEndosoEnv             ENDOSO_TXT_DET.TEXTO%TYPE;
  cEmailAgen                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cEmailEjecutivo             CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cEmailJefe                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  dfechafinpago               DATE;
  nenviar_mail                NUMBER := 0;
  cSubject                    VARCHAR2(500);
  cTxtEstatusCed              VARCHAR2(1000);
  cTxtEstatusRc               VARCHAR2(1000);
  cSubjectCed                 VARCHAR2(1000) := 'Thona Notificación Vencimiento de Cédula: ';
  cSubjectRc                  VARCHAR2(1000) := 'Thona Notificación Vencimiento de Póliza RC: ';
  cSubjectCedRc               VARCHAR2(1000) := 'Thona Notificación Vencimiento de Cédula y Póliza RC: ';
  cTxtVencido                 VARCHAR2(1000) := 'vencida a partir del';
  cTxtXVencer                 VARCHAR2(1000) := 'por vencer el próximo';
  cTexto1                     VARCHAR2(10000):= 'Apreciable Conducto, ';
  cTexto2                     varchar2(10)   := ' Clave ';
  cTexto4                     varchar2(200)  := 'De acuerdo a nuestros registros identificamos que la Cedula de agentes que mantenemos en su expediente, esta  ';
  cTexto5                     varchar2(150)  := 'Favor de gestionar su actualización  a través del portal Agentes Thona, proporcionando copia de documento vigente.';
  cTexto6                     varchar2(150)  := 'De acuerdo a nuestros registros identificamos que la poliza de Responsabilidad Civil que mantenemos en su expediente esta ';
  cTexto7                     varchar2(250)  := ', por lo que solicitamos nos envie copia para su actualizacion.';
  cTexto8                     varchar2(250)  := 'Lo anterior para dar cumplimiento al articulo 93 de la Ley de Instituciones de Seguros que dice: "Para el ejercicio de la actividad  de agentes de seguros o de agente de fianzas, se requerira autorizacion de la Comision"';                            
  cTexto9                     varchar2(150)  := 'Agradecemos la atencion al presente.';
  cTexto10                    varchar2(500)  := 'Lo anterior para dar cumplimiento al articulo 23 del Reglamento de Agentes de Seguros y Fianzas, que dice: "los agentes deberan contratar y mantener vigente un seguro de responsabilidad civil por errores y omisiones, por los montos, terminos y bajo las condiciones que la Comision establezca."';
  cTexto11                    varchar2(500)  := 'Asi como del articulo 32.10.1 de la CUSF que indica: "Los agentes tienen la obligacion de contar con un contrato de seguro de responsabilidad civil por errores y omisiones"; articulo 32.10.2 III "Su cobertura debera ser ininterrumpida, sin dejar periodos al descubierto" 32.10.12 "Los agentes deberan informar a las Instituciones con las que celebren contratos mercantiles, que cuentan con el contrato de seguro de responsabilidad civil por errores y omisiones."';
  --
CURSOR AGENTES IS
 SELECT A.COD_AGENTE,                               A.TIPO_DOC_IDENTIFICACION RFC_AGENTE, 
        A.NUM_DOC_IDENTIFICACION NUM_DOC_AGENTE,    A.CODEJECUTIVO, 
        NVL(A.IDCUENTACORREO,1)IDCUENTACORREO,      A.INDSUJETOSUSP, 
        A.COD_AGENTE_JEFE,                          PNJA.EMAIL EMAIL_AGENTE, 
        PNJ.EMAIL EMAIL_EJECUTIVO,                  ACA.TIPOCEDULA, 
        ACA.FECVENCIMIENTO FINVENC_CEDULA,          ACA.FECVENCPOLRC VENC_POLRC,
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(EC.TIPODOCIDENTEJEC,EC.NUMDOCIDENTEJEC)             NOMBRE_EJECUTIVO, 
        OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.TIPO_DOC_IDENTIFICACION,A.NUM_DOC_IDENTIFICACION) NOMBRE_AGENTE
   FROM AGENTES                   A,
        EJECUTIVO_COMERCIAL       EC,
        PERSONA_NATURAL_JURIDICA  PNJA,
        PERSONA_NATURAL_JURIDICA  PNJ,
        AGENTES_CEDULA_AUTORIZADA ACA
  WHERE PNJA.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION 
    AND PNJA.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION
    --    
--  AND A.COD_AGENTE in(64,198,214,220,227,214,260,263,297,329,379,393,453,471,538,556,614,650,93,149,185,187)
    --
    AND EC.CODCIA       = A.CODCIA
    AND EC.CODEJECUTIVO = A.CODEJECUTIVO
    --
    AND PNJ.TIPO_DOC_IDENTIFICACION = EC.TIPODOCIDENTEJEC 
    AND PNJ.NUM_DOC_IDENTIFICACION  = EC.NUMDOCIDENTEJEC
    --
    AND ACA.COD_AGENTE       = A.COD_AGENTE
    AND (ACA.FECVENCIMIENTO <= SYSDATE  OR 
         ACA.FECVENCPOLRC   <= SYSDATE )  
  ORDER BY A.COD_AGENTE;
--
BEGIN
  --
  -- BUSCA ORIGEN
  --
  BEGIN
    SELECT SYS_CONTEXT('userenv', 'terminal'), 
           USER
      INTO W_ID_TERMINAL,
           W_ID_USER
      FROM DUAL;
  END;
  --
  BEGIN
    SELECT S.CAGE_NOM_CONCEP
      INTO W_ID_ENVIO
      FROM SAI_CAT_GENERAL S
     WHERE S.CAGE_CD_CATALOGO = 15;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         W_ID_ENVIO := 'ORIGEN INDEFINIDO';
    WHEN OTHERS THEN
         W_ID_ENVIO := 'ORIGEN INDEFINIDO O';
  END;
  --
  INSERT INTO CONTROL_PROCESOS_AUTOMATICOS
  VALUES('ENVIA_MAIL_AGENTES_CEDPOLRC',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
  --
  COMMIT; 
  --    
  FOR X IN AGENTES LOOP
      --
      nLeidos         := nLeidos + 1;
      nenviar_mail    := 0;
      cTextoEndosoEnv := NULL;    
      cSubject        := NULL;            
      cEmail          := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
      cPwdEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
      --                
      select MAX(F.FECFINVIG)
        into dfechafinpago
        from facturas F
       WHERE stsfact = 'PAG'
         AND F.IDPOLIZA IN( SELECT AP.IDPOLIZA
                              FROM agente_poliza ap, 
                                   polizas p
                             where p.idpoliza = ap.idpoliza
                               and ap.cod_agente = X.COD_AGENTE
                               and trunc(p.fecfinvig) >= trunc(sysdate));        
      --        
      IF  TRUNC(dfechafinpago) >= SYSDATE THEN       
          BEGIN
            SELECT PNJJ.EMAIL EMAIL_AGENTE 
              INTO cEmailJefe
              FROM AGENTES A, 
                   PERSONA_NATURAL_JURIDICA PNJJ
             WHERE A.COD_AGENTE                 = X.COD_AGENTE_JEFE
               AND PNJJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION 
               AND PNJJ.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION;                 
          EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                  cEmailJefe := '';
          END;
          --   
          dbms_output.put_line('mail del jefe '||cEmailJefe);    
          --
          IF X.EMAIL_AGENTE IS NULL THEN
             cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(X.RFC_AGENTE,X.NUM_DOC_AGENTE);
          ELSE
             cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(X.RFC_AGENTE,X.NUM_DOC_AGENTE,X.IdCuentaCorreo);
          END IF;
          --
          cEmailEjecutivo := X.EMAIL_EJECUTIVO;
--          cEmailEjecutivo := NULL; --'jmmdcbt@prodigy.net.mx';          
--          cEmailAgen      := 'jmarquez@thonaseguros.mx';
--          cEmailJefe      := NULL; --'juanmanuelmarquezd@gmail.com';  
          --                     
          IF (TRUNC(SYSDATE) - X.VENC_POLRC     > 0) AND
             (TRUNC(SYSDATE) - X.FINVENC_CEDULA > 0) THEN
             cSubject        := cSubjectCedRc||X.NOMBRE_AGENTE;             
             cTxtEstatusCed  := cTxtVencido; 
             cTxtEstatusRc   := cTxtVencido;
             nenviar_mail    := 1;  
             cTextoEndosoEnv := cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto4||cTxtEstatusCed||' '||
                                to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto8||chr(10)||chr(13)
                                ||chr(10)||chr(13)||cTexto6||cTxtEstatusRc||' '
                                ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto10||chr(10)||chr(13)||
                                cTexto11||chr(10)||chr(13)||cTexto5||chr(10)||chr(13)||cTexto9;                
             dbms_output.put_line('se enviara correo al agente '||x.cod_Agente);             
             BEGIN
               OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
             EXCEPTION
               WHEN OTHERS THEN
                    dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
             END;  
          ELSE
             nenviar_mail    := 0; 
             cTextoEndosoEnv := NULL;    
             cSubject        := NULL; 
             IF TRUNC(SYSDATE) - X.FINVENC_CEDULA > 0  THEN
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
                cTextoEndosoEnv :=  cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto4||cTxtEstatusCed||' '||
                                    to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto8||chr(10)||chr(13)||cTexto9;
                dbms_output.put_line('se envio correo al agente '||x.cod_Agente);             
                BEGIN
                  OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                EXCEPTION
                  WHEN OTHERS THEN
                       dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
                END;  
                --
             END IF;    
             --
             nenviar_mail    := 0; 
             cTextoEndosoEnv := NULL;    
             cSubject        := NULL;   
             --
             IF TRUNC(SYSDATE) - x.VENC_POLRC > 0 THEN
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
                cTextoEndosoEnv := cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto6||cTxtEstatusRc||' '
                                   ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto10||chr(10)||chr(13)||
                                   cTexto11||chr(10)||chr(13)||cTexto5||chr(10)||chr(13)||cTexto9;                 
                dbms_output.put_line('se envio correo al agente '||x.cod_agente);            
                BEGIN
                  OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                EXCEPTION
                   WHEN OTHERS THEN
                   dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
                END;    
             END IF;  
          END IF;  
        END IF;               
  END LOOP;
  --
EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line('Error: '||SQLERRM);  
END;
/

--
-- ENVIA_MAIL_AGENTES_CEDPOLRC  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   EJECUTIVO_COMERCIAL (Table)
--   ENDOSO_TXT_DET (Table)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   AGENTES (Table)
--   AGENTES_CEDULA_AUTORIZADA (Table)
--   AGENTE_POLIZA (Table)
--   USUARIOS (Table)
--   OC_SENDMAIL (Package)
--   CONTROL_PROCESOS_AUTOMATICOS (Table)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_GENERALES (Package)
--   OC_PERSONA_NATURAL_JURIDICA (Package)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.ENVIA_MAIL_AGENTES_CEDPOLRC  IS

  nLeidos                     NUMBER := 0;
  cEmail                      USUARIOS.EMAIL%TYPE;  
  cPwdEmail                   VARCHAR2(100); 
  cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';      
  --cTextoEndoso                ENDOSO_TXT_DET.TEXTO%TYPE;
  cTextoEndosoEnv             ENDOSO_TXT_DET.TEXTO%TYPE;
  --cTipoNot                    VALORES_DE_LISTAS.CODVALOR%TYPE;  
  cEmailAgen                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cEmailEjecutivo             CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  cEmailJefe                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
  nIdCuentaCorreo             VARCHAR2(100); --AGENTES.IDCUENTACORREO%TYPE;
  ncuantaspolizas             NUMBER;
  dfechafinpago               DATE;
  nenviar_mail                NUMBER := 0;
  cSubject                    VARCHAR2(500);
  cTxtEstatusCed              VARCHAR2(1000);
  cTxtEstatusRc               VARCHAR2(1000);
  cSubjectCed                 VARCHAR2(1000) := 'Notificación Vencimiento de Cédula: ';
  cSubjectRc                  VARCHAR2(1000) := 'Notificación Vencimiento de Póliza RC: ';
  cSubjectCedRc               VARCHAR2(1000) := 'Notificación Vencimiento de Cédula y Póliza RC: ';
  cTxtVencido                 VARCHAR2(1000) := 'vencida a partir del';
  cTxtXVencer                 VARCHAR2(1000) := 'por vencer el próximo';
  cTexto1                     VARCHAR2(10000):= 'Apreciable Conducto, ';
  cTexto2                     varchar2(10)   := ' Clave ';
  --cTexto3                     varchar2(100)  := chr(10);
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

  SELECT A.COD_AGENTE, A.TIPO_DOC_IDENTIFICACION RFC_AGENTE, A.NUM_DOC_IDENTIFICACION NUM_DOC_AGENTE, 
         A.CODEJECUTIVO, nvl(A.IdCuentaCorreo,1) IdCuentaCorreo, A.INDSUJETOSUSP, A.COD_AGENTE_JEFE,
         OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.TIPO_DOC_IDENTIFICACION,A.NUM_DOC_IDENTIFICACION) NOMBRE_AGENTE,
         PNJA.EMAIL EMAIL_AGENTE, 
         OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(EC.TIPODOCIDENTEJEC,EC.NUMDOCIDENTEJEC) NOMBRE_EJECUTIVO, 
         PNJ.EMAIL EMAIL_EJECUTIVO, ACA.TIPOCEDULA, ACA.FECVENCIMIENTO FINVENC_CEDULA, ACA.FECVENCPOLRC VENC_POLRC
  FROM AGENTES A
  , EJECUTIVO_COMERCIAL EC
  , PERSONA_NATURAL_JURIDICA PNJA
  , PERSONA_NATURAL_JURIDICA PNJ
  , AGENTES_CEDULA_AUTORIZADA ACA
  WHERE PNJA.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION 
  AND PNJA.NUM_DOC_IDENTIFICACION = A.NUM_DOC_IDENTIFICACION
--  AND A.COD_AGENTE in(64,198,214,220,227,214,260,263,297,329,379,393,453,471,538,556,614,650,93,149,185,187)
  AND EC.CODEJECUTIVO = A.CODEJECUTIVO
  AND PNJ.TIPO_DOC_IDENTIFICACION = EC.TIPODOCIDENTEJEC 
  AND PNJ.NUM_DOC_IDENTIFICACION = EC.NUMDOCIDENTEJEC
  AND ACA.COD_AGENTE = A.COD_AGENTE
  ORDER BY A.COD_AGENTE;

  BEGIN
      insert into control_procesos_automaticos
      values ('ENVIA_MAIL_AGENTES_CEDPOLRC',sysdate);

      commit; 
      
     FOR X IN AGENTES LOOP
         nLeidos := nLeidos + 1;
         nenviar_mail := 0;
         cEmail     := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
         cPwdEmail := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
         
  /*        SELECT count(*)
          into ncuantaspolizas
          FROM agente_poliza ap
          , polizas p
          where p.idpoliza = ap.idpoliza
          and ap.cod_agente = x.cod_agente
          and trunc(p.fecfinvig) >= trunc(sysdate);  */
          
          select MAX(F.FECFINVIG)
            into dfechafinpago
            from facturas F
           WHERE stsfact = 'PAG'
           AND F.IDPOLIZA IN( SELECT AP.IDPOLIZA
                            FROM agente_poliza ap
                            , polizas p
                            where p.idpoliza = ap.idpoliza
                            and ap.cod_agente = X.COD_AGENTE
                            and trunc(p.fecfinvig) >= trunc(sysdate));        
          
  --       IF ncuantaspolizas > 0 THEN    
         IF  TRUNC(dfechafinpago) >= SYSDATE THEN       
             BEGIN
                SELECT PNJJ.EMAIL EMAIL_AGENTE 
                INTO cEmailJefe
                FROM AGENTES A
                , PERSONA_NATURAL_JURIDICA PNJJ
                WHERE A.COD_AGENTE = X.COD_AGENTE_JEFE
                AND PNJJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION 
                AND PNJJ.NUM_DOC_IDENTIFICACION = A.NUM_DOC_IDENTIFICACION;                 
             EXCEPTION WHEN NO_DATA_FOUND THEN
                 cEmailJefe := '';
             END;
             
             dbms_output.put_line('mail del jefe '||cEmailJefe);    
-----------------------
             IF X.EMAIL_AGENTE IS NULL THEN
                cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(X.RFC_AGENTE,X.NUM_DOC_AGENTE);
             ELSE
--                dbms_output.put_line('pase por 4 rfc '||X.NUM_DOC_AGENTE);
               cEmailAgen := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(X.RFC_AGENTE,X.NUM_DOC_AGENTE,X.IdCuentaCorreo);
--                dbms_output.put_line('pase por 5');
             END IF;
                cEmailEjecutivo := X.EMAIL_EJECUTIVO;
--                cEmailEjecutivo := 'jmmdcbt@prodigy.net.mx';          
--                cEmailAgen := 'jmarquez@thonaseguros.mx';
--                cEmailJefe := 'juanmanuelmarquezd@gmail.com';  
-----------------------             
                    
             IF (TRUNC(SYSDATE) - x.VENC_POLRC > 0) and (TRUNC(SYSDATE) - X.FINVENC_CEDULA > 0) THEN
                  cSubject := cSubjectCedRc||X.NOMBRE_AGENTE;             
                  cTxtEstatusCed := cTxtVencido; 
                  cTxtEstatusRc := cTxtVencido;
                  nenviar_mail := 1;  
                cTextoEndosoEnv :=  cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto4||cTxtEstatusCed||' '||
                to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto8||chr(10)||chr(13)
                 ||chr(10)||chr(13)||cTexto6||cTxtEstatusRc||' '
                 ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto10||chr(10)||chr(13)||
                 cTexto11||chr(10)||chr(13)||cTexto5||chr(10)||chr(13)||cTexto9;                
  --              dbms_output.put_line('pase por 3 '||X.EMAIL_AGENTE);    
            
  --              dbms_output.put_line('cSubject '||cSubject);
    /*            dbms_output.put_line('cEmail '||cEmail);  
                dbms_output.put_line('cPwdEmail '||cPwdEmail);
                dbms_output.put_line('cEmailAgen '||cEmailAgen);
                dbms_output.put_line('cTextoEndosoEnv  '||cTextoEndosoEnv );
                dbms_output.put_line('nenviar_mail '||nenviar_mail); */             
                if nenviar_mail = 1 then
                   dbms_output.put_line('se envio correo al agente '||x.cod_Agente);             
                      BEGIN
                         OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                      EXCEPTION
                        WHEN OTHERS THEN
                          dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
                      END;  
                  END IF;                                                 
             ELSE
               IF TRUNC(SYSDATE) - X.FINVENC_CEDULA > 0  THEN
                  cSubject := cSubjectCed||X.NOMBRE_AGENTE;               
                  cTxtEstatusCed := cTxtVencido;
  --                dbms_output.put_line('Entre por cedula vencida, se enviará mail al agente ');
                  nenviar_mail := 1;
    --           ELSIF TRUNC(SYSDATE) - X.FINVENC_CEDULA <= 0 THEN
               ELSIF trunc(X.FINVENC_CEDULA) between TRUNC(SYSDATE)  and TRUNC(SYSDATE + 7) THEN           
                  cTxtEstatusCed := cTxtXVencer;
                  nenviar_mail := 1;
               END IF;
                 
                cTextoEndosoEnv :=  cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto4||cTxtEstatusCed||' '||
                to_char(x.FINVENC_CEDULA,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto8||chr(10)||chr(13)||cTexto9;
  --              dbms_output.put_line('pase por 3 '||X.EMAIL_AGENTE);    
  --              dbms_output.put_line('cSubject '||cSubject);
    /*            dbms_output.put_line('cEmail '||cEmail);  
                dbms_output.put_line('cPwdEmail '||cPwdEmail);
                dbms_output.put_line('cEmailAgen '||cEmailAgen);
                dbms_output.put_line('cTextoEndosoEnv  '||cTextoEndosoEnv );
                dbms_output.put_line('nenviar_mail '||nenviar_mail); */             
                if nenviar_mail = 1 then
                   dbms_output.put_line('se envio correo al agente '||x.cod_Agente);             
                      BEGIN
                         OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailAgen,cEmailJefe,cEmailEjecutivo,cSubject,cTextoEndosoEnv);
                      EXCEPTION
                        WHEN OTHERS THEN
                          dbms_output.put_line('Error en el envío de notificacion al agente '||X.NOMBRE_AGENTE);      
                      END;  
                  END IF;    
               nenviar_mail := 0;   
               cSubject := cSubjectRc||X.NOMBRE_AGENTE;
               IF TRUNC(SYSDATE) - x.VENC_POLRC > 0 THEN
                  cTxtEstatusRc := cTxtVencido;
                  nenviar_mail := 1;
  --                dbms_output.put_line('Entre por poliza RC vencida, se enviará mail al agente ');          
    --           ELSIF TRUNC(SYSDATE) - x.VENC_POLRC <= 0 THEN
               ELSIF TRUNC(x.VENC_POLRC) BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE + 7) THEN           
                 cTxtEstatusRc := cTxtXVencer;
                  nenviar_mail := 1;             
               END IF;  
                 cTextoEndosoEnv :=  cTexto1||X.NOMBRE_AGENTE||cTexto2||X.COD_AGENTE||chr(10)||chr(13)||cTexto6||cTxtEstatusRc||' '
                 ||to_char(x.VENC_POLRC,'dd/mm/yyyy')||cTexto7||chr(10)||chr(13)||cTexto10||chr(10)||chr(13)||
                 cTexto11||chr(10)||chr(13)||cTexto5||chr(10)||chr(13)||cTexto9;
  --               dbms_output.put_line('pase por 3 '||X.EMAIL_AGENTE);    
  --               dbms_output.put_line('cSubject '||cSubject);
    /*             dbms_output.put_line('cEmail '||cEmail);  
                 dbms_output.put_line('cPwdEmail '||cPwdEmail);
                 dbms_output.put_line('cEmailAgen '||cEmailAgen);
                 dbms_output.put_line('cTextoEndosoEnv  '||cTextoEndosoEnv ); 
                 dbms_output.put_line('nenviar_mail '||nenviar_mail);  */           
                 IF nenviar_mail = 1 THEN  
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
--    dbms_output.put_line('Leidos: '||nLeidos );    

  EXCEPTION
    WHEN OTHERS THEN
  dbms_output.put_line('Error: '||SQLERRM);  
  END;
/

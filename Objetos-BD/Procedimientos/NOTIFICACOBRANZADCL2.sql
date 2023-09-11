CREATE OR REPLACE PROCEDURE SICAS_OC.NOTIFICACOBRANZADCL2 (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdFactura NUMBER) IS

/*
Desarrollador: Luis Argenis Reynoso Alvarez
Fecha: 11/09/2023
Descripci�n: Se implementa regla a ViCapital para obtener los correos de los Agentes y copiarlos en el correo enviado al cliente.
*/

nCodCliente             CLIENTES.CodCliente%TYPE;
cTipoDocIdentificacion  CLIENTES.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentificacion   CLIENTES.Num_Doc_Identificacion%TYPE;
cEmailCliente           CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
nCodAsegurado           DETALLE_POLIZA.Cod_Asegurado%TYPE;
dFecIniVig              POLIZAS.FecIniVig%TYPE;
cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob                DETALLE_POLIZA.PlanCob%TYPE;
nNumCuotaDcl            FACTURAS.NumCuota%TYPE;
dFechaCobro             DETALLE_DOMICI_REFERE.FecAplica%TYPE;
nMontoFactAporta        DETALLE_DOMICI_REFERE.Monto%TYPE;
dFecVenc                FACTURAS.FecVenc%TYPE;

cSubject                VARCHAR2(10000);
cMessage                VARCHAR2(20000);
cEmailAuth              VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
cPwdEmail               VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
cEmailEnvio             VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
cCadenaLogo             VARCHAR2(200)     := ' <img src="http://www.thonaseguros.mx/images/Thona_Seguros.png" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="80" width="300"> ';
cAvisoImportante        VARCHAR2(1000)    := 'AVISO IMPORTANTE. Este correo electr�nico y cualquier archivo que se adjunte al mismo, es propiedad de THONA Seguros S.A. de C.V., y podr� '||
                                             'contener informaci�n privada y privilegiada para uso exclusivo del destinatario. Si usted ha recibido este correo por error, por favor, notifique '||
                                             'al remitente y b�rrelo. No est� autorizado para copiar, retransmitir, utilizar o divulgar este mensaje ni los archivos adjuntos, de lo contrario '||
                                             'estar� infringiendo leyes mexicanas y de otros pa�ses que se aplican rigurosamente.';
cHTMLHeader             VARCHAR2(2000)    := '<html>'                                                                     ||CHR(13)||
                                             '<head>'                                                                     ||CHR(13)||
                                            -- '<meta charset="UTF-8">'                                                     ||CHR(13)||
                                             '<meta http-equiv="Content-Language" content="en/us"/>'                      ||CHR(13)||
                                            -- '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||CHR(13)||
                                                --'</head><body background="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" bgcolor="aqua" width="120" height="280">' ||CHR(13);
                                             '</head><body>'                                                              ||CHR(13);
cHTMLFooter             VARCHAR2(100)     := '</body></html>';
cTextoAlignDerecha      VARCHAR2(50)      := '<P align="right">';
cTextoAlignDerechaClose VARCHAR2(50)      := '</P>';
cSaltoLinea             VARCHAR2(5)       := '<br>';
cTextoImportanteOpen    VARCHAR2(10)      := '<strong>';
cTextoImportanteClose   VARCHAR2(10)      := '</strong>';
cTextoRojoOpen          VARCHAR2(100)     := '<FONT COLOR="red">';
cTextoClose             VARCHAR2(30)      := '</FONT>';
cTextoSmall             VARCHAR2(100)     := '<FONT SIZE="2" COLOR="blue">';
cError                  VARCHAR2(200);

nCod                    NUMBER;
vl_CodAgente            NUMBER;
vl_Mails                VARCHAR2(4000) := NULL;
cError2                  VARCHAR2(200);
VL_LONG                 NUMBER;
CURSOR cur_Salida IS
  SELECT DISTINCT(J.EMAIL) --B.COD_AGENTE,B.COD_AGENTE_JEFE,J.EMAIL,LEVEL
  FROM AGENTES B,PERSONA_NATURAL_JURIDICA J
  WHERE  J.NUM_DOC_IDENTIFICACION = B.NUM_DOC_IDENTIFICACION
    AND J.TIPO_DOC_IDENTIFICACION = B.TIPO_DOC_IDENTIFICACION
    AND B.EST_AGENTE = 'ACT'
  START WITH  B.COD_AGENTE = vl_CodAgente  
  CONNECT BY PRIOR B.COD_AGENTE_JEFE = B.COD_AGENTE;
BEGIN
    BEGIN
      SELECT P.Codcliente,C.Tipo_Doc_Identificacion,C.Num_Doc_Identificacion,
             P.NumPolUnico,P.FecIniVig,DP.IdTipoSeg,DP.PlanCob,DP.Cod_Asegurado
        INTO nCodCliente,cTipoDocIdentificacion,cNumDocIdentificacion,
             cNumPolUnico,dFecIniVig,cIdTipoSeg,cPlanCob,nCodAsegurado
        FROM POLIZAS P,CLIENTES C,DETALLE_POLIZA DP
       WHERE P.CodCia       = nCodCia
         AND P.CodEmpresa   = nCodEmpresa
         AND P.IdPoliza     = nIdPoliza
         AND P.CodCliente   = C.CodCliente
         AND P.CodCia       = DP.CodCia
         AND P.CodEmpresa   = DP.CodEmpresa
         AND P.IdPoliza     = DP.IdPoliza
		 AND ROWNUM <= 1;
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20225,'No Es Posible Obtener Datos del Cliente Para la P�liza '||nIdPoliza);
    END;
   
    BEGIN
      SELECT NVL(D.Monto,0),D.FecAplica,NVL(F.NumCuota,0),F.FecVenc
        INTO nMontoFactAporta,dFechaCobro,nNumCuotaDcl,dFecVenc
        FROM DETALLE_DOMICI_REFERE D,FACTURAS F,DET_DOMICI_REC R
       WHERE F.IdFactura    = nIdFactura 
         AND F.CodCia       = nCodCia
         AND F.CodCia       = D.CodCia
         AND F.IdFactura    = D.IdFactura
         AND D.IdProceso    = R.IdProceso
         AND D.IdFactura    = R.NumRefContrato
         AND F.StsFact      = 'EMI'
         --AND D.Estado       = 'EXC'
--         AND D.IdFactura   IN (SELECT RE.IdFactura
--                                 FROM REGISTRO_EXCEPCION RE
--                                WHERE RE.CodCia     = D.CodCia
--                                  AND RE.IdProceso  = RE.IdProceso)
                                  ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoFactAporta   := 0;
         dFechaCobro        := TRUNC(SYSDATE);
         nNumCuotaDcl       := 0;
    END;
   
    cEmailCliente := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentificacion, cNumDocIdentificacion);
                    
    cSubject := 'Cobranza Declinada '||cNumPolUnico||' Cliente '||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion);
    cMessage := cHTMLHeader                                                                                                                                                                      ||
                cTextoAlignDerecha||'Ref.: Cobranza Declinada P�liza '||cTextoRojoOpen||cNumPolUnico||cTextoClose||cTextoAlignDerechaClose                                                       ||cSaltoLinea||
                cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||
                'Hacemos de su conocimiento, que el pasado '||cTextoRojoOpen||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFechaCobro))||cTextoClose||' se realiz� segundo intento de cobro a la cuenta '  ||
                'bancaria que nos proporcion�, desafortunadamente el banco nos notific� nuevamente"'||cTextoImportanteOpen||'transacci�n declinada por el emisor'||cTextoImportanteClose||'", '  ||
                'por lo que no se pudo cobrar la prima de seguro m�s aportaci�n adicional por '||cTextoRojoOpen||TO_CHAR(nMontoFactAporta,'$9,999.99')||cTextoClose||' cubriendo el pago n�mero '||
                cTextoRojoOpen||nNumCuotaDcl||cTextoClose ||'.'                                                                                                                                  ||cSaltoLinea||cSaltoLinea||
                'Para que usted no quede desprotegido le agradeceremos realizar el pago correspondiente antes del '||cTextoRojoOpen||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFecVenc))||cTextoClose   ||                       
                ' por lo que le pedimos ponerse en contacto con nosotros en el:'                                                                                                                 ||cSaltoLinea||cSaltoLinea||
                'Centro de Servicios a Asegurados, el cual estar� disponible en horario de oficina en los tel�fonos (55) 44-33-89-00 opci�n 3, '                                                 ||
                'o bien por correo electr�nico mipolizaflex@thonaseguros.mx, donde le proporcionaran un n�mero de referencia bancaria para que pueda pagar en ventanilla.'                       ||cSaltoLinea||cSaltoLinea||cSaltoLinea||                  
                'A t e n t a m e n t e,'                                                                                                                                                         ||cSaltoLinea||
                cTextoImportanteOpen||'    Este Correo es Generado de Manera Autom�tica, Por Favor no lo Responda.'||cTextoImportanteClose||UTL_TCP.CRLF                                         ||cSaltoLinea||
                cCadenaLogo                                                                                                                                                                      ||cSaltoLinea||
                cTextoSmall||cAvisoImportante||cTextoClose                                                                                                                                       ||cSaltoLinea||
                cHTMLFooter;

    OC_MAIL.INIT_PARAM;
    OC_MAIL.cCtaEnvio   := cEmailAuth;
    OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
    
    IF cIdTipoSeg = 'VICAP' THEN

      SELECT B.COD_AGENTE
      INTO vl_CodAgente
      FROM AGENTES B,AGENTE_POLIZA A
      WHERE B.COD_AGENTE = A.COD_AGENTE
        AND A.IDPOLIZA = nIdPoliza
        AND B.EST_AGENTE = 'ACT';

      FOR CON IN cur_Salida LOOP
        IF vl_Mails IS NULL THEN
          vl_Mails := CON.EMAIL||',';
        ELSE
          vl_Mails := vl_Mails || REPLACE(vl_Mails,CON.EMAIL,NULL)||',';
        END IF;
      END LOOP;
      
      vl_Mails := REPLACE(vl_Mails,',,',',');
      VL_LONG := length(vl_Mails);
      vl_Mails  := SUBSTR(vl_Mails,0,VL_LONG-1);
      
      vl_Mails := 'lreynoso@thonaseguros.mx,argenyz_revolutionz@hotmail.com';
      
      OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,vl_Mails,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
      
      SICAS_OC.OC_CTRL_MAIL_NOTIFICACIONES.SPINSERT(
                                                'COBRANZADCL2',
                                                nIdPoliza,
                                                cIdTipoSeg,
                                                1,
                                                NULL,
                                                NULL,
                                                cEmailCliente,
                                                vl_Mails,
                                                cSubject,
                                                cMessage,
                                                cError,
                                                nCod,
                                                cError2
                                              );
    ELSE 
        OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,/*'esaavedra@thonaseguros.mx'*/null,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
    END IF;
END NOTIFICACOBRANZADCL2;
/

PROCEDURE NOTIFICACOBRANZADCL1 (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdFactura NUMBER) IS
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

cSubject                VARCHAR2(10000);
cMessage                VARCHAR2(20000);
cEmailAuth              VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
cPwdEmail               VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
cEmailEnvio             VARCHAR2(100)     := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
cCadenaLogo             VARCHAR2(200)     := ' <img src="http://www.thonaseguros.mx/images/Thona_Seguros.png" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="80" width="300"> ';
cAvisoImportante        VARCHAR2(1000)    := 'AVISO IMPORTANTE. Este correo electrónico y cualquier archivo que se adjunte al mismo, es propiedad de THONA Seguros S.A. de C.V., y podrá '||
                                             'contener información privada y privilegiada para uso exclusivo del destinatario. Si usted ha recibido este correo por error, por favor, notifique '||
                                             'al remitente y bórrelo. No está autorizado para copiar, retransmitir, utilizar o divulgar este mensaje ni los archivos adjuntos, de lo contrario '||
                                             'estará infringiendo leyes mexicanas y de otros países que se aplican rigurosamente.';
cHTMLHeader             VARCHAR2(2000)    := '<html>'                                                                     ||CHR(13)||
                                             '<head>'                                                                     ||CHR(13)||
                                             '<meta http-equiv="Content-Language" content="en/us"/>'                      ||CHR(13)||
                                             '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||CHR(13)||
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
         AND P.IdPoliza     = DP.IdPoliza;
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No Es Posible Obtener Datos del Cliente Para la Póliza '||nIdPoliza);
   END;
   
   BEGIN
      SELECT NVL(D.Monto,0),D.FecAplica,NVL(F.NumCuota,0)
        INTO nMontoFactAporta,dFechaCobro,nNumCuotaDcl
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
               cTextoAlignDerecha||'Ref.: Cobranza Declinada Póliza '||cTextoRojoOpen||cNumPolUnico||cTextoClose||cTextoAlignDerechaClose                                                       ||cSaltoLinea||
               cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||
               'Hacemos de su conocimiento, que el pasado '||cTextoRojoOpen||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFechaCobro))||cTextoClose||' se realizó primer intento de cobro a la cuenta '   ||
               'bancaria que nos proporcionó, desafortunadamente el banco nos notificó "'||cTextoImportanteOpen||'transacción declinada por el emisor'||cTextoImportanteClose||'", '            ||
               'por lo que no se pudo cobrar la prima de seguro más aportación adicional por '||cTextoRojoOpen||TO_CHAR(nMontoFactAporta,'$9,999.99')||cTextoClose||' cubriendo el pago número '||
               cTextoRojoOpen||nNumCuotaDcl||cTextoClose ||'.'                                                                                                                                  ||cSaltoLinea||cSaltoLinea||
               'Para que usted no quede desprotegido realizaremos un '||cTextoImportanteOpen||'segundo intento'||cTextoImportanteClose||' de cobro el '                                         ||
               cTextoRojoOpen||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFechaCobro + 5))||cTextoClose                                                                                                 ||                       
               ' a la cuenta bancaria registrada.'                                                                                                                                              ||cSaltoLinea||cSaltoLinea||
               'O si prefiere puede comunicarse antes de la fecha del '||cTextoImportanteOpen||'segundo intento'||cTextoImportanteClose||' de cobro a nuestro centro de '                       ||
               'Servicios a Asegurados, el cual estará disponible de lunes a jueves de 9:00 a 18:00 hrs. y viernes de 9:00 a 15.00 hrs. en los teléfonos (55) 44-33-89-00 opción 2, '           ||
               'o bien por Correo electrónico mipolizaflex@thonaseguros.mx, donde le proporcionaran un número de referencia bancaria para que pueda pagar en ventanilla.'                       ||cSaltoLinea||cSaltoLinea||cSaltoLinea||                  
               'A t e n t a m e n t e,'                                                                                                                                                         ||cSaltoLinea||
               cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||UTL_TCP.CRLF                                         ||cSaltoLinea||
               cCadenaLogo                                                                                                                                                                      ||cSaltoLinea||
               cTextoSmall||cAvisoImportante||cTextoClose                                                                                                                                       ||cSaltoLinea||
               cHTMLFooter;

   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
   OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,/*'esaavedra@thonaseguros.mx'*/null,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
    
END NOTIFICACOBRANZADCL1;

CREATE OR REPLACE PACKAGE GT_TEMP_ENVIA_CORREOS AS
    PROCEDURE ENVIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdFactura NUMBER, cTipoNotifica VARCHAR2);
END GT_TEMP_ENVIA_CORREOS;
/

CREATE OR REPLACE PACKAGE BODY GT_TEMP_ENVIA_CORREOS AS
PROCEDURE ENVIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdFactura NUMBER, cTipoNotifica VARCHAR2) IS
nCodCliente             CLIENTES.CodCliente%TYPE;
cTipoDocIdentificacion  CLIENTES.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentificacion   CLIENTES.Num_Doc_Identificacion%TYPE;
cEmailCliente           CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
nCodAsegurado           DETALLE_POLIZA.Cod_Asegurado%TYPE;
dFecIniVig              POLIZAS.FecIniVig%TYPE;
cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob                DETALLE_POLIZA.PlanCob%TYPE;
nMontoPagoFact          DETALLE_DOMICI_REFERE.Monto%TYPE;
dFecAplica              DETALLE_DOMICI_REFERE.FecAplica%TYPE;
nNumCuota               FACTURAS.NumCuota%TYPE;
nNumCuotaDcl            FACTURAS.NumCuota%TYPE;
dFechaCobro             DETALLE_DOMICI_REFERE.FecAplica%TYPE;
dFechaSigCobro          DETALLE_DOMICI_REFERE.FecAplica%TYPE;
nMontoFactAporta        DETALLE_DOMICI_REFERE.Monto%TYPE;
nAporteFondo             DETALLE_POLIZA.MontoAporteFondo%TYPE;
nIdFondo                 FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nPrimaNivelada           FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;

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
cTextoGdeOpen           VARCHAR2(100)     := '<FONT SIZE="5" COLOR="#ffbf00">';
cTextoGdeRojoOpen       VARCHAR2(100)     := '<FONT SIZE="5" COLOR="red">';
cTextoRojoOpen          VARCHAR2(100)     := '<FONT COLOR="red">';
cTextoAmarilloOpen      VARCHAR2(100)     := '<FONT COLOR="#ffbf00">';
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
   
    IF cTipoNotifica = 'COBRAOK' THEN
        BEGIN
            SELECT NVL(F.Monto_Fact_Local,0),F.FecPago,NVL(F.NumCuota,0)
              INTO nMontoPagoFact,dFecAplica,nNumCuota
             FROM FACTURAS F
            WHERE F.IdFactura = nIdFactura 
              AND F.CodCia    = nCodCia
              AND F.StsFact   = 'PAG';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                nMontoPagoFact := 0;
                dFecAplica     := TRUNC(SYSDATE);
                nNumCuota      := 0;
        END;
       
       
        IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
            nAporteFondo := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, nCodEmpresa, nIdPoliza,  nIDetPol);
            nIdFondo := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado);
            IF NVL(nIdFondo,0) > 0 THEN
                nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo, nNumCuota);
            ELSE
                nPrimaNivelada := 0;
            END IF;
        ELSE
            nAporteFondo   := 0;
            nPrimaNivelada := 0;
        END IF;
        
        nMontoPagoFact := nMontoPagoFact + + NVL(nAporteFondo,0) + NVL(nPrimaNivelada,0);
    END IF;
     
   BEGIN
      SELECT NVL(D.Monto,0),D.FecAplica,NVL(F.NumCuota,0)
        INTO nMontoFactAporta,dFechaCobro,nNumCuotaDcl
        FROM DETALLE_DOMICI_REFERE D,FACTURAS F
       WHERE F.IdFactura    = nIdFactura 
         AND F.CodCia       = nCodCia
         AND F.CodCia       = D.CodCia
         AND F.IdFactura    = D.IdFactura
         AND F.StsFact      = 'EMI'
         AND D.Estado       = 'EXC'
         AND D.IdFactura   IN (SELECT RE.IdFactura
                                 FROM REGISTRO_EXCEPCION RE
                                WHERE RE.CodCia     = D.CodCia
                                  AND RE.IdProceso  = RE.IdProceso);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoFactAporta   := 0;
         dFechaCobro        := TRUNC(SYSDATE);
         nNumCuotaDcl       := 0;
   END;
   
   cEmailCliente := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentificacion, cNumDocIdentificacion); --'hgonzalez@thonaseguros.mx'; --
   IF cTipoNotifica = 'BIENVENIDA' THEN
      cSubject := 'Bienvenido a Portal "Tus Fondos Thona" '||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion);
      cMessage := cHTMLHeader                                                                                                                                                                      ||
                  cTextoAlignDerecha||'Ref.: Bienvenida al Portal "Tus Fondos Thona" Póliza '||cTextoImportanteOpen||cNumPolUnico||cTextoImportanteClose||cTextoAlignDerechaClose                  ||cSaltoLinea||
                  cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||                  
                  'Queremos darle la más cordial bienvenida a nuestro portal'||cTextoImportanteOpen||' "Tus Fondos Thona" '||cTextoImportanteClose                                                 ||
                  'a partir de este momento podrá consultar aquí la información sobre tu póliza, estado de cuenta, movimientos entre otra información relevante.'                                  ||cSaltoLinea||cSaltoLinea||
                  'Usted tendrá acceso al portal '||cTextoImportanteOpen||'"Tus Fondos Thona" '||cTextoImportanteClose||' accediendo a la liga:  '                                                 ||
                  'http://inversiones.thonaseguros.mx/Account/Login  y  registrándose con su contraseña.'                                                                                          ||cSaltoLinea||cSaltoLinea||
                  'Agradecemos su atención y nos ponemos a sus órdenes para cualquier duda o aclaración en el centro de Servicios a Asegurados, para todo lo relacionado con su plan '             ||
                  cTextoAmarilloOpen||cTextoImportanteOpen||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||cTextoImportanteClose||cTextoClose                               ||
                  ', en horario de lunes a jueves de 9:00 a 18:00 hrs. y viernes de 9:00 a 15:00 hrs, nuestro teléfono de contacto  (55) 44-33-89-00 opción 2, o bien por Correo electrónico '     ||
                  'mipolizaflex@thonaseguros.mx, donde con gusto lo atenderemos.'                                                                                                                  ||cSaltoLinea||cSaltoLinea||cSaltoLinea||
                  cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||UTL_TCP.CRLF                                         ||cSaltoLinea||
                  cCadenaLogo                                                                                                                                                                      ||cSaltoLinea||cSaltoLinea||
                  cSaltoLinea||cTextoSmall||cAvisoImportante||cTextoClose                                                                                                                          ||cSaltoLinea||
                  cHTMLFooter;
   ELSIF cTipoNotifica = 'REGISTRO' THEN
      cSubject := 'Registro a Portal "Tus Fondos Thona" '||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion);
      cMessage := cHTMLHeader                                                                                                                                                                      ||
                  cTextoAlignDerecha||'Ref.: Registro en el Portal "Tus Fondos Thona" Póliza '||cTextoImportanteOpen||cNumPolUnico||cTextoImportanteClose||cTextoAlignDerechaClose                 ||cSaltoLinea||
                  cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||                  
                  'Queremos darle la más cordial bienvenida a nuestro grupo de asegurados, su solicitud fue emitida con la póliza '||cNumPolUnico                                                  ||
                  ' en el plan de '||cTextoAmarilloOpen||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||cTextoClose                                                         ||
                  ' con inicio de vigencia a partir del '||cTextoImportanteOpen||TO_CHAR(dFecIniVig,'DD/MM/YYYY')||cTextoImportanteClose||'.'                                                      ||cSaltoLinea||cSaltoLinea||
                  'Usted tendrá acceso al portal '||cTextoImportanteOpen||'"Tus Fondos Thona" '||cTextoImportanteClose                                                                             ||
                  'donde encontrará información sobre su póliza, estado de cuenta, movimientos, entre otra información relevante. '                                                                ||
                  'Para su registro deberá acceder a la siguiente liga  http://inversiones.thonaseguros.mx/ValidateSicas/Register, es importante tener a la mano su número de Cliente: '           ||
                  cTextoImportanteOpen||nCodCliente||cTextoImportanteClose||' y número de póliza.'                                                                                                 ||cSaltoLinea||cSaltoLinea||
                  'Agradecemos su atención y nos ponemos a sus órdenes para cualquier duda o aclaración  en el centro de Servicios a Asegurados, para todo lo relacionado con su plan '            ||
                  cTextoAmarilloOpen||cTextoImportanteOpen||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||cTextoImportanteClose||cTextoClose                               ||
                  ', en horarios de oficina, nuestro teléfono de contacto  (55) 44-33-89-00 opción 2, o bien por Correo electrónico mipolizaflex@thonaseguros.mx, donde con gusto lo atenderemos.' ||cSaltoLinea||cSaltoLinea||cSaltoLinea||
                  cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||UTL_TCP.CRLF                                         ||cSaltoLinea||
                  cCadenaLogo                                                                                                                                                                      ||cSaltoLinea||
                  cSaltoLinea||cTextoSmall||cAvisoImportante||cTextoClose                                                                                                                          ||cSaltoLinea||
                  cHTMLFooter;
   ELSIF cTipoNotifica = 'COBRAOK' THEN
      cSubject := 'Cobranza Exitosa Póliza '||cNumPolUnico||' Cliente '||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion);
      cMessage := cHTMLHeader                                                                                                                                                                      ||
                  cTextoAlignDerecha||'Ref.: Cobranza exitosa  póliza '||cTextoRojoOpen||cNumPolUnico||cTextoClose||cTextoAlignDerechaClose                                                        ||cSaltoLinea||
                  cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||
                  'Hacemos de su conocimiento, que el pasado '||cTextoRojoOpen||OC_GENERALES.FECHA_EN_LETRA(TRUNC(SYSDATE))||cTextoClose||' '                                                      ||
                  'se realizó el cobro a la cuenta bancaria que nos proporcionó de forma exitosa, correspondiente a la prima de seguro más aportación adicional por '                              ||
                  cTextoRojoOpen||TO_CHAR(nMontoPagoFact,'$9,999.99')||cTextoClose||' '||'cubriendo el pago número '||cTextoRojoOpen||nNumCuota||cTextoClose                                       ||
                  ', el cual se verá reflejado en su estado de cuenta, en las siguientes 72 hrs.'                                                                                                  ||cSaltoLinea||cSaltoLinea||
                  'Agradecemos su atención y nos ponemos a sus órdenes para cualquier duda o aclaración  en el centro de Servicios a Asegurados, para todo lo relacionado con su plan '            ||
                  cTextoAmarilloOpen||cTextoImportanteOpen||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||cTextoImportanteClose||cTextoClose                               ||
                  ', en horarios de oficina, nuestro teléfono de contacto  (55) 44-33-89-00 opción 2, o bien por Correo electrónico mipolizaflex@thonaseguros.mx, donde con gusto lo atenderemos.' ||cSaltoLinea||cSaltoLinea||cSaltoLinea||
                  cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||UTL_TCP.CRLF                                         ||cSaltoLinea||
                  cCadenaLogo                                                                                                                                                                      ||cSaltoLinea||cSaltoLinea||
                  cTextoSmall||cAvisoImportante||cTextoClose                                                                                                                                       ||cSaltoLinea||
                  cHTMLFooter;
   ELSIF cTipoNotifica = 'COBRADCL' THEN                  
      cSubject := 'Cobranza Declinada '||cNumPolUnico||' Cliente '||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion);
      cMessage := cHTMLHeader                                                                                                                                                                      ||
                  cTextoAlignDerecha||'Ref.: Cobranza Declinada Póliza '||cTextoRojoOpen||cNumPolUnico||cTextoClose||cTextoAlignDerechaClose                                                       ||cSaltoLinea||
                  cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||
                  'Hacemos de su conocimiento, que el pasado '||cTextoRojoOpen||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFechaCobro))||cTextoClose||' se realizó primer intento de cobro a la cuenta '   ||
                  'bancaria que nos proporcionó, desafortunadamente el banco nos notificó "'||cTextoImportanteOpen||'transacción declinada por el emisor'||cTextoImportanteClose||'", '            ||
                  'por lo que no se pudo cobrar la prima de seguro más aportación adicional por '||nMontoFactAporta||' cubriendo el pago número '||nNumCuotaDcl||'.'                               ||cSaltoLinea||cSaltoLinea||
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
   END IF;
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
   OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,/*'esaavedra@thonaseguros.mx'*/null,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
END ENVIA;
END GT_TEMP_ENVIA_CORREOS;

CREATE OR REPLACE PROCEDURE SICAS_OC.NOTIFICACOBRANZAOKSTD (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdFactura NUMBER) IS

/*
Desarrollador: Luis Argenis Reynoso Alvarez
Fecha: 11/09/2023
Descripción: Se implementa regla a ViCapital para obtener los correos de los Agentes y copiarlos en el correo enviado al cliente.
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
nMontoPagoFact          DETALLE_DOMICI_REFERE.Monto%TYPE;
dFecAplica              DETALLE_DOMICI_REFERE.FecAplica%TYPE;
nNumCuota               FACTURAS.NumCuota%TYPE;
nAporteFondo            DETALLE_POLIZA.MontoAporteFondo%TYPE;
nIdFondo                FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nPrimaNivelada          FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;

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
                                             --'<meta charset="UTF-8">'                                                     ||CHR(13)||
                                             '<meta http-equiv="Content-Language" content="en/us"/>'                      ||CHR(13)||
                                             --'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||CHR(13)||
                                                --'</head><body background="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" bgcolor="aqua" width="120" height="280">' ||CHR(13);
                                             '</head><body>'                                                              ||CHR(13);
cHTMLFooter             VARCHAR2(100)     := '</body></html>';
cTextoAlignDerecha      VARCHAR2(50)      := '<P align="right">';
cTextoAlignDerechaClose VARCHAR2(50)      := '</P>';
cSaltoLinea             VARCHAR2(5)       := '<br>';
cTextoImportanteOpen    VARCHAR2(10)      := '<strong>';
cTextoImportanteClose   VARCHAR2(10)      := '</strong>';
cTextoRojoOpen          VARCHAR2(100)     := '<FONT COLOR="red">';
cTextoAmarilloOpen      VARCHAR2(100)     := '<FONT COLOR="#ffbf00">';
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
          RAISE_APPLICATION_ERROR(-20225,'No Es Posible Obtener Datos del Cliente Para la Póliza '||nIdPoliza);
   END;
   
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
      nAporteFondo   := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, nCodEmpresa, nIdPoliza,  nIDetPol);
      nIdFondo       := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado);
      IF NVL(nIdFondo,0) > 0 THEN
         nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo, nNumCuota);
      ELSE
         nPrimaNivelada := 0;
      END IF;
   ELSE
      nAporteFondo   := 0;
      nPrimaNivelada := 0;
   END IF;
            
   nMontoPagoFact := nMontoPagoFact + NVL(nAporteFondo,0) + NVL(nPrimaNivelada,0);
      
   cEmailCliente  := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentificacion, cNumDocIdentificacion);
   
   cSubject := 'Aplicación Exitosa Póliza '||cNumPolUnico||' Cliente '||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion);
   cMessage := cHTMLHeader                                                                                                                                                                      ||
               cTextoAlignDerecha||'Ref.: Cobranza exitosa  póliza '||cTextoRojoOpen||cNumPolUnico||cTextoClose||cTextoAlignDerechaClose                                                        ||cSaltoLinea||
               cTextoImportanteOpen||OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentificacion, cNumDocIdentificacion)||':'||cTextoImportanteClose                                     ||cSaltoLinea||cSaltoLinea||
               'Hacemos de su conocimiento, que el pasado '||cTextoRojoOpen||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFecAplica))||cTextoClose||' '                                                   ||
               'fue aplicado de manera exitosa el recibo que corresponde a la prima de seguro por '                                                       ||
               cTextoRojoOpen||TO_CHAR(nMontoPagoFact,'$9,999.99')||cTextoClose||' '||'cubriendo el pago número '||cTextoRojoOpen||nNumCuota||cTextoClose||'.'                                  ||cSaltoLinea||cSaltoLinea||
               'Agradecemos su atención y nos ponemos a sus órdenes para cualquier duda o aclaración  en el centro de Servicios a Asegurados, para todo lo relacionado con su plan '            ||
               cTextoAmarilloOpen||cTextoImportanteOpen||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||cTextoImportanteClose||cTextoClose                               ||
               ', en horarios de oficina, nuestro teléfono de contacto  (55) 44-33-89-00 opción 3, o bien por Correo electrónico individual@thonaseguros.mx, donde con gusto lo atenderemos.'   ||cSaltoLinea||cSaltoLinea||cSaltoLinea||
               cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||UTL_TCP.CRLF                                         ||cSaltoLinea||
               cCadenaLogo                                                                                                                                                                      ||cSaltoLinea||cSaltoLinea||
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
      
      --vl_Mails := 'lreynoso@thonaseguros.mx';
      
      OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,vl_Mails,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
      
      SICAS_OC.OC_CTRL_MAIL_NOTIFICACIONES.SPINSERT(
                                                'COBRANZAOKSTD',
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
END NOTIFICACOBRANZAOKSTD;
/
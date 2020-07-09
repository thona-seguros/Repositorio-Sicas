--
-- GT_REA_ALERTA_VENCIMIENTO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   UTL_TCP (Synonym)
--   DUAL (Synonym)
--   VW_CALENDARIO_ALERTAS (View)
--   POLIZAS (Table)
--   OC_EMPRESAS (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   REA_CORREO_ALERTAS (Table)
--   CLIENTES (Table)
--   OC_GENERALES (Package)
--   OC_MAIL (Package)
--   DETALLE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_ALERTA_VENCIMIENTO
IS
PROCEDURE PRINCIPAL;

PROCEDURE ENVIA_CORREO_EDOCTA  (cCodEmpresaGremio     VARCHAR2, 
                                cNombreEmpresa        VARCHAR2, 
                                cCodEsquema           VARCHAR2,
                                cDescEsquema          VARCHAR2,
                                nDias_EstadoCta       NUMBER,
                                nCodCia               NUMBER,
                                nCorreos              VARCHAR2,
                                nTipo                 VARCHAR2);
                                
PROCEDURE ENVIA_CORREO_PAGO  (cCodempresagremio     VARCHAR2, 
                              cNombreempresa        VARCHAR2, 
                              cCodesquema           VARCHAR2,
                              cDescesquema          VARCHAR2,
                              nDias_pago            NUMBER,
                              nCodCia               NUMBER,
                              nCorreos              VARCHAR2,
                              nTipo                 VARCHAR2);
                
END GT_REA_ALERTA_VENCIMIENTO;
/

--
-- GT_REA_ALERTA_VENCIMIENTO  (Package Body) 
--
--  Dependencies: 
--   GT_REA_ALERTA_VENCIMIENTO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_ALERTA_VENCIMIENTO
IS

PROCEDURE PRINCIPAL
IS 
-------------------------------------------------------------------------------------
-- CURSOR PARA FECHAS DE ALERTA EXACTA (=SYSDATE).
-- APLICA PARA ANTES Y DESPUES DE VENCIMIENTO
-- APLICA PARA ESTADOS DE CUENTA Y FECHAS DE PAGO
CURSOR CurAlertasDia IS 
    SELECT CodCia, CodEsquema, DescEsquema, IdEsqContrato, IdCapaContrato, 
           CodEmpresaGremio, DescEmpresaGremio, CodInterReaseg, IdCalendario,
           IdAlerta, Evento, Tipo, Dias, FechaBase, FechaAlerta, Repetir, Correos
    FROM VW_CALENDARIO_ALERTAS
    WHERE FechaAlerta = TRUNC(SYSDATE);
    --ORDER BY Codcia, CodEsquema, IdEsqContrato, IdCapaContrato, CodEmpresaGremio,
    --         IdCalendario, FechaAlerta;
-------------------------------------------------------------------------------------
-- CURSOR PARA FECHAS DE ALERTA CON REPETICION PARA ANTES DE VENCIMIENTO
-- APLICA PARA ESTADOS DE CUENTA Y FECHAS DE PAGO
CURSOR CurAlrRepAnt IS
     SELECT  CodCia, CodEsquema, DescEsquema, IdEsqContrato, IdCapaContrato, 
             CodEmpresaGremio, DescEmpresaGremio, CodInterReaseg, IdCalendario, 
             IdAlerta, Evento, Tipo, Dias, FechaBase, FechaAlerta, Repetir, Correos  
     FROM VW_CALENDARIO_ALERTAS
     WHERE REPETIR = 'S'
     AND Tipo = 'ANTES'
     AND Fechabase > TRUNC(SYSDATE)
     AND FechaAlerta < TRUNC(SYSDATE);
     --ORDER BY Evento, Codcia, CodEsquema, IdEsqContrato, IdCapaContrato, CodEmpresaGremio, 
     --         IdCalendario, FechaAlerta;             
-------------------------------------------------------------------------------------
-- CURSOR PARA FECHAS DE ALERTA CON REPETICION PARA DESPUÉS DE VENCIMIENTO
-- APLICA PARA ESTADOS DE CUENTA Y FECHAS DE PAGO
CURSOR CurAlrRepDes IS
     SELECT  CodCia, CodEsquema, DescEsquema, IdEsqContrato, IdCapaContrato, 
             CodEmpresaGremio, DescEmpresaGremio, CodInterReaseg, IdCalendario, 
             IdAlerta, Evento, Tipo, Dias, FechaBase, FechaAlerta, Repetir, Correos  
     FROM VW_CALENDARIO_ALERTAS
     WHERE REPETIR = 'S'
     AND Tipo = 'DESPUES'
     AND FechaAlerta < TRUNC(SYSDATE);
     --ORDER BY Evento, Codcia, CodEsquema, IdEsqContrato, IdCapaContrato, CodEmpresaGremio, 
     --         IdCalendario, FechaAlerta;
-------------------------------------------------------------------------------------
cFecAlrMin   VW_CALENDARIO_ALERTAS.FechaAlerta%TYPE;
cFecAlrMax   VW_CALENDARIO_ALERTAS.FechaAlerta%TYPE;

BEGIN
    
    -- Procesamiento para todas las alertas del día incluyendo
    -- las que tienen repetición y las que no la tienen 
    FOR RecAlertasDia IN CurAlertasDia LOOP
        IF RecAlertasDia.Evento = 'EDOCTA' THEN
            GT_REA_ALERTA_VENCIMIENTO.ENVIA_CORREO_EDOCTA(RecAlertasDia.CodEmpresaGremio,
                                                          RecAlertasDia.DescEmpresaGremio,
                                                          RecAlertasDia.CodEsquema, 
                                                          RecAlertasDia.DescEsquema,
                                                          TRUNC(RecAlertasDia.Dias),
                                                          RecAlertasDia.CodCia,
                                                          RecAlertasDia.Correos,
                                                          RecAlertasDia.Tipo);
        ELSE                                              
            GT_REA_ALERTA_VENCIMIENTO.ENVIA_CORREO_PAGO(RecAlertasDia.CodEmpresaGremio,
                                                          RecAlertasDia.DescEmpresaGremio,
                                                          RecAlertasDia.CodEsquema, 
                                                          RecAlertasDia.DescEsquema,
                                                          TRUNC(RecAlertasDia.Dias),
                                                          RecAlertasDia.CodCia,
                                                          RecAlertasDia.Correos,
                                                          RecAlertasDia.Tipo);
        END IF;                                            
    END LOOP;

    -- Procesamiento para todas las alertas que se encuentran en intervalos de repetición
    -- En este bloque vamos a resolver todas las alertas anteriores al vencimiento.
    FOR RecAlrRepAnt IN CurAlrRepAnt LOOP
        cFecAlrMin := TRUNC(RecAlrRepAnt.FechaAlerta+1);
        -- Buscamos si existe una alerta posterior, 
        -- Si existe, Tomamos FechaAlerta - 1  como límite superior
        -- Si no existe alerta posterior definida, Tomamos FechaBase - 1 como límite superior
        SELECT TRUNC(MIN(FechaAlerta))
        INTO   cFecAlrMax
        FROM VW_CALENDARIO_ALERTAS
        WHERE CodCia         = RecAlrRepAnt.Codcia
        AND CodEsquema       = RecAlrRepAnt.CodEsquema
        AND IdEsqContrato    = RecAlrRepAnt.IdEsqContrato
        AND IdCapaContrato   = RecAlrRepAnt.IdCapaContrato
        AND CodEmpresaGremio = RecAlrRepAnt.CodEmpresaGremio
        AND CodInterReaseg   = RecAlrRepAnt.CodInterReaseg
        AND IdCalendario     = RecAlrRepAnt.IdCalendario
        AND Tipo             = 'ANTES'
        AND FechaAlerta      > RecAlrRepAnt.FechaAlerta
        AND Fechabase        > TRUNC(SYSDATE);             

        IF cFecAlrMax IS NULL THEN
           cFecAlrMax := TRUNC(RecAlrRepAnt.FechaBase);
        ELSE
           cFecAlrMax := cFecAlrMax -1;
        END IF;
         
        IF TRUNC(SYSDATE) BETWEEN cFecAlrMin AND cFecAlrMax THEN
            IF RecAlrRepAnt.Evento = 'EDOCTA' THEN
                GT_REA_ALERTA_VENCIMIENTO.ENVIA_CORREO_EDOCTA(RecAlrRepAnt.CodEmpresaGremio,
                                                              RecAlrRepAnt.DescEmpresaGremio,
                                                              RecAlrRepAnt.CodEsquema, 
                                                              RecAlrRepAnt.DescEsquema,
                                                              TRUNC(RecAlrRepAnt.FechaBase) - TRUNC(SYSDATE),
                                                              RecAlrRepAnt.CodCia,
                                                              RecAlrRepAnt.Correos,
                                                              RecAlrRepAnt.Tipo);

            ELSE                                              
                GT_REA_ALERTA_VENCIMIENTO.ENVIA_CORREO_PAGO(RecAlrRepAnt.CodEmpresaGremio,
                                                            RecAlrRepAnt.DescEmpresaGremio,
                                                            RecAlrRepAnt.CodEsquema, 
                                                            RecAlrRepAnt.DescEsquema,
                                                            TRUNC(RecAlrRepAnt.FechaBase) - TRUNC(SYSDATE),
                                                            RecAlrRepAnt.CodCia,
                                                            RecAlrRepAnt.Correos,
                                                            RecAlrRepAnt.Tipo);
           END IF;                                            
        END IF;
    END LOOP;
    
    -- Procesamiento para todas las alertas que se encuentran en intervalos de repetición
    -- En este bloque vamos a resolver todas las alertas posteriores al vencimiento.
    FOR RecAlrRepDes IN CurAlrRepDes LOOP
        cFecAlrMin := RecAlrRepDes.FechaAlerta+1;
        -- Buscamos si existe una alerta posterior, 
        -- Si existe, Tomamos FechaAlerta - 1  como límite superior
        -- Si no existe alerta posterior definida, dejaremos abierto el intervalo hacie el futuro
        SELECT MIN(FechaAlerta)
        INTO   cFecAlrMax
        FROM VW_CALENDARIO_ALERTAS
        WHERE CodCia         = RecAlrRepDes.Codcia
        AND CodEsquema       = RecAlrRepDes.CodEsquema
        AND IdEsqContrato    = RecAlrRepDes.IdEsqContrato
        AND IdCapaContrato   = RecAlrRepDes.IdCapaContrato
        AND CodEmpresaGremio = RecAlrRepDes.CodEmpresaGremio
        AND CodInterReaseg   = RecAlrRepDes.CodInterReaseg
        AND IdCalendario     = RecAlrRepDes.IdCalendario
        AND Tipo             = 'DESPUES'
        AND FechaAlerta      > RecAlrRepDes.FechaAlerta;             

        IF cFecAlrMax IS NULL THEN
           cFecAlrMax := TRUNC(ADD_MONTHS(RecAlrRepDes.FechaAlerta,10*12)); -- 10 años hacia adelante
        ELSE
           cFecAlrMax := cFecAlrMax -1;
        END IF;
         
        IF TRUNC(SYSDATE) BETWEEN cFecAlrMin AND cFecAlrMax THEN
            IF RecAlrRepDes.Evento = 'EDOCTA' THEN
                GT_REA_ALERTA_VENCIMIENTO.ENVIA_CORREO_EDOCTA(RecAlrRepDes.CodEmpresaGremio,
                                                              RecAlrRepDes.DescEmpresaGremio,
                                                              RecAlrRepDes.CodEsquema, 
                                                              RecAlrRepDes.DescEsquema,
                                                              TRUNC(SYSDATE) - TRUNC(RecAlrRepDes.FechaBase),
                                                              RecAlrRepDes.CodCia,
                                                              RecAlrRepDes.Correos,
                                                              RecAlrRepDes.Tipo);
            ELSE                                              
                GT_REA_ALERTA_VENCIMIENTO.ENVIA_CORREO_PAGO(RecAlrRepDes.CodEmpresaGremio,
                                                            RecAlrRepDes.DescEmpresaGremio,
                                                            RecAlrRepDes.CodEsquema, 
                                                            RecAlrRepDes.DescEsquema,
                                                            TRUNC(SYSDATE) - TRUNC(RecAlrRepDes.FechaBase),
                                                            RecAlrRepDes.CodCia,
                                                            RecAlrRepDes.Correos,
                                                            RecAlrRepDes.Tipo);
           END IF;                                            
        END IF;
    END LOOP;    
    
END PRINCIPAL;

PROCEDURE ENVIA_CORREO_EDOCTA  (cCodEmpresaGremio     VARCHAR2, 
                                cNombreEmpresa        VARCHAR2, 
                                cCodEsquema           VARCHAR2,
                                cDescEsquema          VARCHAR2,
                                nDias_EstadoCta       NUMBER,
                                nCodCia               NUMBER,
                                nCorreos              VARCHAR2,
                                nTipo                 VARCHAR2) 

IS
    nCodCliente             CLIENTES.CodCliente%TYPE;
    cTipoDocIdentificacion  CLIENTES.Tipo_Doc_Identificacion%TYPE;
    cNumDocIdentificacion   CLIENTES.Num_Doc_Identificacion%TYPE;
    cEmailCliente           REA_CORREO_ALERTAS.Correos%TYPE;
    cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
    dFecIniVig              POLIZAS.FecIniVig%TYPE;
    cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;

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
    cHTMLFooter               VARCHAR2(100)     := '</body></html>';
    cTextoAlignDerecha        VARCHAR2(50)      := '<P align="right">';
    cTextoAlignIzquierda      VARCHAR2(50)      := '<P align="left">';
    cTextoAlignDerechaClose   VARCHAR2(50)      := '</P>';
    cTextoAlignIzquierdaClose VARCHAR2(50)      := '</P>';
    cSaltoLinea               VARCHAR2(5)       := '<br>';
    cTextoImportanteOpen      VARCHAR2(10)      := '<strong>';
    cTextoImportanteClose     VARCHAR2(10)      := '</strong>';
    cTextoRojoOpen            VARCHAR2(100)     := '<FONT COLOR="red">';
    cTextoAmarilloOpen        VARCHAR2(100)     := '<FONT COLOR="#ffbf00">';
    cTextoClose               VARCHAR2(30)      := '</FONT>';
    cTextoSmall               VARCHAR2(100)     := '<FONT SIZE="2" COLOR="blue">';
    cError                    VARCHAR2(200);
    cCadTipo1                 VARCHAR2(30);
    cCadTipo2                 VARCHAR2(30);
BEGIN
   
   SELECT DECODE(nTipo,'ANTES', ' está a ','presenta ') INTO cCadTipo1 FROM DUAL;
   SELECT DECODE(nTipo,'ANTES', ' dia(s) de vencer. ',' día(s) vencidos.') INTO cCadTipo2 FROM DUAL;
   
   --cEmailCliente := 'hgonzalez@thonaseguros.mx;antonio.rubio.pineda@gmail.com';--'nazahel@gmail.com';--OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentificacion, cNumDocIdentificacion); --OC_USUARIOS.EMAIL(nCodCia, USER); --
   cEmailCliente := nCorreos;
   cSubject := 'Aviso vencimiento calendario';
   cMessage := cHTMLHeader||
               cTextoAlignIzquierda||cTextoImportanteOpen||'“Estimado usuario: '||cTextoImportanteClose||cTextoAlignIzquierdaClose
               ||cSaltoLinea||cTextoImportanteOpen||'El reporte del Estado de Cuenta al Reasegurador "'||cCodempresagremio||'" – “'||cNombreempresa
               ||'” correspondiente al Esquema de Reaseguro “'||cCodesquema||'” – “'||cDescesquema||'”,'||cTextoImportanteClose 
               ||cTextoImportanteOpen||cCadTipo1||ABS(nDias_estadocta)||cCadTipo2||cTextoImportanteClose 
               ||cSaltoLinea||cSaltoLinea||cTextoImportanteOpen||'Si ya fue enviado omitir este correo”'||cTextoImportanteClose
               ||cSaltoLinea||UTL_TCP.CRLF                                         ||cSaltoLinea||
               cCadenaLogo                                                         ||cSaltoLinea||
               cSaltoLinea||cTextoSmall||cAvisoImportante||cTextoClose             ||cSaltoLinea||
               cHTMLFooter;
                  
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
   OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,NULL,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);      
                
END ENVIA_CORREO_EDOCTA;  

PROCEDURE ENVIA_CORREO_PAGO  (cCodempresagremio     VARCHAR2, 
                              cNombreempresa        VARCHAR2, 
                              cCodesquema           VARCHAR2,
                              cDescesquema          VARCHAR2,
                              nDias_pago            NUMBER,
                              nCodCia               NUMBER,
                              nCorreos              VARCHAR2,
                              nTipo                 VARCHAR2)

IS
    nCodCliente             CLIENTES.CodCliente%TYPE;
    cTipoDocIdentificacion  CLIENTES.Tipo_Doc_Identificacion%TYPE;
    cNumDocIdentificacion   CLIENTES.Num_Doc_Identificacion%TYPE;
    cEmailCliente           CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
    cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
    dFecIniVig              POLIZAS.FecIniVig%TYPE;
    cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;
    
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
    cHTMLFooter               VARCHAR2(100)     := '</body></html>';
    cTextoAlignDerecha        VARCHAR2(50)      := '<P align="right">';
    cTextoAlignIzquierda      VARCHAR2(50)      := '<P align="left">';
    cTextoAlignDerechaClose   VARCHAR2(50)      := '</P>';
    cTextoAlignIzquierdaClose VARCHAR2(50)      := '</P>';
    cSaltoLinea               VARCHAR2(5)       := '<br>';
    cTextoImportanteOpen      VARCHAR2(10)      := '<strong>';
    cTextoImportanteClose     VARCHAR2(10)      := '</strong>';
    cTextoRojoOpen            VARCHAR2(100)     := '<FONT COLOR="red">';
    cTextoAmarilloOpen        VARCHAR2(100)     := '<FONT COLOR="#ffbf00">';
    cTextoClose               VARCHAR2(30)      := '</FONT>';
    cTextoSmall               VARCHAR2(100)     := '<FONT SIZE="2" COLOR="blue">';
    cError                    VARCHAR2(200);
    cCadTipo1                 VARCHAR2(30);
    cCadTipo2                 VARCHAR2(30);
BEGIN
   
   SELECT DECODE(nTipo,'ANTES', 'está a ','presenta ') INTO cCadTipo1 FROM DUAL;
   SELECT DECODE(nTipo,'ANTES', 'dia(s) de vencer. ',' día(s) vencidos.') INTO cCadTipo2 FROM DUAL;
       
   --cEmailCliente := 'hgonzalez@thonaseguros.mx;nazahel@gmail.com';--'nazahel@gmail.com';--OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentificacion, cNumDocIdentificacion); --OC_USUARIOS.EMAIL(nCodCia, USER); --
   cEmailCliente := nCorreos;
   cSubject := 'Aviso vencimiento calendario';
   cMessage := cHTMLHeader||
               cTextoAlignIzquierda||cTextoImportanteOpen||'“Estimado usuario: '||cTextoImportanteClose||cTextoAlignIzquierdaClose
               ||cSaltoLinea||cTextoImportanteOpen||'El pago al Reasegurador "'||cCodempresagremio||'" – “'||cNombreempresa
               ||'” correspondiente al Esquema de Reaseguro “'||cCodesquema||'” – “'||cDescesquema||'”,'||cTextoImportanteClose 
               --||cSaltoLinea||cTextoImportanteOpen||'está a '||ABS(nDias_pago)||' días de vencer.'||cTextoImportanteClose 
               ||cTextoImportanteOpen||cCadTipo1||ABS(nDias_pago)||cCadTipo2||cTextoImportanteClose                
               ||cSaltoLinea||cSaltoLinea||cTextoImportanteOpen||'Si ya fue enviado omitir este correo”'||cTextoImportanteClose
               ||cSaltoLinea||UTL_TCP.CRLF                                         ||cSaltoLinea||
               cCadenaLogo                                                         ||cSaltoLinea||
               cSaltoLinea||cTextoSmall||cAvisoImportante||cTextoClose             ||cSaltoLinea||
               cHTMLFooter;
                  
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
   OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,cEmailCliente,NULL,NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);      
                
END ENVIA_CORREO_PAGO;                
                
END GT_REA_ALERTA_VENCIMIENTO;
/

GRANT EXECUTE ON SICAS_OC.GT_REA_ALERTA_VENCIMIENTO TO PUBLIC
/

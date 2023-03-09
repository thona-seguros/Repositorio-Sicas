CREATE OR REPLACE PROCEDURE ENVIA_CORREO_REPORTE_PLD(PORIGEN       IN VARCHAR2,
                                                     PIDSINIESTRO  IN NUMBER,
                                                     PIDPOLIZA     IN NUMBER,
                                                     PCODASEGURADO IN NUMBER,
                                                     PORIGEN_PLD   IN VARCHAR2,
                                                     PNUM_BENEF    IN NUMBER,
                                                     cErrorEnvio   OUT VARCHAR2
                                                    ) IS
--
--  PLD ALERTAS      20/01/2023  JICO
--
cEmail                       USUARIOS.EMAIL%TYPE;
cPwdEmail                    VARCHAR2(100);
cMiMail                      USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
cSaltoLinea                  VARCHAR2(5)      := '<br>';
cHTMLHeader                  VARCHAR2(2000)   := '<html>'                                                                     ||cSaltoLinea||
                                                 '<head>'                                                                     ||cSaltoLinea||
                                                 '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
                                                 '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>'       ||cSaltoLinea||
                                                 '</head><body>'                                                              ||cSaltoLinea;
cHTMLFooter                 VARCHAR2(100)    := '</body></html>';
cTextoAlignDerecha          VARCHAR2(50)     := '<P align="CENTER">';
cTextoAlignDerechaClose     VARCHAR2(50)     := '</P>';
cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
cTextoImagen_alterna        VARCHAR2(100)    := '<img src="D:/sicas/OficialdeCumplimiento.jpg" alt="imagen">';
cTextoImagen                VARCHAR2(100);
cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
cError                      VARCHAR2(1000);
nDummy                      VARCHAR2(200);
nLeidos                     NUMBER := 0;
cSubject                    VARCHAR2(500);
cTexto1                     VARCHAR2(500);
cTexto2                     VARCHAR2(500);
cTexto3                     VARCHAR2(500);
cTexto4                     VARCHAR2(500);
cTexto5                     VARCHAR2(500);
cTexto6                     VARCHAR2(500);
cTexto7                     VARCHAR2(500);
cTexto8                     VARCHAR2(500);
cTexto9                     VARCHAR2(500);
cTexto10                    VARCHAR2(500);
cTexto11                    VARCHAR2(500);
cTexto12                    VARCHAR2(500);
cTexto14                    VARCHAR2(500);
cTexto15                    VARCHAR2(500);
cTextoEnvio                 VARCHAR2(1000);
cURL                        VARCHAR2(500);
cEmails                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cCtasEmail                  PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO%TYPE;
nDummy                      VARCHAR2(200);
--
CNOMUSUARIO        USUARIOS.NOMUSUARIO%TYPE;
CSINI_POLI         NUMBER(14);
CNOM_ORIGEN_PLD    VALORES_DE_LISTAS.DESCVALLST%TYPE;
--
CURSOR cCuentas is
  SELECT *
    FROM VALORES_DE_LISTAS 
   WHERE CODLISTA = 'EMAILOPPRE'
     AND CODVALOR = 'OFICIA';
	
BEGIN
  --
  cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
  cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
  --
  -- SE OBTIENE LOS DATOS DE USUARIO
  --
--DBMS_OUTPUT.put_line('PORIGEN -> '||PORIGEN);
--DBMS_OUTPUT.put_line('PIDSINIESTRO -> '||PIDSINIESTRO);
--DBMS_OUTPUT.put_line('PIDPOLIZA -> '||PIDPOLIZA);
--DBMS_OUTPUT.put_line('PCODASEGURADO -> '||PCODASEGURADO);
--DBMS_OUTPUT.put_line('PORIGEN_PLD -> '||PORIGEN_PLD);
--DBMS_OUTPUT.put_line('PNUM_BENEF -> '||PNUM_BENEF);
  BEGIN
    SELECT U.NOMUSUARIO,
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CATORIGE',PORIGEN_PLD) 
      INTO CNOMUSUARIO,
           CNOM_ORIGEN_PLD
      FROM USUARIOS U
     WHERE U.CODUSUARIO = USER;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         CNOMUSUARIO := '';
    WHEN OTHERS THEN
         CNOMUSUARIO := '';
  END;
  --
  cTextoImagen := CNOMUSUARIO;    
  --
  -- SE URL DE SICAS
  --
  BEGIN
    SELECT P.DESCRIPCION
      INTO cURL
      FROM PARAMETROS_GLOBALES P
     WHERE P.CODIGO = 'URL';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         cURL := '';
    WHEN OTHERS THEN
         cURL := '';
  END;
  --
  -- SE OBTIENEN LAS CUENTAS DE CORREO
  --
  BEGIN
		FOR I IN cCuentas LOOP
	    cCtasEmail	:= I.DESCVALLST||';';
	  END LOOP;     
  END; 
  --
  IF PORIGEN = 'SINIESTRO' THEN
     --
     CSINI_POLI := PIDSINIESTRO;
     --
     -- SE OBTIENE DATOS DE SINIESTRO
     --
     BEGIN
      SELECT 'Nro. Poliza       :  '||P.NUMPOLUNICO,
             'Nro. Poliza Consecutivo :  '||TO_CHAR(P.IDPOLIZA),
             'Nro. Siniestro    :  '||TO_CHAR(S.IDSINIESTRO),
             'Asegurado         :  '||SUBSTR(OC_ASEGURADO.NOMBRE_ASEGURADO(S.CODCIA,S.CODEMPRESA,S.COD_ASEGURADO),1,200),
             'RFC Asegurado     :  '||OC_ASEGURADO.IDENTIFICACION_TRIBUTARIA_ASEG(S.CODCIA,S.CODEMPRESA,S.COD_ASEGURADO),
             'Nro. Asegurado    :  '||TO_CHAR(S.COD_ASEGURADO),
             'Nro. Beneficiario :  '||TO_CHAR(BS.BENEF),
             'Beneficiario      :  '||SUBSTR((BS.NOMBRE||' '||BS.APELLIDO_PATERNO||' '||BS.APELLIDO_MATERNO),1,200),
             'RFC Beneficiario  :  '||BS.NUM_DOC_TRIBUTARIO
        INTO cTexto4,
             cTexto5,
             cTexto6,
             cTexto7,
             cTexto8,
             cTexto9,
             cTexto10,
             cTexto11,
             cTexto12
        FROM SINIESTRO S,
             POLIZAS P,
             ASEGURADO A,
             BENEF_SIN BS
       WHERE S.IDSINIESTRO = PIDSINIESTRO
         --
         AND P.IDPOLIZA = S.IDPOLIZA
         --
         AND A.COD_ASEGURADO = S.COD_ASEGURADO
         --
         AND BS.IDSINIESTRO = S.IDSINIESTRO
         AND BS.BENEF       = PNUM_BENEF;         
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            CNOMUSUARIO := '';
       WHEN OTHERS THEN
            CNOMUSUARIO := '';
     END;
     --
  ELSIF PORIGEN = 'EMISION' THEN
     --
     CSINI_POLI := PIDPOLIZA;
     --  
     -- SE OBTIENE DATOS DE POLIZA
     --
     BEGIN
      SELECT 'Nro. Poliza       :  '||P.NUMPOLUNICO,
             'Nro. Poliza Consecutivo :  '||TO_CHAR(P.IDPOLIZA),
             'Contratante       :  '||OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE),
             '',
             '',
             '',
             '',
             '',
             ''
        INTO cTexto4,
             cTexto5,
             cTexto6,
             cTexto7,
             cTexto8,
             cTexto9,
             cTexto10,
             cTexto11,
             cTexto12
        FROM POLIZAS P
       WHERE P.IDPOLIZA = PIDPOLIZA;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            CNOMUSUARIO := '';
       WHEN OTHERS THEN
            CNOMUSUARIO := '';
     END;
     --
     --  
     -- SE OBTIENE DATOS DE ASEGURADO
     --
     BEGIN
      SELECT 'Asegurado         :  '||SUBSTR(OC_ASEGURADO.NOMBRE_ASEGURADO(A.CODCIA,A.CODEMPRESA,A.COD_ASEGURADO),1,200),
             'RFC Asegurado     :  '||OC_ASEGURADO.IDENTIFICACION_TRIBUTARIA_ASEG(A.CODCIA,A.CODEMPRESA,A.COD_ASEGURADO),
             'Nro. Asegurado    :  '||TO_CHAR(A.COD_ASEGURADO)
        INTO cTexto7,
             cTexto8,
             cTexto9
        FROM ASEGURADO A
       WHERE A.COD_ASEGURADO = PCODASEGURADO;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            CNOMUSUARIO := '';
       WHEN OTHERS THEN
            CNOMUSUARIO := '';
     END;
     --
  END IF;
  --  
  cSubject := 'Movimiento de '||PORIGEN||' esta detenido por Reglas de coincidencia PLD';
  --
  cTexto1  := 'Estimado Oficial de Cumplimiento: ';
  cTexto2  := 'Se ha identificado una coincidencia de origen '||CNOM_ORIGEN_PLD||' favor de autorizar la continuidad del proceso o validar si es un caso de riesgo.';
  cTexto3  := '';
  cTexto15  := 'Atentamente.';
  --
  cTextoEnvio := cHTMLHeader||
                 cTexto1||cSaltoLinea||cSaltoLinea||
                 cTexto2||cSaltoLinea||
                 cTexto3||cSaltoLinea||
                 cTexto4||cSaltoLinea||
                 cTexto5||cSaltoLinea||
                 cTexto6||cSaltoLinea||
                 cTexto7||cSaltoLinea||
                 cTexto8||cSaltoLinea||
                 cTexto9||cSaltoLinea||
                 cTexto10||cSaltoLinea||
                 cTexto11||cSaltoLinea||
                 cTexto12||cSaltoLinea||cSaltoLinea||
                 cURL||cSaltoLinea||cSaltoLinea||
                 cTexto15||cSaltoLinea||
                 cTextoImagen||cSaltoLinea||
                 cHTMLFooter;   
  --
  OC_MAIL.INIT_PARAM;
  OC_MAIL.cCtaEnvio    := cEmail;
  OC_MAIL.cPwdCtaEnvio := cPwdEmail;
  --
  -- ENVIO DE CORREO
  --
  BEGIN 
    cErrorEnvio := 0;
    OC_MAIL.SEND_EMAIL(
        NULL,        --P_DIRECTORY
        cMiMail    , --P_SENDER
        cCtasEmail,  --P_RECIPIENT
        NULL,        --P_CC
        NULL,        --BCC
        cSubject,    --P_SUBJECT
        cTextoEnvio, --P_BODY
        NULL,        --P_ATTACHMENT1
        NULL,        --P_ATTACHMENT2
        NULL,        --P_ATTACHMENT3
        NULL,        --P_ATTACHMENT4
        cErrorEnvio  --P_ERROR
       );
  EXCEPTION WHEN OTHERS THEN
    cErrorEnvio       := 'ERROR EN EL ENVIO DE LA DENUNCIA '||PORIGEN||'-'||CSINI_POLI||'-'||CNOM_ORIGEN_PLD||SQLERRM;
    DBMS_OUTPUT.PUT_LINE('ERROR EN EL ENVIO DE LA DENUNCIA '||PORIGEN||'-'||CSINI_POLI||'-'||CNOM_ORIGEN_PLD||SQLERRM);              
  END;
  --
END ENVIA_CORREO_REPORTE_PLD;
/

CREATE OR REPLACE PUBLIC SYNONYM ENVIA_CORREO_REPORTE_PLD FOR SICAS_OC.ENVIA_CORREO_REPORTE_PLD
;

GRANT EXECUTE ON SICAS_OC.ENVIA_CORREO_REPORTE_PLD TO PUBLIC
;

/
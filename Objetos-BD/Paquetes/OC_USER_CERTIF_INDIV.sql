CREATE OR REPLACE PACKAGE OC_USER_CERTIF_INDIV AS
FUNCTION  NUMERO_USUARIO(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;
PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdUsuario NUMBER, nCodAsegurado NUMBER, 
                   cPassword VARCHAR2, cEmail VARCHAR2, nNoIntento NUMBER, nIdCertCte NUMBER);
PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdUsuario NUMBER);
PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdUsuario NUMBER);
FUNCTION ENCRIPTA_PW( cPasswE VARCHAR2 ) RETURN RAW;    
FUNCTION DESENCRIPTA_PW( cPasswD VARCHAR2 ) RETURN VARCHAR2;
PROCEDURE ENVIAR_CERTIFICADO(nCodCia NUMBER, nCodEmpresa NUMBER, cDirectorio VARCHAR2, cNomArchivo VARCHAR2, 
                             cEmail VARCHAR2, nCodAsegurado NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

FUNCTION EXISTE_USUARIO_CERT(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;
FUNCTION EXISTE_CTE_CERT(nCodCia NUMBER, nCodEmpresa NUMBER, nCodCliente NUMBER) RETURN VARCHAR2;
FUNCTION NUM_INTENTOS_CERT(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN NUMBER;
FUNCTION CREA_PASSW_CERT(cNombre VARCHAR2, cApePaterno    VARCHAR2, cApeMaterno   VARCHAR2, nCodAsegurado   NUMBER) RETURN VARCHAR2;
FUNCTION OBTENER_PASSW_CERT(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;
FUNCTION COMPARA_PASSW_CERT ( nCodCia       NUMBER,
                              nCodEmpresa   NUMBER,
                              --nCodAsegurado NUMBER,
                              cPassword     VARCHAR2) RETURN VARCHAR2;

END OC_USER_CERTIF_INDIV;

/

CREATE OR REPLACE PACKAGE BODY OC_USER_CERTIF_INDIV AS
-- Variables necesarias para la Encriptacion del Password en el BODY.
Crypt_Raw   RAW(2000);
Crypt_Str   VARCHAR(2000);
-- Llave de Encriptacion
key_encrip  VARCHAR(255) := 'ASXRFGTR';

FUNCTION ENCRIPTA_PW( cPasswE VARCHAR2 ) RETURN RAW AS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 04/02/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : ENCRIPTA_PW																										|
    | Objetivo   : Funcion que Encripta el Password del Asegurado para Usuarios con Servicio de Impresion de Certificados			|
	|			   Individuales mediante Plataforma Digital.																		|
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
	|           cPasswE     Paswword a Encriptar del Asegurado de Certificados Individuales	        (Entrada)                       | 
    |_______________________________________________________________________________________________________________________________|	
*/ 
      Largo     INTEGER := LENGTH(cPasswE);
      I         INTEGER;
      candado   RAW(2000);
      cle       RAW(8)  := UTL_RAW.CAST_TO_RAW(key_encrip);
     BEGIN
      I := 8-MOD(Largo,8);
      candado := UTL_RAW.CAST_TO_RAW(cPasswE||RPAD(CHR(I),I,CHR(I)));
      DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT( INPUT           => candado,
                                           KEY            => cle,
                                           ENCRYPTED_DATA => Crypt_Raw
                                           );
      RETURN Crypt_Raw ;
   END;


   FUNCTION DESENCRIPTA_PW( cPasswD VARCHAR2 ) RETURN VARCHAR2 AS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 04/02/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : ENCRIPTA_PW																										|
    | Objetivo   : Funcion que Desencripta el Password del Asegurado para Usuarios con Servicio de Impresion de Certificados		|
	|			   Individuales mediante Plataforma Digital.																		|
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
	|           cPasswD     Paswword a Desencriptar del Asegurado de Certificados Individuales	        (Entrada)                   | 
    |_______________________________________________________________________________________________________________________________|	
*/    
   Largo		NUMBER;
   Cle        	RAW(8)    := UTL_RAW.CAST_TO_RAW(key_encrip);
   Crypt_Raw  	RAW(2000) := UTL_RAW.CAST_TO_RAW(UTL_RAW.CAST_TO_VARCHAR2( cPasswD)) ;
   BEGIN
      DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT( INPUT          => cPasswD,
                                           KEY            => cle,
                                           DECRYPTED_DATA => Crypt_Raw 
                                           );
      Crypt_Str := UTL_RAW.CAST_TO_VARCHAR2(Crypt_Raw);
      Largo := LENGTH(Crypt_Str);
      Crypt_Str := RPAD(Crypt_Str, Largo-ASCII(SUBSTR(Crypt_Str, Largo)));
      RETURN Crypt_Str;
   END;

FUNCTION  NUMERO_USUARIO(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
nIdUsuario  USER_CERTIF_INDIV.IdUsuario%TYPE;
BEGIN
   SELECT USER_CERTIF_INDIV_SEQ.NEXTVAL
     INTO nIdUsuario
     FROM DUAL;

   RETURN nIdUsuario;
END NUMERO_USUARIO;

PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdUsuario NUMBER, nCodAsegurado NUMBER, 
                   cPassword VARCHAR2, cEmail VARCHAR2, nNoIntento NUMBER, nIdCertCte NUMBER) IS
BEGIN
   INSERT INTO USER_CERTIF_INDIV (IdUsuario, CodCia, CodEmpresa, CodAsegurado, Password,
                                  Email, NoIntento, StsUser, IdCertCte, FecRegistro, 
                                  UserRegistro, FecUltActualiza, UserUltActualiza) 
                          VALUES (nIdUsuario, nCodCia, nCodEmpresa, nCodAsegurado, cPassword,
                                  cEmail, nNoIntento, 'SOL', nIdCertCte, SYSDATE,
                                  USER, SYSDATE, USER);
END INSERTAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdUsuario NUMBER) IS
BEGIN
   UPDATE USER_CERTIF_INDIV 
      SET StsUser          = 'ACT',
          FecUltActualiza  = SYSDATE,
          UserUltActualiza = USER
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa 
      AND IdUsuario  = nIdUsuario ;
END ACTIVAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdUsuario NUMBER) IS
BEGIN
   UPDATE USER_CERTIF_INDIV 
      SET StsUser          = 'SUS',
          FecUltActualiza  = SYSDATE,
          UserUltActualiza = USER
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa 
      AND IdUsuario  = nIdUsuario ;
END SUSPENDER;

PROCEDURE ENVIAR_CERTIFICADO(nCodCia NUMBER, nCodEmpresa NUMBER, cDirectorio VARCHAR2, cNomArchivo VARCHAR2, 
                             cEmail VARCHAR2, nCodAsegurado NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
cEmailCC                USUARIOS.Email%TYPE;
cEmailAuth              VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');--OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
cPwdEmail               VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');--OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'043');
cEmailEnvio             VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
cError                  VARCHAR2(3000);
cSubject                VARCHAR2(1000);
cMessage                VARCHAR2(3000);
cHTMLHeader             VARCHAR2(2000) := '<html><head><meta http-equiv="Content-Language" content="en-us" />'             ||CHR(13)||
                                             '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />'||CHR(13)||
                                             '</head><body>'                                                               ||CHR(13);
cHTMLFooter             VARCHAR2(100)  := '</body></html>';
cSaltoLinea             VARCHAR2(5)    := '<br>';
cTextoImportanteOpen    VARCHAR2(10)   := '<strong>';
cTextoImportanteClose   VARCHAR2(10)   := '</strong>';
BEGIN
   cEmailCC := OC_USUARIOS.EMAIL(nCodCia,USER);
   cSubject := 'Certificado Individual '||OC_ASEGURADO.NOMBRE_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado);
   cMessage := cHTMLHeader                                                                                                                                                             ||
                'Estimado(a): '||OC_ASEGURADO.NOMBRE_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado)||cSaltoLinea||cSaltoLinea                                                          ||
                '    '||cTextoImportanteOpen||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cTextoImportanteClose||' Le hace llegar su certificado Individual de la póliza '||OC_POLIZAS.NUMERO_UNICO(nCodCia, nIdPoliza)||' '||
                'Número Consecutivo '||nIdPoliza||' para el Sub Grupo '||nIDetPol||' y Número de Asegurado '||nCodAsegurado||'.'||cSaltoLinea||cSaltoLinea                             ||
                cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||cSaltoLinea||cSaltoLinea                   ||
                OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cSaltoLinea                                                                                                                                                                                   ||
                ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '||cSaltoLinea||cHTMLFooter;

   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;

   OC_MAIL.SEND_EMAIL(cDirectorio,cEmailEnvio,TRIM(cEmail),TRIM(cEmailCC),NULL,cSubject,cMessage,cNomArchivo,NULL,NULL,NULL,cError);
END ENVIAR_CERTIFICADO;

FUNCTION EXISTE_USUARIO_CERT (nCodCia   NUMBER, nCodEmpresa NUMBER, nCodAsegurado   NUMBER) RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : EXISTE_USUARIO_CERT                                                                                              |
    | Objetivo   : Funcion que valida la existencia del Usuario del Asegurado en la tabla USER_CERTIF_INDIV de Usuarios declientes  |
    |              con servicio de impresion de Certificados Individuales mediante Plataforma Digital. Devuelve "S" cuando          |
    |              si existe y "N" cuando no es asi.                                                                                |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
	|           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodAsegurado           Codigo del Asegurado            (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|	
*/  
cExiste    VARCHAR2(1);
 BEGIN
    BEGIN
         SELECT 'S'
         INTO   cExiste
         FROM   USER_CERTIF_INDIV
         WHERE  CodAsegurado = nCodAsegurado
         AND    CodCia       = nCodCia
         AND    CodEmpresa   = nCodEmpresa;
    EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
    END;

    RETURN cExiste;    
END EXISTE_USUARIO_CERT;

FUNCTION EXISTE_CTE_CERT (nCodCia    NUMBER, nCodEmpresa NUMBER, nCodCliente   NUMBER) RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : EXISTE_CTE_CERT                                                                                                  |
    | Objetivo   : Funcion que valida la existencia del Cliente del que forma parte el Asegurado en la tabla CTES_CERTIF_INDIV de   |
    |              clientes con servicio de impresion de Certificados Individuales mediante Plataforma Digital. Devuelve "S" cuando |
    |              si existe y "N" cuando no es asi.                                                                                |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
	|           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodAsegurado           Codigo del Asegurado            (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|	
*/  
cExiste    VARCHAR2(1);
 BEGIN
    BEGIN
         SELECT 'S'
         INTO   cExiste
         FROM   CTES_CERTIF_INDIV
         WHERE  CodCliente  = nCodCliente
         AND    CodCia      = nCodCia
         AND    CodEmpresa  = nCodEmpresa;
    EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
    END;

    RETURN cExiste;    
END EXISTE_CTE_CERT;

FUNCTION NUM_INTENTOS_CERT (nCodCia    NUMBER, nCodEmpresa NUMBER, nCodAsegurado   NUMBER) RETURN NUMBER IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : NUM_INTENTOS_CERT                                                                                                |
    | Objetivo   : Funcion que valida de intentos de recuperacion de contraseña del Aseguradoen con servicio de impresion de        |
    |              Certificados Individuales mediante Plataforma Digital. Devuelve un numero.                                       |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
	|           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodAsegurado           Codigo del Asegurado            (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|	
*/ 
nIntento    NUMBER;
 BEGIN
    BEGIN
         SELECT NoIntento
         INTO   nIntento
         FROM   USER_CERTIF_INDIV
         WHERE  CodAsegurado = nCodAsegurado
         AND    CodCia       = nCodCia
         AND    CodEmpresa   = nCodEmpresa;
    EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            nIntento := 0;
    END;

    RETURN nIntento;	
END NUM_INTENTOS_CERT;

FUNCTION CREA_PASSW_CERT (cNombre VARCHAR2, cApePaterno    VARCHAR2, cApeMaterno   VARCHAR2, nCodAsegurado   NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : CREA_PASSW_CERT                                                                                                  |
    | Objetivo   : Funcion que genera una contraseña para el Aseguradoen habilitado con servicio de impresion de Certificados       |
    |              Individuales mediante Plataforma Digital. El password se compone por 1ra. letra de cada nombre y las dos         |
    |              primeras letras de cada apellido seguido por subguion y el Codigo de asegurado. Devuelve una cadena.             |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 09/02/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle  JALV ()                                                                                  |
    | Obj. Modif.: Se cambio el algoritmo de generacion de la contraseña: 1ra. letras SOLO del primer nombre y de cada apellido     |
    |              seguido por guion medio y el Codigo de asegurado.                                                                |
    | Parametros:                                                                                                                   |
	|           cNombre                 Nombre completo del asegurado       (Entrada)                                               |
    |           cApePaterno             Apellido Paternoo del asegurado     (Entrada)                                               |
    |           cApePaterno             Apellido Maternoo del asegurado     (Entrada)                                               |
    |           nCodAsegurado           Codigo del Asegurado                (Entrada)                                               |
    |_______________________________________________________________________________________________________________________________|	
*/ 
cPassw          VARCHAR2(50);
BEGIN
    SELECT  SUBSTR(UPPER(TRIM(cNombre)),0,1)||
            /* Inicia JALV (-) 09/02/2021
            SUBSTR(UPPER(TRIM(cNombre)),INSTR(TRIM(cNombre),' ',1,1)+1,DECODE(INSTR(TRIM(cNombre), ' ', 1, 1),0,0,1))||
            SUBSTR(UPPER(TRIM(cNombre)),INSTR(TRIM(cNombre),' ',1,2)+1,DECODE(INSTR(TRIM(cNombre), ' ', 1, 2),0,0,1))||
            SUBSTR(UPPER(TRIM(cNombre)),INSTR(TRIM(cNombre),' ',1,3)+1,DECODE(INSTR(TRIM(cNombre), ' ', 1, 3),0,0,1))||
            SUBSTR(UPPER(TRIM(cNombre)),INSTR(TRIM(cNombre),' ',1,4)+1,DECODE(INSTR(TRIM(cNombre), ' ', 1, 4),0,0,1))||
            SUBSTR(UPPER(TRIM(cNombre)),INSTR(TRIM(cNombre),' ',1,5)+1,DECODE(INSTR(TRIM(cNombre), ' ', 1, 5),0,0,1))||
            SUBSTR(UPPER(cApePaterno),1,2)||SUBSTR(UPPER(cApeMaterno),1,2)||'_'||nCodAsegurado                        
            */
            SUBSTR(UPPER(cApePaterno),1,1)||SUBSTR(UPPER(cApeMaterno),1,1)||'-'||nCodAsegurado  --> Fin JALV (-) 09/02/2021
    INTO    cPassw
    FROM    DUAL;

    RETURN cPassw;
END CREA_PASSW_CERT;

FUNCTION OBTENER_PASSW_CERT (nCodCia    NUMBER, nCodEmpresa NUMBER, nCodAsegurado   NUMBER) RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : OBTENER_PASSW_CERT                                                                                               |
    | Objetivo   : Funcion que recupera la contraseña registrada en sistema del Aseguradoen habilitado con servicio de impresion    |
    |              de Certificados Individuales mediante Plataforma Digital. Devuelve una cadena.                                   |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
	|           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodAsegurado           Codigo del Asegurado            (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|	
*/ 
cPassword    VARCHAR2(2000);
nNoIntento   VARCHAR2(1);
 BEGIN
    BEGIN
             SELECT Password
             INTO   cPassword
             FROM   USER_CERTIF_INDIV
             WHERE  CodAsegurado = nCodAsegurado
             AND    CodCia       = nCodCia
             AND    CodEmpresa   = nCodEmpresa;
        EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                cPassword := 'Password_No_existe';
    END;

    RETURN cPassword;    
END OBTENER_PASSW_CERT;

FUNCTION COMPARA_PASSW_CERT ( nCodCia       NUMBER,
                              nCodEmpresa   NUMBER,
                              --nCodAsegurado NUMBER,
                              cPassword     VARCHAR2)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : COMPARA_PASSW_CERT                                                                                               |
    | Objetivo   : Funcion que compara la contraseña recibida contra la registrada en sistema del Asegurado con servicio de         |
    |              impresion de Certificados Individuales mediante Plataforma Digital. Devuelve "S" cuando hay coincidencia y "N"   |
    |              cuando no la hay.                                                                                                |               
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    | Parametros:                                                                                                                   |
	|           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodAsegurado           Codigo del Asegurado            (Entrada)                                                   |
    |           cPassword               Contraseña a comparar           (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|	
*/ 
cPasswS         VARCHAR2(50);
cCoincide       VARCHAR2(1);
nCodAsegurado   ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
BEGIN    
    nCodAsegurado := SUBSTR(cPassword,(INSTR(cPassword, '-',1)+1),20);
    SELECT  OC_USER_CERTIF_INDIV.DESENCRIPTA_PW( OC_USER_CERTIF_INDIV.OBTENER_PASSW_CERT(nCodCia, nCodEmpresa, nCodAsegurado) )
    INTO    cPasswS
    FROM    DUAL;

    IF cPassword = cPasswS THEN
        cCoincide := 'S';
    ELSE
        cCoincide := 'N';
    END IF;

    RETURN cCoincide;
END COMPARA_PASSW_CERT;

END OC_USER_CERTIF_INDIV;

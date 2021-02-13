CREATE OR REPLACE PACKAGE OC_ASEGURADO_SERVICIOS_WEB AS

FUNCTION VALIDA_ASEG_UNAM(  nCodCia         NUMBER,
                            nCodEmpresa     NUMBER,
                            cNombre         VARCHAR2,   --> JALV (+) 05/02/2021 
                            cApePaterno     VARCHAR2,   --> JALV (+) 05/02/2021
                            cApeMaterno     VARCHAR2,   --> JALV (+) 05/02/2021
                            dFecNac         VARCHAR2,   --> JALV (+) 05/02/2021
                            cEmail          VARCHAR2,   --> JALV (+) 05/02/2021
                             --, cCodAsegurado VARCHAR2 --> JALV (-) 05/02/2021
                             --, cNutra        VARCHAR2 --> JALV (-) 05/02/2021
                            cCodAgrupador VARCHAR2
                            --OUT XML DE POLIZAS 
                             ) RETURN VARCHAR2;

FUNCTION POLIZAS_ASEGURADO_UNAM   (  nCodCia       NUMBER
								  , nCodEmpresa   NUMBER
								  , nCodAsegurado NUMBER
								  , cCodAgrupador VARCHAR2) RETURN XMLTYPE;    

FUNCTION CONSULTA_POLIZA_UNAM ( nCodCia         NUMBER,	
                                nCodEmpresa     NUMBER,
                                --nCodAsegurado   NUMBER,
                                cCodAgrupador   VARCHAR2,
                                cPassword       VARCHAR2)
RETURN XMLTYPE;

END OC_ASEGURADO_SERVICIOS_WEB;
/
CREATE OR REPLACE PACKAGE BODY OC_ASEGURADO_SERVICIOS_WEB AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/01/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : OC_ASEGURADOS_SERVICIOS_WEB                                                                                      |
    | Objetivo   : Package obtiene informacion de los Asegurados que cumplen con los criterios dados en los Servicios WEB de la     |
    |              Plataforma Digital, los resultados son generados en formato XML.                                                 |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION VALIDA_ASEG_UNAM(  nCodCia         NUMBER,
                            nCodEmpresa     NUMBER,
                            cNombre         VARCHAR2,   --> JALV (+) 05/02/2021 
                            cApePaterno     VARCHAR2,   --> JALV (+) 05/02/2021
                            cApeMaterno     VARCHAR2,   --> JALV (+) 05/02/2021
                            dFecNac         VARCHAR2,   --> JALV (+) 05/02/2021
                            cEmail          VARCHAR2,   --> JALV (+) 05/02/2021
                            --, cCodAsegurado VARCHAR2  --> JALV (-) 05/02/2021
                            --, cNutra        VARCHAR2  --> JALV (-) 05/02/2021
                            cCodAgrupador VARCHAR2
                            --OUT XML DE POLIZAS 
                             ) RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : ?                                                                                                                |
    | Para       : ?                                                                                                                |
    | Fecha Elab.: ?                                                                                                                |
    | Email		 : ?                                                                                                                |
    | Nombre     : VALIDA_ASEG_UNAM                                                                                                 |
    | Objetivo   : Funcion que valida la existencia del Asegurado UNAM.                                                             |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 05/02/2021                                                                                                       |
    | Modifico	 : J. Alberto Lopez Valle                                                                                           |
    | Obj. Modif.: Se cambio funcionalidad por completo. Verifica que exista una Poliza asociada, Si existe o no su contraseña de   |
    |              Usuario si no es asi la genera,encripta e inserta el usuario. Verifica tambien si el cliente existe en el        |
    |              servicio de impresion de certificados individuales si no es asi lo agrega. Restringe el numero de intentos para  |
    |              determinar si puede o no hacerlo directamente en Plataforma Digital o con ejecutivo. Devuelve el Password.       |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nodCia                  Codigo de Compañia                  (Entrada)                                               |        
    |           nCodEmpresa             Codigo de Empresa                   (Entrada)                                               |
    |			cNombre		            Nombre del Asegurado	            (Entrada)                                               |
    |			cApePaterno		        Apellido Paterno del Asegurado      (Entrada)                                               |
    |			cApeMaterno		        Apellido Materno del Asegurado      (Entrada)                                               |
    |			dFecNac		            Fecha de Nacimiento del Asegurado   (Entrada)                                               |
    |			cEmail		            Correo electronico del Asegurado    (Entrada)                                               |
    |			cCodAgrupador		    Codigo del Agrupador		        (Entrada)                                               |
    |_______________________________________________________________________________________________________________________________|
*/                             
   --cExiste        VARCHAR2(1);                                --> JALV (-) 05/02/2021
   --cPrefijo       VARCHAR2(3);                                --> JALV (-) 05/02/2021
   --cCampo3        ASEGURADO_CERTIFICADO.Campo3%TYPE;          --> JALV (-) 05/02/2021
   nCodAsegurado    ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
   nCodCliente      POLIZAS.CodCliente%TYPE;                    --> Inicia agregar variables: JALV 05/02/2021
   nIntento         USER_CERTIF_INDIV.NoIntento%TYPE;   
   cPassword        USER_CERTIF_INDIV.password%TYPE;
   nIdCertCte       CTES_CERTIF_INDIV.IdCertCte%TYPE;   
   cStsCliente      CLIENTES.StsCliente%TYPE;
   nIdPoliza        POLIZAS.IdPoliza%TYPE;
   cPasswE          VARCHAR2(100);
   cResultado       VARCHAR2(2000);
   cExisteUsr       VARCHAR2(1);
   cExisteCte       VARCHAR2(1);                                --> Fin agregar variables: JALV 05/02/2021
BEGIN
      --cPrefijo := SUBSTR(cCodAsegurado,1,3);
      --nCodAsegurado := TO_NUMBER(SUBSTR(cCodAsegurado,5,LENGTH(cCodAsegurado)));

    BEGIN
            --> Este servicio validara que el asegurado existe a partir del nombre, apellidos y fecha de nacimiento,
            SELECT  DISTINCT NVL(A.cod_asegurado,0), P.codcliente, P.idpoliza, C.stscliente
            --INTO cExiste                                                      --> JALV (-) 05/02/2021
            INTO    nCodAsegurado, nCodCliente, nIdPoliza, cStsCliente          --> JALV (+) 05/02/2021
            FROM    PERSONA_NATURAL_JURIDICA    PNJ,                            --> JALV (+) 05/02/2021
                    ASEGURADO                   A,                              --> JALV (+) 05/02/2021
                    ASEGURADO_CERTIFICADO       AC,
                    POLIZAS                     P,
                    DETALLE_POLIZA              DP,
                    CLIENTES                    C                               --> JALV (+) 05/02/2021
            WHERE   A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion   --> JALV (+) 05/02/2021
            AND     A.num_doc_identificacion    = PNJ.num_doc_identificacion    --> JALV (+) 05/02/2021
            AND     C.codcliente                = P.codcliente                  --> JALV (+) 05/02/2021
            AND     A.Cod_Asegurado             = AC.Cod_Asegurado              --> JALV (+) 05/02/2021
            AND     A.codcia                    = P.codcia                      --> JALV (+) 05/02/2021
            AND     A.CodEmpresa                = P.CodEmpresa                  --> JALV (+) 05/02/2021
            AND     AC.idpoliza                 = P.idpoliza                    --> JALV (+) 05/02/2021
            AND     AC.codcia                   = P.codcia                      --> JALV (+) 05/02/2021
            AND     AC.CodCia                   = DP.CodCia
            AND     AC.IdPoliza                 = DP.IdPoliza
            AND     AC.IDetPol                  = DP.IDetPol
            AND     P.idpoliza                  = DP.idpoliza
            AND     P.CodCia                    = DP.CodCia
            AND     P.CodEmpresa                = DP.CodEmpresa
            AND     UPPER(PNJ.nombre)           LIKE UPPER(cNombre) --)= NVL(UPPER(cNombre),UPPER(PNJ.nombre))    --> JALV (+) 05/02/2021
            AND     UPPER(PNJ.apellido_paterno) = UPPER(cApePaterno)            --> JALV (+) 05/02/2021
            AND     UPPER(PNJ.apellido_materno) = UPPER(cApeMaterno)            --> JALV (+) 05/02/2021
            AND     PNJ.fecnacimiento           = TO_DATE(dFecNac,'DD/MM/YYYY')--TO_DATE(dFecNac,'DD/MM/YY')   --> JALV (+) 05/02/2021           
            AND     P.CodAgrupador              = cCodAgrupador
            AND     AC.Estado                   = 'EMI'                         --> JALV (+) 05/02/2021
            AND     A.CodCia                    = nCodCia                       --> JALV (+) 05/02/2021
            AND     A.CodEmpresa                = nCodEmpresa;                  --> JALV (+) 05/02/2021
            --AND A.Cod_Asegurado  = nCodAsegurado                              --> JALV (-) 05/02/2021

            nIntento := OC_USER_CERTIF_INDIV.NUM_INTENTOS_CERT(nCodCia, nCodEmpresa, nCodAsegurado);
            --DBMS_OUTPUT.PUT_LINE('Si Existe el Asegurado '||nCodAsegurado||' en Poliza de Cliente y el No. Intentos realizados es: '||nIntento);            

            --DBMS_OUTPUT.PUT_LINE('  Ahora voy a validar que exista en Usuarios: USER_CERTIF_INDIV');
            cExisteUsr := OC_USER_CERTIF_INDIV.EXISTE_USUARIO_CERT(nCodCia, nCodEmpresa, nCodAsegurado);

            --DBMS_OUTPUT.PUT_LINE('  Luego validar si el Cliente '||nCodCliente||' existe en CTES_CERTIF_INDIV');
            cExisteCte:= OC_CTES_CERTIF_INDIV.EXISTE_CTE_CERT(nCodCia, nCodEmpresa, nCodCliente);

            --DBMS_OUTPUT.PUT_LINE('Validar accion segun el numero de intento');                     
            IF nIntento = 0 AND cExisteUsr = 'N' THEN    --> Registrar Password y/o Cliente (NoIntentos = 1)
                --DBMS_OUTPUT.PUT_LINE('Ninguna vez ('||nIntento||'): No Existe el Password ni usuario. Se Genera y Encripta el Password');
                cPasswE   := OC_USER_CERTIF_INDIV.CREA_PASSW_CERT (cNombre, cApePaterno, cApeMaterno, nCodAsegurado);  --> Cambiar Prefijo del Nombre ****
                cPassword := OC_USER_CERTIF_INDIV.ENCRIPTA_PW(cPasswE);    

                IF cExisteCte = 'N' THEN -- NO EXISTE Cliente
                    --DBMS_OUTPUT.PUT_LINE('No existe Cliente en CTES_CERTIF_INDIV, Insertarlo y Activarlo');
                    --DBMS_OUTPUT.PUT_LINE('OC_CTES_CERTIF_INDIV.INSERTAR('||nCodCia||', '||nCodEmpresa||', ctes_certif_indiv_seq.NEXTVAL, '||nCodCliente||')');
                    OC_CTES_CERTIF_INDIV.INSERTAR(nCodCia, nCodEmpresa, ctes_certif_indiv_seq.NEXTVAL, nCodCliente);
                    --DBMS_OUTPUT.PUT_LINE('OC_CTES_CERTIF_INDIV.ACTIVAR('||nCodCia||', '||nCodEmpresa||', ctes_certif_indiv_seq.currval)');
                    OC_CTES_CERTIF_INDIV.ACTIVAR(nCodCia, nCodEmpresa, ctes_certif_indiv_seq.currval);                    
                END IF;                
                --DBMS_OUTPUT.PUT_LINE('Obtener el IdCertCte del Cliente en CTES_CERTIF_INDIV');
                SELECT IdCertCte
                INTO   nIdCertCte
                FROM   CTES_CERTIF_INDIV
                WHERE  CodCliente  = nCodCliente
                AND    CodCia      = nCodCia
                AND    CodEmpresa  = nCodEmpresa;
                --DBMS_OUTPUT.PUT_LINE(' Obtuve el IdCertCte '||nIdCertCte||' de CTES_CERTIF_INDIV, y continuo ...');                                      
                --DBMS_OUTPUT.PUT_LINE('Ahora si ya puedo Insertar Y Activar el Asegurado '||nCodAsegurado||' en tabla USER_CERTIF_INDIV');
                --DBMS_OUTPUT.PUT_LINE('OC_USER_CERTIF_INDIV.INSERTAR('||nCodCia||', '||nCodEmpresa||', user_certif_indiv_seq.NEXTVAL, '||nCodAsegurado||', '||cPassword||', '||cEmail||', '||nIntento||', '||nIdCertCte);
                OC_USER_CERTIF_INDIV.INSERTAR(nCodCia, nCodEmpresa, user_certif_indiv_seq.NEXTVAL, nCodAsegurado, cPassword, cEmail, nIntento, nIdCertCte);                
                --DBMS_OUTPUT.PUT_LINE('OC_USER_CERTIF_INDIV.ACTIVAR('||nCodCia||', '||nCodEmpresa||', user_certif_indiv_seq.CURRVAL)');
                OC_USER_CERTIF_INDIV.ACTIVAR(nCodCia, nCodEmpresa, user_certif_indiv_seq.CURRVAL);

                --DBMS_OUTPUT.PUT_LINE('Finalmente Devolver el password generado');
                cResultado := OC_USER_CERTIF_INDIV.DESENCRIPTA_PW(OC_USER_CERTIF_INDIV.OBTENER_PASSW_CERT(nCodCia, nCodEmpresa, nCodAsegurado));
            ELSIF   nIntento = 1 THEN
                --DBMS_OUTPUT.PUT_LINE('Primera vez ('||nIntento||'): Devolver el pasword ya registrado');
                cResultado := OC_USER_CERTIF_INDIV.DESENCRIPTA_PW(OC_USER_CERTIF_INDIV.OBTENER_PASSW_CERT(nCodCia, nCodEmpresa, nCodAsegurado));
            --ELSIF   nIntento = 2 THEN
                --DBMS_OUTPUT.PUT_LINE('Segunda vez ('||nIntento||'): Devolver el pasword ya registrado');
             --   cResultado := OC_USER_CERTIF_INDIV.OBTENER_PASSW_CERT(nCodCia, nCodEmpresa, nCodAsegurado);
            ELSE
                --DBMS_OUTPUT.PUT_LINE('Tercera ocasion o mas ('||nIntento||')');
                --DBMS_OUTPUT.PUT_LINE('Devolver Mensaje de Numero de intentos excedido');
                cResultado := 'Numero de intentos excedido';
            END IF;

            IF nIntento  != 0 OR cResultado <> 'Password_No_existe' OR cResultado <> 'NO EXISTE el asegurado en Polizas de UNAM' THEN
            --DBMS_OUTPUT.PUT_LINE('Incremento el numero de intentos');              
               UPDATE  USER_CERTIF_INDIV
                SET     Email = cEmail, NoIntento = NoIntento+1
                WHERE   CodAsegurado = nCodAsegurado
                AND     CodCia       = nCodCia
                AND     CodEmpresa   = nCodEmpresa;
                --COMMIT;
            END IF;

      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            --DBMS_OUTPUT.PUT_LINE('No existe, devolver mensaje de asegurado no registrado en polizas UNAM');
            --cExiste := 'N';                                                   --> JALV (-) 05/02/2021
            nCodAsegurado := 0;                                                 --> JALV (-) 05/02/2021
            cResultado := 'NO EXISTE el asegurado en Polizas de UNAM';
    END;
       --DBMS_OUTPUT.PUT_LINE('Valor Final obtenido '||cResultado);    

    RETURN cResultado;    
END VALIDA_ASEG_UNAM;

   FUNCTION POLIZAS_ASEGURADO_UNAM   (  nCodCia       NUMBER
                                      , nCodEmpresa   NUMBER
                                      , nCodAsegurado NUMBER
                                      , cCodAgrupador VARCHAR2) RETURN XMLTYPE IS
   nIdPoliza      POLIZAS.IdPoliza%TYPE;
   nIDetPol       DETALLE_POLIZA.IDetPol%TYPE;
   xAseg          XMLTYPE;
   xPolizas       XMLTYPE;
   xListaPolizas  XMLTYPE;

   CURSOR POL_Q IS
      SELECT P.NumPolUnico, P.IdPoliza, D.IDetPol, 
             P.FecIniVig, P.FecFinVig
        FROM ASEGURADO_CERTIFICADO A, DETALLE_POLIZA D, POLIZAS P
       WHERE A.CodCia         = nCodCia
         AND A.Cod_Asegurado  = nCodAsegurado
         AND P.CodAgrupador   = cCodAgrupador
         AND P.StsPoliza      = 'EMI'
         AND A.CodCia         = D.CodCia
         AND A.IdPoliza       = D.IdPoliza
         AND A.IDetPol        = D.IDetPol
         AND D.CodCia         = P.CodCia
         AND D.CodEmpresa     = P.CodEmpresa
         AND D.IdPoliza       = P.IdPoliza ;
   BEGIN
      SELECT XMLCONCAT(
                  XMLELEMENT("Cod_Asegurado", A.Cod_Asegurado),
                  XMLELEMENT("NombreAsegurado", OC_ASEGURADO.NOMBRE_ASEGURADO(nCodCia, nCodEmpresa, A.Cod_Asegurado))
            )
        INTO xAseg
        FROM ASEGURADO A
       WHERE A.CodCia         = nCodCia
         AND A.Cod_Asegurado  = nCodAsegurado;

      FOR X IN POL_Q LOOP
         nIdPoliza   := X.IdPoliza;
         nIDetPol    := X.IDetPol;
         SELECT XMLCONCAT(XMLELEMENT("POLIZA",
                              XMLELEMENT("NumPolUnico", X.NumPolUnico),
                              XMLELEMENT("IDetPol", X.IDetPol),
                              XMLELEMENT("IdPoliza", X.IdPoliza),
                              XMLELEMENT("FecIniVig", TO_CHAR(X.FecIniVig,'DD/MM/YYYY')),
                              XMLELEMENT("FecFinVig", TO_CHAR(X.FecFinVig,'DD/MM/YYYY'))
                           )
                  )
           INTO xPolizas
           FROM ASEGURADO_CERTIFICADO A, DETALLE_POLIZA D, POLIZAS P
          WHERE A.CodCia         = nCodCia
            AND A.Cod_Asegurado  = nCodAsegurado
            AND D.IdPoliza       = nIdPoliza
            AND D.IDetPol        = nIDetPol
            AND P.CodAgrupador   = cCodAgrupador
            AND P.StsPoliza      = 'EMI'
            AND A.CodCia         = D.CodCia
            AND A.IdPoliza       = D.IdPoliza
            AND A.IDetPol        = D.IDetPol
            AND D.CodCia         = P.CodCia
            AND D.CodEmpresa     = P.CodEmpresa
            AND D.IdPoliza       = P.IdPoliza ;

         SELECT XMLCONCAT(xListaPolizas,xPolizas)
           INTO xListaPolizas
           FROM DUAL;
      END LOOP;

      SELECT XMLELEMENT("DATA",XMLCONCAT(xAseg,xListaPolizas))
        INTO xAseg
        FROM DUAL;

      SELECT XMLROOT(xAseg, VERSION '1.0" encoding="UTF-8')
        INTO xAseg
        FROM DUAL;

      RETURN xAseg;
   END POLIZAS_ASEGURADO_UNAM;

-- Funcion que valida password y devuelve xml
FUNCTION CONSULTA_POLIZA_UNAM ( nCodCia         NUMBER,	
                                nCodEmpresa     NUMBER,
                                --nCodAsegurado   NUMBER,
                                cCodAgrupador   VARCHAR2,
                                cPassword       VARCHAR2)
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CONSULTA_POLIZA_UNAM                                                                                             |
    | Objetivo   : Funcion que verifica el password del Asegurado, si coincide genenera un XML con la Poliza del Asegurado UNAM.    |
    |              Devuelve un XML.                                                                                                 |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico	 : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodAsegurado           Codigo del Asegurado            (Entrada)                                                   |
    |           cCodAgrupador           Codigo del Agrupador            (Entrada)                                                   |
    |           cPassword               Contraseña a validar            (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/
cCoincidePw     VARCHAR2(1);
nCodAsegurado   ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
xCertificado    XMLTYPE;
xPrevArch       XMLTYPE; 
BEGIN    
    nCodAsegurado := SUBSTR(cPassword,(INSTR(cPassword, '-',1)+1),LENGTH(cPassword));
    --cCoincidePw := OC_USER_CERTIF_INDIV.COMPARA_PASSW_CERT ( nCodCia, nCodEmpresa, nCodAsegurado, cPassword);
    cCoincidePw := OC_USER_CERTIF_INDIV.COMPARA_PASSW_CERT ( nCodCia, nCodEmpresa, cPassword);
    IF cCoincidePw = 'S' THEN
        xPrevArch   :=  POLIZAS_ASEGURADO_UNAM (nCodCia, nCodEmpresa, nCodAsegurado, cCodAgrupador);
     /*ELSE
        SELECT XMLELEMENT("DATA",
                            XMLELEMENT("Password NO coincide",1)
                        )
        INTO	xPrevArch
		FROM    DUAL;*/
     END IF;

   SELECT 	XMLROOT(xPrevArch, VERSION '1.0" encoding="UTF-8')
   INTO		xCertificado
   FROM 	DUAL;

   RETURN xCertificado;   
END CONSULTA_POLIZA_UNAM;

END OC_ASEGURADO_SERVICIOS_WEB;
/
CREATE OR REPLACE PUBLIC SYNONYM OC_ASEGURADO_SERVICIOS_WEB FOR SICAS_OC.OC_ASEGURADO_SERVICIOS_WEB;
/
GRANT EXECUTE ON OC_ASEGURADO_SERVICIOS_WEB TO PUBLIC;
/

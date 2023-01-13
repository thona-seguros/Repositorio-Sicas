create or replace PACKAGE SICAS_OC.OC_PERSONA_NATURAL_JURIDICA IS
    --  MODIFICACION
    --  09/05/2016 SE COLOCO FUNCION PARA QUITAR ACENTOS Y PONER EN MAYUSCULAS  -- JICO 
    --  28/01/2021 SE AGREGO LA FUNCION DE EXTRAE FECHA DE REGISTRO             -- JICO
    --  14/04/2021 SE AGREGO LA FUNCION CLAVE_RFC                               -- JICO
    --
    FUNCTION EXISTE_PERSONA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION NOMBRE_PERSONA(nCod_Asegurado NUMBER) RETURN VARCHAR2;

    PROCEDURE INSERTAR_PERSONA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                         cNombre VARCHAR2, cApellidoPat VARCHAR2, cApellidoMat VARCHAR2, cApeCasada VARCHAR2,
                         cSexo VARCHAR2, cEstadoCivil VARCHAR2, dFecNacimiento DATE,
                         cDirecRes VARCHAR2, cNumInterior VARCHAR2, cNumExterior VARCHAR2,
                         cCodPaisRes VARCHAR2, cCodProvRes VARCHAR2, cCodDistRes VARCHAR2, 
                         cCodCorrRes VARCHAR2, cCodPosRes VARCHAR2, cCodColonia VARCHAR2, 
                         cTelRes VARCHAR2, cEmail VARCHAR2, cLadaTelRes VARCHAR2);

    FUNCTION FUNC_VALIDA_EDAD(cTipo_Doc_Identificacion VARCHAR2, nNum_Doc_Identificacion VARCHAR2, nCodCia NUMBER,
                        nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;

    FUNCTION NUMERO_TRIBUTARIO_RFC(cNombresPersona VARCHAR2, cApellido_Paterno VARCHAR2, cApellido_Materno VARCHAR2,
                             dFecNacimiento DATE, cTipoPersona VARCHAR2) RETURN VARCHAR2;

    FUNCTION AUXILIAR_CONTABLE(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION NOMBRE_COMERCIAL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION NOMBRE_COMPLETO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION CLAVE_CURP(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION DIRECCION(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION EN_LISTA_DE_REFERENCIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION CODIGO_LISTA_REFERENCIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    PROCEDURE ACTUALIZA_NUMERO_TRIBUTARIO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2);

    FUNCTION FECHA_NACIMIENTO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION ACTIVIDAD(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION EMAIL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION FECHA_INGRESO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN DATE;

    FUNCTION SEXO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION CLAVE_RFC(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

    FUNCTION REGISTRO_FISCAL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

  FUNCTION TIPO_PERSONA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

  FUNCTION RAZON_SOCIAL_FACT(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;

  FUNCTION REGIMEN_FISCAL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER;

   PROCEDURE ACTUALIZA_INFORMACION_FISCAL( cTipo_Doc_Identificacion  PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE
                                         , cNum_Doc_Identificacion   PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE
                                         , nIdRegFisSAT              PERSONA_NATURAL_JURIDICA.IdRegFisSAT%TYPE
                                         , cRazonSocialFact          PERSONA_NATURAL_JURIDICA.RazonSocialFact%TYPE );

END OC_PERSONA_NATURAL_JURIDICA;
/
create or replace PACKAGE BODY SICAS_OC.OC_PERSONA_NATURAL_JURIDICA IS
--

    FUNCTION EXISTE_PERSONA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cExiste   VARCHAR2(1);
    BEGIN
       BEGIN
          SELECT 'S'
            INTO cExiste
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cExiste := 'N';
          WHEN TOO_MANY_ROWS THEN
             cExiste := 'S';
       END;
       RETURN UPPER(cExiste);
    END EXISTE_PERSONA;

    FUNCTION NOMBRE_PERSONA(nCod_Asegurado NUMBER) RETURN VARCHAR2 IS
    cNombreAsegurado  VARCHAR2(200);
    BEGIN
       BEGIN
          SELECT TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || 
                 DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada)
            INTO cNombreAsegurado
            FROM ASEGURADO A, PERSONA_NATURAL_JURIDICA PNJ
           WHERE A.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
             AND A.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
             AND A.cod_asegurado = nCod_Asegurado;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cNombreAsegurado := 'PERSONA NO VALIDO';
          WHEN TOO_MANY_ROWS THEN
            cNombreAsegurado := 'PERSONA DUPLICADO';
       END;
       RETURN UPPER(cNombreAsegurado);
    END NOMBRE_PERSONA;

    PROCEDURE INSERTAR_PERSONA(cTipo_Doc_Identificacion VARCHAR2,   cNum_Doc_Identificacion VARCHAR2,  -- INICIO ACENTO
                               cNombre                  VARCHAR2,   cApellidoPat            VARCHAR2, 
                               cApellidoMat             VARCHAR2,   cApeCasada              VARCHAR2, 
                               cSexo                    VARCHAR2,   cEstadoCivil            VARCHAR2, 
                               dFecNacimiento           DATE,       cDirecRes               VARCHAR2, 
                               cNumInterior             VARCHAR2,   cNumExterior            VARCHAR2,
                               cCodPaisRes              VARCHAR2,   cCodProvRes             VARCHAR2, 
                               cCodDistRes              VARCHAR2,   cCodCorrRes             VARCHAR2,            
                               cCodPosRes               VARCHAR2,   cCodColonia             VARCHAR2, 
                               cTelRes                  VARCHAR2,   cEmail                  VARCHAR2, 
                               cLadaTelRes              VARCHAR2) IS
    BEGIN
       BEGIN
          INSERT INTO PERSONA_NATURAL_JURIDICA
                (Tipo_Doc_Identificacion,                   Num_Doc_Identificacion, 
                 Nombre,                                    Apellido_Paterno, 
                 Apellido_Materno,                          ApeCasada,  
                 Sexo,                                      EstadoCivil, 
                 FecNacimiento,                             DirecRes, 
                 --
                 CodPaisRes,                                CodProvRes, 
                 CodDistRes,                                CodCorrRes, 
                 ZipRes,                                    TelRes, 
                 EmpresaTrab,                               DirecOfi, 
                 CodPaisOfi,                                CodProvOfi, 
                 --
                 CodDistOfi,                                CodCorrOfi, 
                 ZipOfi,                                    TelOfi, 
                 FaxOfi,                                    Email, 
                 FecSts,                                    FecIngreso,
                 Cedula,                                    
                 Tipo_Id_Tributaria, 
                 Num_Tributario,   
                 --
                 CodigoZip,                                 CodPosRes,
                 CodAsenRes,                                CodPosOfi,
                 CodAsenOfi,                                Tipo_Persona,
                 Tip_DocIde_Matriz,                         Num_DocIde_Matriz,
                 TelMovil,                                  CodColRes,
                 --
                 LadaTelRes,                                LadaTelOfi,              
                 LadaFaxOfi,                                LadaTelMovil, 
                 NumInterior,                               NumExterior)
          VALUES(cTipo_Doc_Identificacion,                  cNum_Doc_Identificacion,
                 CAMBIA_ACENTOS(cNombre),                   CAMBIA_ACENTOS(cApellidoPat),
                 CAMBIA_ACENTOS(cApellidoMat),              CAMBIA_ACENTOS(cApeCasada),  
                 cSexo,                                     cEstadoCivil, 
                 dFecNacimiento,                            CAMBIA_ACENTOS(cDirecRes), 
                 --
                 cCodPaisRes,                               cCodProvRes, 
                 cCodDistRes,                               cCodCorrRes, 
                 NULL,                                      cTelRes, 
                 NULL,                                      NULL, 
                 NULL,                                      NULL, 
                 --
                 NULL,                                      NULL, 
                 NULL,                                      NULL, 
                 NULL,                                      cEmail, 
                 TRUNC(SYSDATE),                            TRUNC(SYSDATE),
                 NULL,                                      
                 DECODE(cTipo_Doc_Identificacion, 'RFC', cTipo_Doc_Identificacion, NULL),
                 DECODE(cTipo_Doc_Identificacion, 'RFC', cNum_Doc_Identificacion, NULL), 
                 --
                 NULL,                                      cCodPosRes, 
                 NULL,                                      NULL, 
                 NULL,                                      NULL, 
                 NULL,                                      NULL, 
                 NULL,                                      cCodColonia, 
                 --
                 cLadaTelRes,                               NULL, 
                 NULL,                                      'OCPNJ', 
                 cNumInterior,                              cNumExterior);
       EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
             RAISE_APPLICATION_ERROR(-20225,'Ya Existe Persona Natural Juridica para Identificacion: '||
                                     TRIM(cTipo_Doc_Identificacion)||'-'||TRIM(cNum_Doc_Identificacion));
       END;
       IF cEmail IS NOT NULL THEN
          BEGIN
             INSERT INTO CORREOS_ELECTRONICOS_PNJ
                   (Tipo_Doc_Identificacion, Num_Doc_Identificacion, 
                    Correlativo_Email, Email, Email_Principal)
             VALUES(cTipo_Doc_Identificacion, cNum_Doc_Identificacion,
                    1, cEmail, 'S');
          EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
                RAISE_APPLICATION_ERROR(-20225,'Ya Existe un Email para Persona Natural Juridica con Identificacion: '||
                                        TRIM(cTipo_Doc_Identificacion)||'-'||TRIM(cNum_Doc_Identificacion));
          END;
       END IF;
    END INSERTAR_PERSONA;            -- FINI ACENTO

    FUNCTION FUNC_VALIDA_EDAD(cTipo_Doc_Identificacion VARCHAR2, nNum_Doc_Identificacion VARCHAR2, nCodCia NUMBER,
                              nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
    nEdad           NUMBER(5);
    cValido         VARCHAR2(1);
    dFecNacimiento  DATE;
    BEGIN
       BEGIN
          SELECT TRUNC(FecNacimiento)
            INTO dFecNacimiento
            FROM PERSONA_NATURAL_JURIDICA
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND  Num_Doc_Identificacion = nNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20225,'Debe agregar la Fecha de Nacimiento al Asegurado');

       END;
       nEdad := FLOOR((TRUNC(SYSDATE) - TRUNC(dFecNacimiento)) / 365.25);
       BEGIN
          SELECT 'S'
            INTO cValido
            FROM COBERTURAS_DE_SEGUROS
           WHERE CodCia     = nCodCia
             AND CodEmpresa = nCodEmpresa
             AND IdTipoSeg  = cIdTipoSeg
             AND PlanCob    = cPlanCob
             AND nEdad BETWEEN Edad_Minima AND Edad_Maxima;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cValido := 'N';
          WHEN TOO_MANY_ROWS THEN
             cValido := 'S';
       END;
    /*   IF cValido = 'N' THEN
           RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
       END IF;*/
       RETURN (cValido);
    END FUNC_VALIDA_EDAD;

    FUNCTION NUMERO_TRIBUTARIO_RFC(cNombresPersona VARCHAR2, cApellido_Paterno VARCHAR2, cApellido_Materno VARCHAR2,
                                   dFecNacimiento DATE, cTipoPersona VARCHAR2) RETURN VARCHAR2 IS
    cNombre          PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
    cApellido_Pat    PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;    
    cApellido_Mat    PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;    
    cNum_Tributario  PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
    cCodLista        VALORES_DE_LISTAS.CodLista%TYPE;
    cNombreCompleto  VARCHAR2(300);
    cCadenaMulti     VARCHAR2(600);
    nTotMultiplic    NUMBER(28,2);
    nCociente        NUMBER(10);
    nResiduo         NUMBER(10);
    nCifraFinal      NUMBER(10);
    nCifraTexto      VARCHAR2(20);
    cHomoClave       VARCHAR2(2);
    nPosicion        NUMBER(3);
    nValorPos        NUMBER(3);
    nSumaDigVer      NUMBER(28,2);
    cDigitoVerif     VARCHAR2(1);
    cNombreEliminado VARCHAR2(10);

    CURSOR ANEXOS_Q IS
       SELECT CodValor, DescValLst
         FROM VALORES_DE_LISTAS
        WHERE CodLista = cCodLista;
    BEGIN
       IF cTipoPersona = 'FISICA' THEN
          cNombre       := UPPER(cNombresPersona);
          cApellido_Pat := UPPER(cApellido_Paterno);
          cApellido_Mat := UPPER(cApellido_Materno);
          -- Elimina Palabras que NO se utilizan
          cCodLista  := 'RFCANE-V';
          -- Determina si la palabra que NO se utiliza va al principio del Apellido
          FOR X IN ANEXOS_Q LOOP
             IF SUBSTR(cNombre, 1, LENGTH(LTRIM(X.DescValLst))) = LTRIM(X.DescValLst) THEN
                cNombre       := TRIM(REPLACE(UPPER(cNombre),LTRIM(X.DescValLst),' '));
             END IF;
             IF SUBSTR(cApellido_Pat, 1, LENGTH(LTRIM(X.DescValLst))) = LTRIM(X.DescValLst) THEN
                cApellido_Pat := TRIM(REPLACE(UPPER(cApellido_Pat),LTRIM(X.DescValLst),' '));
             END IF;
             IF SUBSTR(cApellido_Mat, 1, LENGTH(LTRIM(X.DescValLst))) = LTRIM(X.DescValLst) THEN
                cApellido_Mat := TRIM(REPLACE(UPPER(cApellido_Mat),LTRIM(X.DescValLst),' '));
             END IF;
          END LOOP;
          FOR X IN ANEXOS_Q LOOP
             IF SUBSTR(cNombre, 1, LENGTH(X.DescValLst)) = X.DescValLst THEN
                cNombre       := REPLACE(UPPER(cNombre),X.DescValLst,' ');
             END IF;
             IF SUBSTR(cApellido_Pat, 1, LENGTH(X.DescValLst)) = X.DescValLst THEN
                cApellido_Pat := REPLACE(UPPER(cApellido_Pat),X.DescValLst,' ');
             END IF;
             IF SUBSTR(cApellido_Mat, 1, LENGTH(X.DescValLst)) = X.DescValLst THEN
                cApellido_Mat := REPLACE(UPPER(cApellido_Mat),X.DescValLst,' ');
             END IF;
          END LOOP;

          -- Sustituye Signos Especiales
          cCodLista  := 'RFCANE-VI';
          FOR X IN ANEXOS_Q LOOP
             cNombre       := REPLACE(UPPER(cNombre),X.CodValor,X.DescValLst);
             cApellido_Pat := REPLACE(UPPER(cApellido_Pat),X.CodValor,X.DescValLst);
             cApellido_Mat := REPLACE(UPPER(cApellido_Mat),X.CodValor,X.DescValLst);
          END LOOP;

          -- Elimina Signos Especiales
          cCodLista  := 'RFCANE-VI';
          FOR X IN ANEXOS_Q LOOP
             cNombre       := REPLACE(UPPER(cNombre),TRIM(X.CodValor),'');
             cApellido_Pat := REPLACE(UPPER(cApellido_Pat),TRIM(X.CodValor),'');
             cApellido_Mat := REPLACE(UPPER(cApellido_Mat),TRIM(X.CodValor),'');
          END LOOP;

          -- Regla 6 - Elimina MARIA y JOSE si es el primer Nombre dado su uso frecuente
          IF SUBSTR(cNombre,1,6) = 'MARIA ' THEN
             cNombre := SUBSTR(cNombre,7,LENGTH(cNombre));
             cNombreEliminado := 'MARIA ';
          ELSIF SUBSTR(cNombre,1,5) = 'JOSE ' THEN
             cNombre := SUBSTR(cNombre,6,LENGTH(cNombre));
             cNombreEliminado := 'JOSE ';
          END IF;

          -- Regla No. 4 - En los casos en que el apellido paterno de la persona física se componga de una o dos letras
          IF LENGTH(cApellido_Pat) IN (1, 2) THEN
             cNum_Tributario := SUBSTR(cApellido_Pat,1,1) || SUBSTR(cApellido_Mat,1,1) || SUBSTR(cNombre,1,2);
          -- Regla No. 7 - En los casos en que la persona física tenga un solo apellido, se conformará con la primera y segunda letras 
          -- del apellido paterno o materno, según figure en el acta de nacimiento, más la primera y segunda letras del nombre.
          ELSIF TRIM(cApellido_Pat) IS NOT NULL AND TRIM(cApellido_Mat) IS NULL THEN
             cNum_Tributario := SUBSTR(cApellido_Pat,1,2) || SUBSTR(cNombre,1,2);
          ELSIF (TRIM(cApellido_Pat) IS NULL AND TRIM(cApellido_Mat) IS NOT NULL) THEN
             cNum_Tributario := SUBSTR(cApellido_Mat,1,2) || SUBSTR(cNombre,1,2);
          -- Regla No. 1 - La primera letra del apellido paterno y la siguiente primera vocal del mismo,
          -- La primera letra del apellido materno y La primera letra del nombre
          ELSE
             cNum_Tributario := SUBSTR(cApellido_Pat,1,1);
             FOR X IN 2..LENGTH(cApellido_Pat) LOOP
                IF SUBSTR(cApellido_Pat,X,1) IN ('A', 'E', 'I', 'O', 'U') THEN
                   cNum_Tributario := cNum_Tributario || SUBSTR(cApellido_Pat,X,1);
                   EXIT;
                END IF;
             END LOOP;
             cNum_Tributario := cNum_Tributario || SUBSTR(cApellido_Mat,1,1) || SUBSTR(cNombre,1,1);
          END IF;

          -- Regla No. 9 - Cuando de las cuatro letras que formen la expresión alfabética, resulte una palabra inconveniente, 
          -- la ultima letra será sustituida por una  “ X “.
          cCodLista  := 'RFCANE-IV';
          FOR X IN ANEXOS_Q LOOP
             IF cNum_Tributario = X.CodValor THEN
                cNum_Tributario := X.DescValLst;
                EXIT;
             END IF;
          END LOOP;

          -- Regla No. 2 - Fecha de Nacimiento del contribuyente, con números arábigos en el siguiente orden:
          -- Año: Se tomarán las dos últimas cifras.
          -- Mes: Se tomará el mes de nacimiento en su número de orden, en un año de calendario.
          -- Día: 
          cNum_Tributario := cNum_Tributario || TO_CHAR(dFecNacimiento,'YYMMDD');

          -- Cálculo de HomoClave

          IF TRIM(cNombreEliminado) IS NOT NULL THEN
             cNombreCompleto := TRIM(cNombreEliminado) || ' ' || cNombre || ' ' || cApellido_Pat || ' ' || cApellido_Mat;
          ELSE
             cNombreCompleto := cNombre || ' ' || cApellido_Pat || ' ' || cApellido_Mat;
          END IF;

          cCadenaMulti    := '0';
          FOR X IN 1..LENGTH(TRIM(cNombreCompleto)) LOOP
             BEGIN
                SELECT cCadenaMulti || TRIM(DescValLst)
                  INTO cCadenaMulti
                  FROM VALORES_DE_LISTAS
                 WHERE CodLista = 'RFCANE-I'
                   AND CodValor = SUBSTR(cNombreCompleto,X,1);
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   NULL;
             END;
          END LOOP;

          nTotMultiplic := 0;
          FOR X IN 1..LENGTH(TRIM(cCadenaMulti))-1 LOOP
             nTotMultiplic := nTotMultiplic + (TO_NUMBER(SUBSTR(cCadenaMulti,X,2)) * TO_NUMBER(SUBSTR(cCadenaMulti,X+1,1)));
          END LOOP;

          nCifraTexto := TRIM(TO_CHAR(nTotMultiplic,'99999999990'));
          nCifraFinal := TO_NUMBER(SUBSTR(nCifraTexto,LENGTH(nCifraTexto)-2,3));

          nCociente    := FLOOR(nCifraFinal / 34);
          nResiduo     := MOD(nCifraFinal, 34);

          BEGIN
             SELECT TRIM(DescValLst)
               INTO cHomoClave
               FROM VALORES_DE_LISTAS
              WHERE CodLista = 'RFCANE-II'
                AND TO_NUMBER(CodValor) = nCociente;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20225,'Cociente para HomoClave NO se encuentra en Catálogo RFCANE-II');
          END;

          BEGIN
             SELECT TRIM(cHomoClave) || TRIM(DescValLst)
               INTO cHomoClave
               FROM VALORES_DE_LISTAS
              WHERE CodLista = 'RFCANE-II'
                AND TO_NUMBER(CodValor) = nResiduo;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20225,'Residuo para HomoClave NO se encuentra en Catálogo RFCANE-II');
          END;

          cNum_Tributario := cNum_Tributario || cHomoClave;

          -- Cálculo del Dígito Verificador
          nPosicion  := 13;
          FOR X IN 1..LENGTH(TRIM(cNum_Tributario)) LOOP
             BEGIN
                SELECT TO_NUMBER(DescValLst)
                  INTO nValorPos
                  FROM VALORES_DE_LISTAS
                 WHERE CodLista = 'RFCANE-III'
                   AND CodValor = SUBSTR(cNum_Tributario,X,1);
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   nValorPos := 0;
             END;
             nSumaDigVer := NVL(nSumaDigVer,0) + NVL(nValorPos,0) * nPosicion;
             nPosicion   := nPosicion - 1;
          END LOOP;

          nResiduo     := MOD(nSumaDigVer, 11);

          IF NVL(nResiduo,0) = 0 THEN
             cDigitoVerif := '0';
          ELSIF NVL(nResiduo,0) = 10 THEN
             cDigitoVerif := '1';
          ELSIF NVL(nResiduo,0) > 0 THEN
             cDigitoVerif := TRIM(SUBSTR(TO_CHAR(11 - NVL(nResiduo,0)),1,1));
          END IF;

          cNum_Tributario := cNum_Tributario || cDigitoVerif;

          RETURN(cNum_Tributario);
       ELSE
          RAISE_APPLICATION_ERROR(-20225,'Solamente se Forma el RFC para Personas FISICAS');
       END IF;
    END NUMERO_TRIBUTARIO_RFC;

    FUNCTION AUXILIAR_CONTABLE(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cAuxContable    PERSONA_NATURAL_JURIDICA.AuxContable%TYPE;
    BEGIN
       BEGIN
          SELECT AuxContable
            INTO cAuxContable
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cAuxContable := NULL;
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20225,'Existen Varias Personas o Empresas con el Mismo Documento de Identificación');
       END;
       RETURN(cAuxContable);
    END AUXILIAR_CONTABLE;

    FUNCTION NOMBRE_COMERCIAL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cNombreComercial    PERSONA_NATURAL_JURIDICA.NombreComercial%TYPE;
    BEGIN
       BEGIN
          SELECT NombreComercial
            INTO cNombreComercial
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cNombreComercial := NULL;
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20225,'Existen Varias Personas o Empresas con el Mismo Documento de Identificación');
       END;
       RETURN(cNombreComercial);
    END NOMBRE_COMERCIAL;

    FUNCTION NOMBRE_COMPLETO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cNombreCompleto    PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
    BEGIN
       BEGIN
          SELECT TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || 
                 DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada)
            INTO cNombreCompleto
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cNombreCompleto := NULL;
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20225,'Existen Varias Personas o Empresas con el Mismo Documento de Identificación');
       END;
       RETURN(cNombreCompleto);
    END NOMBRE_COMPLETO;

    FUNCTION CLAVE_CURP(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cClaveCURP    PERSONA_NATURAL_JURIDICA.CURP%TYPE;
    BEGIN
       BEGIN
          SELECT CURP
            INTO cClaveCURP
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cClaveCURP := NULL;
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20225,'Existen Varias Personas o Empresas con el Mismo Documento de Identificación');
       END;
       RETURN(cClaveCURP);
    END CLAVE_CURP;

    FUNCTION DIRECCION(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cDireccion  VARCHAR2(2000);
    BEGIN
       BEGIN
          SELECT  TRIM(PNJ.DirecRes)||' '||TRIM(NumExterior)||' ' ||DECODE(NumInterior, NULL, NULL, 'Interior') ||' '||TRIM(NumInterior)||' '
                  || TRIM (OC_COLONIA.DESCRIPCION_COLONIA(PNJ.CodPaisRes, PNJ.CodProvRes, PNJ.CodDistRes, PNJ.CodCorrres, PNJ.CodPosRes, CodColRes))
                  ||', '||TRIM(OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.CodPaisRes, PNJ.CodProvRes))
                  ||', '||TRIM(OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(PNJ.CodPaisRes, PNJ.CodProvRes, PNJ.CodDistRes, PNJ.CodCorrRes)) 
                  ||', CP '|| TRIM(PNJ.CodPosRes)
            INTO cDireccion
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cDireccion  := ' NO VALIDA';
       END;
      RETURN UPPER(TRIM(cDireccion));
    END DIRECCION;

    FUNCTION EN_LISTA_DE_REFERENCIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cEnLista     VARCHAR2(1);
    BEGIN
       BEGIN
          SELECT 'S'
            INTO cEnLista
            FROM PERSONA_NATURAL_JURIDICA
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
             AND CodListaRef        IS NOT NULL;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cEnLista := 'N';
          WHEN TOO_MANY_ROWS THEN
             cEnLista := 'S';
       END;
       RETURN(cEnLista);
    END EN_LISTA_DE_REFERENCIA;

    FUNCTION CODIGO_LISTA_REFERENCIA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cCodListaRef     CLIENTES.CodListaRef%TYPE;
    BEGIN
       BEGIN
          SELECT CodListaRef
            INTO cCodListaRef
            FROM PERSONA_NATURAL_JURIDICA
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
             AND CodListaRef        IS NOT NULL;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cCodListaRef := NULL;
          WHEN TOO_MANY_ROWS THEN
             cCodListaRef := NULL;
       END;
       RETURN(cCodListaRef);
    END CODIGO_LISTA_REFERENCIA;

    PROCEDURE ACTUALIZA_NUMERO_TRIBUTARIO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) IS
    BEGIN
       UPDATE PERSONA_NATURAL_JURIDICA
          SET Tipo_Id_Tributaria = DECODE(cTipo_Doc_Identificacion, 'RFC', cTipo_Doc_Identificacion, NULL),
              Num_Tributario     = DECODE(cTipo_Doc_Identificacion, 'RFC', cNum_Doc_Identificacion, NULL)
        WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
          AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
          AND Num_Tributario         IS NULL;
    END ACTUALIZA_NUMERO_TRIBUTARIO;

    FUNCTION FECHA_NACIMIENTO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    W_FECNACIMIENTO    PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
    BEGIN
       BEGIN
          SELECT PNJ.FECNACIMIENTO
            INTO W_FECNACIMIENTO
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             W_FECNACIMIENTO := NULL;
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20225,'Existen Varias Personas o Empresas con el Mismo Documento de Identificación');
       END;
       RETURN(W_FECNACIMIENTO);
    END FECHA_NACIMIENTO;

    FUNCTION ACTIVIDAD(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cCODACTIVIDAD    PERSONA_NATURAL_JURIDICA.CODACTIVIDAD%TYPE;
    BEGIN
       BEGIN
          SELECT PNJ.CODACTIVIDAD
            INTO cCODACTIVIDAD
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20225,'Persona NJ : '||TRIM(TO_CHAR(cTipo_Doc_Identificacion)) ||' '||TRIM(TO_CHAR(cNum_Doc_Identificacion)) || ' NO Existe');
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20225,'Persona NJ : '||TRIM(TO_CHAR(cTipo_Doc_Identificacion)) ||' '||TRIM(TO_CHAR(cNum_Doc_Identificacion)) || ' Duplicado');
       END;
       RETURN(cCODACTIVIDAD);
    END ACTIVIDAD;

    FUNCTION EMAIL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    cEmail         PERSONA_NATURAL_JURIDICA.Email%TYPE;
    BEGIN
       BEGIN
          SELECT Email
            INTO cEmail
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20225,'Persona NJ : '||TRIM(TO_CHAR(cTipo_Doc_Identificacion)) ||' '||TRIM(TO_CHAR(cNum_Doc_Identificacion)) || ' NO Existe');
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR(-20225,'Persona NJ : '||TRIM(TO_CHAR(cTipo_Doc_Identificacion)) ||' '||TRIM(TO_CHAR(cNum_Doc_Identificacion)) || ' Duplicado');
       END;
       RETURN(cEmail);
    END EMAIL;

    FUNCTION FECHA_INGRESO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN DATE IS
    W_FECINGRESO    PERSONA_NATURAL_JURIDICA.FECINGRESO%TYPE;
    BEGIN
       BEGIN
          SELECT PNJ.FECINGRESO
            INTO W_FECINGRESO
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             W_FECINGRESO := NULL;
          WHEN TOO_MANY_ROWS THEN
             W_FECINGRESO := NULL;
          WHEN OTHERS THEN
             W_FECINGRESO := NULL;
       END;
       RETURN(W_FECINGRESO);
    END FECHA_INGRESO;

    FUNCTION SEXO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
    W_SEXO   PERSONA_NATURAL_JURIDICA.SEXO%TYPE;
    BEGIN
       BEGIN
          SELECT PNJ.SEXO
            INTO W_SEXO
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             W_SEXO := NULL;
          WHEN TOO_MANY_ROWS THEN
             W_SEXO := NULL;
          WHEN OTHERS THEN
             W_SEXO := NULL;   END;
       RETURN(W_SEXO);
    END SEXO;

    FUNCTION CLAVE_RFC(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
        cClaveRFC    PERSONA_NATURAL_JURIDICA.NUM_TRIBUTARIO%TYPE;
    BEGIN
       BEGIN
          SELECT NUM_TRIBUTARIO
            INTO cClaveRFC
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cClaveRFC := NULL;
       END;
       RETURN(cClaveRFC);
    END CLAVE_RFC;
    --
    --
    --
    FUNCTION REGISTRO_FISCAL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
        nIDREGFISSAT PERSONA_NATURAL_JURIDICA.IDREGFISSAT%TYPE;
    BEGIN
        BEGIN
          SELECT IDREGFISSAT
            INTO nIDREGFISSAT
            FROM PERSONA_NATURAL_JURIDICA PNJ
           WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nIDREGFISSAT := NULL;
       END;
       RETURN(nIDREGFISSAT);
    END REGISTRO_FISCAL;
    --
FUNCTION TIPO_PERSONA(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
cTipo_Persona  PERSONA_NATURAL_JURIDICA.Tipo_Persona%TYPE;
BEGIN
   BEGIN
      SELECT Tipo_Persona
        INTO cTipo_Persona
        FROM PERSONA_NATURAL_JURIDICA PNJ
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipo_Persona := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varias Personas o Empresas con el Mismo Documento de Identificación');
   END;
   RETURN cTipo_Persona;
END TIPO_PERSONA;

FUNCTION RAZON_SOCIAL_FACT(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
cRazonSocialFact  PERSONA_NATURAL_JURIDICA.RazonSocialFact%TYPE;
BEGIN
   BEGIN
      SELECT NVL(RazonSocialFact,'NA')
        INTO cRazonSocialFact
        FROM PERSONA_NATURAL_JURIDICA PNJ
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRazonSocialFact := 'NA';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varias Personas o Empresas con el Mismo Documento de Identificación');
   END;
   RETURN cRazonSocialFact;
END RAZON_SOCIAL_FACT;

FUNCTION REGIMEN_FISCAL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN NUMBER IS
nIdRegFisSat   PERSONA_NATURAL_JURIDICA.IdRegFisSat%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IdRegFisSat,0)
        INTO nIdRegFisSat
        FROM PERSONA_NATURAL_JURIDICA PNJ
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Persona NJ : '||TRIM(TO_CHAR(cTipo_Doc_Identificacion)) ||' '||TRIM(TO_CHAR(cNum_Doc_Identificacion)) || ' NO Existe');
   END;
   RETURN nIdRegFisSat;
END REGIMEN_FISCAL;

   PROCEDURE ACTUALIZA_INFORMACION_FISCAL( cTipo_Doc_Identificacion  PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE
                                         , cNum_Doc_Identificacion   PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE
                                         , nIdRegFisSAT              PERSONA_NATURAL_JURIDICA.IdRegFisSAT%TYPE
                                         , cRazonSocialFact          PERSONA_NATURAL_JURIDICA.RazonSocialFact%TYPE ) IS
   BEGIN
      UPDATE PERSONA_NATURAL_JURIDICA
      SET    IdRegFisSAT     = nIdRegFisSAT
        ,    RazonSocialFact = cRazonSocialFact
      WHERE  Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
        AND  Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   END ACTUALIZA_INFORMACION_FISCAL;

END OC_PERSONA_NATURAL_JURIDICA;
/
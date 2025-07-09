create or replace PACKAGE          OC_RIESGOS_PLD IS

FUNCTION RETURN_CLIENTES_ADMACREL (NOMBRE IN VARCHAR2) RETURN VARCHAR2;

PROCEDURE VALIDA(P_TIPO_DOC_IDENTIFICACION VARCHAR2,
                 P_NUM_DOC_IDENTIFICACION  VARCHAR2,
                 P_ORIGEN                   NUMBER,
                 P_RESULTADO OUT NUMBER);

/*PROCEDURE CORREO_PLD_HISTORICO( PRFC            IN VARCHAR2,
                                PNOMBRE         IN  VARCHAR2,
                                PORIGEN          IN VARCHAR2,

                                CCOLOR      VARCHAR2,
                                        LSTEMPLEA   VARCHAR2, 
                                        LSTLISTA    VARCHAR2, 
                                        LSTCLIENT   VARCHAR2, 
                                        LSTACTIVI   VARCHAR2, 
                                        LSTQEQ      VARCHAR2, 
                                        LSTLCNSF    VARCHAR2, 
                                        LSTPAIS     VARCHAR2, 
                                        LSTCIUDAD   VARCHAR2, 
                                        LSTESTADO  VARCHAR2, 
                                        LSTCCC      VARCHAR2, 

                                PBENEFSIN       IN VARCHAR2,
                                PASEGURADOS     IN VARCHAR2,
                                PCLIENTES       IN VARCHAR2,
                                PEMPLEADOS      IN VARCHAR2,
                                PPROVEEDORES    IN VARCHAR2,
                                PBENEFICIARIOS  IN VARCHAR2,
                                PCOLOR          IN VARCHAR2,
                                PRIESGO         IN VARCHAR2
                                );*/

PROCEDURE CORREO_PLD_REALTIME( PRFC            IN VARCHAR2,
                                PNOMBRE         IN  VARCHAR2,
                                PORIGEN          IN VARCHAR2,
                                PBENEFSIN       IN VARCHAR2,
                                PASEGURADOS     IN VARCHAR2,
                                PCLIENTES       IN VARCHAR2,
                                PEMPLEADOS      IN VARCHAR2,
                                PPROVEEDORES    IN VARCHAR2,
                                PBENEFICIARIOS  IN VARCHAR2,
                                PCOLOR          IN VARCHAR2,
                                PRIESGO         IN VARCHAR2
                                );

PROCEDURE CORREO_PLD_ANONIMO( PFOLIO            IN VARCHAR2
                                );

PROCEDURE CORREO_EJECUCION_HISTORICO( OPCION            IN NUMBER --1 INICIO, 2 FINAL
                                );

PROCEDURE CORREO_RFC_ERRONEO( NOMBRE IN VARCHAR2, AP_PATERNO IN VARCHAR2, AP_MATERNO IN VARCHAR2, FECNACIM IN VARCHAR2, ERRORSQL IN VARCHAR2,PTIPO_DOC_IDENTIFICACION   IN VARCHAR,PNUM_DOC_IDENTIFICACION IN VARCHAR
                                );
vl_SinRiesgo        CONSTANT    VARCHAR2(20) := 'Sin Riesgo';
vl_BajoRiesgo       CONSTANT    VARCHAR2(20) := 'Bajo Riesgo';
vl_MedianoRiesgo    CONSTANT    VARCHAR2(20) := 'Mediano Riesgo';
vl_AltoRiesgo       CONSTANT    VARCHAR2(20) := 'Alto Riesgo';

END OC_RIESGOS_PLD;
/
create or replace PACKAGE BODY          OC_RIESGOS_PLD IS

FUNCTION    RETURN_CLIENTES_ADMACREL (NOMBRE IN VARCHAR2) RETURN VARCHAR2 IS

vl_CadenaClientes VARCHAR2(4000) := '';

BEGIN

        SELECT LISTAGG(C.CODCLIENTE,''',''') 
        INTO vl_CadenaClientes
        FROM SICAS_OC.CLIENTES C,SICAS_OC.PERSONA_NATURAL_JURIDICA J
        WHERE C.CODCLIENTE = C.CODCLIENTE
            AND J.TIPO_DOC_IDENTIFICACION = C.TIPO_DOC_IDENTIFICACION
            AND J.NUM_DOC_IDENTIFICACION = C.NUM_DOC_IDENTIFICACION
            AND (J.NOMBRE||' '||J.APELLIDO_PATERNO||' '||J.APELLIDO_MATERNO = NOMBRE
            OR J.NOMBRE||' '||J.APELLIDO_PATERNO||' '||J.APELLIDO_MATERNO LIKE '%'|| NOMBRE ||'%'
                    OR SOUNDEX(J.NOMBRE||' '||J.APELLIDO_PATERNO||' '||J.APELLIDO_MATERNO) = SOUNDEX(NOMBRE))
            AND ROWNUM <= 50;

    RETURN vl_CadenaClientes;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '';
END;

PROCEDURE VALIDA(P_TIPO_DOC_IDENTIFICACION VARCHAR2,
                 P_NUM_DOC_IDENTIFICACION  VARCHAR2,
                 P_ORIGEN                   NUMBER,
                 P_RESULTADO OUT NUMBER
                 ) IS

vl_EMPLEA VARCHAR2(15) := '';
vl_LISTA    VARCHAR2(15) := '';
vl_CLIENT   VARCHAR2(15) := '';
vl_ACTIVI   VARCHAR2(15) := '';
vl_QEQ      VARCHAR2(15) := '';
vl_LCNSF   VARCHAR2(15) := '';
vl_PAIS     VARCHAR2(15) := '';
vl_CIUDAD   VARCHAR2(15) := '';
vl_ESTADO  VARCHAR2(15) := '';
vl_CCC2      VARCHAR2(15) := '';

P_TP_RESOLUCION   ADMON_RIESGO.TP_RESOLUCION%TYPE := '';
W_MENSAJE         VARCHAR2(4000) := ' ';
CCODACTIVIDAD     PERSONA_NATURAL_JURIDICA.CODACTIVIDAD%TYPE;
P_IDTIPOSEG       TIPOS_DE_SEGUROS.IDTIPOSEG%TYPE;
CCODPAIS          PAIS.CODPAIS%TYPE;
CNOMPAIS          PAIS.DESCPAIS%TYPE;
CCODESTADO        DISTRITO.CODESTADO%TYPE;
CCODCIUDAD        DISTRITO.CODCIUDAD%TYPE;
CNOMCIUDAD        DISTRITO.DESCCIUDAD%TYPE;
vl_Benef_SinMsj     VARCHAR2(4000);
vl_Benef_Sin        NUMBER := 0;
vl_AseguradoMsj     VARCHAR2(4000);
vl_Asegurado        NUMBER := 0;
vl_ClientesMsj      VARCHAR2(4000);
vl_Clientes         NUMBER := 0;
vl_EmpleadosMsj     VARCHAR2(4000);
vl_Empleados        NUMBER := 0;
vl_ProveedoresMsj   VARCHAR2(4000);
vl_Proveedores      NUMBER := 0;
vl_BeneficiarioMsj  VARCHAR2(4000);
vl_Beneficiario     NUMBER := 0;
CNOMBRE             VARCHAR2(4000);
vl_Provincia        NUMBER := 0;
vl_Total            NUMBER := 0;
vl_Color            VARCHAR2(10);
VL_RIESGO           VARCHAR2(20);
vl_CCC              NUMBER;

BEGIN

    BEGIN
        SELECT PNJ.CODPAISRES,
               OC_PAIS.NOMBRE_PAIS(PNJ.CODPAISRES) NOM_PAIS,
               PNJ.CODPROVRES,
               PNJ.CODDISTRES,
               OC_DISTRITO.NOMBRE_DISTRITO(PNJ.CODPAISRES,PNJ.CODPROVRES,PNJ.CODDISTRES) NOM_CIUDAD,
               PNJ.NOMBRE||' '||PNJ.APELLIDO_PATERNO||' '||PNJ.APELLIDO_MATERNO AS NOMBRE
      INTO CCODPAIS, CNOMPAIS,CCODESTADO,CCODCIUDAD,CNOMCIUDAD , CNOMBRE
      FROM PERSONA_NATURAL_JURIDICA PNJ
     WHERE PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
       AND NVL(PNJ.NUM_TRIBUTARIO,PNJ.NUM_DOC_IDENTIFICACION)  = P_NUM_DOC_IDENTIFICACION;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         NULL;
    WHEN OTHERS THEN
         NULL;
  END;

  IF OC_EMPLEADOS_FUNCIONARIOS.ES_EMPLEADO_FUNCIONARIO(1, P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
        /*OC_RIESGOS_PLD.INSERTA(P_CODCIA,
                             P_CODEMPRESA,
                             P_ID_PROCESO,
                             P_IDPOLIZA,
                             P_CLIENTE,
                             P_ASEGURADO,
                             'EMPLEA',
                             P_ST_RESOLUCION,
                             P_TIPO_DOC_IDENTIFICACION,
                             P_NUM_DOC_IDENTIFICACION,
                             P_TP_RESOLUCION,
                             P_OBSERVACIONES
                             );*/
        W_MENSAJE := W_MENSAJE||'EMPLEA ';
        vl_EMPLEA  := 'EMPLEA';

  END IF;

  IF OC_PERSONA_NATURAL_JURIDICA.EN_LISTA_DE_REFERENCIA(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
        /*OC_RIESGOS_PLD.INSERTA(P_CODCIA,
                             P_CODEMPRESA,
                             P_ID_PROCESO,
                             P_IDPOLIZA,
                             P_CLIENTE,
                             P_ASEGURADO,
                             'LISTA',
                             P_ST_RESOLUCION,
                             P_TIPO_DOC_IDENTIFICACION,
                             P_NUM_DOC_IDENTIFICACION,
                             P_TP_RESOLUCION,
                             P_OBSERVACIONES
                            );*/
        W_MENSAJE := W_MENSAJE||'LISTA ';
        vl_LISTA    := 'LISTA';

   END IF;

  IF OC_CLIENTES.ES_CLIENTE_ALTO(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
        /*OC_RIESGOS_PLD.INSERTA(P_CODCIA,
                             P_CODEMPRESA,
                             P_ID_PROCESO,
                             P_IDPOLIZA,
                             P_CLIENTE,
                             P_ASEGURADO,
                             'CLIENT',
                             P_ST_RESOLUCION,
                             P_TIPO_DOC_IDENTIFICACION,
                             P_NUM_DOC_IDENTIFICACION,
                             P_TP_RESOLUCION,
                             P_OBSERVACIONES
                            );*/
        W_MENSAJE := W_MENSAJE||'CLIENT ';
        vl_CLIENT    := 'CLIENT';
  END IF;

  CCODACTIVIDAD := OC_PERSONA_NATURAL_JURIDICA.ACTIVIDAD(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION);

    IF P_ORIGEN = 1 THEN
        IF OC_ACTIVIDADES_ECONOMICAS.TIPORIESGO(cCodActividad) = 'ALTO' THEN
         /*OC_RIESGOS_PLD.INSERTA(P_CODCIA,
                                 P_CODEMPRESA,
                                 P_ID_PROCESO,
                                 P_IDPOLIZA,
                                 P_CLIENTE,
                                 P_ASEGURADO,
                                 'ACTIVI',
                                 P_ST_RESOLUCION,
                                 P_TIPO_DOC_IDENTIFICACION,
                                 P_NUM_DOC_IDENTIFICACION,
                                 P_TP_RESOLUCION,
                                 P_OBSERVACIONES
                                );*/
            W_MENSAJE := W_MENSAJE||'ACTIVI ';

vl_ACTIVI    := 'ACTIVI';

        END IF;
    END IF;

  IF OC_CAT_QEQ.ES_QEQ(P_TIPO_DOC_IDENTIFICACION,P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     /*OC_RIESGOS_PLD.INSERTA(P_CODCIA,
                             P_CODEMPRESA,
                             P_ID_PROCESO,
                             P_IDPOLIZA,
                             P_CLIENTE,
                             P_ASEGURADO,
                             'QEQ',
                             P_ST_RESOLUCION,
                             P_TIPO_DOC_IDENTIFICACION,
                             P_NUM_DOC_IDENTIFICACION,
                             P_TP_RESOLUCION,
                             P_OBSERVACIONES
                            );*/
     W_MENSAJE := W_MENSAJE||'QEQ ';
     vl_QEQ       := 'QEQ';
  END IF;

  IF OC_PLD_LISTAS_CNSF.ES_LISTA_CNSF(P_TIPO_DOC_IDENTIFICACION,P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     /*OC_RIESGOS_PLD.INSERTA(P_CODCIA,
                             P_CODEMPRESA,
                             P_ID_PROCESO,
                             P_IDPOLIZA,
                             P_CLIENTE,
                             P_ASEGURADO,
                             'LCNSF',
                             P_ST_RESOLUCION,
                             P_TIPO_DOC_IDENTIFICACION,
                             P_NUM_DOC_IDENTIFICACION,
                             P_TP_RESOLUCION,
                             P_OBSERVACIONES
                            );*/
     W_MENSAJE := W_MENSAJE||'LCNSF ';

vl_LCNSF    := 'LCNSF';

  END IF;
/*
  IF OC_TIPOS_DE_SEGUROS.ES_PRODUCTO_ALTO(P_IDTIPOSEG) = 'S' THEN
     OC_RIESGOS_PLD.INSERTA(P_CODCIA,
                             P_CODEMPRESA,
                             P_ID_PROCESO,
                             P_IDPOLIZA,
                             P_CLIENTE,
                             P_ASEGURADO,
                             'TIPSEG',
                             P_ST_RESOLUCION,
                             P_TIPO_DOC_IDENTIFICACION,
                             P_NUM_DOC_IDENTIFICACION,
                             P_TP_RESOLUCION,
                             P_OBSERVACIONES
                            );
     W_MENSAJE := W_MENSAJE||'TIPSEG ';
  END IF;
*/
   IF OC_PAIS.ES_PAIS_ALTO_RIESGO(CCODPAIS) = 'S' THEN
              /*OC_ADMON_ACTIVI.INSERTA(P_CODCIA,       -- P_CODCIA          NUMBER,
                                P_ID_PROCESO,         -- P_ID_PROCESO      NUMBER,
                                P_IDPOLIZA,           -- P_IDPOLIZA        NUMBER,
                                0,                    -- P_IDETPOL         NUMBER,
                                'PAIS',               -- P_TP_PERSONA      VARCHAR2,
                                'PAIS',               -- P_ORIGEN          VARCHAR2,
                                P_CLIENTE,            -- P_CODCLIENTE      NUMBER,
                                P_ASEGURADO,          -- P_CODASEGURADO    NUMBER,
                                0,                    -- P_IDFACTURA       NUMBER,
                                '',                   -- P_IDTIPOSEG       VARCHAR,
                                '',                   -- P_COD_MONEDA      VARCHAR2,
                                '',                   -- P_FORMPAGO        VARCHAR2,
                                '',                   -- P_TIPO_PERSONA    VARCHAR2,
                                '',                   -- P_CODACTIVIDAD    VARCHAR2,
                                '',                   -- P_ASEGURADOS_EMI  NUMBER,
                                '',                   -- P_ASEGURADOS_END  NUMBER,
                                '',                   -- P_SUMAASEG_EMI    NUMBER,
                                '',                   -- P_SUMAASEG_END    NUMBER
                                'EL ASEGURADO O BENEFICIARIO ES DE UN PAIS DE ALTO RIESGO, '||CCODPAIS||' = '||CNOMPAIS,    -- P_OBSERVACIONES   VARCHAR2,
                                '',                   -- P_IDENDOSO        NUMBER,    
                                P_TIPO_DOC_IDENTIFICACION, -- P_TIPO_DOC_IDENTIFICACION VARCHAR2,    
                                P_NUM_DOC_IDENTIFICACION   -- P_NUM_DOC_IDENTIFICACION  VARCHAR2             
                               );  */
        W_MENSAJE := W_MENSAJE||'PAIS ';
        vl_PAIS      := 'PAIS';

   END IF;

   IF OC_DISTRITO.ES_CIUDAD_ALTO_RIESGO(CCODPAIS, CCODESTADO, CCODCIUDAD) = 'S' THEN
              /*OC_ADMON_ACTIVI.INSERTA(P_CODCIA,       -- P_CODCIA          NUMBER,
                                P_ID_PROCESO,         -- P_ID_PROCESO      NUMBER,
                                P_IDPOLIZA,           -- P_IDPOLIZA        NUMBER,
                                0,                    -- P_IDETPOL         NUMBER,
                                'CIUDAD',             -- P_TP_PERSONA      VARCHAR2,
                                'CIUDAD',             -- P_ORIGEN          VARCHAR2,
                                P_CLIENTE,            -- P_CODCLIENTE      NUMBER,
                                P_ASEGURADO,          -- P_CODASEGURADO    NUMBER,
                                0,                    -- P_IDFACTURA       NUMBER,
                                '',                   -- P_IDTIPOSEG       VARCHAR,
                                '',                   -- P_COD_MONEDA      VARCHAR2,
                                '',                   -- P_FORMPAGO        VARCHAR2,
                                '',                   -- P_TIPO_PERSONA    VARCHAR2,
                                '',                   -- P_CODACTIVIDAD    VARCHAR2,
                                '',                   -- P_ASEGURADOS_EMI  NUMBER,
                                '',                   -- P_ASEGURADOS_END  NUMBER,
                                '',                   -- P_SUMAASEG_EMI    NUMBER,
                                '',                   -- P_SUMAASEG_END    NUMBER
                                'EL ASEGURADO O BENEFICIARIO ES DE UNA CIUDAD DE ALTO RIESGO, '||CCODCIUDAD||' = '||CNOMCIUDAD,    -- P_OBSERVACIONES   VARCHAR2,
                                '',                   -- P_IDENDOSO        NUMBER,    
                                P_TIPO_DOC_IDENTIFICACION, -- P_TIPO_DOC_IDENTIFICACION VARCHAR2,    
                                P_NUM_DOC_IDENTIFICACION   -- P_NUM_DOC_IDENTIFICACION  VARCHAR2             
                               );  */
    W_MENSAJE := W_MENSAJE||'CIUDAD ';
    vl_CIUDAD    := 'CIUDAD';
   END IF;

   BEGIN
       SELECT COUNT(1)
       INTO vl_Provincia
       FROM SICAS_OC.PROVINCIA
       WHERE CODESTADO = CCODESTADO
            AND TIPORIESGO = 'ALTO';

       IF vl_Provincia >=1 THEN
            W_MENSAJE := W_MENSAJE||'ESTADO ';

vl_ESTADO   := 'ESTADO';

        END IF;
   EXCEPTION
    WHEN OTHERS THEN
        vl_Provincia :=0;
   END;

   BEGIN
       SELECT COUNT(1)
       INTO vl_CCC
       FROM SICAS_OC.COMITECOMCTRL
       WHERE CODCIA = 1
            AND CODEMPRESA = 1
            AND IDCONSEC >= 0
            AND (NVL(NOMBRE,'X') = CNOMBRE
            OR NVL(RFC,'X') = P_NUM_DOC_IDENTIFICACION);

       IF vl_CCC >=1 THEN
            W_MENSAJE := W_MENSAJE||'CCC ';
            vl_CCC      := 'CCC';
        END IF;
   EXCEPTION
    WHEN OTHERS THEN
        vl_CCC :=0;
   END;

    /*AQUI FALTA AGREGAR LA VALIDACION CONTRA LA TABLA SICAS_OC.COMITECOMCTRL */

    IF LENGTH(W_MENSAJE)>2 THEN
        P_RESULTADO := 1;
        --SE ENVIA CORREO
        W_MENSAJE := REPLACE(W_MENSAJE,' ','-');
        W_MENSAJE := ' '||W_MENSAJE;

        SELECT COUNT(1)
        INTO vl_Asegurado
        FROM SICAS_OC.ASEGURADO
        WHERE COD_ASEGURADO = NVL(NULL,COD_ASEGURADO)
            AND TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
            AND NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION;

        SELECT COUNT(1)
        INTO vl_Benef_Sin
        FROM SICAS_OC.BENEF_SIN
        WHERE CODCIA = 1
            AND CODEMPRESA = 1
            AND IDSINIESTRO >= 0
            AND IDPOLIZA >= 0
            AND COD_ASEGURADO >= 0
            AND BENEF >= 0
            AND ESTADO IN ('ACT','ACTIVO')
            AND TIPO_ID_TRIBUTARIO = P_TIPO_DOC_IDENTIFICACION
            AND NUM_DOC_TRIBUTARIO = P_NUM_DOC_IDENTIFICACION;

        SELECT COUNT(1)
        INTO vl_Clientes
        FROM SICAS_OC.CLIENTES
        WHERE CODCLIENTE >= 0
            AND STSCLIENTE = 'ACT'
            AND TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
            AND NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION;

        SELECT COUNT(1)
        INTO vl_Empleados
        FROM SICAS_OC.EMPLEADOS_FUNCIONARIOS
        WHERE CODCIA = 1
            AND CODEMPLEADOFUNC >= 0
            AND STSEMPLEADOFUNC = 'ACTIVO'
            AND TIPODOCIDENTEMP = P_TIPO_DOC_IDENTIFICACION
            AND NUMDOCIDENTEMP = P_NUM_DOC_IDENTIFICACION;

        SELECT COUNT(1)
        INTO vl_Proveedores
        FROM SICAS_OC.PROVEEDORES
        WHERE CODCIA = 1
            AND CODPROVEEDOR >= 0
            AND STSPROVEEDOR IN ('ACTIV','ACT')
            AND TIPODOCIDENTPROV = P_TIPO_DOC_IDENTIFICACION
            AND NUMDOCIDENTPROV = P_NUM_DOC_IDENTIFICACION;

        SELECT COUNT(1)
        INTO vl_Beneficiario
        FROM SICAS_OC.BENEFICIARIO B
        INNER JOIN SICAS_OC.ASEGURADO A
            ON A.COD_ASEGURADO = B.COD_ASEGURADO
        WHERE B.IDPOLIZA >= 0
            AND B.IDETPOL >= 0 
            AND B.COD_ASEGURADO >= 0
            AND B.BENEF >= 0
            AND B.ESTADO IN ('ACTIVO','SOLICI','RENOVA')
            AND A.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
            AND A.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION;

        vl_Benef_SinMsj     := vl_Benef_Sin;
        vl_AseguradoMsj     := vl_Asegurado;
        vl_ClientesMsj      := vl_Clientes;
        vl_EmpleadosMsj     := vl_Empleados;
        vl_ProveedoresMsj   := vl_Proveedores;
        vl_BeneficiarioMsj  := vl_Beneficiario;

        UPDATE SICAS_OC.PERSONA_NATURAL_JURIDICA
        SET ISVALIDPLD = 1,
            FECVALIDPLD = SYSDATE
        WHERE TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
            AND NUM_DOC_IDENTIFICACION  = P_NUM_DOC_IDENTIFICACION;

       vl_Total := vl_Beneficiario + vl_Proveedores + vl_Empleados + vl_Clientes + vl_Asegurado + vl_Benef_Sin;

       IF vl_Total = 0 THEN                 --Sin Riesgo
            vl_Color := '#187fcf';
            vl_Riesgo := vl_SinRiesgo;
       ELSIF vl_Total BETWEEN 1 AND 4 THEN  --Bajo Riesgo
            vl_Color := '#41b220';
            vl_Riesgo := vl_BajoRiesgo;
       ELSIF vl_Total BETWEEN 5 AND 7 THEN  --Mediano Riesgo
            vl_Color := '#e3a51e';
            vl_Riesgo := vl_MedianoRiesgo;
       ELSE                                 --Alto Riesgo
            vl_Color := '#cf2618';
            vl_Riesgo := vl_AltoRiesgo;
       END IF;
    COMMIT;

        IF vl_Total > 0 THEN  --Estado Sin Riesgo no se alertará 
            IF P_ORIGEN = 2 THEN 
            NULL;
            --ORIGEN HISTORICO
                /*SICAS_OC.OC_RIESGOS_PLD.CORREO_PLD_HISTORICO( P_NUM_DOC_IDENTIFICACION,CNOMBRE,W_MENSAJE,
                vl_Color,
                vl_EMPLEA ,
                vl_LISTA    , 
                vl_CLIENT   , 
                vl_ACTIVI   , 
                vl_QEQ      , 
                vl_LCNSF    , 
                vl_PAIS     , 
                vl_CIUDAD   , 
                vl_ESTADO  , 
                vl_CCC2      , 

                vl_Benef_SinMsj,vl_AseguradoMsj,vl_ClientesMsj,vl_EmpleadosMsj,vl_ProveedoresMsj,vl_BeneficiarioMsj,vl_Color,vl_Riesgo);*/
            ELSIF P_ORIGEN = 1 THEN --ORIGEN TIEMPO REAL
                SICAS_OC.OC_RIESGOS_PLD.CORREO_PLD_REALTIME( P_NUM_DOC_IDENTIFICACION,CNOMBRE,W_MENSAJE,vl_Benef_SinMsj,vl_AseguradoMsj,vl_ClientesMsj,vl_EmpleadosMsj,vl_ProveedoresMsj,vl_BeneficiarioMsj,vl_Color,vl_Riesgo);
            ELSE
                P_RESULTADO := 0;
            END IF;
        END IF;
    ELSE
        P_RESULTADO := 0;
    END IF; 

EXCEPTION
    WHEN OTHERS THEN
        P_RESULTADO := 0;
        DBMS_OUTPUT.PUT_LINE('ERROR:  '||SQLERRM);
END VALIDA;

    /*PROCEDURE CORREO_PLD_HISTORICO( PRFC            IN VARCHAR2,
                                        PNOMBRE         IN  VARCHAR2,
                                        PORIGEN         IN VARCHAR2,

                                        CCOLOR      VARCHAR2,
                                        LSTEMPLEA   VARCHAR2, 
                                        LSTLISTA    VARCHAR2, 
                                        LSTCLIENT   VARCHAR2, 
                                        LSTACTIVI   VARCHAR2, 
                                        LSTQEQ      VARCHAR2, 
                                        LSTLCNSF    VARCHAR2, 
                                        LSTPAIS     VARCHAR2, 
                                        LSTCIUDAD   VARCHAR2, 
                                        LSTESTADO  VARCHAR2, 
                                        LSTCCC      VARCHAR2, 

                                        PBENEFSIN       IN VARCHAR2,
                                        PASEGURADOS     IN VARCHAR2,
                                        PCLIENTES       IN VARCHAR2,
                                        PEMPLEADOS      IN VARCHAR2,
                                        PPROVEEDORES    IN VARCHAR2,
                                        PBENEFICIARIOS  IN VARCHAR2,
                                        PCOLOR          IN VARCHAR2,
                                        PRIESGO         IN VARCHAR2
                                        ) IS
--
--  PLD ALERTAS      20/01/2023  JICO
--
cEmail                       USUARIOS.EMAIL%TYPE;
cPwdEmail                    VARCHAR2(100);
cMiMail                      USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
cSaltoLinea                  VARCHAR2(5)      := '<br>';
cHTMLHeader                  VARCHAR2(2000)   := '<html>'                                                                     ||
                                                 '<head>'                                                                     ||
                                                 '<meta http-equiv="Content-Language" content="es/mx"/>'                      ||
                                                 '<meta http-equiv=”Content-Type” content=”text/html; charset=UTF-8? />'       ||
                                                 '<meta http-equiv="X-UA-Compatible">'                                          ||
                                                 '</head><body>'                                                              ||cSaltoLinea;
cHTMLFooter                 VARCHAR2(4000)    := '</body></html>';
cTextoAlignDerecha          VARCHAR2(50)     := '<P align="CENTER">';
cTextoAlignDerechaClose     VARCHAR2(50)     := '</P>';
cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
cTextoImagen_alterna        VARCHAR2(100)    := '<img src="D:/sicas/OficialdeCumplimiento.jpg" alt="imagen">';
cTextoImagen                VARCHAR2(100);
cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
cError                      VARCHAR2(4000);
nDummy                      VARCHAR2(4000);
nLeidos                     NUMBER := 0;
cSubject                    VARCHAR2(4000);
cTextoEnvio                 VARCHAR2(4000);
cURL                        VARCHAR2(4000);
cEmails                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cCtasEmail                  PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO%TYPE;
cTexto1                     VARCHAR2(4000);
cTexto2                     VARCHAR2(4000);
cTexto3                     VARCHAR2(4000);
vl_Amperson                 VARCHAR2(1):='&';
vl_Tab                      VARCHAR2(6):='ensp;';
CNOMUSUARIO        USUARIOS.NOMUSUARIO%TYPE;
vl_Cero             NUMBER := 0;
CNOM_ORIGEN_PLD    VALORES_DE_LISTAS.DESCVALLST%TYPE;
vl_Tabulador        VARCHAR2(100) := vl_Amperson||vl_Tab;
CURSOR cCuentas is
  SELECT *
    FROM VALORES_DE_LISTAS 
   WHERE CODLISTA = 'EMAILOPPRE'
     AND CODVALOR = 'OFICIH';

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
            cCtasEmail  := I.DESCVALLST||';';
          END LOOP;     
  END; 

  cSubject := 'Deteccion ('||PRIESGO||') en Historicos con coincidencia PLD';
  --
  cTexto1  := 'Estimado Oficial de Cumplimiento: ';
  cTexto2  := 'Se ha identificado una coincidencia de origen Historico, favor de revisar las coincidencias.';
  cTexto3  := '';

  cTextoEnvio := cHTMLHeader||
                 cTexto1||cSaltoLinea||cSaltoLinea||
                 cTexto2||cSaltoLinea||
                 cTexto3||cSaltoLinea||
                 vl_Tabulador||'RFC:  '||'<b style="color:'||PCOLOR||'";>'||PRFC||'</b>'||cSaltoLinea||cSaltoLinea||
                 vl_Tabulador||'NOMBRE:  '||'<b>'||PNOMBRE||'</b>'||cSaltoLinea||cSaltoLinea||

                 vl_Tabulador||'Listas de Coincidencia: '|| '<b>'||PORIGEN||'</b>'||cSaltoLinea||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||'Roles Detectados: '||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Amperson||vl_Tab||PASEGURADOS||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PBENEFICIARIOS||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PBENEFSIN||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PCLIENTES||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PEMPLEADOS||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PPROVEEDORES||cSaltoLinea||cSaltoLinea||

                 vl_Tabulador||cURL||' '||cSaltoLinea||cSaltoLinea||
                 cTextoImagen||cSaltoLinea||
                 cHTMLFooter;   


  OC_MAIL.INIT_PARAM;
  OC_MAIL.cCtaEnvio    := cEmail;
  OC_MAIL.cPwdCtaEnvio := cPwdEmail;
  --
  -- ENVIO DE CORREO
  --
    BEGIN 

        UPDATE SICAS_OC.PERSONA_NATURAL_JURIDICA
        SET ISVALIDPLD = 2, --PLD
            FECVALIDPLD = SYSDATE
        WHERE TIPO_DOC_IDENTIFICACION = 'RFC'
            AND NUM_DOC_IDENTIFICACION  = PRFC;


                INSERT INTO SICAS_OC.PASO_PLD 
                (IDCONSEC ,
RFC ,
NIVEL ,
CNOMBRE,
CCOLOR ,
LSTEMPLEA,
LSTLISTA ,
LSTCLIENT,
LSTACTIVI,
LSTQEQ   ,
LSTLCNSF ,
LSTPAIS  ,
LSTCIUDAD,
LSTESTADO,
LSTCCC   ,
PBENEFS,
PASEGURADOS,
PCLIENTES,
PEMPLEADOS ,
PPROVEEDORES,
PBENEFICIARIOS,
PESTATUS 
)
                VALUES(
                SEQ_PASO_PLD.NEXTVAL,
                PRFC,
                PRIESGO,
                PNOMBRE,
                CCOLOR,
                LSTEMPLEA   , 
                LSTLISTA    , 
                LSTCLIENT   , 
                LSTACTIVI   , 
                LSTQEQ      , 
                LSTLCNSF    , 
                LSTPAIS     , 
                LSTCIUDAD   , 
                LSTESTADO  , 
                LSTCCC      , 

                --PORIGEN,
                PBENEFSIN,
                PASEGURADOS,
                PCLIENTES,
                PEMPLEADOS,
                PPROVEEDORES,
                PBENEFICIARIOS,
                'PENDIENTE'
            );
        /*OC_MAIL.SEND_EMAIL(
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
            vl_Cero  --P_ERROR
        );
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR EN EL ENVIO DE LA DENUNCIA '||PORIGEN||'-'||'-'||CNOM_ORIGEN_PLD||SQLERRM);              
    END;

    END CORREO_PLD_HISTORICO;*/

    PROCEDURE CORREO_PLD_REALTIME( PRFC            IN VARCHAR2,
                                    PNOMBRE         IN  VARCHAR2,
                                    PORIGEN         IN VARCHAR2,
                                    PBENEFSIN       IN VARCHAR2,
                                    PASEGURADOS     IN VARCHAR2,
                                    PCLIENTES       IN VARCHAR2,
                                    PEMPLEADOS      IN VARCHAR2,
                                    PPROVEEDORES    IN VARCHAR2,
                                    PBENEFICIARIOS  IN VARCHAR2,
                                    PCOLOR          IN VARCHAR2,
                                    PRIESGO         IN VARCHAR2
                                        ) IS

cEmail                       USUARIOS.EMAIL%TYPE;
cPwdEmail                    VARCHAR2(100);
cMiMail                      USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
cSaltoLinea                  VARCHAR2(5)      := '<br>';
cHTMLHeader                  VARCHAR2(2000)   := '<html>'                                                                     ||
                                                 '<head>'                                                                     ||
                                                 '<meta http-equiv="Content-Language" content="es/mx"/>'                      ||
                                                 '<meta http-equiv=”Content-Type” content=”text/html; charset=UTF-8? />'       ||
                                                 '<meta http-equiv="X-UA-Compatible">'                                          ||
                                                 '</head><body>'                                                              ||cSaltoLinea;
cHTMLFooter                 VARCHAR2(4000)    := '</body></html>';
cTextoAlignDerecha          VARCHAR2(50)     := '<P align="CENTER">';
cTextoAlignDerechaClose     VARCHAR2(50)     := '</P>';
cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
cTextoImagen_alterna        VARCHAR2(100)    := '<img src="D:/sicas/OficialdeCumplimiento.jpg" alt="imagen">';
cTextoImagen                VARCHAR2(100);
cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
cError                      VARCHAR2(4000);
nDummy                      VARCHAR2(4000);
nLeidos                     NUMBER := 0;
cSubject                    VARCHAR2(4000);
cTextoEnvio                 VARCHAR2(4000);
cURL                        VARCHAR2(4000);
cEmails                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cCtasEmail                  PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO%TYPE;
cTexto1                     VARCHAR2(4000);
cTexto2                     VARCHAR2(4000);
cTexto3                     VARCHAR2(4000);
vl_Amperson                 VARCHAR2(1):='&';
vl_Tab                      VARCHAR2(6):='ensp;';
CNOMUSUARIO        USUARIOS.NOMUSUARIO%TYPE;
vl_Cero             NUMBER := 0;
CNOM_ORIGEN_PLD    VALORES_DE_LISTAS.DESCVALLST%TYPE;
vl_Tabulador        VARCHAR2(100) := vl_Amperson||vl_Tab;

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
            cCtasEmail  := I.DESCVALLST||';';
          END LOOP;     
  END; 

  cSubject := 'Deteccion ('||PRIESGO||') en Tiempo Real con coincidencia PLD';
  --
  cTexto1  := 'Estimado Oficial de Cumplimiento: ';
  cTexto2  := 'Se ha identificado una coincidencia de origen Tiempo Real, favor de revisar las coincidencias.';
  cTexto3  := '';


  cTextoEnvio := cHTMLHeader||
                 cTexto1||cSaltoLinea||cSaltoLinea||
                 cTexto2||cSaltoLinea||
                 cTexto3||cSaltoLinea||
                 vl_Tabulador||'RFC:  '||'<b style="color:'||PCOLOR||'";>'||PRFC||'</b>'||cSaltoLinea||cSaltoLinea||
                 vl_Tabulador||'NOMBRE:  '||'<b>'||PNOMBRE||'</b>'||cSaltoLinea||cSaltoLinea||

                 vl_Tabulador||'Listas de Coincidencia: '|| '<b>'||PORIGEN||'</b>'||cSaltoLinea||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||'Roles Detectados: '||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Amperson||vl_Tab||PASEGURADOS||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PBENEFICIARIOS||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PBENEFSIN||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PCLIENTES||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PEMPLEADOS||cSaltoLinea||
                 vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||vl_Tabulador||'<b>*</b>'||vl_Tabulador||vl_Tabulador||PPROVEEDORES||cSaltoLinea||cSaltoLinea||

                 vl_Tabulador||cURL||' '||cSaltoLinea||cSaltoLinea||
                 cTextoImagen||cSaltoLinea||
                 cHTMLFooter;   


  OC_MAIL.INIT_PARAM;
  OC_MAIL.cCtaEnvio    := cEmail;
  OC_MAIL.cPwdCtaEnvio := cPwdEmail;
  --
  -- ENVIO DE CORREO
  --
    BEGIN 

        IF PRIESGO = vl_AltoRiesgo THEN
            UPDATE SICAS_OC.PERSONA_NATURAL_JURIDICA
            SET ISVALIDPLD = 2, --PLD
                FECVALIDPLD = SYSDATE
            WHERE TIPO_DOC_IDENTIFICACION = 'RFC'
                AND NUM_DOC_IDENTIFICACION  = PRFC;
        END IF;

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
            vl_Cero  --P_ERROR
        );
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR EN EL ENVIO DE LA DENUNCIA '||PORIGEN||'-'||'-'||CNOM_ORIGEN_PLD||SQLERRM);              
    END;

    END CORREO_PLD_REALTIME;

PROCEDURE CORREO_PLD_ANONIMO( PFOLIO            IN VARCHAR2) IS 
    cEmail                       USUARIOS.EMAIL%TYPE;
cPwdEmail                    VARCHAR2(100);
cMiMail                      USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
cSaltoLinea                  VARCHAR2(5)      := '<br>';
cHTMLHeader                  VARCHAR2(2000)   := '<html>'                                                                     ||
                                                 '<head>'                                                                     ||
                                                 '<meta http-equiv="Content-Language" content="es/mx"/>'                      ||
                                                 '<meta http-equiv=”Content-Type” content=”text/html; charset=UTF-8? />'       ||
                                                 '<meta http-equiv="X-UA-Compatible">'                                          ||
                                                 '</head><body>'                                                              ||cSaltoLinea;
cHTMLFooter                 VARCHAR2(4000)    := '</body></html>';
cTextoAlignDerecha          VARCHAR2(50)     := '<P align="CENTER">';
cTextoAlignDerechaClose     VARCHAR2(50)     := '</P>';
cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
cTextoImagen_alterna        VARCHAR2(100)    := '<img src="D:/sicas/OficialdeCumplimiento.jpg" alt="imagen">';
cTextoImagen                VARCHAR2(100);
cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
cError                      VARCHAR2(4000);
nDummy                      VARCHAR2(4000);
nLeidos                     NUMBER := 0;
cSubject                    VARCHAR2(4000);
cTextoEnvio                 VARCHAR2(4000);
cURL                        VARCHAR2(4000);
cEmails                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cCtasEmail                  PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO%TYPE;
cTexto1                     VARCHAR2(4000);
cTexto2                     VARCHAR2(4000);
cTexto3                     VARCHAR2(4000);
vl_Amperson                 VARCHAR2(1):='&';
vl_Tab                      VARCHAR2(6):='ensp;';
CNOMUSUARIO        USUARIOS.NOMUSUARIO%TYPE;
vl_Cero             NUMBER := 0;
CNOM_ORIGEN_PLD    VALORES_DE_LISTAS.DESCVALLST%TYPE;
vl_Tabulador        VARCHAR2(100) := vl_Amperson||vl_Tab;

CURSOR cCuentas is
  SELECT *
    FROM VALORES_DE_LISTAS 
   WHERE CODLISTA = 'EMAILOPPRE'
     AND CODVALOR = 'OFICIA';

BEGIN
  --
  cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
  cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');

  BEGIN
                FOR I IN cCuentas LOOP
            cCtasEmail  := I.DESCVALLST||';';
          END LOOP;     
  END; 

  cSubject := 'Nueva denuncia anonima registrada';
  --
  cTexto1  := 'Estimado Oficial de Cumplimiento: ';
  cTexto2  := 'Le informamos que se ha asignado el Folio ('||PFOLIO ||') a una nueva denuncia recibida a través de nuestro sistema.';
  cTexto3  := 'Solicitamos iniciar la investigación correspondiente, asegurando el cumplimiento de los protocolos de confidencialidad y transparecnia.';


  cTextoEnvio := cHTMLHeader||
                 cTexto1||cSaltoLinea||cSaltoLinea||
                 cTexto2||cSaltoLinea||cSaltoLinea||
                 cTexto3||cSaltoLinea||

                 cSaltoLinea||cSaltoLinea||
                 cTextoImagen||cSaltoLinea||
                 cHTMLFooter;   


  OC_MAIL.INIT_PARAM;
  OC_MAIL.cCtaEnvio    := cEmail;
  OC_MAIL.cPwdCtaEnvio := cPwdEmail;
  --
  -- ENVIO DE CORREO
  --
  BEGIN 

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
            vl_Cero  --P_ERROR
        );

    COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR EN EL ENVIO DE LA DENUNCIA ANONIMA '||SQLERRM);              
    END;
END CORREO_PLD_ANONIMO;

PROCEDURE CORREO_RFC_ERRONEO( NOMBRE IN VARCHAR2, AP_PATERNO IN VARCHAR2, AP_MATERNO IN VARCHAR2, FECNACIM IN VARCHAR2, ERRORSQL IN VARCHAR2,PTIPO_DOC_IDENTIFICACION   IN VARCHAR,PNUM_DOC_IDENTIFICACION IN VARCHAR) IS 
    cEmail                       USUARIOS.EMAIL%TYPE;
    cPwdEmail                    VARCHAR2(100);
    cMiMail                      USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
    cSaltoLinea                  VARCHAR2(5)      := '<br>';
    cHTMLHeader                  VARCHAR2(2000)   := '<html>'                                                                     ||
                                                     '<head>'                                                                     ||
                                                     '<meta http-equiv="Content-Language" content="es/mx"/>'                      ||
                                                     '<meta http-equiv=”Content-Type” content=”text/html; charset=UTF-8? />'       ||
                                                     '<meta http-equiv="X-UA-Compatible">'                                          ||
                                                     '</head><body>'                                                              ||cSaltoLinea;
    cHTMLFooter                 VARCHAR2(4000)    := '</body></html>';
    cTextoAlignDerecha          VARCHAR2(50)     := '<P align="CENTER">';
    cTextoAlignDerechaClose     VARCHAR2(50)     := '</P>';
    cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
    cTextoImagen_alterna        VARCHAR2(100)    := '<img src="D:/sicas/OficialdeCumplimiento.jpg" alt="imagen">';
    cTextoImagen                VARCHAR2(100);
    cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
    cError                      VARCHAR2(4000);
    nDummy                      VARCHAR2(4000);
    nLeidos                     NUMBER := 0;
    cSubject                    VARCHAR2(4000);
    cTextoEnvio                 VARCHAR2(4000);
    cURL                        VARCHAR2(4000);
    cEmails                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
    cCtasEmail                  PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO%TYPE;
    cTexto1                     VARCHAR2(4000);
    cTexto2                     VARCHAR2(4000);
    cTexto3                     VARCHAR2(4000);
    cTexto4                     VARCHAR2(4000);
    cTexto5                     VARCHAR2(4000);
    vl_Amperson                 VARCHAR2(1):='&';
    vl_Tab                      VARCHAR2(6):='ensp;';
    CNOMUSUARIO        USUARIOS.NOMUSUARIO%TYPE;
    vl_Cero             NUMBER := 0;
    CNOM_ORIGEN_PLD    VALORES_DE_LISTAS.DESCVALLST%TYPE;
    vl_Tabulador        VARCHAR2(100) := vl_Amperson||vl_Tab;
    vl_RFC VARCHAR2(50);
    CURSOR cCuentas is
      SELECT *
        FROM VALORES_DE_LISTAS 
       WHERE CODLISTA = 'EMAILOPPRE'
         AND CODVALOR = 'OFICIA';

BEGIN
  --
  cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
  cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');

  BEGIN
    FOR I IN cCuentas LOOP
        cCtasEmail      := I.DESCVALLST||';';
    END LOOP;     
  END; 

  cSubject := 'Error al generar RFC';

  cTexto1  := 'Nombre    : '||NOMBRE;
  cTexto2  := 'Ap Paterno: '||AP_PATERNO;
  cTexto3  := 'Ap Materno: '||AP_MATERNO;
  cTexto4  := 'Fec Nacimiento: '||FECNACIM;
  cTexto5  := 'Error SQL: '||ERRORSQL;

  cTextoEnvio := cHTMLHeader||
                 cTexto1||cSaltoLinea||
                 cTexto2||cSaltoLinea||
                 cTexto3||cSaltoLinea||
                cTexto4||cSaltoLinea||
                cTexto5||cSaltoLinea||
                 cSaltoLinea||cSaltoLinea||
                 cTextoImagen||cSaltoLinea||
                 cHTMLFooter;   


  OC_MAIL.INIT_PARAM;
  OC_MAIL.cCtaEnvio    := cEmail;
  OC_MAIL.cPwdCtaEnvio := cPwdEmail;
  --
  -- ENVIO DE CORREO
  --
      BEGIN 

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
                vl_Cero  --P_ERROR
            );
    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR EN EL ENVIO DE ERROR AL GENERAR RFC'||SQLERRM);              
    END;

END CORREO_RFC_ERRONEO;

PROCEDURE CORREO_EJECUCION_HISTORICO( OPCION            IN NUMBER) IS 
    cEmail                       USUARIOS.EMAIL%TYPE;
cPwdEmail                    VARCHAR2(100);
cMiMail                      USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
cSaltoLinea                  VARCHAR2(5)      := '<br>';
cHTMLHeader                  VARCHAR2(2000)   := '<html>'                                                                     ||
                                                 '<head>'                                                                     ||
                                                 '<meta http-equiv="Content-Language" content="es/mx"/>'                      ||
                                                 '<meta http-equiv=”Content-Type” content=”text/html; charset=UTF-8? />'       ||
                                                 '<meta http-equiv="X-UA-Compatible">'                                          ||
                                                 '</head><body>'                                                              ||cSaltoLinea;
cHTMLFooter                 VARCHAR2(4000)    := '</body></html>';
cTextoAlignDerecha          VARCHAR2(50)     := '<P align="CENTER">';
cTextoAlignDerechaClose     VARCHAR2(50)     := '</P>';
cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
cTextoImagen_alterna        VARCHAR2(100)    := '<img src="D:/sicas/OficialdeCumplimiento.jpg" alt="imagen">';
cTextoImagen                VARCHAR2(100);
cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
cError                      VARCHAR2(4000);
nDummy                      VARCHAR2(4000);
nLeidos                     NUMBER := 0;
cSubject                    VARCHAR2(4000);
cTextoEnvio                 VARCHAR2(4000);
cURL                        VARCHAR2(4000);
cEmails                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cCtasEmail                  PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO%TYPE;
cTexto1                     VARCHAR2(4000);
cTexto2                     VARCHAR2(4000);
cTexto3                     VARCHAR2(4000);
vl_Amperson                 VARCHAR2(1):='&';
vl_Tab                      VARCHAR2(6):='ensp;';
CNOMUSUARIO        USUARIOS.NOMUSUARIO%TYPE;
vl_Cero             NUMBER := 0;
CNOM_ORIGEN_PLD    VALORES_DE_LISTAS.DESCVALLST%TYPE;
vl_Tabulador        VARCHAR2(100) := vl_Amperson||vl_Tab;

CURSOR cCuentas is
  SELECT *
    FROM VALORES_DE_LISTAS 
   WHERE CODLISTA = 'EMAILOPPRE'
     AND CODVALOR = 'OFICIA';

BEGIN
  --
  cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
  cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');

  BEGIN
                FOR I IN cCuentas LOOP
            cCtasEmail  := I.DESCVALLST||';';
          END LOOP;     
  END; 

    IF OPCION = 1 THEN --INICIO DEL PROCESO
      cSubject := 'Inicio de Ejecucion de Cruce Historico';
      --
      cTexto1  := 'Estimado Oficial de Cumplimiento: ';
      cTexto2  := 'Le informamos que el proceso de cruce histórico ha iniciado con éxito.';
    ELSIF OPCION = 2 THEN--FINALIZACIÓN DEL PROCESO
    cSubject := 'Fin de Ejecucion de Cruce Historico';
      --
      cTexto1  := 'Estimado Oficial de Cumplimiento: ';
      cTexto2  := 'Le informamos que el proceso de cruce histórico ha finalizado con éxito.';
    END IF;

  cTextoEnvio := cHTMLHeader||
                 cTexto1||cSaltoLinea||cSaltoLinea||
                 cTexto2||cSaltoLinea||cSaltoLinea||
                 cTexto3||cSaltoLinea||

                 cSaltoLinea||cSaltoLinea||
                 cTextoImagen||cSaltoLinea||
                 cHTMLFooter;   


  OC_MAIL.INIT_PARAM;
  OC_MAIL.cCtaEnvio    := cEmail;
  OC_MAIL.cPwdCtaEnvio := cPwdEmail;
  --
  -- ENVIO DE CORREO
  --
  BEGIN 

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
            vl_Cero  --P_ERROR
        );

    COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR EN EL ENVIO DE CRUCE HISTORICO '||SQLERRM);              
    END;

END CORREO_EJECUCION_HISTORICO;

END OC_RIESGOS_PLD;
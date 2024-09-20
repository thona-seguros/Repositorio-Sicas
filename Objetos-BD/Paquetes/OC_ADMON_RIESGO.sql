CREATE OR REPLACE PACKAGE OC_ADMON_RIESGO IS
--
-- BITACORA DE CAMBIOS7
--
-- CAMBIO SE QUITA LA VALIDACION DE -SI ES AGENTE-         JMMD   20200709
-- CAMBIO REGISTROS CNSF                                   ICO    20221228
-- CAMBIO PLD ALERTAS SE COLOCA FUNCION DE ENVIO DE CORREO ICO    07/03/2023 ALERTA
--
PROCEDURE VALIDA(P_CODCIA                  NUMBER,
                 P_CODEMPRESA              NUMBER,
                 P_ID_PROCESO              NUMBER,
                 P_IDPOLIZA                NUMBER,
                 P_CLIENTE                 NUMBER,
                 P_ASEGURADO               NUMBER,
                 P_ST_RESOLUCION           VARCHAR2,
                 P_TIPO_DOC_IDENTIFICACION VARCHAR2,
                 P_NUM_DOC_IDENTIFICACION  VARCHAR2,
                 P_OBSERVACIONES           VARCHAR2,
                 P_MENSAJE                 IN OUT VARCHAR2);

PROCEDURE INSERTA(P_CODCIA                  NUMBER,
                  P_CODEMPRESA              NUMBER,
                  P_ID_PROCESO              NUMBER,
                  P_IDPOLIZA                NUMBER,
                  P_CLIENTE                 NUMBER,
                  P_ASEGURADO               NUMBER,
                  P_ORIGEN                  VARCHAR2,
                  P_ST_RESOLUCION           VARCHAR2,
                  P_TIPO_DOC_IDENTIFICACION VARCHAR2,
                  P_NUM_DOC_IDENTIFICACION  VARCHAR2,
                  P_TP_RESOLUCION           VARCHAR2,
                  P_OBSERVACIONES           VARCHAR2);

PROCEDURE VALIDA_PERSONAS_POLIZA(P_IDPOLIZA   NUMBER,
                                 P_MENSAJE    IN OUT VARCHAR2);

PROCEDURE VALIDA_PERSONAS_ENDOSO(P_CODCIA     NUMBER,
                                 P_IDPOLIZA   NUMBER,
                                 P_ENDOSO     NUMBER,
                                 P_MENSAJE    IN OUT VARCHAR2);

FUNCTION EXISTE_POLIZA_PLD(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER) RETURN VARCHAR2;

PROCEDURE VALIDA_PERSONAS_LARGO_PLAZO(P_IDPOLIZA   NUMBER,
                                      P_MENSAJE    IN OUT VARCHAR2);

FUNCTION POLIZA_BLOQUEADA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER) RETURN VARCHAR2;

END OC_ADMON_RIESGO;
/
CREATE OR REPLACE PACKAGE BODY OC_ADMON_RIESGO IS
--
-- BITACORA DE CAMBIO
-- ALTA   JICO 20170518
-- CAMBIO JICO 20170628 PARAMETRIZACION DE ESTATUS
-- CAMBIO JICO 20170814 SE AGREGO LA BUSQUEDA POR TIPO DE SEGURO
-- CAMBIO JICO 20170901 SE AGREGO LA FUNCIONALIDAD DE ENDOSOS
-- CAMBIO JICO 20190809 SE AGREGO LA FUNCIONALIDAD DE AÑOS SUBSECUENTES LARGO PLAZO
-- CAMBIO JMMD 20200709 SE QUITA LA VALIDACION DE -SI ES AGENTE-
--
PROCEDURE VALIDA(P_CODCIA                  NUMBER,
                 P_CODEMPRESA              NUMBER,
                 P_ID_PROCESO              NUMBER,
                 P_IDPOLIZA                NUMBER,
                 P_CLIENTE                 NUMBER,
                 P_ASEGURADO               NUMBER,
                 P_ST_RESOLUCION           VARCHAR2,
                 P_TIPO_DOC_IDENTIFICACION VARCHAR2,
                 P_NUM_DOC_IDENTIFICACION  VARCHAR2,
                 P_OBSERVACIONES           VARCHAR2,
                 P_MENSAJE                 IN OUT VARCHAR2
                 ) IS
--
P_TP_RESOLUCION   ADMON_RIESGO.TP_RESOLUCION%TYPE := '';
W_MENSAJE         VARCHAR2(300);
CCODACTIVIDAD     PERSONA_NATURAL_JURIDICA.CODACTIVIDAD%TYPE;
P_IDTIPOSEG       TIPOS_DE_SEGUROS.IDTIPOSEG%TYPE;
CCODPAIS          PAIS.CODPAIS%TYPE;
CNOMPAIS          PAIS.DESCPAIS%TYPE;
CCODESTADO        DISTRITO.CODESTADO%TYPE;
CCODCIUDAD        DISTRITO.CODCIUDAD%TYPE;
CNOMCIUDAD        DISTRITO.DESCCIUDAD%TYPE;
--
BEGIN
  --
  W_MENSAJE := '';
  --
  BEGIN
    SELECT D.IDTIPOSEG
      INTO P_IDTIPOSEG
      FROM DETALLE_POLIZA D
     WHERE D.IDPOLIZA = P_IDPOLIZA
       AND D.CODCIA   = P_CODCIA
       AND D.IDETPOL  = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         NULL;
    WHEN OTHERS THEN
         NULL;
  END;
  --
  BEGIN
    SELECT PNJ.CODPAISRES,
           OC_PAIS.NOMBRE_PAIS(PNJ.CODPAISRES) NOM_PAIS,
           PNJ.CODPROVRES,
           PNJ.CODDISTRES,
           OC_DISTRITO.NOMBRE_DISTRITO(PNJ.CODPAISRES,PNJ.CODPROVRES,PNJ.CODDISTRES) NOM_CIUDAD
      INTO CCODPAIS, 
           CNOMPAIS,
           CCODESTADO,
           CCODCIUDAD,
           CNOMCIUDAD 
      FROM PERSONA_NATURAL_JURIDICA PNJ,
           PAIS P
     WHERE PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
       AND PNJ.NUM_DOC_IDENTIFICACION  = P_NUM_DOC_IDENTIFICACION;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         NULL;
    WHEN OTHERS THEN
         NULL;
  END;
  --
  -- VALIDA SI ES EMPLEADO
  --
  IF OC_EMPLEADOS_FUNCIONARIOS.ES_EMPLEADO_FUNCIONARIO(P_CODCIA , P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO.INSERTA(P_CODCIA,
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
                             );
     W_MENSAJE := '!! ALERTA !!   LA PERSONA ES EMPLEADO  - ENVIADO A AUTORIZACION ';
  END IF;
  --
  -- VALIDA SI ESTA EN LISTA DE REFERENCIA
  --
  IF OC_PERSONA_NATURAL_JURIDICA.EN_LISTA_DE_REFERENCIA(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO.INSERTA(P_CODCIA,
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
                            );
     W_MENSAJE := '!! ALERTA !!   LA PERSONA ESTA EN LISTA DE REFERENCIA  - ENVIADO A AUTORIZACION ';
   END IF;
  --
  -- VALIDA SI ES AGENTE
  --
  -- JMMD SE ELIMINA ESTA VALIDACIÓN POR ACUERDO EN REUNION CON LA DIRECCION GENERAL EL DIA 08/07/2020 SOLICITO SR. SAAVEDRA
/*  IF OC_AGENTES.ES_AGENTE(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO.INSERTA(P_CODCIA,
                             P_CODEMPRESA,
                             P_ID_PROCESO,
                             P_IDPOLIZA,
                             P_CLIENTE,
                             P_ASEGURADO,
                             'AGENTE',
                             P_ST_RESOLUCION,
                             P_TIPO_DOC_IDENTIFICACION,
                             P_NUM_DOC_IDENTIFICACION,
                             P_TP_RESOLUCION,
                             P_OBSERVACIONES
                            );
     W_MENSAJE := '!! ALERTA !!  LA PERSONA ES AGENTE - ENVIADO A AUTORIZACION  - ENVIADO A AUTORIZACION ';
  END IF;  */
  --
  -- VALIDA SI ES CLIENTE DE ALTO RIESGO
  --
  IF OC_CLIENTES.ES_CLIENTE_ALTO(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO.INSERTA(P_CODCIA,
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
                            );
     W_MENSAJE := '!! ALERTA !!  LA PERSONA ES CLIENTE DE RIESGO  - ENVIADO A AUTORIZACION ';
  END IF;
  --
  -- VALIDA SI LA ACTIVIDAD ES DE ALTO RIESGO
  --
  CCODACTIVIDAD := OC_PERSONA_NATURAL_JURIDICA.ACTIVIDAD(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION);
  --
  IF OC_ACTIVIDADES_ECONOMICAS.TIPORIESGO(cCodActividad) = 'ALTO' THEN
     OC_ADMON_RIESGO.INSERTA(P_CODCIA,
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
                            );
     W_MENSAJE := '!! ALERTA !!   LA PERSONA ES CLIENTE CON ACTIVIDAD DE RIESGO  - ENVIADO A AUTORIZACION ';
  END IF;
  --
  -- VALIDA SI ES QUIEN ES QUIEN
  --
  IF OC_CAT_QEQ.ES_QEQ(P_TIPO_DOC_IDENTIFICACION,P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO.INSERTA(P_CODCIA,
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
                            );
     W_MENSAJE := '!! ALERTA !!   LA PERSONA ESTA EN QUIEN ES QUIEN  - ENVIADO A AUTORIZACION ';
  END IF;
  --
  -- VALIDA SI ES DE UNA LISTA DE LA CNSF
  --
  IF OC_PLD_LISTAS_CNSF.ES_LISTA_CNSF(P_TIPO_DOC_IDENTIFICACION,P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO.INSERTA(P_CODCIA,
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
                            );
     W_MENSAJE := '!! ALERTA !!   LA PERSONA ESTA EN UNA LISTA NEGRA DE LA CNSF - ENVIADO A AUTORIZACION ';
  END IF;
  --
  -- VALIDA SI ES TIPO DE SEGURO SE ALTO RIESGO
  --
  IF OC_TIPOS_DE_SEGUROS.ES_PRODUCTO_ALTO(P_IDTIPOSEG) = 'S' THEN
     OC_ADMON_RIESGO.INSERTA(P_CODCIA,
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
     W_MENSAJE := '!! ALERTA !!   EL PRODUCTO ES DE ALTO RIESGO - ENVIADO A AUTORIZACION ';
  END IF;
   --
   -- VALIDA SI ES PAIS DE ALTO RIESGO  SOLO REGISTRA
   --
   IF OC_PAIS.ES_PAIS_ALTO_RIESGO(CCODPAIS) = 'S' THEN
              OC_ADMON_ACTIVI.INSERTA(P_CODCIA,       -- P_CODCIA          NUMBER,
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
                                P_NUM_DOC_IDENTIFICACION   -- P_NUM_DOC_IDENTIFICACION	VARCHAR2	     
                               );      
   END IF;
   --
   -- VALIDA SI ES CIUDAD DE ALTO RIESGO  SOLO REGISTRA
   --  
   IF OC_DISTRITO.ES_CIUDAD_ALTO_RIESGO(CCODPAIS, CCODESTADO, CCODCIUDAD) = 'S' THEN
              OC_ADMON_ACTIVI.INSERTA(P_CODCIA,       -- P_CODCIA          NUMBER,
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
                                P_NUM_DOC_IDENTIFICACION   -- P_NUM_DOC_IDENTIFICACION	VARCHAR2	     
                               );      
   END IF;
  --
  -- CAMBIO ST DE POLIZAS
  -- SE COMENTO ESTE PEDAZO DE CODIGO PARA QUE NO ACTUALICE LOS STATUS DE POLIZA,ENDOSO Y  LARGO PLAZO EN PLD YA QUE ES UN PROCESO NOCTURNO ARH 18/09/2024
  /*IF W_MENSAJE IS NOT NULL THEN
     IF P_ST_RESOLUCION = 'PEND' THEN  -- ORIGEN POLIZA
        UPDATE POLIZAS
           SET STSPOLIZA      = 'PLD',
               PLDSTBLOQUEADA = 'S'
         WHERE IDPOLIZA  = P_IDPOLIZA
           AND CODCIA    = P_CODCIA
           AND STSPOLIZA IN ('SOL','XRE');
     END IF;
     IF P_ST_RESOLUCION = 'PENT' THEN  -- ORIGEN ENDOSOS
        UPDATE ENDOSOS
           SET STSENDOSO      = 'PLD',
               PLDSTBLOQUEADA = 'S'
         WHERE IDPOLIZA  = P_IDPOLIZA
           AND IDENDOSO  = P_CLIENTE
           AND STSENDOSO IN ('SOL');
     END IF;
     IF P_ST_RESOLUCION = 'PENC' THEN  -- ORIGEN LARGO PLAZO
        UPDATE RENO_CTRL R
           SET ST_RENOVA      = 'PLD',
               PLDSTBLOQUEADA = 'S'
         WHERE R.ID_POLIZA  = P_IDPOLIZA
           AND R.ST_RENOVA = 'PEN';
     END IF;
     --
     P_MENSAJE := W_MENSAJE;
     --
     COMMIT;
     --
  END IF;*/
  P_MENSAJE := W_MENSAJE;
     --
  COMMIT;
  --
END VALIDA;


PROCEDURE INSERTA(P_CODCIA                  NUMBER,
                  P_CODEMPRESA              NUMBER,
                  P_ID_PROCESO              NUMBER,
                  P_IDPOLIZA                NUMBER,
                  P_CLIENTE                 NUMBER,
                  P_ASEGURADO               NUMBER,
                  P_ORIGEN                  VARCHAR2,
                  P_ST_RESOLUCION           VARCHAR2,
                  P_TIPO_DOC_IDENTIFICACION VARCHAR2,
                  P_NUM_DOC_IDENTIFICACION  VARCHAR2,
                  P_TP_RESOLUCION           VARCHAR2,
                  P_OBSERVACIONES           VARCHAR2) IS
--
 W_NOMBRE     ADMON_RIESGO.NOMBRE%TYPE;
 W_USUARIO    VARCHAR2(15);
 W_ERRORENVIO VARCHAR2(2000);
--
BEGIN
  --
  SELECT USER
    INTO W_USUARIO
    FROM DUAL;
  --
  W_NOMBRE := OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION);
  --
  --INSERTA ADMON_RIESGO
  --
  INSERT INTO ADMON_RIESGO
    (CODEMPRESA,                          CODCIA,
     ID_PROCESO,                          IDPOLIZA,
     STSPOLIZA,                           CODCLIENTE,
     CODASEGURADO,
     ORIGEN,                              TIPO_DOC_IDENTIFICACION,
     NUM_DOC_IDENTIFICACION,              NOMBRE,
     ST_RESOLUCION,                       FE_ESTATUS,
     TP_RESOLUCION,                       OBSERVACIONES,
     FECHA_PROCESO,                       USUARIO
    )
    VALUES
    (P_CODEMPRESA,                        P_CODCIA,
     P_ID_PROCESO,                        P_IDPOLIZA,
     'N/A',                               P_CLIENTE,
     P_ASEGURADO,
     P_ORIGEN,                            P_TIPO_DOC_IDENTIFICACION,
     P_NUM_DOC_IDENTIFICACION,            W_NOMBRE,
     P_ST_RESOLUCION,                     SYSDATE,
     P_TP_RESOLUCION,                     P_OBSERVACIONES,
     TRUNC(SYSDATE),                      W_USUARIO
    );
  --
  --INSERTA ADMON_RIESGO_H
  --
  OC_ADMON_RIESGO_H.INSERTA(P_CODCIA,
                            P_CODEMPRESA,
                            P_ID_PROCESO,
                            P_IDPOLIZA,
                            P_CLIENTE,
                            P_ASEGURADO,
                            P_ORIGEN,
                            P_ST_RESOLUCION,
                            P_TP_RESOLUCION);

  -- ALERTA
  ENVIA_CORREO_REPORTE_PLD('EMISION', --PORIGEN
                           0,         --PIDSINIESTRO
                           P_IDPOLIZA,
                           P_ASEGURADO,
                           P_ORIGEN,
                           0,
                           W_ERRORENVIO);
  --
END INSERTA;
--


PROCEDURE VALIDA_PERSONAS_POLIZA(P_IDPOLIZA   NUMBER,
                                 P_MENSAJE    IN OUT VARCHAR2) IS
MENSAJE VARCHAR2(1000);
--
CURSOR POLIZA IS
-- CLIENTE
SELECT P.CODCIA CIA,
       P.CODCIA EMPRESA,
       P.IDPOLIZA,
       C.TIPO_DOC_IDENTIFICACION,
       C.NUM_DOC_IDENTIFICACION,
       P.CODCLIENTE CODCLIENTE,
       0 COD_ASEGURADO
  FROM POLIZAS   P,
       CLIENTES  C
 WHERE P.IDPOLIZA = P_IDPOLIZA
   --
   AND C.CODCLIENTE = P.CODCLIENTE
--
UNION
-- ASEGURADO POLIZA
SELECT AC.CODCIA CIA,
       AC.CODCIA EMPRESA,
       AC.IDPOLIZA,
       A.TIPO_DOC_IDENTIFICACION,
       A.NUM_DOC_IDENTIFICACION,
       0 CODCLIENTE,
       AC.COD_ASEGURADO COD_ASEGURADO
  FROM ASEGURADO_CERTIFICADO AC,
       ASEGURADO             A
 WHERE AC.CODCIA   = 1
   AND AC.IDPOLIZA = P_IDPOLIZA
   --
   AND A.COD_ASEGURADO = AC.COD_ASEGURADO
--
UNION
-- ASEGURADO CERTIFICADO
SELECT DP.CODCIA CIA,
       DP.CODCIA EMPRESA,
       DP.IDPOLIZA,
       A.TIPO_DOC_IDENTIFICACION,
       A.NUM_DOC_IDENTIFICACION,
       0 CODCLIENTE,
       DP.COD_ASEGURADO COD_ASEGURADO
  FROM DETALLE_POLIZA DP,
       ASEGURADO             A
 WHERE DP.CODCIA   = 1
   AND DP.IDPOLIZA = P_IDPOLIZA
   --
   AND A.COD_ASEGURADO = DP.COD_ASEGURADO
   --
 ORDER BY 7,6
;

BEGIN
  --
  FOR S IN POLIZA LOOP
      MENSAJE:= '';
      OC_ADMON_RIESGO.VALIDA(S.CIA,
                             S.EMPRESA,
                             1,  --ES EL P_ID_PROCESO
                             S.IDPOLIZA,
                             S.CODCLIENTE,
                             S.COD_ASEGURADO,
                             'PEND',
                             S.TIPO_DOC_IDENTIFICACION,
                             S.NUM_DOC_IDENTIFICACION,
                             'POLIZA      - ',
                             MENSAJE
                            );
      --
      IF MENSAJE IS NOT NULL THEN
         P_MENSAJE := MENSAJE;
      END IF;
      --
  END LOOP;
END VALIDA_PERSONAS_POLIZA;


PROCEDURE VALIDA_PERSONAS_ENDOSO(P_CODCIA     NUMBER,
                                 P_IDPOLIZA   NUMBER,
                                 P_ENDOSO     NUMBER,
                                 P_MENSAJE    IN OUT VARCHAR2) IS
MENSAJE VARCHAR2(1000);
--
CURSOR ENDOSO IS
SELECT AC.CODCIA CIA,
       AC.CODCIA EMPRESA,
       AC.IDPOLIZA,
       AC.IDENDOSO,
       A.TIPO_DOC_IDENTIFICACION,
       A.NUM_DOC_IDENTIFICACION,
       AC.COD_ASEGURADO COD_ASEGURADO
  FROM ASEGURADO_CERTIFICADO AC,
       ASEGURADO             A
 WHERE AC.CODCIA   = P_CODCIA
   AND AC.IDPOLIZA = P_IDPOLIZA
   AND AC.IDENDOSO = P_ENDOSO
   --
   AND A.COD_ASEGURADO = AC.COD_ASEGURADO
;
BEGIN
  --
  FOR E IN ENDOSO LOOP
      MENSAJE:= '';
      OC_ADMON_RIESGO.VALIDA(E.CIA,
                             E.EMPRESA,
                             1,
                             E.IDPOLIZA,
                             E.IDENDOSO,
                             E.COD_ASEGURADO,
                             'PENT',
                             E.TIPO_DOC_IDENTIFICACION,
                             E.NUM_DOC_IDENTIFICACION,
                             'ENDOSO      - '||E.IDENDOSO,
                             MENSAJE
                            );
      --
      IF MENSAJE IS NOT NULL THEN
         P_MENSAJE := MENSAJE;
      END IF;
      --
  END LOOP;
END VALIDA_PERSONAS_ENDOSO;

FUNCTION EXISTE_POLIZA_PLD(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER) RETURN VARCHAR2 IS
cExiste VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM ADMON_RIESGO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND St_Resolucion = 'PEND';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN cExiste;
END EXISTE_POLIZA_PLD;


PROCEDURE VALIDA_PERSONAS_LARGO_PLAZO(P_IDPOLIZA   NUMBER,
                                      P_MENSAJE    IN OUT VARCHAR2) IS
MENSAJE VARCHAR2(1000);
--
CURSOR POLIZA IS
-- CLIENTE
SELECT P.CODCIA CIA,
       P.CODCIA EMPRESA,
       P.IDPOLIZA,
       C.TIPO_DOC_IDENTIFICACION,
       C.NUM_DOC_IDENTIFICACION,
       P.CODCLIENTE CODCLIENTE,
       0 COD_ASEGURADO
  FROM POLIZAS   P,
       CLIENTES  C
 WHERE P.IDPOLIZA = P_IDPOLIZA
   --
   AND C.CODCLIENTE = P.CODCLIENTE
--
UNION
-- ASEGURADO POLIZA
SELECT AC.CODCIA CIA,
       AC.CODCIA EMPRESA,
       AC.IDPOLIZA,
       A.TIPO_DOC_IDENTIFICACION,
       A.NUM_DOC_IDENTIFICACION,
       0 CODCLIENTE,
       AC.COD_ASEGURADO COD_ASEGURADO
  FROM ASEGURADO_CERTIFICADO AC,
       ASEGURADO             A
 WHERE AC.CODCIA   = 1
   AND AC.IDPOLIZA = P_IDPOLIZA
   --
   AND A.COD_ASEGURADO = AC.COD_ASEGURADO
--
UNION
-- ASEGURADO CERTIFICADO
SELECT DP.CODCIA CIA,
       DP.CODCIA EMPRESA,
       DP.IDPOLIZA,
       A.TIPO_DOC_IDENTIFICACION,
       A.NUM_DOC_IDENTIFICACION,
       0 CODCLIENTE,
       DP.COD_ASEGURADO COD_ASEGURADO
  FROM DETALLE_POLIZA DP,
       ASEGURADO             A
 WHERE DP.CODCIA   = 1
   AND DP.IDPOLIZA = P_IDPOLIZA
   --
   AND A.COD_ASEGURADO = DP.COD_ASEGURADO
   --
 ORDER BY 7,6
;

BEGIN
  --
  FOR S IN POLIZA LOOP
      MENSAJE:= '';
      OC_ADMON_RIESGO.VALIDA(S.CIA,
                             S.EMPRESA,
                             1,  --ES EL P_ID_PROCESO
                             S.IDPOLIZA,
                             S.CODCLIENTE,
                             S.COD_ASEGURADO,
                             'PENC',
                             S.TIPO_DOC_IDENTIFICACION,
                             S.NUM_DOC_IDENTIFICACION,
                             'LARGO_PLAZO - ',
                             MENSAJE
                            );
      --
      IF MENSAJE IS NOT NULL THEN
         P_MENSAJE := MENSAJE;
      END IF;
      --
  END LOOP;
END VALIDA_PERSONAS_LARGO_PLAZO;

FUNCTION POLIZA_BLOQUEADA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER) RETURN VARCHAR2 IS
cExiste VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM ADMON_RIESGO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND St_Resolucion = 'BLOQ';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN cExiste;
END POLIZA_BLOQUEADA;

END OC_ADMON_RIESGO;
/

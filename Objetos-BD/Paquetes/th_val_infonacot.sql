--
-- TH_VAL_INFONACOT  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_OUTPUT (Synonym)
--   OC_APROBACIONES (Package)
--   INFO_ALTBAJ (Table)
--   INFO_SINIESTRO (Table)
--   POLIZAS (Table)
--   DATOS_PART_EMISION (Table)
--   APROBACIONES (Table)
--   COBERTURA_SINIESTRO (Table)
--   COBERT_ACT (Table)
--   TB_AMORTI (Table)
--   OC_COBERTURA_SINIESTRO (Package)
--   DETALLE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.TH_VAL_INFONACOT IS

PROCEDURE VALIDA_EMISION(P_FECHA_CARGA DATE);
--
PROCEDURE DEVUELVE_SIN_INFONACOT(P_ID_CREDITO     NUMBER,     -- INICIO   INFODEV
                                 P_ID_TRABAJADOR  NUMBER,
                                 P_ID_ENVIO       NUMBER,
                                 P_IMPORTE        NUMBER,
                                 P_ID_ASEGURADORA NUMBER,
                                 P_MENSAJE_ERROR OUT VARCHAR2);
--

PROCEDURE VALIDA_SUMASEG_INFONACOT(P_POLIZA_INFO       VARCHAR2,
                                   P_MENSAJE_ERROR OUT VARCHAR2);
--
END TH_VAL_INFONACOT;
/

--
-- TH_VAL_INFONACOT  (Package Body) 
--
--  Dependencies: 
--   TH_VAL_INFONACOT (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.TH_VAL_INFONACOT IS
--
-- CREACION     19/04/2016                                                        -- JICO
-- MODIFICACION 06/09/2016                                                        -- JICO
-- MODIFICACION 18/10/2016  SE AGREGO PROCEDIEMTO DE VALIDA_SUMASEG_INFONACOT     -- JICO
-- MODIFICACION 23/11/2016  INCERCION DE REGLAS EN VALIDACION DE EMISION          -- JICO VALSIN
-- MODIFICACION 07/08/2017  GRABADO FINAL DE IMPORTES DE POLIZA                   -- JICO INSPOL
-- MODIFICACION 22/02/2018  CAMBIO  DE PLANTILLA                                  -- JICO INFO1
-- MODIFICACION 11/06/2018  REESTRUCTURA REGLAS                                   -- JICO INFREG
-- MODIFICACION 02/08/2018  REESTRUCTURA DE REGLA 4                               -- JICO INFREG4
--
PROCEDURE VALIDA_EMISION(P_FECHA_CARGA DATE) IS
BEGIN
DECLARE
  W_EXISTE NUMBER;
  W_ERROR  NUMBER;
  W_CUOTAS NUMBER;
  W_CUOTAS_PAGADAS NUMBER;
  W_SUM_ASEG_DESEMPLEO  NUMBER;
  --
  W_FE_INICIO         INFO_ALTBAJ.FE_INICIO%TYPE;
  W_FE_FIN_3MESES     INFO_ALTBAJ.FE_INICIO%TYPE;
  W_NOMBRE            INFO_ALTBAJ.NOMBRE%TYPE;
  W_PATERNO           INFO_ALTBAJ.PATERNO%TYPE;
  W_MATERNO           INFO_ALTBAJ.MATERNO%TYPE;
  W_FE_NACIMIENTO     INFO_ALTBAJ.FE_NACIMIENTO%TYPE;
  W_IDPOLIZA          INFO_ALTBAJ.IDPOLIZA%TYPE;
  W_IDETPOL           INFO_ALTBAJ.IDETPOL%TYPE;
  W_CUOTA             INFO_ALTBAJ.CUOTA%TYPE;
  W_FECHA_SIN_INI     INFO_SINIESTRO.FECHA_BAJA%TYPE;
  W_FECHA_SIN_MESANT  INFO_SINIESTRO.FECHA_BAJA%TYPE;
  W_DIFERENCIA        NUMBER := 2;
  W_DIFERENCIA_CALC   NUMBER;
  W_SINIESTRO         INFO_SINIESTRO.SINIESTRO%TYPE;
  --
  W_REGISTROS NUMBER;
  --
CURSOR POLITICAS IS
 SELECT ID_CODCIA,
        NU_REMESA,
        ID_CREDITO,
        ID_TRABAJADOR,
        TRIM(PATERNO) PATERNO,
        TRIM(MATERNO) MATERNO,
        TRIM(NOMBRE) NOMBRE,
        TRIM(SEGUNDO_NOMBRE) SEGUNDO_NOMBRE,
        FE_NACIMIENTO,
        SEXO,
        IMPORTE,
        COBERTURA,
        FECHA_BAJA,
        FE_CARGA,
        ADD_MONTHS(FE_CARGA,-1) FE_CARGA_ANT,
        ID_ENVIO
   FROM INFO_SINIESTRO ISI
  WHERE ISI.FE_CARGA = P_FECHA_CARGA
;
--
BEGIN
  --
  W_REGISTROS := 0;
  W_EXISTE    := 0;
  FOR I IN POLITICAS LOOP
      --
      -- REGLA 1 QUE EXISTA CREDITO
      --
      W_EXISTE := 0;
      W_ERROR  := 0;
      W_CUOTAS := 0;
      W_CUOTAS_PAGADAS := 0;
      W_SINIESTRO := 0;
      --
      BEGIN
        SELECT IA.FE_INICIO,
               ADD_MONTHS(ADD_MONTHS(IA.FE_INICIO,IA.PLAZO),3),
               TRIM(IA.NOMBRE),
               TRIM(IA.PATERNO),
               TRIM(IA.MATERNO),
               IA.FE_NACIMIENTO,
               IA.IDPOLIZA,
               IA.IDETPOL,
               IA.CUOTA
          INTO W_FE_INICIO,
               W_FE_FIN_3MESES,
               W_NOMBRE,
               W_PATERNO,
               W_MATERNO,
               W_FE_NACIMIENTO,
               W_IDPOLIZA,
               W_IDETPOL,
               W_CUOTA
          FROM INFO_ALTBAJ IA
         WHERE IA.ID_CREDITO    = I.ID_CREDITO
           AND IA.ID_TRABAJADOR = I.ID_TRABAJADOR;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             W_ERROR  := 22;
             W_EXISTE := 1;
        WHEN OTHERS THEN
             W_ERROR  := 22;
             W_EXISTE := 1;
      END;
      --
      -- REGLA 2 QUE EL SINIESTRO ESTE EN LA VIGENCIA DE LA POLIZA
      --
      IF W_EXISTE = 0 THEN
         BEGIN
           SELECT 0
             INTO W_EXISTE
             FROM INFO_ALTBAJ IA
            WHERE IA.ID_CREDITO    = I.ID_CREDITO
              AND IA.ID_TRABAJADOR = I.ID_TRABAJADOR
              AND I.FECHA_BAJA     BETWEEN IA.FE_INICIO
                                       AND ADD_MONTHS(IA.FE_INICIO,IA.PLAZO);
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                W_ERROR  := 30;
                W_EXISTE := 1;
           WHEN OTHERS THEN
                W_ERROR  := 30;
                W_EXISTE := 1;
         END;
      END IF;
      --
      -- OBTIENE NUMERO DE CUOTAS
      --
      BEGIN
        SELECT MAX(ISI.MENSUALIDAD)
          INTO W_CUOTAS
          FROM INFO_SINIESTRO ISI
         WHERE ISI.ID_CREDITO     = I.ID_CREDITO
           AND ISI.ID_TRABAJADOR  = I.ID_TRABAJADOR;
      END;
      -- INI INFREG4
      -- EXTRAE SINIESTRO
      --  
      BEGIN
        SELECT DISTINCT(S.SINIESTRO)
          INTO W_SINIESTRO
          FROM INFO_SINIESTRO S
         WHERE S.ID_CREDITO        = I.ID_CREDITO
           AND S.ID_TRABAJADOR     = I.ID_TRABAJADOR
           AND NVL(S.SINIESTRO,0) != 0;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             W_SINIESTRO := 0;
        WHEN OTHERS THEN
             W_SINIESTRO := 0;
      END;           
      --
      W_CUOTAS_PAGADAS := 0;
      --
      IF W_SINIESTRO != 0 THEN
         BEGIN
           SELECT COUNT(*)
             INTO W_CUOTAS_PAGADAS
             FROM APROBACIONES A
            WHERE A.IDSINIESTRO   = W_SINIESTRO
              AND A.STSAPROBACION = 'PAG';           
         END;
      END IF;
      -- 
      -- REGLA 4 VALIDAR QUE NO SE EXCEDAN DE 6 PAGOS
      --
      IF W_EXISTE = 0 THEN
        IF W_CUOTAS_PAGADAS > 6 THEN
           W_ERROR  := 25;
           W_EXISTE := 1;
        END IF;
      END IF;     
      -- FIN INFREG4
      -- REGLA 5 VALIDAR FECHA DE OCURRIDO DEL SINIESTRO VS FECHA DE INICIO DEL CREDITO
      --
      IF W_EXISTE = 0 THEN
         IF I.FECHA_BAJA - W_FE_INICIO < 62  THEN
            W_EXISTE := 1;
            W_ERROR  := 35;
         END IF;
      END IF;      
      --
      -- REGLA 8 VALIDAR FECHA DE RECLAMACION VS FECHA DE OCURRIDO
      --
      IF W_EXISTE = 0 THEN
         IF W_FE_INICIO < '08/02/2016' THEN
            IF I.FE_CARGA - I.FECHA_BAJA < 62  THEN
               W_EXISTE := 1;
               W_ERROR  := 31;
            END IF;
         END IF;
      END IF;
      --
      -- REGLA 12 VALIDAR FECHA DE NOTIFICACION VS FECHA DE OCURRIDO
      --
      IF W_EXISTE = 0 THEN
         IF I.FE_CARGA < I.FECHA_BAJA  THEN
               W_EXISTE := 1;
               W_ERROR  := 39;
            END IF;
      END IF;
      --
      -- REGLA 10 VALIDAR LA SECUENCIA DE RECLAMOS
      --
      IF W_EXISTE = 0 THEN
         --
         IF W_CUOTAS > 1 THEN
            BEGIN
              SELECT MAX(ISI.FE_CARGA)
                INTO W_FECHA_SIN_MESANT
                FROM INFO_SINIESTRO ISI
               WHERE ISI.ID_CREDITO     = I.ID_CREDITO
                 AND ISI.ID_TRABAJADOR  = I.ID_TRABAJADOR
                 AND ISI.FE_CARGA       < P_FECHA_CARGA;
            EXCEPTION
              WHEN OTHERS THEN
                   W_FECHA_SIN_MESANT := I.FE_CARGA_ANT;
            END;
            IF TO_CHAR(W_FECHA_SIN_MESANT,'YYYYMM') != TO_CHAR(I.FE_CARGA_ANT,'YYYYMM') THEN
               W_EXISTE := 1;
               W_ERROR  := 33;
            END IF;
         END IF;
      END IF;
      --
      -- REGLA 3 PARA LA COBERTURA DE DESEMPLEO VALIDA EL IMPORTE RECLAMADO VS LA CUOTA
      --
      IF W_EXISTE = 0 THEN
         BEGIN
         SELECT SUM_ASEG_DESEMPLEO
           INTO W_SUM_ASEG_DESEMPLEO
           FROM TB_AMORTI TA
          WHERE ID_CODCIA     = I.ID_CODCIA
            AND ID_CREDITO    = I.ID_CREDITO
            AND ID_TRABAJADOR = I.ID_TRABAJADOR
            AND TO_CHAR(TA.MESVERSARIO,'MM/YYYY') = TO_CHAR(I.FECHA_BAJA,'MM/YYYY');
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                BEGIN
                 SELECT SUM_ASEG_DESEMPLEO
                   INTO W_SUM_ASEG_DESEMPLEO
                   FROM TB_AMORTI TA
                  WHERE ID_CODCIA     = I.ID_CODCIA
                    AND ID_CREDITO    = I.ID_CREDITO
                    AND ID_TRABAJADOR = I.ID_TRABAJADOR
                    AND TO_CHAR(ADD_MONTHS(TA.MESVERSARIO,1),'MM/YYYY') = TO_CHAR(I.FECHA_BAJA,'MM/YYYY');
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                       W_ERROR  := 32;
                       W_EXISTE := 1;
                       --
                  WHEN OTHERS THEN
                       W_ERROR  := 32;
                       W_EXISTE := 1;
                END;
           WHEN OTHERS THEN
                W_ERROR  := 32;
                W_EXISTE := 1;
         END;
         IF W_EXISTE = 0 THEN
            W_DIFERENCIA_CALC := I.IMPORTE - W_CUOTA;
            IF W_DIFERENCIA_CALC != 0 THEN
               IF W_DIFERENCIA_CALC <= W_DIFERENCIA AND
                  W_DIFERENCIA_CALC >= (W_DIFERENCIA * -1) THEN
                  NULL;
               ELSE
                  W_ERROR := 24;
                  W_EXISTE := 1;
               END IF;
            END IF;
         END IF;
      END IF;
      -- 
      -- REGLA 11 VALIDAR LA FECHA DE OCURRIDO DEL SINIESTRO
      --
      IF W_EXISTE = 0 THEN
         --
         IF W_CUOTAS > 1 THEN
            BEGIN
              SELECT DISTINCT(ISI.FECHA_BAJA)
                INTO W_FECHA_SIN_INI
               FROM INFO_SINIESTRO ISI
               WHERE ISI.ID_CREDITO   = I.ID_CREDITO
                AND ISI.ID_TRABAJADOR = I.ID_TRABAJADOR
                AND ISI.MENSUALIDAD   = 1;
            EXCEPTION
              WHEN OTHERS THEN
                   W_FECHA_SIN_INI := I.FECHA_BAJA;
            END;
            --
            IF W_FECHA_SIN_INI != I.FECHA_BAJA THEN
               W_EXISTE := 1;
               W_ERROR  := 34;
            END IF;
         END IF;
      END IF;
      --
      -- REGLA 6 VALIDAR NOMBRE Y APELLIDOS VS EMISION
      --
      IF W_EXISTE = 0 THEN
         IF NVL(W_NOMBRE,'0') = NVL(I.NOMBRE,'0') THEN
            IF NVL(W_PATERNO,'0') = NVL(I.PATERNO,'0') THEN
               IF NVL(W_MATERNO,'0') = NVL(I.MATERNO,'0') THEN
                  NULL;
               ELSE
                  W_EXISTE := 1;
                  W_ERROR  := 26;
               END IF;
            ELSE
               W_EXISTE := 1;
               W_ERROR  := 26;
            END IF;
         ELSE
            W_EXISTE := 1;
            W_ERROR  := 26;
         END IF;
         --
      END IF;
      --
      -- REGLA 7 VALIDAR FECHA DE NACIMIENTO VS EMISION
      --
      IF W_EXISTE = 0 THEN
         IF W_FE_NACIMIENTO = I.FE_NACIMIENTO THEN
            W_EXISTE := 0;
         ELSE
            W_EXISTE := 1;
            W_ERROR  := 27;
         END IF;
         --
      END IF;
      --
      -- GRABA ERROR
      --
      UPDATE INFO_SINIESTRO ISI
         SET ISI.CODERRORCARGA = W_ERROR,
             ISI.MENSUALIDAD   = W_CUOTAS,
             ISI.ERROR_INICIAL = W_ERROR
       WHERE ISI.ID_CREDITO     = I.ID_CREDITO
         AND ISI.ID_TRABAJADOR  = I.ID_TRABAJADOR
         AND ISI.ID_ENVIO       = I.ID_ENVIO
         AND ISI.FE_CARGA       = P_FECHA_CARGA;
      --
      COMMIT;
      --
      W_REGISTROS := W_REGISTROS + 1;
      --
  END LOOP;
END;
END;
--
--
--
PROCEDURE DEVUELVE_SIN_INFONACOT(P_ID_CREDITO     NUMBER,     -- INICIO   INFODEV
                                 P_ID_TRABAJADOR  NUMBER,
                                 P_ID_ENVIO       NUMBER,
                                 P_IMPORTE        NUMBER,
                                 P_ID_ASEGURADORA NUMBER,
                                 P_MENSAJE_ERROR OUT VARCHAR2) IS
--
W_NUM_APROBACION   COBERTURA_SINIESTRO.NUMMOD%TYPE;
W_IDSINIESTRO      COBERTURA_SINIESTRO.IDSINIESTRO%TYPE;
W_IDPOLIZA         COBERTURA_SINIESTRO.IDPOLIZA%TYPE;
W_IDDETSIN         COBERTURA_SINIESTRO.IDDETSIN%TYPE;
W_NUMMOD           COBERTURA_SINIESTRO.NUMMOD%TYPE;
W_CODCOBERT        COBERTURA_SINIESTRO.CODCOBERT%TYPE;
--
W_ID_CREDITO       INFO_SINIESTRO.ID_CREDITO%TYPE;
W_ID_TRABAJADOR    INFO_SINIESTRO.ID_TRABAJADOR%TYPE;
W_ID_ENVIO         INFO_SINIESTRO.ID_ENVIO%TYPE;
W_IMPORTE          INFO_SINIESTRO.IMPORTE%TYPE;
W_ID_ASEGURADORA   INFO_SINIESTRO.ID_ASEGURADORA%TYPE;
--
W_ID_ENDOSO        INFO_SINIESTRO.ID_ENDOSO%TYPE;
W_CONTINUA         BOOLEAN;
W_MENSAJE_ERROR    VARCHAR2(2000);
W_CODCIA           NUMBER := 1;
W_EMPRESA          NUMBER := 1;
W_USUARIO          VARCHAR2(100);
--
BEGIN
  --
  W_ID_CREDITO     := P_ID_CREDITO;
  W_ID_TRABAJADOR  := P_ID_TRABAJADOR;
  W_ID_ENVIO       := P_ID_ENVIO||1;
  W_ID_ENDOSO      := P_ID_ENVIO;
  W_IMPORTE        := P_IMPORTE;
  W_ID_ASEGURADORA := P_ID_ASEGURADORA;
  W_CONTINUA       := TRUE;
  --
  -- ANULAR APROBACION
  --
  BEGIN
    SELECT CS.NUMMOD,
           CS.IDSINIESTRO,
           CS.IDPOLIZA,
           CS.IDDETSIN,
           CS.CODCOBERT
      INTO W_NUM_APROBACION,
           W_IDSINIESTRO,
           W_IDPOLIZA,
           W_IDDETSIN,
           W_CODCOBERT
      FROM INFO_SINIESTRO      IFS2,
           COBERTURA_SINIESTRO CS
     WHERE IFS2.ID_CREDITO    = W_ID_CREDITO
       AND IFS2.ID_TRABAJADOR = W_ID_TRABAJADOR
       AND IFS2.ID_ENVIO      = W_ID_ENVIO
       --
       AND CS.IDSINIESTRO = IFS2.SINIESTRO
       AND CS.CODCOBERT   = DECODE(IFS2.COBERTURA,1,'DESEMP'
                                                 ,2,'INVALI'
                                                 ,3,'FALLEC'
                                                 ,4,'DESINV')
       AND TO_CHAR(CS.FECRES,'YYYYMM') = W_ID_ENDOSO
    ;
    --
    DBMS_OUTPUT.PUT_LINE('W_NUM_APROBACION -> '||W_NUM_APROBACION);
    DBMS_OUTPUT.PUT_LINE('W_IDSINIESTRO    -> '||W_IDSINIESTRO);
    DBMS_OUTPUT.PUT_LINE('W_IDPOLIZA       -> '||W_IDPOLIZA);
    DBMS_OUTPUT.PUT_LINE('W_IDDETSIN       -> '||W_IDDETSIN);
    DBMS_OUTPUT.PUT_LINE('W_CODCOBERT      -> '||W_CODCOBERT);
    --
  EXCEPTION
    WHEN OTHERS THEN
         --
         W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'DEVUELVE -  ERROR AL BUSCAR COBERTURA';
         --
  END;
  --
  IF W_CONTINUA THEN
     OC_APROBACIONES.ANULAR(W_CODCIA,
                            W_EMPRESA,
                            W_NUM_APROBACION,
                            W_IDSINIESTRO,
                            W_IDPOLIZA,
                            W_IDDETSIN);
     --
     IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'DEVUELVE -  ERROR EN APROBACIONES'; END IF;
     --
  END IF;
  --
  IF W_CONTINUA THEN
     --
     -- ALTA DE MOVIMIENTO DE DISMINUCION DE RESERVA
     --
     --   OBTIENE EL SIGUIENTE NUMERO DE SECUECIA PARA LA TRANSACCION
     --
     SELECT NVL(MAX(NumMod),0) + 1
       INTO W_NUMMOD
       FROM COBERTURA_SINIESTRO
      WHERE IDPOLIZA    = W_IDPOLIZA
        AND IDSINIESTRO = W_IDSINIESTRO
        AND IDDETSIN    = W_IDDETSIN
        AND CODCOBERT   = W_CODCOBERT;
     --
     INSERT INTO COBERTURA_SINIESTRO
      (IDDETSIN,
       CODCOBERT,
       IDSINIESTRO,
       IDPOLIZA,
       DOC_REF_PAGO,
       --
       MONTO_PAGADO_MONEDA,
       MONTO_PAGADO_LOCAL,
       MONTO_RESERVADO_MONEDA,
       MONTO_RESERVADO_LOCAL,
       STSCOBERTURA,
       --
       NUMMOD,
       CODTRANSAC,
       CODCPTOTRANSAC,
       IDTRANSACCION,
       SALDO_RESERVA,
       --
       INDORIGEN,
       FECRES,
       SALDO_RESERVA_LOCAL,
       IDTRANSACCIONANUL
      )
     VALUES
      (W_IDDETSIN,
       W_CODCOBERT,
       W_IDSINIESTRO,
       W_IDPOLIZA,
       '',
       --
       0,
       0,
       W_IMPORTE,
       W_IMPORTE,
       'EMI',
       --
       W_NUMMOD,
       'DIRVAD',
       'DIRVAD',
       '',
       W_IMPORTE,
       --
       'D',
       TRUNC(SYSDATE),
       W_IMPORTE,
       ''
      );
     --
     IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'DEVUELVE -  ERROR EN GRABADO DE COBERTURA_SINIESTRO'; END IF;
     --
  END IF;
  --
  IF W_CONTINUA THEN
     OC_COBERTURA_SINIESTRO.EMITE_RESERVA(W_CODCIA,
                                          W_EMPRESA,
                                          W_IDSINIESTRO,
                                          W_IDPOLIZA,
                                          W_IDDETSIN,
                                          W_CODCOBERT,
                                          W_NUMMOD,
                                          '');
     --
     IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'DEVUELVE -  ERROR EN GRABADO DE EMITE_RESERVA '; END IF;
     --
  END IF;
  --
  SELECT USER
    INTO W_USUARIO
    FROM DUAL;
  --
  IF W_CONTINUA THEN
     BEGIN
       INSERT INTO INFO_SINIESTRO
         (ID_CODCIA,                 NU_REMESA,                 ID_CREDITO_THONA,
          ID_POLIZA,                 ID_ENDOSO,                 ID_ASEGURADORA,
          ID_CREDITO,                ID_TRABAJADOR,             IMPORTE,
          DOMICILIO_CT,
          ID_ENVIO,                  FE_CARGA,                  ST_REGISTRO,
          CODUSUARIO,                CODERRORCARGA
         )
       VALUES
         (1,                         '',                        W_ID_CREDITO,
          'DEVOLUCION',              W_ID_ENDOSO,               W_ID_ASEGURADORA,
          '',                        W_ID_TRABAJADOR,           W_IMPORTE,
          'DEVOLUCION DE SINIESTRO: ENVIO - '||W_ID_ENDOSO||' IMPORTE - '||W_IMPORTE||' - '||SYSDATE||' - '||W_USUARIO,
          W_ID_ENVIO,                TRUNC(SYSDATE),            'DEV',
          W_USUARIO,                 '0'
       );
     EXCEPTION
       WHEN OTHERS THEN NULL;
     END ;
     --
     IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'DEVUELVE -  ERROR EN GRABADO DE INFO_SINIESTRO'; END IF;
     --
  END IF;
  --
  IF W_CONTINUA THEN
     NULL;
  ELSE
     P_MENSAJE_ERROR := sqlcode||' - '||W_MENSAJE_ERROR;
     --
  END IF;
  --
END DEVUELVE_SIN_INFONACOT;   --FIN INFODEV


PROCEDURE VALIDA_SUMASEG_INFONACOT(P_POLIZA_INFO       VARCHAR2,
                                   P_MENSAJE_ERROR OUT VARCHAR2) IS
--
W_POLIZA           POLIZAS.NUMPOLUNICO%TYPE;
W_SUMAASEG_LOCAL   COBERT_ACT.SUMAASEG_LOCAL%TYPE;
W_SUMAASEG_MONEDA  COBERT_ACT.SUMAASEG_MONEDA%TYPE;
W_CODCIA           NUMBER;
W_CONTINUA         BOOLEAN;
W_MENSAJE_ERROR    VARCHAR2(2000);
--
W_SUMAASEG_LOCAL_P   POLIZAS.SUMAASEG_LOCAL%TYPE;   --INSPOL
W_SUMAASEG_MONEDA_P  POLIZAS.SUMAASEG_MONEDA%TYPE;  --INSPOL
W_PRIMANETA_LOCAL_P  POLIZAS.PRIMANETA_LOCAL%TYPE;  --INSPOL
W_PRIMANETA_MONEDA_P POLIZAS.PRIMANETA_MONEDA%TYPE; --INSPOL
W_POLI               POLIZAS.IDPOLIZA%TYPE;         --INSPOL
--
CURSOR COB IS
  SELECT P.NUMPOLUNICO  POL_UNICO,
         DP.IDPOLIZA    POLI,
         DP.IDETPOL     CERT,
         DP.NUMDETREF   CRED,
         DPE.CAMPO19    PMAARCH,
         DP.PRIMA_LOCAL PMAPOLI,
         TO_NUMBER(DPE.CAMPO18,'99999999999.99') - DP.PRIMA_LOCAL DIF, --INFO1
         ROWNUM
    FROM POLIZAS            P,
         DETALLE_POLIZA     DP,
         DATOS_PART_EMISION DPE
   WHERE P.NUMPOLUNICO = W_POLIZA
     AND P.CODCIA      = W_CODCIA
     AND DP.IDPOLIZA   = P.IDPOLIZA
     AND DPE.CODCIA    = DP.CODCIA
     AND DPE.IDPOLIZA  = DP.IDPOLIZA
     AND DPE.IDETPOL   = DP.IDETPOL
     AND TO_NUMBER(DPE.CAMPO18,'99999999999.99') - DP.PRIMA_LOCAL BETWEEN  -0.02 AND 0.02    --INFO1
     AND TO_NUMBER(DPE.CAMPO18,'99999999999.99') - DP.PRIMA_LOCAL  != 0                      --INFO1
;
--
BEGIN
  --
  W_CODCIA   := 1;
  W_POLIZA   := P_POLIZA_INFO;
  W_CONTINUA := TRUE;
  W_POLI     := 0;   --INSPOL
  -- INSPOL INICIO
  BEGIN
   SELECT IDPOLIZA
     INTO W_POLI
     FROM POLIZAS
    WHERE NUMPOLUNICO = W_POLIZA
      AND CODCIA      = W_CODCIA;
  EXCEPTION
    WHEN OTHERS THEN
         W_POLI := W_POLIZA;
  END;
  -- INSPOL FIN
  FOR I IN COB LOOP
      --
      UPDATE COBERT_ACT CA
         SET CA.PRIMA_MONEDA = CA.PRIMA_MONEDA + I.DIF,
             CA.PRIMA_LOCAL  = CA.PRIMA_LOCAL  + I.DIF
       WHERE CA.CODCIA    = W_CODCIA
         AND CA.IDPOLIZA  = I.POLI
         AND CA.IDETPOL   = I.CERT
         AND CA.CODCOBERT = 'DESEMP'
      ;
      --
      IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'SUMA_ASEG -  ERROR EN COBERT_ACT'; END IF;
      --
      -- DETALLE_POLIZA
      --
      IF W_CONTINUA THEN
         --
         SELECT SUM(CA.SUMAASEG_LOCAL),
                SUM(CA.SUMAASEG_MONEDA)
           INTO W_SUMAASEG_LOCAL,
                W_SUMAASEG_MONEDA
           FROM COBERT_ACT CA
          WHERE CA.CODCIA   = W_CODCIA
           AND CA.IDPOLIZA  = I.POLI
           AND CA.IDETPOL   = I.CERT;
         --
         UPDATE DETALLE_POLIZA DP
            SET DP.PRIMA_LOCAL  = DP.PRIMA_LOCAL  + I.DIF,
                DP.PRIMA_MONEDA = DP.PRIMA_MONEDA + I.DIF,
                DP.SUMA_ASEG_LOCAL  = W_SUMAASEG_LOCAL,
                DP.SUMA_ASEG_MONEDA = W_SUMAASEG_MONEDA
          WHERE DP.CODCIA   = W_CODCIA
            AND DP.IDPOLIZA = I.POLI
            AND DP.IDETPOL  = I.CERT;
         --
         IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'SUMA_ASEG -  ERROR EN DETALLE_POLIZA'; END IF;
         --
         -- POLIZA
         --
         IF W_CONTINUA THEN
            UPDATE POLIZAS P
               SET P.PRIMANETA_LOCAL  = P.PRIMANETA_LOCAL  + I.DIF,
                   P.PRIMANETA_MONEDA = P.PRIMANETA_MONEDA + I.DIF
             WHERE P.CODCIA   = W_CODCIA
               AND P.IDPOLIZA = I.POLI;
            --
            IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'SUMA_ASEG -  ERROR EN POLIZAS'; END IF;
            --
            COMMIT;
            --
         END IF;
         --
      END IF;
  END LOOP;
  --
  IF W_CONTINUA THEN
     -- INSPOL INICIO
     -- DETALLE_POLIZA
     --
     SELECT SUM(DP.SUMA_ASEG_LOCAL),
            SUM(DP.SUMA_ASEG_MONEDA),
            SUM(DP.PRIMA_LOCAL),
            SUM(DP.PRIMA_MONEDA)
       INTO W_SUMAASEG_LOCAL_P,
            W_SUMAASEG_MONEDA_P,
            W_PRIMANETA_LOCAL_P,
            W_PRIMANETA_MONEDA_P
       FROM DETALLE_POLIZA DP
      WHERE DP.CODCIA   = W_CODCIA
        AND DP.IDPOLIZA = W_POLI
     ;
     --
     -- POLIZA
     --
     UPDATE POLIZAS P
        SET P.SUMAASEG_LOCAL   = W_SUMAASEG_LOCAL_P,
            P.SUMAASEG_MONEDA  = W_SUMAASEG_MONEDA_P,
            P.PRIMANETA_LOCAL  = W_PRIMANETA_LOCAL_P,
            P.PRIMANETA_MONEDA = W_PRIMANETA_MONEDA_P
      WHERE P.CODCIA   = W_CODCIA
        AND P.IDPOLIZA = W_POLI
     ;
     --
     COMMIT;
     -- INSPOL FIN
  ELSE
     W_MENSAJE_ERROR := sqlcode||' - '||W_MENSAJE_ERROR;
     --
     SELECT SUBSTR(W_MENSAJE_ERROR,1,1980)
       INTO P_MENSAJE_ERROR
       FROM DUAL;
     --
  END IF;

END VALIDA_SUMASEG_INFONACOT;

--
--
END TH_VAL_INFONACOT;
/

--
-- TH_VAL_INFONACOT  (Synonym) 
--
--  Dependencies: 
--   TH_VAL_INFONACOT (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM TH_VAL_INFONACOT FOR SICAS_OC.TH_VAL_INFONACOT
/


GRANT EXECUTE ON SICAS_OC.TH_VAL_INFONACOT TO PUBLIC
/

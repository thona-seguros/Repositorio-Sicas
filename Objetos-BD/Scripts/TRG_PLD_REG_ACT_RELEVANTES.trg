CREATE OR REPLACE TRIGGER TRG_PLD_REG_ACT_RELEVANTES
 AFTER UPDATE OF STSFACT ON "FACTURAS"
 REFERENCING OLD AS OLD NEW AS NEW 
 FOR EACH ROW
DECLARE
--
-- AUTOMATIZACION DE REGLAS CNSF              07/03/2023  JICO
--
 C_TIPO_PERSONA  VARCHAR2(15);
 N_ACUMULADO     FACTURAS.MONTO_FACT_MONEDA%TYPE; 
 N_MONTO_DESDE   PLD_REGLAS.MONTO_DESDE%TYPE;
 N_MONTO_HASTA   PLD_REGLAS.MONTO_HASTA%TYPE;
 N_MONTO_MAX_MENSUAL PLD_REGLAS.MONTO_MAX_MENSUAL%TYPE;
 C_ID_ALERTA     PLD_REGLAS.ID_ALERTA%TYPE;
 C_DESC_ALERTA   PLD_REGLAS.DESC_ALERTA%TYPE;
BEGIN
  --
  BEGIN
    SELECT NVL(PNJ.TIPO_PERSONA,'FISICA')
      INTO C_TIPO_PERSONA
      FROM CLIENTES                 C,
           PERSONA_NATURAL_JURIDICA PNJ
     WHERE C.CODCLIENTE = :NEW.CODCLIENTE
       --
       AND PNJ.TIPO_DOC_IDENTIFICACION = C.TIPO_DOC_IDENTIFICACION
       AND PNJ.NUM_DOC_IDENTIFICACION  = C.NUM_DOC_IDENTIFICACION;
  EXCEPTION
    WHEN OTHERS THEN
         NULL;
  END;
  --
  BEGIN
    SELECT P.MONTO_DESDE,
           P.MONTO_HASTA,
           P.MONTO_MAX_MENSUAL,
           P.ID_ALERTA,
           P.DESC_ALERTA
      INTO N_MONTO_DESDE,
           N_MONTO_HASTA,
           N_MONTO_MAX_MENSUAL,
           C_ID_ALERTA,
           C_DESC_ALERTA
      FROM PLD_REGLAS P
     WHERE P.CODCIA       = 1
       AND P.TABLA        = 'FACTURAS'
       AND P.CAMPO        = 'IDFACTURA'
       AND P.ST_CAMPO     = :NEW.STSFACT
       AND P.COD_MONEDA   = :NEW.COD_MONEDA
       AND P.FORMPAGO     = :NEW.FORMPAGO
       AND P.TIPO_PERSONA = C_TIPO_PERSONA;
  EXCEPTION
    WHEN OTHERS THEN
         NULL;
  END;
  --
  IF :NEW.COD_MONEDA = 'PS' THEN  -- PARA MONEDA NACIONAL
     IF :NEW.STSFACT  = 'PAG' THEN -- PARA ESTATUS DE RECIBO PAGADO
        IF :NEW.FORMPAGO = 'EFEC' THEN --PARA FORMA DE PAGO EFECTIVO
           IF :NEW.MONTO_FACT_MONEDA > N_MONTO_HASTA THEN --PARA MONTO MAYOR AL LIMITE
              --  
              INSERT INTO ADMON_ACTIVI_RELEVANTES 
               (CODCIA,              ID_PROCESO,                 IDPOLIZA,
                IDETPOL,             TP_PERSONA,                 ORIGEN,
                CODCLIENTE,          CODASEGURADO,               IDFACTURA,
                --
                IDTIPOSEG,           COD_MONEDA,                 FORMPAGO,
                TIPO_PERSONA,        CODACTIVIDAD,               ASEGURADOS_EMI,
                ASEGURADOS_END,      SUMAASEG_EMI,               SUMAASEG_END,
                --
                ST_RIESGO,           OBSERVACIONES,              FE_PROCESO,
                FE_HORA_PROCESO,     FE_ACTUALIZACION,           USUARIO_ACTUA,
                IMPTE_MOVTO_REG,     FE_ALTA_REG,                HISTORICO_MOVTOS_REG,
                --
                IDENDOSO,            TIPO_DOC_IDENTIFICACION,    NUM_DOC_IDENTIFICACION    
               )
              VALUES 
               (:NEW.CODCIA,               1,                    :NEW.IDPOLIZA, 
                :NEW.IDETPOL,              'CONTRA',             'EFEMN',
                :NEW.CODCLIENTE,           '',                   :NEW.IDFACTURA,
                --
                '',                        :NEW.COD_MONEDA,      :NEW.FORMPAGO,
                C_TIPO_PERSONA,            '',                   0,
                0,                         0,                    0,
                --
                'PEND',                    C_DESC_ALERTA,        TRUNC(SYSDATE),
                SYSDATE,                   '',                   USER,
                :NEW.MONTO_FACT_LOCAL,     '',                   '',
                --
                '',                        '',                   ''
               );
              --
           ELSE ------ VALIDA ACUMULADO DE PAGOS EN EFECTIVO EN UN MES POR POLIZA
              BEGIN
                SELECT SUM(F.MONTO_FACT_MONEDA)
                  INTO N_ACUMULADO
                  FROM FACTURAS F
                 WHERE F.FECPAGO BETWEEN (SELECT TO_DATE('01/'||TO_CHAR(SYSDATE,'mm/yyyy'),'dd/mm/yyyy') FROM DUAL) AND 
                                         (SELECT TRUNC(TO_DATE(LAST_DAY(SYSDATE),'dd/mm/rrrr')) FROM DUAL)
                   AND IDPOLIZA = :NEW.IDPOLIZA ;  
              EXCEPTION 
                WHEN OTHERS THEN
                     N_ACUMULADO := 0;
              END;
              --
              IF :NEW.STSFACT  = 'PAG'  AND 
                 :NEW.FORMPAGO = 'EFEC' AND 
                 N_ACUMULADO  >=  N_MONTO_MAX_MENSUAL THEN
                 --            
                 INSERT INTO ADMON_ACTIVI_RELEVANTES 
                  (CODCIA,              ID_PROCESO,                 IDPOLIZA,
                   IDETPOL,             TP_PERSONA,                 ORIGEN,
                   CODCLIENTE,          CODASEGURADO,               IDFACTURA,
                   --
                   IDTIPOSEG,           COD_MONEDA,                 FORMPAGO,
                   TIPO_PERSONA,        CODACTIVIDAD,               ASEGURADOS_EMI,
                   ASEGURADOS_END,      SUMAASEG_EMI,               SUMAASEG_END,
                   --
                   ST_RIESGO,           OBSERVACIONES,              FE_PROCESO,
                   FE_HORA_PROCESO,     FE_ACTUALIZACION,           USUARIO_ACTUA,
                   IMPTE_MOVTO_REG,     FE_ALTA_REG,                HISTORICO_MOVTOS_REG,
                   --
                   IDENDOSO,            TIPO_DOC_IDENTIFICACION,    NUM_DOC_IDENTIFICACION    
                  )
                 VALUES 
                  (:NEW.CODCIA,          1,                          :NEW.IDPOLIZA,  
                   :NEW.IDETPOL,         'CONTRA',                   'EFEMN',
                   :NEW.CODCLIENTE,      '',                         :NEW.IDFACTURA,
                   --
                   '',                   :NEW.COD_MONEDA,            :NEW.FORMPAGO,
                   C_TIPO_PERSONA,       '',                         0,
                   0,                    0,                          0,
                   --
                  'PEND',                'CON ESTE PAGO SE REBASA EL LIMITE DEL ACUMULADO MENSUAL EN '||:NEW.COD_MONEDA||' DE '||N_MONTO_MAX_MENSUAL,  TRUNC(SYSDATE),
                   SYSDATE,              '',                         USER,
                   :NEW.MONTO_FACT_LOCAL,   '',                      '',
                   --
                   '',                   '',                         ''
                  );
              ELSE
                 NULL;
              END IF;
           END IF;
        ELSE
           NULL;
        END IF;
     ELSE
        NULL;
     END IF;
  --
  --
  ELSE  -- PARA MONEDA EXTRANJERA
  --
  --
     IF :NEW.STSFACT  = 'PAG' THEN -- PARA ESTATUS DE RECIBO PAGADO
        IF :NEW.FORMPAGO = 'EFEC' THEN --PARA FORMA DE PAGO EFECTIVO
           IF :NEW.MONTO_FACT_MONEDA > N_MONTO_HASTA THEN --PARA MONTO MAYOR AL LIMITE
              --  
              INSERT INTO ADMON_ACTIVI_RELEVANTES 
               (CODCIA,              ID_PROCESO,                 IDPOLIZA,
                IDETPOL,             TP_PERSONA,                 ORIGEN,
                CODCLIENTE,          CODASEGURADO,               IDFACTURA,
                --
                IDTIPOSEG,           COD_MONEDA,                 FORMPAGO,
                TIPO_PERSONA,        CODACTIVIDAD,               ASEGURADOS_EMI,
                ASEGURADOS_END,      SUMAASEG_EMI,               SUMAASEG_END,
                --
                ST_RIESGO,           OBSERVACIONES,              FE_PROCESO,
                FE_HORA_PROCESO,     FE_ACTUALIZACION,           USUARIO_ACTUA,
                IMPTE_MOVTO_REG,     FE_ALTA_REG,                HISTORICO_MOVTOS_REG,
                --
                IDENDOSO,            TIPO_DOC_IDENTIFICACION,    NUM_DOC_IDENTIFICACION    
               )
              VALUES 
               (:NEW.CODCIA,               1,                    :NEW.IDPOLIZA, 
                :NEW.IDETPOL,              'CONTRA',             'EFEUSD',
                :NEW.CODCLIENTE,           '',                   :NEW.IDFACTURA,
                --
                '',                        :NEW.COD_MONEDA,      :NEW.FORMPAGO,
                C_TIPO_PERSONA,            '',                   0,
                0,                         0,                    0,
                --
                'PEND',                    C_DESC_ALERTA,        TRUNC(SYSDATE),
                SYSDATE,                   '',                   USER,
                :NEW.MONTO_FACT_LOCAL,     '',                   '',
                --
                '',                        '',                   ''
               );
              --
           ELSE ------ VALIDA ACUMULADO DE PAGOS EN EFECTIVO EN UN MES POR POLIZA
              BEGIN
                SELECT SUM(F.MONTO_FACT_MONEDA)
                  INTO N_ACUMULADO
                  FROM FACTURAS F
                 WHERE F.FECPAGO BETWEEN (SELECT TO_DATE('01/'||TO_CHAR(SYSDATE,'mm/yyyy'),'dd/mm/yyyy') FROM DUAL) AND 
                                         (SELECT TRUNC(TO_DATE(LAST_DAY(SYSDATE),'dd/mm/rrrr')) FROM DUAL)
                   AND IDPOLIZA = :NEW.IDPOLIZA ;  
              EXCEPTION 
                WHEN OTHERS THEN
                     N_ACUMULADO := 0;
              END;
              --
              IF :NEW.STSFACT  = 'PAG'  AND 
                 :NEW.FORMPAGO = 'EFEC' AND 
                 N_ACUMULADO  >=  N_MONTO_MAX_MENSUAL THEN
                 --            
                 INSERT INTO ADMON_ACTIVI_RELEVANTES 
                  (CODCIA,              ID_PROCESO,                 IDPOLIZA,
                   IDETPOL,             TP_PERSONA,                 ORIGEN,
                   CODCLIENTE,          CODASEGURADO,               IDFACTURA,
                   --
                   IDTIPOSEG,           COD_MONEDA,                 FORMPAGO,
                   TIPO_PERSONA,        CODACTIVIDAD,               ASEGURADOS_EMI,
                   ASEGURADOS_END,      SUMAASEG_EMI,               SUMAASEG_END,
                   --
                   ST_RIESGO,           OBSERVACIONES,              FE_PROCESO,
                   FE_HORA_PROCESO,     FE_ACTUALIZACION,           USUARIO_ACTUA,
                   IMPTE_MOVTO_REG,     FE_ALTA_REG,                HISTORICO_MOVTOS_REG,
                   --
                   IDENDOSO,            TIPO_DOC_IDENTIFICACION,    NUM_DOC_IDENTIFICACION    
                  )
                 VALUES 
                  (:NEW.CODCIA,          1,                          :NEW.IDPOLIZA,  
                   :NEW.IDETPOL,         'CONTRA',                   'EFEUSD',
                   :NEW.CODCLIENTE,      '',                         :NEW.IDFACTURA,
                   --
                   '',                   :NEW.COD_MONEDA,            :NEW.FORMPAGO,
                   C_TIPO_PERSONA,       '',                         0,
                   0,                    0,                          0,
                   --
                  'PEND',                'CON ESTE PAGO SE REBASA EL LIMITE DEL ACUMULADO MENSUAL EN '||:NEW.COD_MONEDA||' DE '||N_MONTO_MAX_MENSUAL,  TRUNC(SYSDATE),
                   SYSDATE,              '',                         USER,
                   :NEW.MONTO_FACT_LOCAL,   '',                      '',
                   --
                   '',                   '',                         ''
                  );
              ELSE
                 NULL;
              END IF;
           END IF;
        ELSE
           NULL;
        END IF;
     END IF;
  END IF;
END;
/

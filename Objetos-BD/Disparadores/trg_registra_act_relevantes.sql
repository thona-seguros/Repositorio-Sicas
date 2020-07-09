--
-- TRG_REGISTRA_ACT_RELEVANTES  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   PERSONA_NATURAL_JURIDICA (Table)
--   ADMON_ACTIVI_RELEVANTES (Table)
--   CLIENTES (Table)
--   FACTURAS (Table)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_REGISTRA_ACT_RELEVANTES
 AFTER UPDATE OF STSFACT ON SICAS_OC.FACTURAS
 REFERENCING OLD AS OLD NEW AS NEW 
 FOR EACH ROW
DECLARE
 W_USUARIO       VARCHAR2(15);
 W_TIPO_PERSONA  VARCHAR2(15);
 W_ACUMULADO     FACTURAS.MONTO_FACT_MONEDA%TYPE; 
 W_OBSERVACIONES ADMON_ACTIVI_RELEVANTES.OBSERVACIONES%TYPE; 
BEGIN
  SELECT USER 
    INTO W_USUARIO
    FROM DUAL;
  --
  BEGIN
    SELECT NVL(PNJ.TIPO_PERSONA,'FISICA')
      INTO W_TIPO_PERSONA
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
  IF :NEW.COD_MONEDA = 'PS' THEN  -- PARA MONEDA NACIONAL
     IF :NEW.STSFACT  = 'PAG'  AND 
        :NEW.FORMPAGO = 'EFEC' AND 
        :NEW.MONTO_FACT_LOCAL > 300000 THEN
        --  
        IF (W_TIPO_PERSONA = 'FISICA' AND :NEW.MONTO_FACT_LOCAL >= 300000)
            OR
           (W_TIPO_PERSONA = 'MORAL'  AND :NEW.MONTO_FACT_LOCAL >= 500000) THEN
           --
           IF W_TIPO_PERSONA = 'FISICA' THEN
              W_OBSERVACIONES := 'EL PAGO SUPERA EL LÍMITE DE 300,000 PESOS PARA PERSONAS FISICAS' ;
           ELSE 
             W_OBSERVACIONES := 'EL PAGO SUPERA EL LÍMITE DE 500,000 PESOS PARA PERSONAS MORALES' ;
           END IF;
           INSERT INTO ADMON_ACTIVI_RELEVANTES 
            (CODCIA,                              ID_PROCESO,
             IDPOLIZA,                            IDETPOL,
             TP_PERSONA,                          ORIGEN,
             CODCLIENTE,                          CODASEGURADO,
             IDFACTURA,                           IDTIPOSEG,
             COD_MONEDA,                          FORMPAGO,
             TIPO_PERSONA,                        CODACTIVIDAD,
             ASEGURADOS_EMI,                      ASEGURADOS_END,
             SUMAASEG_EMI,                        SUMAASEG_END,
             ST_RIESGO,                           OBSERVACIONES,
             FE_PROCESO,                          FE_HORA_PROCESO,
             FE_ACTUALIZACION,                    USUARIO_ACTUA,
             IMPTE_MOVTO_REG,                     FE_ALTA_REG,
             HISTORICO_MOVTOS_REG,                IDENDOSO,    
             TIPO_DOC_IDENTIFICACION,             NUM_DOC_IDENTIFICACION    
            )
            VALUES
            (:NEW.CODCIA,                         1,
             :NEW.IDPOLIZA,                       :NEW.IDETPOL,
             'CONTRA',                           'EFEMN',
             :NEW.CODCLIENTE,                    '',
             :NEW.IDFACTURA,                     '',
             :NEW.COD_MONEDA,                    :NEW.FORMPAGO,
             W_TIPO_PERSONA,                     '',
             0,                                  0,
             0,                                  0,
             'PEND',                             W_OBSERVACIONES,
             TRUNC(SYSDATE),                     SYSDATE,
             '',                                 W_USUARIO,
             :NEW.MONTO_FACT_LOCAL,              '',
             '',                                 '',
             '',                                 ''
            );
           --
        ELSE
           NULL;
        END IF;
     ELSE
     ------------ VALIDA ACUMULADO DE PAGOS 
       BEGIN
        select sum(monto_fact_moneda)
          INTO W_ACUMULADO
        from FACTURAS 
        where fecpago between (select to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy')from dual) and 
        (select TRUNC(to_date(last_DAY(SYSDATE),'dd/mm/rrrr')) from dual)
        and idpoliza = :NEW.IDPOLIZA ;  
     ------------
       EXCEPTION WHEN OTHERS THEN
        W_ACUMULADO := 0;
       END;
     ------------
       IF :NEW.STSFACT  = 'PAG'  AND 
          :NEW.FORMPAGO = 'EFEC' AND 
          W_ACUMULADO >= 1000000 THEN
          --            
         INSERT INTO ADMON_ACTIVI_RELEVANTES 
          (CODCIA,                              ID_PROCESO,
           IDPOLIZA,                            IDETPOL,
           TP_PERSONA,                          ORIGEN,
           CODCLIENTE,                          CODASEGURADO,
           IDFACTURA,                           IDTIPOSEG,
           COD_MONEDA,                          FORMPAGO,
           TIPO_PERSONA,                        CODACTIVIDAD,
           ASEGURADOS_EMI,                      ASEGURADOS_END,
           SUMAASEG_EMI,                        SUMAASEG_END,
           ST_RIESGO,                           OBSERVACIONES,
           FE_PROCESO,                          FE_HORA_PROCESO,
           FE_ACTUALIZACION,                    USUARIO_ACTUA,
           IMPTE_MOVTO_REG,                     FE_ALTA_REG,
           HISTORICO_MOVTOS_REG,                IDENDOSO,    
           TIPO_DOC_IDENTIFICACION,             NUM_DOC_IDENTIFICACION    
          )
          VALUES
          (:NEW.CODCIA,                         1,
           :NEW.IDPOLIZA,                       :NEW.IDETPOL,
           'CONTRA',                           'EFEMN',
           :NEW.CODCLIENTE,                    '',
           :NEW.IDFACTURA,                     '',
           :NEW.COD_MONEDA,                    :NEW.FORMPAGO,
           W_TIPO_PERSONA,                     '',
           0,                                  0,
           0,                                  0,
           'PEND',                             'CON ESTE PAGO SE REBASA EL LIMITE DE 1 000,000 DE PESOS EN ACUMULADO MENSUAL',
           TRUNC(SYSDATE),                     SYSDATE,
           '',                                 W_USUARIO,
           :NEW.MONTO_FACT_LOCAL,              '',
           '',                                 '',
           '',                                 ''
          );
         --
          ELSE
             NULL;
          END IF;
         
     ------------
       
     END IF;
  ELSE  -- PARA MONEDA EXTRANJERA
     IF :NEW.STSFACT           = 'PAG'  AND 
        :NEW.FORMPAGO          = 'EFEC' AND 
        :NEW.MONTO_FACT_MONEDA > 10000 THEN
        --
        IF (W_TIPO_PERSONA = 'FISICA' AND :NEW.MONTO_FACT_MONEDA >= 10000)
            OR
           (W_TIPO_PERSONA = 'MORAL'  AND :NEW.MONTO_FACT_MONEDA >= 50000) THEN
           --
           IF W_TIPO_PERSONA = 'FISICA' THEN
              W_OBSERVACIONES := 'EL PAGO SUPERA EL LÍMITE DE 10,000 DOLARES PARA PERSONAS FISICAS' ;
           ELSE 
             W_OBSERVACIONES := 'EL PAGO SUPERA EL LÍMITE DE 50,000 DOLARES PARA PERSONAS MORALES' ;
           END IF;           
           INSERT INTO ADMON_ACTIVI_RELEVANTES
            (CODCIA,                              ID_PROCESO,
             IDPOLIZA,                            IDETPOL,
             TP_PERSONA,                          ORIGEN,
             CODCLIENTE,                          CODASEGURADO,
             IDFACTURA,                           IDTIPOSEG,
             COD_MONEDA,                          FORMPAGO,
             TIPO_PERSONA,                        CODACTIVIDAD,
             ASEGURADOS_EMI,                      ASEGURADOS_END,
             SUMAASEG_EMI,                        SUMAASEG_END,
             ST_RIESGO,                           OBSERVACIONES,
             FE_PROCESO,                          FE_HORA_PROCESO,
             FE_ACTUALIZACION,                    USUARIO_ACTUA,
             IMPTE_MOVTO_REG,                     FE_ALTA_REG,
             HISTORICO_MOVTOS_REG,                IDENDOSO,    
             TIPO_DOC_IDENTIFICACION,             NUM_DOC_IDENTIFICACION
            )
            VALUES
            (:NEW.CODCIA,                         1,
             :NEW.IDPOLIZA,                       :NEW.IDETPOL,
             'CONTRA',                            'EFEUSD',
             :NEW.CODCLIENTE,                     '',
             :NEW.IDFACTURA,                      '',
             :NEW.COD_MONEDA,                     :NEW.FORMPAGO,
             W_TIPO_PERSONA,                      '',
             0,                                   0,
             0,                                   0,
             'PEND',                              W_OBSERVACIONES ,
             TRUNC(SYSDATE),                      SYSDATE,
             '',                                  W_USUARIO,
             :NEW.MONTO_FACT_MONEDA,               '',
             '',                                 '',
             '',                                 ''
            );
           --
        ELSE
          NULL;
        END IF;
     ELSE
     ----------------------------------
       IF :NEW.MONTO_FACT_MONEDA >= 500 THEN
           --
           W_OBSERVACIONES := 'EL PAGO SUPERA EL LÍMITE DE 500 DOLARES' ;
           
           INSERT INTO ADMON_ACTIVI_RELEVANTES
            (CODCIA,                              ID_PROCESO,
             IDPOLIZA,                            IDETPOL,
             TP_PERSONA,                          ORIGEN,
             CODCLIENTE,                          CODASEGURADO,
             IDFACTURA,                           IDTIPOSEG,
             COD_MONEDA,                          FORMPAGO,
             TIPO_PERSONA,                        CODACTIVIDAD,
             ASEGURADOS_EMI,                      ASEGURADOS_END,
             SUMAASEG_EMI,                        SUMAASEG_END,
             ST_RIESGO,                           OBSERVACIONES,
             FE_PROCESO,                          FE_HORA_PROCESO,
             FE_ACTUALIZACION,                    USUARIO_ACTUA,
             IMPTE_MOVTO_REG,                     FE_ALTA_REG,
             HISTORICO_MOVTOS_REG,                IDENDOSO,    
             TIPO_DOC_IDENTIFICACION,             NUM_DOC_IDENTIFICACION
            )
            VALUES
            (:NEW.CODCIA,                         1,
             :NEW.IDPOLIZA,                       :NEW.IDETPOL,
             'CONTRA',                            'EFEUSD',
             :NEW.CODCLIENTE,                     '',
             :NEW.IDFACTURA,                      '',
             :NEW.COD_MONEDA,                     :NEW.FORMPAGO,
             W_TIPO_PERSONA,                      '',
             0,                                   0,
             0,                                   0,
             'PEND',                              W_OBSERVACIONES ,
             TRUNC(SYSDATE),                      SYSDATE,
             '',                                  W_USUARIO,
             :NEW.MONTO_FACT_MONEDA,               '',
             '',                                 '',
             '',                                 ''
            );
       END IF;
        --------
     ------------ VALIDA ACUMULADO DE PAGOS 
       BEGIN
        select sum(monto_fact_moneda)
          INTO W_ACUMULADO
        from FACTURAS 
        where fecpago between (select to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy')from dual) and 
        (select TRUNC(to_date(last_DAY(SYSDATE),'dd/mm/rrrr')) from dual)
        and idpoliza = :NEW.IDPOLIZA ;  
     ------------
       EXCEPTION WHEN OTHERS THEN
        W_ACUMULADO := 0;
       END;
     ------------
       IF :NEW.STSFACT  = 'PAG'  AND 
          :NEW.FORMPAGO = 'EFEC' AND 
          W_ACUMULADO >= 100000 THEN
          --  
           INSERT INTO ADMON_ACTIVI_RELEVANTES
            (CODCIA,                              ID_PROCESO,
             IDPOLIZA,                            IDETPOL,
             TP_PERSONA,                          ORIGEN,
             CODCLIENTE,                          CODASEGURADO,
             IDFACTURA,                           IDTIPOSEG,
             COD_MONEDA,                          FORMPAGO,
             TIPO_PERSONA,                        CODACTIVIDAD,
             ASEGURADOS_EMI,                      ASEGURADOS_END,
             SUMAASEG_EMI,                        SUMAASEG_END,
             ST_RIESGO,                           OBSERVACIONES,
             FE_PROCESO,                          FE_HORA_PROCESO,
             FE_ACTUALIZACION,                    USUARIO_ACTUA,
             IMPTE_MOVTO_REG,                     FE_ALTA_REG,
             HISTORICO_MOVTOS_REG,                IDENDOSO,    
             TIPO_DOC_IDENTIFICACION,             NUM_DOC_IDENTIFICACION
            )
            VALUES
            (:NEW.CODCIA,                         1,
             :NEW.IDPOLIZA,                       :NEW.IDETPOL,
             'CONTRA',                            'EFEUSD',
             :NEW.CODCLIENTE,                     '',
             :NEW.IDFACTURA,                      '',
             :NEW.COD_MONEDA,                     :NEW.FORMPAGO,
             W_TIPO_PERSONA,                      '',
             0,                                   0,
             0,                                   0,
             'PEND',                              'CON ESTE PAGO SE REBASA EL LIMITE DE 100,000 DOLARES EN ACUMULADO MENSUAL',
             TRUNC(SYSDATE),                      SYSDATE,
             '',                                  W_USUARIO,
             :NEW.MONTO_FACT_MONEDA,               '',
             '',                                 '',
             '',                                 ''
            );
         --
          ELSE
             NULL;
          END IF;        
     ------------
     ----------------------------------
--        NULL;
     END IF;
  END IF;
  --
END;
------------- SYNONYMS -----------------
/

--
-- TRG_REGISTRA_ACT_INUSUALES  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   FACTURAS (Table)
--   ADMON_ACTIVI (Table)
--   CLIENTES (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_REGISTRA_ACT_INUSUALES
 AFTER UPDATE OF STSFACT ON SICAS_OC.FACTURAS
 REFERENCING OLD AS OLD NEW AS NEW 
 FOR EACH ROW
DISABLE
DECLARE
 W_USUARIO       VARCHAR2(15);
 W_TIPO_PERSONA  VARCHAR2(15);
BEGIN
  IF :NEW.COD_MONEDA = 'PS' THEN  -- PARA MONEDA NACIONAL
     IF :NEW.STSFACT  = 'PAG'  AND 
        :NEW.FORMPAGO = 'EFEC' AND 
        :NEW.MONTO_FACT_LOCAL > 300000 THEN
        --  
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
        IF (W_TIPO_PERSONA = 'FISICA' AND :NEW.MONTO_FACT_LOCAL >= 300000)
            OR
           (W_TIPO_PERSONA = 'MORAL'  AND :NEW.MONTO_FACT_LOCAL >= 500000) THEN
           --
           INSERT INTO ADMON_ACTIVI 
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
             'PEND',                             '',
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
        NULL;
     END IF;
  ELSE  -- PARA MONEDA EXTRANJERA
     IF :NEW.STSFACT           = 'PAG'  AND 
        :NEW.FORMPAGO          = 'EFEC' AND 
        :NEW.MONTO_FACT_MONEDA > 10000 THEN
        --  
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
        IF (W_TIPO_PERSONA = 'FISICA' AND :NEW.MONTO_FACT_MONEDA >= 10000)
            OR
           (W_TIPO_PERSONA = 'MORAL'  AND :NEW.MONTO_FACT_MONEDA >= 50000) THEN
           --
           INSERT INTO ADMON_ACTIVI 
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
             'PEND',                              '',
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
        NULL;
     END IF;
  END IF;
  --
END;
/

--
-- TRG_ACTUALIZA_DETALLE_RECARGO  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   LOG_TRANSACCION (Table)
--   SQ_LOGTRANSACC (Sequence)
--   POLIZAS (Table)
--   DETALLE_RECARGO (Table)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_ACTUALIZA_DETALLE_RECARGO 
 BEFORE
  UPDATE
 ON SICAS_OC.DETALLE_RECARGO
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
  nMaxTransaccion   NUMBER(18,0);
  cCodcia           NUMBER(14,0);
  cIdePoliza        NUMBER(14,0);
  cIP               VARCHAR2(20);
  cUsuario          VARCHAR2(30);
  cMoneda           VARCHAR2(25);
BEGIN
  SELECT SQ_LOGTRANSACC.NEXTVAL
    INTO nMaxTransaccion
    FROM DUAL;
  --
    SELECT USER
    INTO   cUsuario
    FROM   DUAL;

    SELECT  NVL(CODCIA,1)
    INTO    cCodCia
    FROM    POLIZAS
    WHERE   IDPOLIZA = :NEW.IDPOLIZA;

    SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
    INTO cIP
    FROM DUAL;
               INSERT INTO LOG_TRANSACCION ( id_transaccion,
                                          codcia,
                                          id_referencia,
                                          fecha_transaccion,
                                          direccion_ip,
                                          num_referencia,
                                          origen_transaccion,
                                          desc_movimiento,
                                          codusuario )

              VALUES                    ( nMaxtransaccion,
                                          cCodCia,
                                         'RECARGOS'||' '||' '||'Poliza No.:'||TO_CHAR(:NEW.IDPOLIZA)||' '||'Certificado No.:'||' '||TO_CHAR(:NEW.IDETPOL),
                                         SYSDATE,
                                         cIP,
                                         'CODIGO:'||' '||:NEW.CODREC,
                                         'ACTUALIZO DETALLE RECARGO',
                                         'DATOS INGRESADOS:' ||'Monto Local :'||' '||TO_CHAR(:NEW.Monto_Local,'999,999,999.00')||' ' ||'Suma Moneda :'||' '||TO_CHAR(:NEW.Monto_Moneda,'999,999,999.00'),
                                         cUsuario);
END;
/

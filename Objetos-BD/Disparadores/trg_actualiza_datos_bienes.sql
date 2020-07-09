--
-- TRG_ACTUALIZA_DATOS_BIENES  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   LOG_TRANSACCION (Table)
--   SQ_LOGTRANSACC (Sequence)
--   POLIZAS (Table)
--   DATOS_PARTICULARES_BIENES (Table)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_ACTUALIZA_DATOS_BIENES 
 BEFORE
  UPDATE
 ON SICAS_OC.DATOS_PARTICULARES_BIENES
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
  --
  SELECT SQ_LOGTRANSACC.NEXTVAL
    INTO nMaxTransaccion
    FROM DUAL;
  --
    SELECT USER
    INTO   cUsuario
    FROM   DUAL;

    SELECT  CODCIA
    INTO    cCodCia
    FROM    POLIZAS
    WHERE   IDPOLIZA = :NEW.IDPOLIZA;



    SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
    INTO cIP
    FROM DUAL;
            INSERT INTO LOG_TRANSACCION
              VALUES(nMaxtransaccion,cCodCia,'DATOS DE BIENES'||' '||TO_CHAR(:NEW.IDPOLIZA),SYSDATE,
              cIP, 'Numero de Bien'||:NEW.NUM_BIEN, 'ACTUALIZO DATOS DE BIENES',
              'DATOS INGRESADOS: '||' '||'Datos de Bienes: '||:NEW.IDETPOL||' '||
              'Vigencia: '||TO_CHAR(:NEW.Inicio_Vigencia,'DD/MM/YYYY')||' A '||TO_CHAR(:NEW.Fin_Vigencia,'DD/MM/YYYY')||' '||
              'Suma Asegurada Local'||TO_CHAR(:NEW.suma_aseg_local_bien,'999,999,999.00')||' ' ||
              'Suma Asegurada Moneda :'||' '||TO_CHAR(:NEW.suma_aseg_Moneda_bien,'999,999,999.00')||'Prima Moneda :'||' '||TO_CHAR(:NEW.Prima_neta_local_bien,'999,999,999.00')||
              'Prima Neta Moneda :'||' '||TO_CHAR(:NEW.prima_neta_moneda_bien,'999,999,999.00'),cUsuario);
END;
/

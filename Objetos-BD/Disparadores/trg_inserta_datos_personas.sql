--
-- TRG_INSERTA_DATOS_PERSONAS  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   POLIZAS (Table)
--   DATOS_PARTICULARES_PERSONAS (Table)
--   LOG_TRANSACCION (Table)
--   SQ_LOGTRANSACC (Sequence)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_INSERTA_DATOS_PERSONAS 
 BEFORE
  INSERT
 ON SICAS_OC.DATOS_PARTICULARES_PERSONAS
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
              VALUES(nMaxtransaccion,cCodCia,'INSERTO DATOS DE PERSONAS'||' '||TO_CHAR(:NEW.IDPOLIZA),SYSDATE,
              cIP, 'Numero de Persona'||:NEW.IDETPOL, 'INSERTO DATOS DE PERSONAS',
              'DATOS INGRESADOS: '||' '||'Datos de Personas: '||:NEW.IDETPOL||' '||
              'Suma Asegurada Local'||TO_CHAR(:NEW.suma_aseg_local,'999,999,999.00')||' ' ||
              'Suma Asegurada Moneda :'||' '||TO_CHAR(:NEW.suma_aseg_Moneda,'999,999,999.00')||'Prima Moneda :'||' '||TO_CHAR(:NEW.Prima_local,'999,999,999.00')||
              'Prima Neta Moneda :'||' '||TO_CHAR(:NEW.prima_moneda,'999,999,999.00'),cUsuario);
END;
/

--
-- TRG_INSERTA_POLIZA  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   POLIZAS (Table)
--   LOG_TRANSACCION (Table)
--   MONEDA (Table)
--   SQ_LOGTRANSACC (Sequence)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_INSERTA_POLIZA 
 BEFORE 
 INSERT
 ON SICAS_OC.POLIZAS
 REFERENCING OLD AS OLD NEW AS NEW
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

    SELECT  DESC_MONEDA
    INTO    cMoneda
    FROM    MONEDA
    WHERE   COD_MONEDA = :NEW.COD_MONEDA;


    SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
    INTO cIP
    FROM DUAL;
            INSERT INTO LOG_TRANSACCION
              VALUES(nMaxtransaccion,:NEW.CodCia,'POLIZA'||' '||TO_CHAR(:NEW.IDPOLIZA),SYSDATE,
              cIP, :NEW.NUMPOLREF, 'INGRESO DE POLIZA',
              'DATOS INGRESADOS: '||' '||'Tipo Poliza: '||:NEW.TIPOPOL||' '||
              'Vigencia: '||TO_CHAR(:NEW.FecIniVig,'DD/MM/YYYY')||' A '||TO_CHAR(:NEW.FecFinVig,'DD/MM/YYYY')||' '||
              'Estado de Poliza: '||:NEW.StsPoliza||' '||'Suma Asegurada Local'||TO_CHAR(:NEW.sumaaseg_local,'999,999,999.00')||' ' ||
              'Suma Asegurada Moneda :'||' '||TO_CHAR(:NEW.sumaaseg_Moneda,'999,999,999.00')||'Prima Moneda :'||' '||:NEW.Primaneta_local||
              'Prima Neta Moneda :'||' '||:NEW.primaneta_moneda||' '||'Moneda Poliza :'||:NEW.Cod_Moneda
              ||' '||'Cliente :'||' '||TO_CHAR(:NEW.CodCliente)||' '||'Agente :'||' '||TO_CHAR(:NEW.Cod_Agente),cUsuario);

END;
/

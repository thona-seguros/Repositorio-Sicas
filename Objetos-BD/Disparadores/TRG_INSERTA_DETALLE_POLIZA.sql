
  CREATE OR REPLACE TRIGGER "SICAS_OC"."TRG_INSERTA_DETALLE_POLIZA" 
 BEFORE 
 INSERT
 ON DETALLE_POLIZA
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

    SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
    INTO cIP
    FROM DUAL;
            INSERT INTO LOG_TRANSACCION
              VALUES(nMaxtransaccion,:NEW.CodCia,'POLIZA'||' '||TO_CHAR(:NEW.IDPOLIZA),SYSDATE,
              cIP, 'Insercion Detalle de Polza', 'INSERTO DETALLE DE POLIZA',
              'DATOS INGRESADOS: '||' '||'Detalle Poliza: '||:NEW.IDETPOL||' '||'Asegurado :'||:NEW.COD_ASEGURADO||' '||
              'Empresa '||:NEW.CODEMPRESA||' '||'Plan de Pagos'||' '||:NEW.CODPLANPAGO||' '||
              'Vigencia: '||TO_CHAR(:NEW.FecIniVig,'DD/MM/YYYY')||' A '||TO_CHAR(:NEW.FecFinVig,'DD/MM/YYYY')||' '||
              'Suma Asegurada Local'||TO_CHAR(:NEW.suma_aseg_local,'999,999,999.00')||' ' ||
              'Suma Asegurada Moneda :'||' '||TO_CHAR(:NEW.suma_aseg_Moneda,'999,999,999.00')||'Prima Moneda :'||' '||TO_CHAR(:NEW.Prima_local,'999,999,999.00')||
              'Prima Neta Moneda :'||' '||TO_CHAR(:NEW.prima_moneda,'999,999,999.00'),cUsuario);

END;






ALTER TRIGGER "SICAS_OC"."TRG_INSERTA_DETALLE_POLIZA" ENABLE

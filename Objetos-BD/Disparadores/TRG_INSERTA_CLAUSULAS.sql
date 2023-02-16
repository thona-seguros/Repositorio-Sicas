
  CREATE OR REPLACE TRIGGER "SICAS_OC"."TRG_INSERTA_CLAUSULAS" 
 BEFORE
  INSERT
 ON CLAUSULAS_DETALLE
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
              VALUES(nMaxtransaccion,cCodCia,'CLAUSULAS'||' '||TO_CHAR(:NEW.IDPOLIZA),SYSDATE,
              cIP, 'Codigo de Clausula'||:NEW.COD_CLAUSULA, 'INSERTO CLAUSULAS',
              'DATOS INGRESADOS: '||' '||'CLAUSULAS',cUsuario);
END;


ALTER TRIGGER "SICAS_OC"."TRG_INSERTA_CLAUSULAS" ENABLE

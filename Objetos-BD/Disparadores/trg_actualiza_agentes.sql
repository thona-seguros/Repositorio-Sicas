--
-- TRG_ACTUALIZA_AGENTES  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   POLIZAS (Table)
--   AGENTES (Table)
--   LOG_TRANSACCION (Table)
--   SQ_LOGTRANSACC (Sequence)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_ACTUALIZA_AGENTES 
 BEFORE UPDATE ON SICAS_OC.AGENTES
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
nMaxTransaccion   LOG_TRANSACCION.Id_Transaccion%TYPE;
cCodCia           POLIZAS.CodCia%TYPE;
cIP               VARCHAR2(20);
cUsuario          VARCHAR2(30);
BEGIN
--   SELECT MAX(ID_TRANSACCION) + 1
--     INTO nMaxTransaccion
--     FROM LOG_TRANSACCION;
   --  
   SELECT SQ_LOGTRANSACC.NEXTVAL
     INTO nMaxTransaccion
     FROM DUAL;
   --           
   SELECT USER
     INTO cUsuario
     FROM DUAL;

   SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
     INTO cIP
     FROM DUAL;

   INSERT INTO LOG_TRANSACCION
         (Id_Transaccion, CodCia, Id_Referencia, Fecha_Transaccion, Direccion_IP,
          Num_Referencia, Origen_Transaccion, Desc_Movimiento, CodUsuario)
   VALUES(nMaxtransaccion, :NEW.CodCia, 'AGENTE ' || TO_CHAR(:NEW.Cod_Agente), SYSDATE, cIP,
          :NEW.Cod_Agente, 'ACTUALIZO AGENTE', 'DATOS INGRESADOS: Status: ' || :NEW.Est_Agente ||
          ' Tipo Doc. Identificaci�n: ' || :NEW.Tipo_Doc_Identificacion || '  No. Doc. Identificaci�n: ' ||
          :NEW.Num_Doc_Identificacion || ' Tipo Agente: ' || :NEW.Tipo_Agente || ' Canal de Venta: ' ||
          :NEW.CanalComisVenta || ' C�digo Agente Jefe: ' || :NEW.Cod_Agente_Jefe || ' Clasificaci�n Agente: ' ||
          :NEW.CodTipo || ' Nivel Jer�rquico: ' || :NEW.CodNivel || ' Indicador Pago Autom�tico: '|| :NEW.IndPagosAutom ||
          ' Ejecutivo Comercial: ' || TO_CHAR(:NEW.CodEjecutivo) || ' Forma de Pago: ' || :NEW.IdFormaPago, cUsuario);
END;
/

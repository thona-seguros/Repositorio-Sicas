--
-- TRG_ACTUALIZA_FACTURAS  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   LOG_TRANSACCION (Table)
--   SQ_LOGTRANSACC (Sequence)
--   POLIZAS (Table)
--   FACTURAS (Table)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_ACTUALIZA_FACTURAS 
 BEFORE UPDATE ON SICAS_OC.FACTURAS
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
nMaxTransaccion   LOG_TRANSACCION.Id_Transaccion%TYPE;
cCodCia           POLIZAS.CodCia%TYPE;
cIP               VARCHAR2(20);
cUsuario          VARCHAR2(30);
BEGIN
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
   VALUES(nMaxtransaccion, :NEW.CodCia, 'FACTURAS ' || TO_CHAR(:NEW.IdFactura), SYSDATE, cIP,
          :NEW.IdFactura, 'ACTUALIZO FACTURA', 'DATOS INGRESADOS: No. Póliza: ' || :NEW.IdPoliza ||
          ' Certificado/Subgrupo: ' || :NEW.IDetPol || ' Status: ' || :NEW.StsFact ||
          ' Código Cliente: ' || :NEW.CodCliente || ' Fecha Vencimiento: ' || TO_CHAR(:NEW.FecVenc,'DD/MM/RRRR') ||
          ' Monto Local: ' || TRIM(TO_CHAR(:NEW.Monto_Fact_Local,'999,999,999,990.00')) ||
          ' Monto Moneda: ' || TRIM(TO_CHAR(:NEW.Monto_Fact_Moneda,'999,999,999,990.00')) ||
          ' Recibo de Pago: '|| :NEW.ReciboPago || ' Fecha Anulación: ' || TO_CHAR(:NEW.FecAnul,'DD/MM/RRRR') ||
          ' Motivo Anulación: ' || :NEW.MotivAnul ||
          ' Comision Local: ' || TRIM(TO_CHAR(:NEW.MtoComisi_Local,'999,999,999,990.00')) ||
          ' Comisión Moneda: ' || TRIM(TO_CHAR(:NEW.MtoComisi_Local,'999,999,999,990.00')) ||
          ' No. Cuota: ' || :NEW.NumCuota || ' Forma de Pago: ' || :NEW.FormPago ||
          ' No. Transacción Emisión: ' || :NEW.IdTransaccion || ' No. Transacción Anulación: ' || :NEW.IdTransaccionAnu ||
          ' Fecha de Pago: ' || TO_CHAR(:NEW.FecPago,'DD/MM/RRRR') || ' Fecha Envío Fact. Elect.: ' ||
          TO_CHAR(:NEW.FecEnvFactElec,'DD/MM/RRRR') || ' Usuario Envío Fact. Elec.: ' || :NEW.CodUsuarioEnvFact ||
          ' IndContabilizada: ' || :NEW.IndContabilizada || ' Fecha Contabilizada ' || TO_CHAR(:NEW.FecContabilizada,'DD/MM/RRRR') ||
          ' No. Transacción Contab.: ' || :NEW.IdTransacContab || ' Ind. Fact. Elect.: ' || :NEW.IndFactElectronica ||
          ' Fecha. Gen. Aviso Cobro: ' || TO_CHAR(:NEW.FecGenAviCob,'DD/MM/RRRR') || ' Folio Fact. Elec.: ' || 
          :NEW.FolioFactElec || ' Fecha Envío Anul. Fact. Elec.: ' || TO_CHAR(:NEW.FecEnvFactElecAnu,'DD/MM/RRRR') ||
          ' Usuario Envio Anul. Fact. Elec.: ' || :NEW.CodUsuarioEnvFactAnu, cUsuario);
END;
/

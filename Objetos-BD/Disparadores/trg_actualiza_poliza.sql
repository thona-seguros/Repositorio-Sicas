--
-- TRG_ACTUALIZA_POLIZA  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   POLIZAS (Table)
--   LOG_TRANSACCION (Table)
--   MONEDA (Table)
--   SQ_LOGTRANSACC (Sequence)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_ACTUALIZA_POLIZA 
 BEFORE UPDATE ON SICAS_OC.POLIZAS
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
     INTO cUsuario
     FROM DUAL;

   SELECT Desc_Moneda
     INTO cMoneda
     FROM MONEDA
    WHERE Cod_Moneda = :NEW.Cod_Moneda;

   SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
     INTO cIP
     FROM DUAL;

   INSERT INTO LOG_TRANSACCION
     VALUES(nMaxtransaccion,:NEW.CodCia,'POLIZA'||' '||TO_CHAR(:NEW.IdPoliza),SYSDATE,
     cIP, :NEW.NumPolRef, 'ACTUALIZO POLIZA',
     'DATOS INGRESADOS: ' || 'Tipo Póliza: ' || :NEW.TipoPol ||
     ' Vigencia: ' || TO_CHAR(:NEW.FecIniVig,'DD/MM/YYYY') || ' A ' || TO_CHAR(:NEW.FecFinVig,'DD/MM/YYYY') ||
     ' Estado Póliza: ' || :NEW.StsPoliza || ' Suma Asegurada Local ' || :NEW.SumaAseg_Local ||
     ' Suma Asegurada Moneda: ' || :NEW.SumaAseg_Moneda || ' Prima Moneda: ' || :NEW.Primaneta_Local ||
     ' Prima Neta Moneda:' || :NEW.PrimaNeta_Moneda ||  ' Moneda:' || :NEW.Cod_Moneda ||
     ' Cliente : ' || :NEW.CodCliente || ' Agente: ' || :NEW.Cod_Agente || ' Plan de Pagos: ' || :NEW.CodPlanPago ||
     ' No. Póliza Unico: ' || :NEW.NumPolUnico || ' Grupo Económico: ' || :NEW.CodGrupoEc ||
     ' SAMI: ' || :NEW.SamiPoliza || ' Tipo Administración: ' || :NEW.TipoAdministracion ||
     ' Ind. Factura Póliza: ' || :NEW.IndFacturaPol || ' Ind. Fact. Elec.: ' || :NEW.IndFactElectronica ||
     ' Ind. Calculo Derechos: ' || :NEW.IndCalcDerechoEmis || ' Código Direc. Regional: ' || :NEW.CodDirecRegional ||
     ' No. Folio Portal: ' || :NEW.NumFolioPortal, cUsuario);
END;
/

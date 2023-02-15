
  CREATE OR REPLACE TRIGGER "SICAS_OC"."TRG_ACTUALIZA_DETALLE_POLIZA" 
 BEFORE UPDATE ON DETALLE_POLIZA
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

    SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
    INTO cIP
    FROM DUAL;
            INSERT INTO LOG_TRANSACCION
              VALUES(nMaxtransaccion,:NEW.CodCia,'POLIZA'||' '||TO_CHAR(:NEW.IDPOLIZA),SYSDATE,
              cIP, 'Insercion Detalle de Polza', 'ACTUALIZO DETALLE DE POLIZA',
              'DATOS INGRESADOS: ' || 'Detalle Poliza: ' || :NEW.IDetPol || ' Asegurado : ' || :NEW.Cod_Asegurado ||
              ' Empresa ' || :NEW.CodEmpresa || ' Plan de Pagos: ' || :NEW.CodPlanPago ||
              ' Vigencia: ' || TO_CHAR(:NEW.FecIniVig,'DD/MM/YYYY') || ' A ' || TO_CHAR(:NEW.FecFinVig,'DD/MM/YYYY') || 
              ' Suma Asegurada Local: ' || :NEW.Suma_Aseg_Local || ' Suma Asegurada Moneda:' || :NEW.Suma_Aseg_Moneda ||
              ' Prima Local: ' || :NEW.Prima_Local || ' Prima Moneda: ' || :NEW.Prima_Moneda || ' % de Comisión: ' ||
              :NEW.PorcComis || ' Tipo de Seguro: ' || :NEW.IdTipoSeg || ' Plan de Coberturas: ' || :NEW.PlanCob ||
              ' Código Filial: ' || :NEW.CodFilial || ' Código Categoría: ' || :NEW.CodCategoria ||
              ' Ind. Fact. Elec.: ' || :NEW.IndFactElectronica || ' Ind. Aseg. Modelo: ' || :NEW.IndAsegModelo ||
              ' Cantidad Aseg. Modelo: ' || :NEW.CantAsegModelo, cUsuario);
END;






ALTER TRIGGER "SICAS_OC"."TRG_ACTUALIZA_DETALLE_POLIZA" ENABLE

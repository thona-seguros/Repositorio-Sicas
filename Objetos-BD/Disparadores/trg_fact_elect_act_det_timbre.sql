--
-- TRG_FACT_ELECT_ACT_DET_TIMBRE  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   OC_FACT_ELECT_DET_TIMBRE_LOG (Package)
--   FACT_ELECT_DETALLE_TIMBRE (Table)
--   FACT_ELECT_DETALLE_TIMBRE_LOG (Table)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_FACT_ELECT_ACT_DET_TIMBRE
 BEFORE UPDATE ON SICAS_OC.FACT_ELECT_DETALLE_TIMBRE
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    nCodCia           FACT_ELECT_DETALLE_TIMBRE.CodCia%TYPE;
    nCodEmpresa       FACT_ELECT_DETALLE_TIMBRE.CodEmpresa%TYPE;
    cNombreCampo      FACT_ELECT_DETALLE_TIMBRE_LOG.NombreCampo%TYPE;
    cSentencia        FACT_ELECT_DETALLE_TIMBRE_LOG.Sentencia%TYPE := 'UPDATE';
    cTipoModificacion FACT_ELECT_DETALLE_TIMBRE_LOG.TipoModificacion%TYPE := 'MANUAL';
    cValorAntes       FACT_ELECT_DETALLE_TIMBRE_LOG.ValorAntes%TYPE;
    cValorDespues     FACT_ELECT_DETALLE_TIMBRE_LOG.ValorDespues%TYPE;
    cUsuario          VARCHAR2(30);
BEGIN

  SELECT USER
    INTO cUsuario
    FROM DUAL;

    nCodCia     := :NEW.CodCia;
    nCodEmpresa := :NEW.CodEmpresa;

    IF :NEW.IDFACTURA != :OLD.IDFACTURA THEN
        cNombreCampo := 'IdFactura';
        cValorAntes  := TO_CHAR(:OLD.IDFACTURA);
        cValorDespues:= TO_CHAR(:NEW.IDFACTURA);
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;
    IF :NEW.IDNCR != :OLD.IDNCR THEN
        cNombreCampo := 'IdNcr';
        cValorAntes  := TO_CHAR(:OLD.IDNCR);
        cValorDespues:= TO_CHAR(:NEW.IDNCR);
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;
    IF :NEW.CODPROCESO != :OLD.CODPROCESO THEN
        cNombreCampo := 'CodProceso';
        cValorAntes  := TO_CHAR(:OLD.CODPROCESO);
        cValorDespues:= TO_CHAR(:NEW.CODPROCESO);
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;
    IF :NEW.UUID != :OLD.UUID THEN
        cNombreCampo := 'UUID';
        cValorAntes  := TO_CHAR(:OLD.UUID);
        cValorDespues:= TO_CHAR(:NEW.UUID);
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;
    IF :NEW.FECHAUUID != :OLD.FECHAUUID THEN
        cNombreCampo := 'FechaUUID';
        cValorAntes  := TO_CHAR(:OLD.FECHAUUID,'DD/MM/YYYY');
        cValorDespues:= TO_CHAR(:NEW.FECHAUUID,'DD/MM/YYYY');
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;
    IF :NEW.FOLIOFISCAL != :OLD.FOLIOFISCAL THEN
        cNombreCampo := 'FolioFiscal';
        cValorAntes  := TO_CHAR(:OLD.FOLIOFISCAL);
        cValorDespues:= TO_CHAR(:NEW.FOLIOFISCAL);
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;
    IF :NEW.CODRESPUESTASAT != :OLD.CODRESPUESTASAT THEN
        cNombreCampo := 'CodRespuestaSAT';
        cValorAntes  := TO_CHAR(:OLD.CODRESPUESTASAT);
        cValorDespues:= TO_CHAR(:NEW.CODRESPUESTASAT);
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;
    IF :NEW.SERIE != :OLD.SERIE THEN
        cNombreCampo := 'Serie';
        cValorAntes  := TO_CHAR(:OLD.SERIE);
        cValorDespues:= TO_CHAR(:NEW.SERIE);
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;
    IF :NEW.UUIDCANCELADO != :OLD.UUIDCANCELADO THEN
        cNombreCampo := 'UuidCancelado';
        cValorAntes  := TO_CHAR(:OLD.UUIDCANCELADO);
        cValorDespues:= TO_CHAR(:NEW.UUIDCANCELADO);
        OC_FACT_ELECT_DET_TIMBRE_LOG.INSERTAR(nCodCia, nCodEmpresa, cNombreCampo,
                                              :NEW.IDFACTURA, :NEW.IDNCR, cSentencia, cTipoModificacion,
                                              cValorAntes, cValorDespues, SYSDATE, cUsuario);
    END IF;

END;
/

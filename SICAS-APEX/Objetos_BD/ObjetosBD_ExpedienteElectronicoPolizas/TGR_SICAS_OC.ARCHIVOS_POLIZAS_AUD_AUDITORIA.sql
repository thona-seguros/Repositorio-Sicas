-- ============================================================================
--  TRIGGER: ARCHIVOS_POLIZAS_AUD_AUDITORIA
-- ============================================================================
--  Descripción :   Gestiona automaticamente las columnas de auditoria
--                  (CREATED, UPDATED) en la tabla ARCHIVOS_POLIZAS_AUD.
--                  Registra fechas y usuarios en las columnas correspondientes
--                  segun la acción realiza.
-- ============================================================================

CREATE OR REPLACE TRIGGER SICAS_OC.ARCHIVOS_POLIZAS_AUD_AUDITORIA
    BEFORE INSERT OR UPDATE 
    ON SICAS_OC.ARCHIVOS_POLIZAS_AUD
    FOR EACH ROW
BEGIN

    IF INSERTING THEN
        :NEW.CREATED := SYSDATE;
        :NEW.CREATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER);
    END IF;

    :NEW.UPDATED := SYSDATE;
    :NEW.UPDATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER);

    IF UPDATING THEN
        :NEW.VERSION := :OLD.VERSION;
    END IF;

END ARCHIVOS_POLIZAS_AUD_AUDITORIA;
/

-- HABILITAR TRIGGER
ALTER TRIGGER SICAS_OC.ARCHIVOS_POLIZAS_AUD_AUDITORIA ENABLE;
/
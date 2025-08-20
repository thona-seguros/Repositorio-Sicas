-- ===========================================================================
--  TRIGGER: TIPO_DOCUMENTOS_POLIZAS_AUD
-- ===========================================================================
--  Descripción : Trigger que actualiza automáticamente las columnas de  
--                auditoría en la tabla TIPO_DOCUMENTOS_POLIZAS.
-- ===========================================================================

CREATE OR REPLACE TRIGGER SICAS_OC.TIPO_DOCUMENTOS_POLIZAS_AUD
    BEFORE INSERT OR UPDATE ON SICAS_OC.TIPO_DOCUMENTOS_POLIZAS
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.CREATED    := SYSDATE;
        :NEW.CREATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
    END IF;

    :NEW.UPDATED    := SYSDATE;
    :NEW.UPDATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
END TIPO_DOCUMENTOS_POLIZAS_AUD;
/

-- HABILITAR TRIGGER
ALTER TRIGGER SICAS_OC.TIPO_DOCUMENTOS_POLIZAS_AUD ENABLE;
/
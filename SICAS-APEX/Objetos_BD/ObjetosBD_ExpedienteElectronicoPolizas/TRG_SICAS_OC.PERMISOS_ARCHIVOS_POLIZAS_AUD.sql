-- ===========================================================================
--  TRIGGER: PERMISOS_ARCHIVOS_POLIZAS_AUD
-- ===========================================================================
--  Descripción : Trigger que actualiza automáticamente las columnas de  
--                auditoría en la tabla PERMISOS_ARCHIVOS_POLIZAS.
-- ===========================================================================

CREATE OR REPLACE EDITIONABLE TRIGGER SICAS_OC.PERMISOS_ARCHIVOS_POLIZAS_AUD
    BEFORE INSERT OR UPDATE ON SICAS_OC.PERMISOS_ARCHIVOS_POLIZAS
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.CREATED    := SYSDATE;
        :NEW.CREATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
    END IF;

    :NEW.UPDATED    := SYSDATE;
    :NEW.UPDATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
END PERMISOS_ARCHIVOS_POLIZAS_AUD;
/

-- HABILITAR TRIGGER
ALTER TRIGGER SICAS_OC.PERMISOS_ARCHIVOS_POLIZAS_AUD ENABLE;
/
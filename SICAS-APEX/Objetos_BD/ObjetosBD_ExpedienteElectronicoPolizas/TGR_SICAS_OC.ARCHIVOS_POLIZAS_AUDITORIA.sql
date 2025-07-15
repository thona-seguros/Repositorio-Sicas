-- ============================================================================
--  TRIGGER: ARCHIVOS_POLIZAS_AUDITORIA
-- ============================================================================
--  Descripción :   Gestiona automaticamente las columnas de auditoria
--                  (CREATED, UPDATED, DELETED) en la tabla ARCHIVOS_POLIZAS.
--                  Registra fechas y usuarios en las columnas correspondientes
--                  segun la acción realiza.
-- ============================================================================

CREATE OR REPLACE EDITIONABLE TRIGGER SICAS_OC.ARCHIVOS_POLIZAS_AUDITORIA
    BEFORE INSERT OR UPDATE ON SICAS_OC.ARCHIVOS_POLIZAS
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.CREATED    := SYSDATE;
        :NEW.CREATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
    END IF;

    :NEW.UPDATED    := SYSDATE;
    :NEW.UPDATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);

    IF :NEW.ESTATUS_BORRADO = 'S' THEN
        :NEW.DELETED    := SYSDATE;
        :NEW.DELETED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
    END IF;
END ARCHIVOS_POLIZAS_AUDITORIA;
/

-- HABILITAR TRIGGER
ALTER TRIGGER SICAS_OC.ARCHIVOS_POLIZAS_AUDITORIA ENABLE;
/
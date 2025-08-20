--------------------------------------------------------------------------------
                    --TABLA PARA TIPO_DOCUMENTOS_POLIZAS--
--------------------------------------------------------------------------------
DROP PUBLIC SYNONYM TIPO_DOCUMENTOS_POLIZAS;

CREATE TABLE SICAS_OC.TIPO_DOCUMENTOS_POLIZAS (
    "CLV_DOC"           VARCHAR2(5) NOT NULL ENABLE,                -- Clave del tipo de documento
    "DESCRIPCION"       VARCHAR2(500) NOT NULL ENABLE,              -- Descripción del tipo de documento
    "CLV_DOC_PARENT"    VARCHAR2(5),                                -- Clave del documento padre 
    "CREATED"           DATE DEFAULT SYSDATE NOT NULL ENABLE,       -- Fecha de creación del registro
    "CREATED_BY"        VARCHAR2(50) DEFAULT USER NOT NULL ENABLE,  -- Usuario que creó el registro
    "UPDATED"           DATE DEFAULT SYSDATE NOT NULL ENABLE,       -- Fecha de última actualización del registro
    "UPDATED_BY"        VARCHAR2(50) DEFAULT USER NOT NULL ENABLE   -- Usuario que actualizó por última vez
) TABLESPACE TS_SICASOC;

--ÍNDICES
CREATE UNIQUE INDEX SICAS_OC.TIPO_DOCUMENTOS_POLIZAS_INDX ON SICAS_OC.SINIESTRO_DETALLE_PAGO (CLV_DOC) TABLESPACE IDX_SICASOC;
/

--PRIMARY KEY
ALTER TABLE SICAS_OC.TIPO_DOCUMENTOS_POLIZAS ADD CONSTRAINT PK_TIPO_DOCUMENTOS_POLIZAS PRIMARY KEY (CLV_DOC) USING INDEX;
/

--GRANT
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON SICAS_OC.TIPO_DOCUMENTOS_POLIZAS TO ROL_MODIFICA_SICAS;
GRANT SELECT ON SICAS_OC.TIPO_DOCUMENTOS_POLIZAS TO ROL_CONSULTA_SICAS;
/

--SINÓNIMO
CREATE OR REPLACE PUBLIC SYNONYM TIPO_DOCUMENTOS_POLIZAS FOR SICAS_OC.TIPO_DOCUMENTOS_POLIZAS;
/

--##COMENTARIOS DESCRIPTIVOS
COMMENT ON TABLE SICAS_OC.TIPO_DOCUMENTOS_POLIZAS                       IS 'Catálogo de tipos de documentos utilizados en archivos de pólizas. Tabla: ARCHIVOS_POLIZAS';

COMMENT ON COLUMN SICAS_OC.TIPO_DOCUMENTOS_POLIZAS.CLV_DOC              IS 'Clave del tipo de documento';
COMMENT ON COLUMN SICAS_OC.TIPO_DOCUMENTOS_POLIZAS.DESCRIPCION          IS 'Descripción del tipo de documento';
COMMENT ON COLUMN SICAS_OC.TIPO_DOCUMENTOS_POLIZAS.CLV_DOC_PARENT       IS 'Clave del documento padre';
COMMENT ON COLUMN SICAS_OC.TIPO_DOCUMENTOS_POLIZAS.CREATED              IS 'Fecha de creación del registro';
COMMENT ON COLUMN SICAS_OC.TIPO_DOCUMENTOS_POLIZAS.CREATED_BY           IS 'Usuario que creó el registro';
COMMENT ON COLUMN SICAS_OC.TIPO_DOCUMENTOS_POLIZAS.UPDATED              IS 'Fecha de última actualización del registro';
COMMENT ON COLUMN SICAS_OC.TIPO_DOCUMENTOS_POLIZAS.UPDATED_BY           IS 'Usuario que actualizó por última vez el registro';

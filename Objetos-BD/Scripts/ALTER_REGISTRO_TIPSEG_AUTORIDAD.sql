ALTER TABLE REGISTRO_TIPSEG_AUTORIDAD ADD
(CondicionesGenerales  BLOB DEFAULT EMPTY_BLOB())  ;
/
COMMENT ON COLUMN SICAS_OC.REGISTRO_TIPSEG_AUTORIDAD.CondicionesGenerales IS 'Archivo de Condiciones Generales del Producto';
 
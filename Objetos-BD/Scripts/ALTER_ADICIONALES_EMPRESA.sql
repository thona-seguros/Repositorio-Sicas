-- Agregar columna para firma de Carta de Bienvenida de Agentes
ALTER TABLE ADICIONALES_EMPRESA ADD PathFirma_CBA VARCHAR2(100 BYTE);
/
COMMENT ON COLUMN ADICIONALES_EMPRESA.PathFirma_CBA IS 'Ruta de la firma para Carta de Bienvenida a Agentes';
/

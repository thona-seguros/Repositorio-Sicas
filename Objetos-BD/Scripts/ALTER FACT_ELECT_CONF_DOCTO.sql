ALTER TABLE FACT_ELECT_CONF_DOCTO ADD(
IndVentaPublicoGeneral  VARCHAR2(1)
);
/
COMMENT ON COLUMN FACT_ELECT_CONF_DOCTO.IndVentaPublicoGeneral IS 'Aplica para venta al publico en general';
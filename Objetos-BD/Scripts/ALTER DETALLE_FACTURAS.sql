ALTER TABLE DETALLE_FACTURAS ADD
(MontoPrimaCompMoneda   NUMBER(18,2),
 MontoPrimaCompLocal    NUMBER(18,2));
 /
COMMENT ON COLUMN DETALLE_FACTURAS.MontoPrimaCompMoneda IS 'Monto Prima Complementaria en Moneda';
/
COMMENT ON COLUMN DETALLE_FACTURAS.MontoPrimaCompLocal IS 'Monto Prima Complementaria en Moneda Local';
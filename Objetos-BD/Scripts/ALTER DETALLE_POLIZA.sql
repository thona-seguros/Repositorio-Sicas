ALTER TABLE DETALLE_POLIZA ADD
(MontoPrimaCompMoneda   NUMBER(18,2),
 MontoPrimaCompLocal    NUMBER(18,2));
 /
COMMENT ON COLUMN DETALLE_POLIZA.MontoPrimaCompMoneda IS 'Monto Prima Complementaria en Moneda';
/
COMMENT ON COLUMN DETALLE_POLIZA.MontoPrimaCompLocal IS 'Monto Prima Complementaria en Moneda Local';
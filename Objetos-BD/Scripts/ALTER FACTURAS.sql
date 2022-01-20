ALTER TABLE FACTURAS ADD
(MontoPrimaCompMoneda   NUMBER(18,2),
 MontoPrimaCompLocal    NUMBER(18,2));
 /
COMMENT ON COLUMN FACTURAS.MontoPrimaCompMoneda IS 'Monto Prima Complementaria en Moneda';
/
COMMENT ON COLUMN FACTURAS.MontoPrimaCompLocal IS 'Monto Prima Complementaria en Moneda Local';
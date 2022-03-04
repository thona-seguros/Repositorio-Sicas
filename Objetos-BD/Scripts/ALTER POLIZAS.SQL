----- alter table persona natural juridica
ALTER TABLE
   POLIZAS
ADD
   (
      COASEGURO             NUMBER(14,6),
      DEDUCIBLE	        NUMBER(18,2) 
   );

-- COMMENTS FOR POLIZAS
COMMENT ON COLUMN POLIZAS.COASEGURO IS 'Coaseguro';
/
COMMENT ON COLUMN POLIZAS.DEDUCIBLE IS 'Deducible';
/

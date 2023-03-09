-- Modifica tabla
-- =============================
--  
ALTER TABLE PAIS
ADD
(
TIPORIESGO		VARCHAR2(6)	
)
;
 
comment on column PAIS.TIPORIESGO	 is 'Tipo de riesgo';

/



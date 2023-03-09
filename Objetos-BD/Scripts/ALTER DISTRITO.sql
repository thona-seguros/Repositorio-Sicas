-- Modifica tabla
-- =============================
--  
ALTER TABLE DISTRITO
ADD
(
TIPORIESGO		VARCHAR2(6)	
)
;


comment on column DISTRITO.TIPORIESGO	 is 'Tipo de riesgo';

/



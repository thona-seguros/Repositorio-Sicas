-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE MONEDA
ADD
(
CVE_CNSF	VARCHAR2(15)	,
DESC_CNSF	VARCHAR2(300)	
)
;

comment on column MONEDA.CVE_CNSF is 'Clave de la CNSF';
comment on column MONEDA.DESC_CNSF is 'Descripcion de la CNSF';



/



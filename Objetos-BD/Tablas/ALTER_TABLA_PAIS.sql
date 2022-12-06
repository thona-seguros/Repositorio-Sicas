-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE PAIS
ADD
(
CVE_CNSF	VARCHAR2(15)	,
DESC_CNSF	VARCHAR2(300)	
)
;

comment on column PAIS.CVE_CNSF is 'Clave de la CNSF';
comment on column PAIS.DESC_CNSF is 'Descripcion de la CNSF';



/

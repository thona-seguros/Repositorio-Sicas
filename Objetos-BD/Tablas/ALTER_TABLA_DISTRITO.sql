-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE DISTRITO
ADD
(
CVE_CNSF	VARCHAR2(15)	,
DESC_CNSF	VARCHAR2(300)	
)
;

comment on column DISTRITO.CVE_CNSF is 'Clave de la CNSF';
comment on column DISTRITO.DESC_CNSF is 'Descripcion de la CNSF';



/



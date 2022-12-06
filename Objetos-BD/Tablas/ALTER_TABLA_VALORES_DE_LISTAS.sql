-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE VALORES_DE_LISTAS
ADD
(
CVE_CNSF	VARCHAR2(15)	,
DESC_CNSF	VARCHAR2(300)	
)
;

comment on column VALORES_DE_LISTAS.CVE_CNSF is 'Clave de la CNSF';
comment on column VALORES_DE_LISTAS.DESC_CNSF is 'Descripcion de la CNSF';



/



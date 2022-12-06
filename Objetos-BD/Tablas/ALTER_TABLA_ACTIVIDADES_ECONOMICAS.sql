-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE ACTIVIDADES_ECONOMICAS
ADD
(
CVE_CNSF	VARCHAR2(15)	,
DESC_CNSF	VARCHAR2(300)	
)
;

comment on column ACTIVIDADES_ECONOMICAS.CVE_CNSF is 'Clave de la CNSF';
comment on column ACTIVIDADES_ECONOMICAS.DESC_CNSF is 'Descripcion de la CNSF';



/



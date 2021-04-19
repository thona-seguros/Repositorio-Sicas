-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE SINIESTRO
ADD
(
CODMUNICIPIO	VARCHAR2(3)	,
NOM_MEDICO_CERTIFICA	VARCHAR2(300)	,
ID_CEDULA_MEDICA	VARCHAR2(20)
)
;

comment on column SINIESTRO.CODMUNICIPIO is 'Codigo de municipio';
comment on column SINIESTRO.NOM_MEDICO_CERTIFICA is 'Nombre de medico certificante';
comment on column SINIESTRO.ID_CEDULA_MEDICA is 'Cedula medico';



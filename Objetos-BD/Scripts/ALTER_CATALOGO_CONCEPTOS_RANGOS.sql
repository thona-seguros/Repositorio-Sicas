-- =============================
-- Modifica tabla
-- =============================
-- 
ALTER TABLE CATALOGO_CONCEPTOS_RANGOS
ADD
(
ID_AÑO	NUMBER(5)	DEFAULT 1
)
;
comment on column CATALOGO_CONCEPTOS_RANGOS.ID_AÑO is 'Año polizá';
--
-- =============================
-- Modifica llave primaria
-- =============================
-- 
-- Elimina llave actual
--
alter table CATALOGO_CONCEPTOS_RANGOS drop constraint PK_CATALOGO_CONCEPTOS_RANGOS cascade;
-- 
-- Elimina indice de la llave actual
--
drop index PK_CATALOGO_CONCEPTOS_RANGOS;
-- 
-- Construye la llave nueva
--
alter table CATALOGO_CONCEPTOS_RANGOS
add constraint PK_CATALOGO_CONCEPTOS_RANGOS primary key (CODCIA, CODEMPRESA, CODCONCEPTO, IDTIPOSEG, CODTIPORANGO, CODMONEDA, ID_AÑO, RANGOINICIAL, RANGOFINAL)
using index;
--

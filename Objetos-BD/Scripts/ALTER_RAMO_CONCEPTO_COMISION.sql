-- =============================
-- Elimina llave primaria
-- =============================
-- 
ALTER TABLE RAMO_CONCEPTO_COMISION drop constraint PK_RAMO_CONCEPTO cascade;
DROP INDEX PK_RAMO_CONCEPTO;

-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE RAMO_CONCEPTO_COMISION
ADD
(
CODTIPOPLAN	VARCHAR2(6) default 999
)
;
comment on column RAMO_CONCEPTO_COMISION.CODTIPOPLAN is 'Codigo del Tipo Plan (Ramo) Relacionado';


alter table RAMO_CONCEPTO_COMISION
  add constraint PK_RAMO_CONCEPTO primary key (CODCONCEPTO,CODCIA,IDTIPOSEG,CODEMPRESA,CODTIPO,ORIGEN, CODTIPOPLAN)
; 
 

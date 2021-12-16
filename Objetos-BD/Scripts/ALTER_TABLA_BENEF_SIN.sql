-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE BENEF_SIN
ADD
(
ID_EDAD_MINORIA	VARCHAR2(2)	,
NOMBRE_MINORIA	VARCHAR2(100)	,
PORC_MINORIA	NUMBER(8,6),
SIT_CLIENTE	VARCHAR2(20)	,
SIT_REFERENCIA	VARCHAR2(50)	,
SIT_CONCEPTO	VARCHAR2(100)
)
;

comment on column BENEF_SIN.ID_EDAD_MINORIA is 'Identificador de si hay minoria de edad';
comment on column BENEF_SIN.NOMBRE_MINORIA is 'Nombre de beneficiario con minoria ';
comment on column BENEF_SIN.PORC_MINORIA is 'Porcentaje del pago ';
comment on column BENEF_SIN.SIT_CLIENTE is 'Numero de cliente de convenio';
comment on column BENEF_SIN.SIT_REFERENCIA is 'Numero de referencia de convenio';
comment on column BENEF_SIN.SIT_CONCEPTO is 'Concepto de convenio';


/


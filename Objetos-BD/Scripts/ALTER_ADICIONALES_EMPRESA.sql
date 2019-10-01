-- =============================
-- Modifica tabla
-- =============================
-- 
ALTER TABLE ADICIONALES_EMPRESA
ADD
(
DIRECCION_UEAT  VARCHAR2(500),
EMAIL_UEAT      VARCHAR2(200),
HORARIO_UEAT    VARCHAR2(200),
TELEFONO_UEAT   VARCHAR2(200)
)
;
comment on column ADICIONALES_EMPRESA.DIRECCION_UEAT is 'Direccion de la Unidad de Atencion a Clientes Thona';
comment on column ADICIONALES_EMPRESA.EMAIL_UEAT     is 'Email de la Unidad de Atencion a Clientes Thona';
comment on column ADICIONALES_EMPRESA.HORARIO_UEAT   is 'Horario de la Unidad de Atencion a Clientes Thona';
comment on column ADICIONALES_EMPRESA.TELEFONO_UEAT  is 'Telefono de la Unidad de Atencion a Clientes Thona';


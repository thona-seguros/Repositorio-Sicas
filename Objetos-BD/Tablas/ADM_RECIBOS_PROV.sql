
-- Create table
DROP PUBLIC SYNONYM ADM_RECIBOS_PROV;
DROP TABLE SICAS_OC.ADM_RECIBOS_PROV;

create table SICAS_OC.ADM_RECIBOS_PROV
(
  CODCIA             NUMBER(14) not null,
  CODEMPRESA         NUMBER(14) not null,
  IDPOLIZA           NUMBER(14) not null,
  IDENDOSO           NUMBER(14) not null,
  IDETPOL            NUMBER(14),
  IDTRANSACCION      NUMBER(18) not null,
  IDFACTURA          NUMBER(14) not null,
  MONTO_FACT_MONEDA  NUMBER(18,2)not null,
  IDFACTURA2         NUMBER(14),
  MONTO_FACT_MONEDA2 NUMBER(18,2),
  IDNCR              NUMBER(14),
  MONTO_NCR_MONEDA   NUMBER(18,2),
  NUMCUOTA           NUMBER(3),
  FECFINVIG          DATE,
  FECVENC            DATE,
  MONTOTOTALMONEDA   NUMBER(18,2),
  IVASIN             NUMBER(18,2),
  PRIMANETA          NUMBER(18,2),
  STS                VARCHAR2(3),
  FECHATRANSACCION   DATE,
  USUARIOGENERO      VARCHAR2(30)
)
tablespace TS_SICASOC
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
/
-- Add comments to the columns 
comment on column SICAS_OC.ADM_RECIBOS_PROV.CODCIA
  is 'Fecha de Inicio de Vigencia';
comment on column SICAS_OC.ADM_RECIBOS_PROV.CODEMPRESA
  is 'Codigo de Empresa';
comment on column SICAS_OC.ADM_RECIBOS_PROV.IDPOLIZA
  is 'Identificador de Poliza';
comment on column SICAS_OC.ADM_RECIBOS_PROV.IDENDOSO
  is 'Identificador de Endoso';
comment on column SICAS_OC.ADM_RECIBOS_PROV.IDETPOL
  is 'Identificador de Certificado';
comment on column SICAS_OC.ADM_RECIBOS_PROV.IDTRANSACCION
  is 'Identificador Unico de Transaccion';
comment on column SICAS_OC.ADM_RECIBOS_PROV.IDFACTURA
  is 'Identificador de Recibo Original';
comment on column SICAS_OC.ADM_RECIBOS_PROV.MONTO_FACT_MONEDA
  is 'Monto de factura Original';
comment on column SICAS_OC.ADM_RECIBOS_PROV.IDFACTURA2
  is 'Identificador de Recibo Provicional';
comment on column SICAS_OC.ADM_RECIBOS_PROV.MONTO_FACT_MONEDA2
  is 'Monto de Recibo Provicional';
comment on column SICAS_OC.ADM_RECIBOS_PROV.IDNCR
  is 'Identificador de Nota de Credito Provicional';
comment on column SICAS_OC.ADM_RECIBOS_PROV.MONTO_NCR_MONEDA
  is 'Monto de Nota de Credito Provicional';
comment on column SICAS_OC.ADM_RECIBOS_PROV.NUMCUOTA
  is 'Numero de Cuota de factura';
comment on column SICAS_OC.ADM_RECIBOS_PROV.FECFINVIG
  is 'Fecha de inicio de vigencia de Recibo';
comment on column SICAS_OC.ADM_RECIBOS_PROV.FECVENC
  is 'Fecha de Vencimiento de Recibo';
comment on column SICAS_OC.ADM_RECIBOS_PROV.MONTOTOTALMONEDA
  is 'Monto total del recibo 1 y 2';
comment on column SICAS_OC.ADM_RECIBOS_PROV.IVASIN
  is 'IVA del Recibo';
comment on column SICAS_OC.ADM_RECIBOS_PROV.PRIMANETA
  is 'Prima Neta para los Recibo AP';
comment on column SICAS_OC.ADM_RECIBOS_PROV.STS
  is 'Status del Recibo Provicional';
comment on column SICAS_OC.ADM_RECIBOS_PROV.FECHATRANSACCION
  is 'Fecha que se realizo la Transaccion';
comment on column SICAS_OC.ADM_RECIBOS_PROV.USUARIOGENERO
  is 'Usuario que genero el registro';
/
-- Create/Recreate primary, unique and foreign key constraints 
alter table SICAS_OC.ADM_RECIBOS_PROV
  add primary key (IDENDOSO, IDPOLIZA, CODCIA, IDTRANSACCION)
  using index 
  tablespace IDX_SICASOC
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
/
-- Create/Recreate indexes 
create index IDX_ADM_RECIBOS_PROV_1 on ADM_RECIBOS_PROV (CODCIA, CODEMPRESA, FECHATRANSACCION, IDPOLIZA)
  tablespace TS_SICASOC
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
  
 /
 CREATE PUBLIC SYNONYM ADM_RECIBOS_PROV FOR ADM_RECIBOS_PROV;

/
-- Grant/Revoke object privileges 
grant select on SICAS_OC.ADM_RECIBOS_PROV to ROL_CONSULTA_SICAS;
grant select, insert, update, delete, alter on SICAS_OC.ADM_RECIBOS_PROV to ROL_MODIFICA_SICAS;
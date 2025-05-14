DROP TABLE SICAS_OC.T_EDOSCTA_ARRASTRE_PD;
-- Create table
create table SICAS_OC.T_EDOSCTA_ARRASTRE_PD
(
  IDEJECUCION             NUMBER(14),
  cod_agente              NUMBER(18) not null,
  fecha_desde             DATE not null,
  fecha_hasta             DATE not null,
  nivel_agente            VARCHAR2(50),
  descripcion_ramo        VARCHAR2(200),
  codnivel                NUMBER(10),
  numpolunico             VARCHAR2(30),
  fec_generacion          DATE,
  idpoliza                NUMBER(14),
  idendoso                VARCHAR2(14),
  nomcliente              VARCHAR2(350),
  recibo                  VARCHAR2(16),
  moneda                  VARCHAR2(5),
  prima_comisinable_local NUMBER(18,2),
  monto_comision          NUMBER(18,2),
  comi_moneda             NUMBER(18,2),
  stt_comision            VARCHAR2(6),
  status_pagof            VARCHAR2(6),
  pagado                  NUMBER(18,2),
  por_pagar               NUMBER(18,2),
  mtoiva                  NUMBER(18,2),
  mtoivaret               NUMBER(18,2),
  mtoisr                  NUMBER(18,2),
  mtoisrret               NUMBER(18,2),
  subtotal                NUMBER(18,2),
  case_comision           NUMBER(18,2),
  case_mtoiva             NUMBER(18,2),
  case_mtoivaret          NUMBER(18,2),
  case_mtoisr             NUMBER(18,2),
  case_mtoisrret          NUMBER(18,2),
  por_pagar_showon        NUMBER(18,2),
  por_pagar_comision      NUMBER(18,2),
  por_pagar_mtoiva        NUMBER(18,2),
  por_pagar_mtoivaret     NUMBER(18,2),
  por_pagar_mtoisr        NUMBER(18,2),
  case_mtoprimafactura    NUMBER(18,2),
  en_contra               NUMBER(18,2),
  codtipoplan             VARCHAR2(6),
  a_favor                 NUMBER(18,2),
  idcomision              NUMBER(14) not null,
  nombre_agente           VARCHAR2(150),
  direcres                VARCHAR2(150),
  num_tributario          VARCHAR2(20),
  numcedula               VARCHAR2(30),
  fecvencimiento          DATE,
  tipo_persona            VARCHAR2(20),
  num_doc_identificacion  VARCHAR2(20),
  por_com_distribuida     NUMBER(9,6),
  porc_com_proporcional   NUMBER(9,6),
  prima_neta              NUMBER(18,2),
  mtoprimafactura         NUMBER(18,2),
  nomina_com              NUMBER(14),
  fecha_pago              DATE
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

-- Add comments to the table 
comment on table SICAS_OC.T_EDOSCTA_ARRASTRE_PD
  is 'Tabla temporal para saldos de arrastre';
-- Add comments to the columns 
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.IDEJECUCION
  is 'ID identificador de ejecución de reportes PD';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.cod_agente
  is 'Codigo de agente';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.fecha_desde
  is 'Codigo de agente';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.fecha_hasta
  is 'Codigo de agente';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.nivel_agente
  is 'NIvel de agente';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.descripcion_ramo
  is 'Desc. ramo';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.codnivel
  is 'Codigo de nivel';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.numpolunico
  is 'No. de Poliza unico';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.fec_generacion
  is 'Fecha de generacion';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.idpoliza
  is 'Numero de poliza';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.idendoso
  is 'Numero de endoso';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.nomcliente
  is 'Nombre del cliente';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.recibo
  is 'Recibo';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.moneda
  is 'Moneda';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.prima_comisinable_local
  is 'Prima comisionable';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.monto_comision
  is 'Monto comision';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.comi_moneda
  is 'Monto comision moneda';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.stt_comision
  is 'Status de la comision';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.status_pagof
  is 'Status del pago';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.pagado
  is 'Monto pagado';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.por_pagar
  is 'Monto por pagar';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.mtoiva
  is 'Monto de iva';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.mtoivaret
  is 'Monto iva retenido';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.mtoisr
  is 'Monto de isr';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.mtoisrret
  is 'Monto isr retenido';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.subtotal
  is 'Monto del subtotal';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.case_comision
  is 'Monto de caso comision';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.case_mtoiva
  is 'Monto de caso iva';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.case_mtoivaret
  is 'Monto de caso iva retenido';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.case_mtoisr
  is 'Monto caso de isr';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.case_mtoisrret
  is 'Monto caso de isr retenido';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.por_pagar_showon
  is 'Monto por pagar showon';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.por_pagar_comision
  is 'Monto comision por pagar';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.por_pagar_mtoiva
  is 'Monto de iva por pagar';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.por_pagar_mtoivaret
  is 'Monto de iva retenido por pagar';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.por_pagar_mtoisr
  is 'Monto de isr por pagar';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.case_mtoprimafactura
  is 'Monto prima factura';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.en_contra
  is 'Monto en contra';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.codtipoplan
  is 'Codigo de tipo de plan';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.a_favor
  is 'Monto a favor';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.idcomision
  is 'Identificador de comision';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.nombre_agente
  is 'Nombre del agentel';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.direcres
  is 'Direccion';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.num_tributario
  is 'Numero tributario';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.numcedula
  is 'Numero de cedula';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.fecvencimiento
  is 'Fecha de vencimiento';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.tipo_persona
  is 'Tipo de persona';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.num_doc_identificacion
  is 'RFC';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.por_com_distribuida
  is 'Comision distribuida';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.porc_com_proporcional
  is 'Comision proporcional';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.prima_neta
  is 'Monto de Prima neta';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.mtoprimafactura
  is 'Monto prima factura';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.nomina_com
  is 'Numero de nomina';
comment on column SICAS_OC.T_EDOSCTA_ARRASTRE_PD.fecha_pago
  is 'Fecha de Pago';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SICAS_OC.T_EDOSCTA_ARRASTRE_PD
  add constraint PK_T_EDOSCTA_ARRASTRE_PD primary key (IDEJECUCION, COD_AGENTE, FECHA_DESDE, FECHA_HASTA, IDCOMISION)
  using index
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
-- Grant/Revoke object privileges 
grant select, insert, update, delete, alter on SICAS_OC.T_EDOSCTA_ARRASTRE_PD to ROL_MODIFICA_SICAS;

CREATE OR REPLACE PUBLIC SYNONYM T_EDOSCTA_ARRASTRE_PD FOR SICAS_OC.T_EDOSCTA_ARRASTRE_PD;

-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM SALDOS_COMISIONES_MES
;
DROP TABLE SALDOS_COMISIONES_MES
;

CREATE TABLE SALDOS_COMISIONES_MES
(
CD_CIA        		NUMBER(14)  ,
CD_AGENTE 		NUMBER(18),
CD_TIPO_RAMO      	VARCHAR2(6)  ,
FE_INI_SALDO		DATE,
FE_FIN_SALDO		DATE,
FE_PROC_SALDO		DATE,
CD_MONEDA		VARCHAR2(5),
MT_SALDO_INICIAL	NUMBER(18,2),
MT_COMISION_MES	NUMBER(18,2),
MT_IVA_MES		NUMBER(18,2),
MT_IVARET_MES		NUMBER(18,2),
MT_ISR_MES		NUMBER(18,2),
MT_ISRRET_MES		NUMBER(18,2),
MT_ENCONTRA_MES	NUMBER(18,2),
MT_AFAVOR_MES		NUMBER(18,2),
MT_SALDO_FINAL		NUMBER(18,2),
DS_OBSERVACIONES	VARCHAR2(300),

CONSTRAINT SALDOS_COMIS_MES_pk PRIMARY KEY(CD_CIA, CD_AGENTE, CD_TIPO_RAMO, FE_INI_SALDO )
)

TABLESPACE TS_SICASOC
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on SALDOS_COMISIONES_MES to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM SALDOS_COMISIONES_MES FOR SALDOS_COMISIONES_MES
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column SALDOS_COMISIONES_MES.CD_CIA 			is 'Numero de compañía';
comment on column SALDOS_COMISIONES_MES.CD_AGENTE  		is 'Codigo de Agente';
comment on column SALDOS_COMISIONES_MES.CD_TIPO_RAMO       	is 'Tipo de Ramo';
comment on column SALDOS_COMISIONES_MES.FE_INI_SALDO	 	is 'Fecha Inicio Saldo';
comment on column SALDOS_COMISIONES_MES.FE_FIN_SALDO	 	is 'Fecha_final_saldo';
comment on column SALDOS_COMISIONES_MES.FE_PROC_SALDO	is 'Fecha Proceso Saldo';
comment on column SALDOS_COMISIONES_MES.CD_MONEDA	 	is 'Moneda';
comment on column SALDOS_COMISIONES_MES.MT_SALDO_INICIAL	is 'Monto Saldo Inicial';
comment on column SALDOS_COMISIONES_MES.MT_COMISION_MES	is 'Monto Comision Mes';
comment on column SALDOS_COMISIONES_MES.MT_IVA_MES	 	is 'Monto Iva Mes';
comment on column SALDOS_COMISIONES_MES.MT_IVARET_MES		is 'Monto IvaRet Mes';
comment on column SALDOS_COMISIONES_MES.MT_ISR_MES		is 'Monto ISR Mes';
comment on column SALDOS_COMISIONES_MES.MT_ISRRET_MES		is 'Monto ISRRET Mes';
comment on column SALDOS_COMISIONES_MES.MT_ENCONTRA_MES	is 'Monto en Contra Mes';
comment on column SALDOS_COMISIONES_MES.MT_AFAVOR_MES	is 'Monto a Favor Mes';
comment on column SALDOS_COMISIONES_MES.MT_SALDO_FINAL	is 'Monto Saldo Final Mes';
comment on column SALDOS_COMISIONES_MES.DS_OBSERVACIONES	 is 'Observaciones';
-----
/

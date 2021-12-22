-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM SALDOS_COMISIONES_MES_3
;
DROP TABLE SALDOS_COMISIONES_MES_3
;

CREATE TABLE SALDOS_COMISIONES_MES_3
(
CODCIA        		NUMBER(14)  ,
COD_AGENTE 		NUMBER(18),
COD_TIPO_RAMO      	VARCHAR2(6)  ,
FEC_INI_SALDO		DATE,
FEC_FIN_SALDO		DATE,
FEC_PROC_SALDO		DATE,
COD_MONEDA		VARCHAR2(5),
MONTO_SALDO_INICIAL	NUMBER(18,2),
MONTO_COMISION_MES	NUMBER(18,2),
MONTO_IVA_MES		NUMBER(18,2),
MONTO_IVARET_MES	NUMBER(18,2),
MONTO_ISR_MES		NUMBER(18,2),
MONTO_ISRRET_MES	NUMBER(18,2),
MONTO_ENCONTRA_MES	NUMBER(18,2),
MONTO_AFAVOR_MES	NUMBER(18,2),
MONTO_SALDO_FINAL	NUMBER(18,2),
DESC_OBSERVACIONES	VARCHAR2(300),

CONSTRAINT SALDOS_COMIS_MES3_PK PRIMARY KEY(CODCIA, COD_AGENTE, COD_TIPO_RAMO, FEC_INI_SALDO, COD_MONEDA )
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
grant select, insert, update, delete, alter, index on SALDOS_COMISIONES_MES_3 to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM SALDOS_COMISIONES_MES_3 FOR SALDOS_COMISIONES_MES_3
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column SALDOS_COMISIONES_MES_3.CODCIA 			is 'Numero de compañía';
comment on column SALDOS_COMISIONES_MES_3.COD_AGENTE  		is 'Codigo de Agente';
comment on column SALDOS_COMISIONES_MES_3.COD_TIPO_RAMO       	is 'Tipo de Ramo';
comment on column SALDOS_COMISIONES_MES_3.FEC_INI_SALDO	 	is 'Fecha Inicio Saldo';
comment on column SALDOS_COMISIONES_MES_3.FEC_FIN_SALDO	 	is 'Fecha_final_saldo';
comment on column SALDOS_COMISIONES_MES_3.FEC_PROC_SALDO		is 'Fecha Proceso Saldo';
comment on column SALDOS_COMISIONES_MES_3.COD_MONEDA	 	is 'Moneda';
comment on column SALDOS_COMISIONES_MES_3.MONTO_SALDO_INICIAL	is 'Monto Saldo Inicial';
comment on column SALDOS_COMISIONES_MES_3.MONTO_COMISION_MES	is 'Monto Comision Mes';
comment on column SALDOS_COMISIONES_MES_3.MONTO_IVA_MES	 	is 'Monto Iva Mes';
comment on column SALDOS_COMISIONES_MES_3.MONTO_IVARET_MES	is 'Monto IvaRet Mes';
comment on column SALDOS_COMISIONES_MES_3.MONTO_ISR_MES		is 'Monto ISR Mes';
comment on column SALDOS_COMISIONES_MES_3.MONTO_ISRRET_MES	is 'Monto ISRRET Mes';
comment on column SALDOS_COMISIONES_MES_3.MONTO_ENCONTRA_MES	is 'Monto en Contra Mes';
comment on column SALDOS_COMISIONES_MES_3.MONTO_AFAVOR_MES	is 'Monto a Favor Mes';
comment on column SALDOS_COMISIONES_MES_3.MONTO_SALDO_FINAL	is 'Monto Saldo Final Mes';
comment on column SALDOS_COMISIONES_MES_3.DESC_OBSERVACIONES	is 'Observaciones';
-----
/

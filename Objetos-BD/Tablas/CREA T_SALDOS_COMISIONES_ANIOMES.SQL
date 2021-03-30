-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM T_SALDOS_COMISIONES_ANIOMES
;
DROP TABLE T_SALDOS_COMISIONES_ANIOMES
;

CREATE TABLE T_SALDOS_COMISIONES_ANIOMES
(
CODCIA        		NUMBER(14)  ,
COD_AGENTE 		NUMBER(18),
FE_INI_SALDO		DATE,
COD_MONEDA		VARCHAR2(5),
MONTO_SALDO_FINAL		NUMBER(18,2),

CONSTRAINT SALDOS_COMIS_ANIOMES_pk PRIMARY KEY(CODCIA, COD_AGENTE,COD_MONEDA,FE_INI_SALDO )
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
grant select, insert, update, delete, alter, index on T_SALDOS_COMISIONES_ANIOMES to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM T_SALDOS_COMISIONES_ANIOMES FOR T_SALDOS_COMISIONES_ANIOMES
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column T_SALDOS_COMISIONES_ANIOMES.CODCIA 			is 'Numero de compañía';
comment on column T_SALDOS_COMISIONES_ANIOMES.COD_AGENTE  		is 'Codigo de Agente';
comment on column T_SALDOS_COMISIONES_ANIOMES.FE_INI_SALDO	 	is 'Fecha Inicio Saldo';
comment on column T_SALDOS_COMISIONES_ANIOMES.COD_MONEDA	 	is 'Moneda';
comment on column T_SALDOS_COMISIONES_ANIOMES.MONTO_SALDO_FINAL		is 'Monto Saldo Final Mes';
-----
/

-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM LOG_CONF_FACT_ELECT;
DROP TABLE SICAS_OC.LOG_CONF_FACT_ELECT;


CREATE TABLE SICAS_OC.LOG_CONF_FACT_ELECT
(
IDCTRLOG	    NUMBER(22),
CODCIA	        NUMBER(22),
NOMBRETABLA	    VARCHAR2(100),
NOMBRECAMPO	    VARCHAR2(100),
VALORCAMPOANT	CLOB default EMPTY_CLOB(),
VALORCAMPOUPD	CLOB default EMPTY_CLOB(),
ACCION	        VARCHAR2(50),
USUARIOMOD	    VARCHAR2(30),
FECMODIFICACION	DATE
)
tablespace TS_SICASOC;
/
-- =============================
-- Genera Primaty key
-- =============================
 
alter table SICAS_OC.LOG_CONF_FACT_ELECT
  add constraint PK_LOG_CONF_FACT_ELECT primary key (CODCIA,IDCTRLOG)
   using index 
  tablespace TS_SICASOC; 

/
-- =============================
-- Genera Indice
-- =============================
create  index LOG_CONF_FACT_ELECT_IDX_1 on LOG_CONF_FACT_ELECT(CODCIA,NOMBRETABLA)
  tablespace TS_SICASOC;
create  index LOG_CONF_FACT_ELECT_IDX_2 on LOG_CONF_FACT_ELECT(CODCIA,NOMBRETABLA,NOMBRECAMPO)
  tablespace TS_SICASOC;
/

-- =============================
-- Crea Comentarios
-- =============================
comment on TABLE SICAS_OC.LOG_CONF_FACT_ELECT is 'Tabla construida para Logs de cambios en la configuracion de Factura Electronica';

comment on column SICAS_OC.LOG_CONF_FACT_ELECT.IDCTRLOG is 'No. de Operación';
comment on column SICAS_OC.LOG_CONF_FACT_ELECT.CODCIA is 'Clave de Compania';
comment on column SICAS_OC.LOG_CONF_FACT_ELECT.NOMBRETABLA is 'Nombre de la Tabla modificada';
comment on column SICAS_OC.LOG_CONF_FACT_ELECT.NOMBRECAMPO is 'Nombre del Campo modificado';
comment on column SICAS_OC.LOG_CONF_FACT_ELECT.VALORCAMPOANT is 'Valor anterior del campo';
comment on column SICAS_OC.LOG_CONF_FACT_ELECT.VALORCAMPOUPD is 'Valor actualizdo del campo';
comment on column SICAS_OC.LOG_CONF_FACT_ELECT.ACCION is 'Descripción de la accion ejecutada (Update, Delete)';
comment on column SICAS_OC.LOG_CONF_FACT_ELECT.USUARIOMOD is 'Usuario de actualizacion';
comment on column SICAS_OC.LOG_CONF_FACT_ELECT.FECMODIFICACION is 'Fecha de actualizacion';


/

-- =============================
-- Crea el Sinónimo
-- =============================
CREATE OR REPLACE PUBLIC SYNONYM LOG_CONF_FACT_ELECT FOR SICAS_OC.LOG_CONF_FACT_ELECT;

/

-- =============================
-- Genera los permisos
-- =============================
GRANT DELETE, INSERT, SELECT, UPDATE ON SICAS_OC.LOG_CONF_FACT_ELECT TO PUBLIC;

/
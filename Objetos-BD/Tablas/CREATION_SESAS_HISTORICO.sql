--ELIMINACION SINONIMO TABLA
DROP PUBLIC SYNONYM SESAS_HISTORICO; 
/
--ELIMINACION SINONIMO SECUENCIA
DROP PUBLIC SYNONYM SESAS_HIST_SEQ; 
/
--ELIMINACION SECUENCIA
DROP SEQUENCE SICAS_OC.SESAS_HIST_SEQ;
/
--ELIMINACION TABLA
DROP TABLE SICAS_OC.SESAS_HISTORICO;
/

----SCRIPT SECUENCIA SESAS_HIST_SEQ

  CREATE SEQUENCE SICAS_OC.SESAS_HIST_SEQ
  START WITH 1
  INCREMENT BY 1
  NOMAXVALUE
  MINVALUE 1
  ORDER;
/
----CREACION SEGUNDA TABLA SESAS_HISTORICO

CREATE TABLE SICAS_OC.SESAS_HISTORICO(
ID_SESAS_HIST NUMBER  DEFAULT SICAS_OC.SESAS_HIST_SEQ.NEXTVAL,
CODCIA NUMBER DEFAULT 1,
CODEMPRESA NUMBER DEFAULT 1,
NPOLIZA VARCHAR2(30),	
CERTIFICADO	VARCHAR2(20),
IDSINIESTRO	NUMBER NOT NULL,
NUM_REC	NUMBER,
FECOCU		DATE,
FECREP		DATE,
FECCON		VARCHAR2(10),
FECPAG		VARCHAR2(10),
EST_REC	VARCHAR2(30),
ENTIDAD_OC	VARCHAR2(30),
COB_AFEC	NUMBER,
FNACIM	VARCHAR2(10),
SEXO	VARCHAR2(1),
CAUSA	VARCHAR2(200),
TIP_MOV	VARCHAR2(5),
MONTO	NUMBER,
MTO_DED	NUMBER,
MTO_COA	NUMBER,
MTO_PAG	NUMBER,
MTO_CED	NUMBER,
PC	VARCHAR2(30),
ANOREP	NUMBER,
CREATION_BY VARCHAR2(30) DEFAULT USER,
CREATION_DATE DATE DEFAULT SYSDATE ,
LAST_UPDATE_BY VARCHAR2(30) DEFAULT USER,
LAST_UPDATE_DATE DATE DEFAULT SYSDATE,
ESTATUS VARCHAR2(30),
RECL NUMBER,
EST_CIERRE NUMBER,
IDPOLIZA NUMBER,
COBERTURA VARCHAR2(20)
)TABLESPACE TS_SICASOC;
/
  --CREACION DE INDICES PARA COLUMNAS
CREATE UNIQUE INDEX SICAS_OC.SIN_SESAS_HIST_IDX ON SICAS_OC.SESAS_HISTORICO(CODCIA,CODEMPRESA,ID_SESAS_HIST) TABLESPACE IDX_SICASOC;



CREATE  INDEX SICAS_OC.SIN_SESAS_HIST_IDSINIESTRO_IDX ON SICAS_OC.SESAS_HISTORICO(IDSINIESTRO) TABLESPACE IDX_SICASOC;

CREATE  INDEX SICAS_OC.SIN_SESAS_HIST_NPOLIZA_IDX ON SICAS_OC.SESAS_HISTORICO(NPOLIZA) TABLESPACE IDX_SICASOC;
/

 --CREACION DE PK PARA COLUMNAS
  ALTER TABLE SICAS_OC.SESAS_HISTORICO ADD CONSTRAINT PK_SESAS_HIST PRIMARY KEY (CODCIA,CODEMPRESA,ID_SESAS_HIST) USING INDEX SIN_SESAS_HIST_IDX;
  /
  --##GRANTs

  GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON SICAS_OC.SESAS_HISTORICO TO ROL_MODIFICA_SICAS;
  GRANT SELECT ON SICAS_OC.SESAS_HISTORICO TO ROL_CONSULTA_SICAS;
  /
  --SINONIMO TABLA
  CREATE OR REPLACE PUBLIC SYNONYM SESAS_HISTORICO FOR SICAS_OC.SESAS_HISTORICO;
/
  
 --PERMISOS SECUENCIA SICAS_OC.SESAS_HIST_SEQ

  GRANT SELECT ON SICAS_OC.SESAS_HIST_SEQ  TO PUBLIC ;
  /
  CREATE OR REPLACE PUBLIC SYNONYM SESAS_HIST_SEQ FOR SICAS_OC.SESAS_HIST_SEQ;
  /

----COMENTARIO TABLA
  COMMENT ON TABLE SICAS_OC.SESAS_HISTORICO IS 'Información de la tabla ss_hist del área técnica';

  --##COMENTARIOS DESCRIPTIVOS
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.IDSINIESTRO             IS 'NUMERO DE SINIESTRO DE LA TABLA HISTORICO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.NPOLIZA 		        IS 'NUMERO DE POLIZA';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.FECOCU 			IS 'FECHA OCURRENCIA';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.FECREP 			    IS 'FECHA REPORTE DE AÑOA ANTERIORES';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.CREATION_BY 			    IS 'REGISTRO CREADO POR';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.CREATION_DATE             IS 'FECHA DE CREACION DE REGISTRO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.LAST_UPDATE_BY               IS 'FECHA DE ULTIMA ACTUALIZACION POR';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.LAST_UPDATE_DATE              IS 'FECHA DE ULTIMA ACTUALIZACION';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.ID_SESAS_HIST              IS 'ID DE CONTROL DE REGISTROS';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.CODCIA              IS 'CODIGO COMPANIA';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.CODEMPRESA              IS 'CODIGO EMPRESA';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.FECCON              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.FECPAG              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.EST_REC              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.ENTIDAD_OC              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.COB_AFEC              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.FNACIM              IS 'FECHA NACIMIENTO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.SEXO              IS 'SEXO DE CLIENTE';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.CAUSA              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.TIP_MOV              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.MONTO              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.MTO_DED              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.MTO_COA              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.MTO_PAG              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.MTO_CED              IS 'NO DEFINIDO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.ANOREP              IS 'AÑO DE REPORTE QUE SE PROCESO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.ESTATUS              IS 'ESTATUS DE INCERCION DE PRIMER REGISTRO';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.RECL              IS 'RECL QUE  INDICA EL CONSECUTIVO Y LO COMPARA CON RECL DE SINIESTROS -1';
COMMENT ON COLUMN SICAS_OC.SESAS_HISTORICO.EST_CIERRE              IS 'ESTATUS DE CIERRE';
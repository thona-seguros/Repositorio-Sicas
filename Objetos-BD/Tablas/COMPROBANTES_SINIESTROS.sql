-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM COMPROBANTES_SINIESTROS;
DROP TABLE SICAS_OC.COMPROBANTES_SINIESTROS;

CREATE TABLE SICAS_OC.COMPROBANTES_SINIESTROS
(
  IDSINIESTRO       NUMBER(14) not null,
  IDPOLIZA          NUMBER(14) not null,
  NUMCSINI          NUMBER(14) not null,
  FEC_COMPROBANTE   DATE,
  FOLIO_COMPROBANTE VARCHAR2(45),
  MONTO_COMPROBANTE NUMBER(18,2),
  ACTUALIZO_USUARIO VARCHAR2(30 CHAR) default USER,
  ACTUALIZO_FECHA   DATE default sysdate
)
TABLESPACE TS_SICASOC
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE 
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
/
-- =============================
-- CREA COMENTARIOS DE LA TABLA
-- =============================
comment on table SICAS_OC.COMPROBANTES_SINIESTROS
  is 'Comprobantes de siniestros para la Franquicia';
-- Add comments to the columns 
comment on column SICAS_OC.COMPROBANTES_SINIESTROS.IDSINIESTRO
  is 'Código del Siniestro';
comment on column SICAS_OC.COMPROBANTES_SINIESTROS.IDPOLIZA
  is 'Código de la Poliza';
comment on column SICAS_OC.COMPROBANTES_SINIESTROS.NUMCSINI
  is 'consecutivo del comprobante del siniestro';
comment on column SICAS_OC.COMPROBANTES_SINIESTROS.FEC_COMPROBANTE
  is 'Fecha del Comprobante';
comment on column SICAS_OC.COMPROBANTES_SINIESTROS.FOLIO_COMPROBANTE
  is 'Folio del Comprobante';
comment on column SICAS_OC.COMPROBANTES_SINIESTROS.MONTO_COMPROBANTE
  is 'Cantidad del comprobante';
comment on column SICAS_OC.COMPROBANTES_SINIESTROS.ACTUALIZO_USUARIO
  is 'Usuario que incrementa o altera el registro';
comment on column SICAS_OC.COMPROBANTES_SINIESTROS.ACTUALIZO_FECHA
  is 'Fecha en que se incrementa o se alteró el registro';
/
-- =============================
-- Genera Primary key
-- =============================
ALTER TABLE SICAS_OC.COMPROBANTES_SINIESTROS
  ADD CONSTRAINT COMPROBANTES_SINIESTROS_PK PRIMARY KEY (IDSINIESTRO, IDPOLIZA, NUMCSINI)
  USING INDEX  
  TABLESPACE IDX_SICASOC
  PCTFREE  10
  INITRANS 2
  MAXTRANS 255
  STORAGE 
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
  
/
-- =============================
-- Genera los permisos
-- ============================= 
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX ON SICAS_OC.COMPROBANTES_SINIESTROS TO ROL_MODIFICA_SICAS;
GRANT SELECT ON SICAS_OC.COMPROBANTES_SINIESTROS TO ROL_CONSULTA_SICAS;
/
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE OR REPLACE PUBLIC SYNONYM COMPROBANTES_SINIESTROS FOR SICAS_OC.COMPROBANTES_SINIESTROS;

/
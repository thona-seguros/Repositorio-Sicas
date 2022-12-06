-- =============================
-- Crea Tabla
-- =============================
--DROP PUBLIC SYNONYM PLD_OPE_PREOCUPANTES
--;
--DROP TABLE PLD_OPE_PREOCUPANTES
--;

CREATE TABLE PLD_OPE_PREOCUPANTES
(
CODCIA	NUMBER(14)
CODEMPRESA	NUMBER(14)
IDDENUNCIA	NUMBER(14)
FOLIO_DENUNCIA	VARCHAR2(20)
CODTIPOREPORTE	VARCHAR2(6)	,
CODCANALDENUNCIA	VARCHAR2(6)	,
FEC_REPORTE	DATE	,
CODCOMPORTAMIENTO	VARCHAR2(6)	,
NUMPOLUNICO	VARCHAR2(30)	,
MONTO_DENUNCIA	NUMBER(18,2)	,
FEC_DETECCION	DATE	,
NOM_REPORTA	VARCHAR2(250)	,
CORREO_ELECTRONICO	VARCHAR2(250)	,
NOMBRE_PERSONA_REPORTADA	VARCHAR2(200)	,
APELLIDO_PATERNO	VARCHAR2(50)	,
APELLIDO_MATERNO	VARCHAR2(50)	,
DESCRIPCION_DENUNCIA	VARCHAR2(4000)	,
CODUSUARIO_ALTA	VARCHAR2(30) DEFAULT USER	,
FEC_ALTA	DATE	DEFAULT TRUNC(SYSDATE),
CODUSUARIO_MOD	VARCHAR2(30)	,
FEC_MODIFICACION	DATE
)
tablespace TS_SICASOC
;

-- =============================
-- Genera Primaty key
-- =============================
 
alter table PLD_OPE_PREOCUPANTES
  add constraint PK_PLD_OPE_PREOCUPANTES primary key (CODCIA,CODEMPRESA,IDDENUNCIA,FOLIO_DENUNCIA,CODTIPOREPORTE)
   using index 
  tablespace TS_SICASOC
; 

-- =============================
-- Genera Indice
-- =============================
create  index PLD_OPE_PREOCUPANTES_IDX_1 on PLD_OPE_PREOCUPANTES(FEC_REPORTE,CODCIA)
  tablespace TS_SICASOC
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on PLD_OPE_PREOCUPANTES to PUBLIC
;

-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM PLD_OPE_PREOCUPANTES FOR PLD_OPE_PREOCUPANTES
;

-- =============================
-- Crea Comentarios
-- =============================
comment on column PLD_OPE_PREOCUPANTES.CODCIA is 'Clave de Compania';
comment on column PLD_OPE_PREOCUPANTES.CODEMPRESA is 'Clave de Empresa';
comment on column PLD_OPE_PREOCUPANTES.IDDENUNCIA is 'Consecutivo de Denuncia';
comment on column PLD_OPE_PREOCUPANTES.FOLIO_DENUNCIA is 'No. de Denuncia';
comment on column PLD_OPE_PREOCUPANTES.CODTIPOREPORTE is 'Tipo de reporte (TIPREP)';
comment on column PLD_OPE_PREOCUPANTES.CODCANALDENUNCIA is 'Canal de denuncia (CANDEN)';
comment on column PLD_OPE_PREOCUPANTES.FEC_REPORTE is 'Fecha del reporte';
comment on column PLD_OPE_PREOCUPANTES.CODCOMPORTAMIENTO is 'Codigo de comportamiento (COMPOR)';
comment on column PLD_OPE_PREOCUPANTES.NUMPOLUNICO is 'Número de póliza';
comment on column PLD_OPE_PREOCUPANTES.MONTO_DENUNCIA is 'Monto';
comment on column PLD_OPE_PREOCUPANTES.FEC_DETECCION is 'Fecha de detección';
comment on column PLD_OPE_PREOCUPANTES.NOM_REPORTA is 'Nombre de quien hace el reporte';
comment on column PLD_OPE_PREOCUPANTES.CORREO_ELECTRONICO is 'Correo electrónico';
comment on column PLD_OPE_PREOCUPANTES.NOMBRE_PERSONA_REPORTADA is 'Nombre de la Persona Reportada';
comment on column PLD_OPE_PREOCUPANTES.APELLIDO_PATERNO is 'Apellido Paterno';
comment on column PLD_OPE_PREOCUPANTES.APELLIDO_MATERNO is 'Apellido Materno';
comment on column PLD_OPE_PREOCUPANTES.DESCRIPCION_DENUNCIA is 'Descripción de lo observado';
comment on column PLD_OPE_PREOCUPANTES.CODUSUARIO_ALTA is 'Usuario que registra';
comment on column PLD_OPE_PREOCUPANTES.FEC_ALTA is 'Fecha de registro';
comment on column PLD_OPE_PREOCUPANTES.CODUSUARIO_MOD is 'Usuario de actualizacion';
comment on column PLD_OPE_PREOCUPANTES.FEC_MODIFICACION is 'Fecha de actualizacion';


/

-- =============================
-- Crea Tabla
-- =============================
--DROP PUBLIC SYNONYM PLD_REP_OPERACIONES
--;
--DROP TABLE PLD_REP_OPERACIONES
--;

CREATE TABLE PLD_REP_OPERACIONES
(
CODCIA	NUMBER(14)	,
IDOPERACION	NUMBER(20)	,
CODTIPOREPORTE	VARCHAR2(6)	,
ID_PERIODO	VARCHAR2(15)	,
FOLIO	VARCHAR2(15)	,
COD_ORGANO_SUPER	VARCHAR2(15)	,
ID_OBLIGADO	VARCHAR2(15)	,
ID_LOCALIDAD	VARCHAR2(15)	,
ID_SUCURSAL	VARCHAR2(15)	,
ID_TIP_OPERACION	VARCHAR2(15)	,
COD_INSTRU_MONEDA	VARCHAR2(15)	,
NUMPOLUNICO	VARCHAR2(30)	,
NUMCUENTABANCARIA	VARCHAR2(30)	,
ID_OPE_IMSS	VARCHAR2(30)	,
MONTO	NUMBER(20,2)	,
COD_MONEDA	VARCHAR2(15)	,
FEC_OPERACION	DATE	,
COD_NACIONALIDAD	VARCHAR2(15)	,
TIPO_PERSONA	VARCHAR2(6)	,
RAZONSOCIAL	VARCHAR2(300)	,
NOMBRE_REPORTADA	VARCHAR2(200)	,
APE_PATERNO_REPORTADA	VARCHAR2(50)	,
APE_MATERNO_REPORTADA	VARCHAR2(50)	,
NUM_TRIBUTARIO	VARCHAR2(20)	,
CURP	VARCHAR2(30)	,
FECNACIMIENTO	VARCHAR2(200)	,
DIRECRES	VARCHAR2(500)	,
CODPAIS	VARCHAR2(3)	,
CODESTADO	VARCHAR2(3)	,
CODCIUDAD	VARCHAR2(3)	,
CODMUNICIPIO	VARCHAR2(3)	,
CODIGO_POSTAL	VARCHAR2(30)	,
CODIGO_COLONIA	VARCHAR2(6)	,
TELRES	VARCHAR2(30)	,
CODACTIVIDAD	VARCHAR2(10)	,
NOM_AGE_APO	VARCHAR2(200)	,
APE_PATERNO_AGE_APO	VARCHAR2(50)	,
APE_MATERNO_AGE_APO	VARCHAR2(50)	,
NUM_TRIBUTARIO_AGE_APO	VARCHAR2(20)	,
CURP_AGE_APO	VARCHAR2(30)	,
NUM_CONSECUTIVO	VARCHAR2(15)	,
CVE_OBLIGADO	VARCHAR2(15)	,
NOM_TITULAR	VARCHAR2(200)	,
APE_PATERNO_TITULAR	VARCHAR2(50)	,
APE_MATERNO_TITULAR	VARCHAR2(50)	,
DESCRIPCION_DENUNCIA	VARCHAR2(4000)	,
RAZONES	VARCHAR2(4000)	,
CODUSUARIO_ALTA	VARCHAR2(30) DEFAULT USER	,
FEC_ALTA	DATE	DEFAULT TRUNC(SYSDATE)
)
tablespace TS_SICASOC
;

-- =============================
-- Genera Primaty key
-- =============================
 
alter table PLD_REP_OPERACIONES
  add constraint PK_PLD_REP_OPERACIONES primary key (IDOPERACION,CODCIA)
   using index 
  tablespace TS_SICASOC
; 

-- =============================
-- Genera Indice
-- =============================
create  index PLD_REP_OPERACIONES_IDX_1 on PLD_REP_OPERACIONES(ID_PERIODO,CODCIA)
  tablespace TS_SICASOC
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on PLD_REP_OPERACIONES to PUBLIC
;

-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM PLD_REP_OPERACIONES FOR PLD_REP_OPERACIONES
;

-- =============================
-- Crea Comentarios
-- =============================
comment on column PLD_REP_OPERACIONES.CODCIA is 'Clave de Compania';
comment on column PLD_REP_OPERACIONES.IDOPERACION is 'No. de Operación';
comment on column PLD_REP_OPERACIONES.CODTIPOREPORTE is 'Tipo de reporte (TIPREP)';
comment on column PLD_REP_OPERACIONES.ID_PERIODO is 'Periodo del reporte ';
comment on column PLD_REP_OPERACIONES.FOLIO is 'Numero de Folio';
comment on column PLD_REP_OPERACIONES.COD_ORGANO_SUPER is 'Organo Supervisor ';
comment on column PLD_REP_OPERACIONES.ID_OBLIGADO is 'Clave de sujeto obligado';
comment on column PLD_REP_OPERACIONES.ID_LOCALIDAD is 'Localidad';
comment on column PLD_REP_OPERACIONES.ID_SUCURSAL is 'Sucursal';
comment on column PLD_REP_OPERACIONES.ID_TIP_OPERACION is 'Tipo de operación';
comment on column PLD_REP_OPERACIONES.COD_INSTRU_MONEDA is 'Instrumento Monetario';
comment on column PLD_REP_OPERACIONES.NUMPOLUNICO is 'Número de póliza consecutivo';
comment on column PLD_REP_OPERACIONES.NUMCUENTABANCARIA is 'Numero de Contrato';
comment on column PLD_REP_OPERACIONES.ID_OPE_IMSS is 'Operación o Número de Seguro Social';
comment on column PLD_REP_OPERACIONES.MONTO is 'Monto';
comment on column PLD_REP_OPERACIONES.COD_MONEDA is 'Moneda';
comment on column PLD_REP_OPERACIONES.FEC_OPERACION is 'Fecha de Operación';
comment on column PLD_REP_OPERACIONES.COD_NACIONALIDAD is 'Nacionalidad (NACION)';
comment on column PLD_REP_OPERACIONES.TIPO_PERSONA is 'Tipo de Persona (TIPPER)';
comment on column PLD_REP_OPERACIONES.RAZONSOCIAL is 'Razón Social o Denominación';
comment on column PLD_REP_OPERACIONES.NOMBRE_REPORTADA is 'Nombre de la Persona Reportada';
comment on column PLD_REP_OPERACIONES.APE_PATERNO_REPORTADA is 'Apellido Paterno de la Persona Reportada';
comment on column PLD_REP_OPERACIONES.APE_MATERNO_REPORTADA is 'Apellido Materno de la Persona Reportada';
comment on column PLD_REP_OPERACIONES.NUM_TRIBUTARIO is 'RFC';
comment on column PLD_REP_OPERACIONES.CURP is 'CURP';
comment on column PLD_REP_OPERACIONES.FECNACIMIENTO is 'Fecha de Nacimiento';
comment on column PLD_REP_OPERACIONES.DIRECRES is 'Domicilio';
comment on column PLD_REP_OPERACIONES.CODPAIS is 'Clave de Pais';
comment on column PLD_REP_OPERACIONES.CODESTADO is 'Clave de Estado';
comment on column PLD_REP_OPERACIONES.CODCIUDAD is 'Clave de Ciudad';
comment on column PLD_REP_OPERACIONES.CODMUNICIPIO is 'Clave de Municipio';
comment on column PLD_REP_OPERACIONES.CODIGO_POSTAL is 'Codigo postal';
comment on column PLD_REP_OPERACIONES.CODIGO_COLONIA is 'Codigo de Colonia';
comment on column PLD_REP_OPERACIONES.TELRES is 'Teléfono';
comment on column PLD_REP_OPERACIONES.CODACTIVIDAD is 'Actividad Económica';
comment on column PLD_REP_OPERACIONES.NOM_AGE_APO is 'Nombre del Agente o Apoderado';
comment on column PLD_REP_OPERACIONES.APE_PATERNO_AGE_APO is 'Apellido Paterno del Agente o Apoderado';
comment on column PLD_REP_OPERACIONES.APE_MATERNO_AGE_APO is 'Apellido Materno del Agente o Apoderado';
comment on column PLD_REP_OPERACIONES.NUM_TRIBUTARIO_AGE_APO is 'RFC agente o apoderado';
comment on column PLD_REP_OPERACIONES.CURP_AGE_APO is 'CURP  agente o apoderado';
comment on column PLD_REP_OPERACIONES.NUM_CONSECUTIVO is 'Consecutivo';
comment on column PLD_REP_OPERACIONES.CVE_OBLIGADO is 'Clave de sujeto obligado';
comment on column PLD_REP_OPERACIONES.NOM_TITULAR is 'Nombre del titular de la cuenta';
comment on column PLD_REP_OPERACIONES.APE_PATERNO_TITULAR is 'Apellido Paterno del titular de la cuenta';
comment on column PLD_REP_OPERACIONES.APE_MATERNO_TITULAR is 'Apellido Materno del titular de la cuenta';
comment on column PLD_REP_OPERACIONES.DESCRIPCION_DENUNCIA is 'Descripción de la Operación';
comment on column PLD_REP_OPERACIONES.RAZONES is 'Razones por las que el acto u operación se considera Interna preocupante';
comment on column PLD_REP_OPERACIONES.CODUSUARIO_ALTA is 'Usuario que registra';
comment on column PLD_REP_OPERACIONES.FEC_ALTA is 'Fecha de registro';




/

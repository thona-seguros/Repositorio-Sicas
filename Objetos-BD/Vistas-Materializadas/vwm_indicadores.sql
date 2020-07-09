--
-- VWM_INDICADORES  (Materialized View) 
--
--  Dependencies: 
--   VALORES_DE_LISTAS (Table)
--   VW_INDICADOR_COTIZA (View)
--   VW_INDICADOR_POLIZA (View)
--   PLAN_COBERTURAS (Table)
--   POLIZAS (Table)
--   POLIZAS_TEXTO_COTIZACION (Table)
--   FN_INDICADORES_CODDIFER (Function)
--   COTIZACIONES (Table)
--   COTIZACIONES_DETALLE (Table)
--   OFICINAS (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   AGENTE_POLIZA (Table)
--   REA_ESQUEMAS (Table)
--   REA_ESQUEMAS_POLIZAS (Table)
--   CATEGORIAS (Table)
--   CLIENTES (Table)
--   DETALLE_POLIZA (Table)
--   TIPOS_DE_SEGUROS (Table)
--
CREATE MATERIALIZED VIEW SICAS_OC.VWM_INDICADORES (CODCIA,CODEMPRESA,PERIODO,IDCOTIZACION,FECCOTIZACION,STSCOTIZACION,NUMUNICOCOTIZACION,FECVENCECOTIZACION,IDTIPOSEG,CODRAMO,RAMO,PLANCOB,CODSUBRAMO,SUBRAMO,IDPOLIZA,NUMRENOV,CODGRUPOEC,CONTRA_REA,CLIENTE,NUMCERTIF,NUMPOLUNICO,STSPOLIZA,FECSTATUS,FECEMISION,FECINIVIG,FECFINVIG,FECRENOVACION,FECANUL,CODAGENTE,AGENTE,CODPROMOTOR,PROMOTOR,CODDR,DR,CODPLANPAGO,CODCANALFORMAVENTA,CANALFORMAVENTA,CODAGRUPADOR,AGRUPADOR,CODTIPONEGOCIO,TIPONEGOCIO,CODCATEGO,CATEGORIA,CODFUENTERECURSOS,FUENTERECURSOS,CODOFICINA,OFICINA,GIRONEGOCIO,ESCONTRIBUTORIO,PORCENCONTRIBUTORIO,PLATAFOMA_WEB,CODPAQCOMERCIAL,COD_MONEDA,SUMAASEGCOTLOCAL,SUMAASEGCOTMONEDA,PRIMACOTMONEDA,CODDIFER,DIFERENCIAS)
TABLESPACE TS_SICASOC
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 07/07/2020 11:25:19 a. m. (QP5 v5.240.12305.39476) */
SELECT CODCIA,
       CODEMPRESA,
       PERIODO,
       IDCOTIZACION,
       FECCOTIZACION,
       STSCOTIZACION,
       NUMUNICOCOTIZACION,
       FECVENCECOTIZACION,
       IDTIPOSEG,
       CODRAMO,
       RAMO,
       PLANCOB,
       CODSUBRAMO,
       SUBRAMO,
       IDPOLIZA,
       NUMRENOV,
       CODGRUPOEC,
       CONTRA_REA,
       CLIENTE,
       NUMCERTIF,
       NUMPOLUNICO,
       STSPOLIZA,
       FECSTATUS,
       FECEMISION,
       FECINIVIG,
       FECFINVIG,
       FECRENOVACION,
       FECANUL,
       CODAGENTE,
       AGENTE,
       CODPROMOTOR,
       PROMOTOR,
       CODDR,
       DR,
       CODPLANPAGO,
       CODCANALFORMAVENTA,
       CANALFORMAVENTA,
       CODAGRUPADOR,
       AGRUPADOR,
       CODTIPONEGOCIO,
       TIPONEGOCIO,
       CODCATEGO,
       CATEGORIA,
       CODFUENTERECURSOS,
       FUENTERECURSOS,
       CODOFICINA,
       OFICINA,
       GIRONEGOCIO,
       ESCONTRIBUTORIO,
       PORCENCONTRIBUTORIO,
       PLATAFOMA_WEB,
       CODPAQCOMERCIAL,
       COD_MONEDA,
       SUMAASEGCOTLOCAL,
       SUMAASEGCOTMONEDA,
       PRIMACOTLOCAL PRIMACOTMONEDA,
       CODDIFER,
       SICAS_OC.FN_INDICADORES_CODDIFER (CODDIFER) DIFERENCIAS
  FROM (SELECT    CASE
                     WHEN COT_IDCOTIZACION <>
                             NVL (POL_IDCOTIZACION, COT_IDCOTIZACION)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --1
                 CASE
                     WHEN COT_IDTIPOSEG <> NVL (POL_IDTIPOSEG, COT_IDTIPOSEG)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --2
                 CASE
                     WHEN COT_CODRAMO <> NVL (POL_CODRAMO, COT_CODRAMO)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --3
                 CASE
                     WHEN COT_PLANCOB <> NVL (POL_PLANCOB, COT_PLANCOB)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --4
                 CASE
                     WHEN COT_CODSUBRAMO <>
                             NVL (POL_CODSUBRAMO, COT_CODSUBRAMO)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --5
                 CASE
                     WHEN COT_IDECOTIZA <> NVL (POL_NUMDET, COT_IDECOTIZA)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --6
                 CASE
                     WHEN COT_FECSTATUS <> NVL (POL_FECSTATUS, COT_FECSTATUS)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --7
                 CASE
                     WHEN COT_FECCOTIZACION <>
                             NVL (POL_FECEMISION, COT_FECCOTIZACION)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --8
                 CASE
                     WHEN COT_FECINIVIGCOT <>
                             NVL (POL_FECINIVIG, COT_FECINIVIGCOT)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                          --9
                 CASE
                     WHEN COT_FECFINVIGCOT <>
                             NVL (POL_FECFINVIG, COT_FECFINVIGCOT)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --10
                 CASE
                     WHEN COT_CODAGENTE <> NVL (POL_CODAGENTE, COT_CODAGENTE)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --11
                 CASE
                     WHEN COT_CODPLANPAGO <>
                             NVL (POL_CODPLANPAGO, COT_CODPLANPAGO)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --12
                 CASE
                     WHEN COT_CODCANALFORMAVENTA <>
                             NVL (POL_CODCANALFORMAVENTA,
                                  COT_CODCANALFORMAVENTA)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --13
                 CASE
                     WHEN COT_TIPONEGOCIO <>
                             NVL (POL_TIPONEGOCIO, COT_TIPONEGOCIO)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --14
                 CASE
                     WHEN COT_CODCATEGO <> NVL (POL_CODCATEGO, COT_CODCATEGO)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --15
                 CASE
                     WHEN COT_CATEGORIA <> NVL (POL_CATEGORIA, COT_CATEGORIA)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --16
                 CASE
                     WHEN COT_CODFUENTERECURSOS <>
                             NVL (POL_CODFUENTERECURSOS,
                                  COT_CODFUENTERECURSOS)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --17
                 CASE
                     WHEN COT_CODOFICINA <>
                             NVL (POL_CODOFICINA, COT_CODOFICINA)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --18
                 CASE
                     WHEN COT_GIRONEGOCIO <>
                             NVL (POL_GIRONEGOCIO, COT_GIRONEGOCIO)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --19
                 CASE
                     WHEN COT_PORCENCONTRIBUTORIO <>
                             NVL (POL_PORCENCONTRIBUTORIO,
                                  COT_PORCENCONTRIBUTORIO)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --20
                 CASE
                     WHEN COT_PLATAFOMA_WEB <>
                             NVL (POL_PLATAFOMA_WEB, COT_PLATAFOMA_WEB)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --21
                 CASE
                     WHEN COT_CODPAQCOMERCIAL <>
                             NVL (POL_CODPAQCOMERCIAL, COT_CODPAQCOMERCIAL)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --22
                 CASE
                     WHEN COT_COD_MONEDA <>
                             NVL (POL_COD_MONEDA, COT_COD_MONEDA)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --23
                 CASE
                     WHEN COT_SUMAASEGCOTLOCAL <>
                             NVL (POL_SUMA_ASEG_LOCAL, COT_SUMAASEGCOTLOCAL)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --24
                 CASE
                     WHEN COT_SUMAASEGCOTMONEDA <>
                             NVL (POL_SUMA_ASEG_MONEDA,
                                  COT_SUMAASEGCOTMONEDA)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --25
                 CASE
                     WHEN COT_PRIMACOTLOCAL <>
                             NVL (POL_PRIMA_LOCAL, COT_PRIMACOTLOCAL)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ||                                                         --26
                 CASE
                     WHEN COT_PRIMACOTMONEDA <>
                             NVL (POL_PRIMA_MONEDA, COT_PRIMACOTMONEDA)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
                  CODDIFER,                                               --27
               NVL (POL_CODCIA, COT_CODCIA) CODCIA,
               NVL (POL_CODEMPRESA, COT_CODEMPRESA) CODEMPRESA,
               TO_CHAR (NVL (POL_FECEMISION, COT_FECCOTIZACION), 'YYYYMM')
                  PERIODO,
               NVL (POL_IDCOTIZACION, COT_IDCOTIZACION) IDCOTIZACION,
               COT_FECCOTIZACION FECCOTIZACION,
               COT_STSCOTIZACION STSCOTIZACION,
               COT_NUMUNICOCOTIZACION NUMUNICOCOTIZACION,
               COT_FECVENCECOTIZACION FECVENCECOTIZACION,
               NVL (POL_IDTIPOSEG, COT_IDTIPOSEG) IDTIPOSEG,
               NVL (POL_CODRAMO, COT_CODRAMO) CODRAMO,
               NVL (POL_RAMO, COT_RAMO) RAMO,
               NVL (POL_PLANCOB, COT_PLANCOB) PLANCOB,
               NVL (POL_CODSUBRAMO, COT_CODSUBRAMO) CODSUBRAMO,
               NVL (POL_SUBRAMO, COT_SUBRAMO) SUBRAMO,
               NVL (POL_IDPOLIZA, COT_IDPOLIZA) IDPOLIZA,
               POL.POL_NUMRENOV NUMRENOV,
               POL.POL_CODGRUPOEC CODGRUPOEC,
               POL_CONTRA_REA CONTRA_REA,
               REPLACE (NVL (POL_CLIENTE, COT_CLIENTE), CHR (10), ' ')
                  CLIENTE,
               NVL (POL_NUMDET, COT_IDECOTIZA) NUMCERTIF,
               POL_NUMPOLUNICO NUMPOLUNICO,
               POL_STSPOLIZA STSPOLIZA,
               POL_FECSTATUS FECSTATUS,
               POL_FECEMISION FECEMISION,
               NVL (POL_FECINIVIG, COT_FECINIVIGCOT) FECINIVIG,
               NVL (POL_FECFINVIG, COT_FECFINVIGCOT) FECFINVIG,
               NVL (POL_FECRENOVACION, COT_FECRENOVA) FECRENOVACION,
               POL_FECANUL FECANUL,
               NVL (POL_CODAGENTE, COT_CODAGENTE) CODAGENTE,
               NVL (POL_AGENTE, COT_AGENTE) AGENTE,
               POL_CODPROMOTOR CODPROMOTOR,
               POL_PROMOTOR PROMOTOR,
               POL_CODDR CODDR,
               POL_DR DR,
               NVL (POL_CODPLANPAGO, COT_CODPLANPAGO) CODPLANPAGO,
               NVL (POL_CODCANALFORMAVENTA, COT_CODCANALFORMAVENTA)
                  CODCANALFORMAVENTA,
               NVL (POL_CANALFORMAVENTA, COT_CANALFORMAVENTA) CANALFORMAVENTA,
               NVL (POL_CODAGRUPADOR, COT_CODAGRUPADOR) CODAGRUPADOR,
               NVL (POL_AGRUPADOR, COT_AGRUPADOR) AGRUPADOR,
               NVL (POL_CODTIPONEGOCIO, COT_CODTIPONEGOCIO) CODTIPONEGOCIO,
               NVL (POL_TIPONEGOCIO, COT_TIPONEGOCIO) TIPONEGOCIO,
               NVL (POL_CODCATEGO, COT_CODCATEGO) CODCATEGO,
               NVL (POL_CATEGORIA, COT_CATEGORIA) CATEGORIA,
               NVL (POL_CODFUENTERECURSOS, COT_CODFUENTERECURSOS)
                  CODFUENTERECURSOS,
               NVL (POL_FUENTERECURSOS, COT_FUENTERECURSOS) FUENTERECURSOS,
               NVL (POL_CODOFICINA, COT_CODOFICINA) CODOFICINA,
               NVL (POL_OFICINA, COT_OFICINA) OFICINA,
               REPLACE (NVL (POL_GIRONEGOCIO, COT_GIRONEGOCIO),
                        CHR (10),
                        ' ')
                  GIRONEGOCIO,
               NVL (POL_ESCONTRIBUTORIO, COT_ESCONTRIBUTORIO) ESCONTRIBUTORIO,
               NVL (POL_PORCENCONTRIBUTORIO, COT_PORCENCONTRIBUTORIO)
                  PORCENCONTRIBUTORIO,
               NVL (POL_PLATAFOMA_WEB, COT_PLATAFOMA_WEB) PLATAFOMA_WEB,
               NVL (POL_CODPAQCOMERCIAL, COT_CODPAQCOMERCIAL) CODPAQCOMERCIAL,
               NVL (POL_COD_MONEDA, COT_COD_MONEDA) COD_MONEDA,
               NVL (POL_SUMA_ASEG_LOCAL, COT_SUMAASEGCOTLOCAL)
                  SUMAASEGCOTLOCAL,
               NVL (POL_SUMA_ASEG_MONEDA, COT_SUMAASEGCOTMONEDA)
                  SUMAASEGCOTMONEDA,
               NVL (POL_PRIMA_LOCAL, COT_PRIMACOTLOCAL) PRIMACOTLOCAL,
               NVL (POL_PRIMA_MONEDA, COT_PRIMACOTMONEDA) PRIMACOTMONEDA
          FROM SICAS_OC.VW_INDICADOR_POLIZA POL
               FULL OUTER JOIN
               SICAS_OC.VW_INDICADOR_COTIZA COT
                  ON     POL_CODCIA = COT_CODCIA
                     AND POL_CODEMPRESA = COT_CODEMPRESA
                     AND POL_IDPOLIZA = COT_IDPOLIZA)
/


COMMENT ON MATERIALIZED VIEW SICAS_OC.VWM_INDICADORES IS 'Indicadores de origen cotizacion VS polizas'
/

--
-- VWM_INDICADORES  (Synonym) 
--
--  Dependencies: 
--   VWM_INDICADORES (Table)
--
CREATE OR REPLACE PUBLIC SYNONYM VWM_INDICADORES FOR SICAS_OC.VWM_INDICADORES
/

--
-- IDX_VWM_INDICADORES_IDCOTIZA  (Index) 
--
--  Dependencies: 
--   VWM_INDICADORES (Table)
--   VWM_INDICADORES (Materialized View)
--
CREATE INDEX SICAS_OC.IDX_VWM_INDICADORES_IDCOTIZA ON SICAS_OC.VWM_INDICADORES
(IDCOTIZACION)
LOGGING
TABLESPACE TS_SICASOC
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL
/

--
-- IDX_VWM_INDICADORES_IDPOLIZA  (Index) 
--
--  Dependencies: 
--   VWM_INDICADORES (Table)
--   VWM_INDICADORES (Materialized View)
--
CREATE INDEX SICAS_OC.IDX_VWM_INDICADORES_IDPOLIZA ON SICAS_OC.VWM_INDICADORES
(IDPOLIZA)
LOGGING
TABLESPACE TS_SICASOC
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL
/

--
-- IDX_VWM_INDICADORES_PK  (Index) 
--
--  Dependencies: 
--   VWM_INDICADORES (Table)
--   VWM_INDICADORES (Materialized View)
--
CREATE INDEX SICAS_OC.IDX_VWM_INDICADORES_PK ON SICAS_OC.VWM_INDICADORES
(PERIODO, IDCOTIZACION, IDPOLIZA)
LOGGING
TABLESPACE TS_SICASOC
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL
/

GRANT SELECT ON SICAS_OC.VWM_INDICADORES TO PUBLIC
/

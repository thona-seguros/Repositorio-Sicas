--
-- DATOS_REPCARTERA  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   VALORES_DE_LISTAS (Table)
--   OC_AGENTES (Package)
--   PLAN_DE_PAGOS (Table)
--   POLIZAS (Table)
--   DETALLE_FACTURAS (Table)
--   OC_VALORES_DE_LISTAS (Package)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   REPCARTERA (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   COMISIONES (Table)
--   OC_PLAN_COBERTURAS (Package)
--   OC_CLIENTES (Package)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.datos_repCartera IS

CURSOR x IS
SELECT   pol.numpolunico as poliza,
         pol.idpoliza as consecutivo,
         pol.codagrupador as agrupador,
        -- depo.idtiposeg as ramo,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS',oc_plan_coberturas.codigo_subramo(1,1,depo.idtiposeg ,depo.plancob )) as ramo,
         REPLACE(oc_clientes.nombre_cliente(pol.codcliente), '''', ' ') as contratante,
         pol.fecinivig as inicio_vig,
         pol.fecfinvig as fin_vig,
         --pol.codplanpago as plan_pago,
         plpa.descplan as plan_pago,
         tbl_ns.num_subgrupos as num_subgrupos,
         --CONCAT(pol.stspoliza, pol.motivanul) as status,
         CONCAT(vls.descvallst,CONCAT(' ',vla.descvallst)) AS status,
         pol.fecsts as fecha_status,
         NVL(prim_com.monto,0) as prima_neta,
         --tbl_prima_neta.prima_neta as prima_neta,
         NVL(tbl_der_emi.monto, 0) as derecho_poliza,
         NVL(tbl_rec.monto, 0) as recargo,
         NVL(tbl_iva.monto, 0) as iva,
         NVL((NVL(prim_com.monto,0) + NVL(tbl_der_emi.monto, 0) + NVL(tbl_rec.monto, 0) + NVL(tbl_iva.monto, 0)),0) as prima_total,
         --NVL((tbl_prima_neta.prima_neta + NVL(tbl_der_emi.monto, 0) + NVL(tbl_rec.monto, 0) + NVL(tbl_iva.monto, 0)),0) as prima_total,
         NVL(prim_com.monto,0) as prima_base,
         NVL(tbl_prima_pagada.prima_pagada,0) as prima_pagada,
        nvl( tbl_com_age.cod_agente_distr,0) as codigo_agente,
         OC_AGENTES.NOMBRE_AGENTE(1,tbl_com_age.cod_agente_distr) nombre_agente,
         TRUNC(tbl_com_age.porc) as porcentaje_agente,
         --tbl_age_tipo.codtipo as tipo_pago_a,
         TRUNC((prim_com.monto * tbl_com_age.porc / 100),2)  as cantidad_agente,
         tbl_com_prom.cod_agente_distr as codigo_promotor,
         OC_AGENTES.NOMBRE_AGENTE(1,tbl_com_prom.cod_agente_distr) nombre_promotor,
         TRUNC(tbl_com_prom.porc) as porcentaje_promotor,
         --tbl_prom_tipo.codtipo as tipo_pago_p,
         TRUNC((prim_com.monto * tbl_com_prom.porc / 100),2) as monto_promotor,
         tbl_com_dir_reg.cod_agente_distr as codigo_direccion,
         OC_AGENTES.NOMBRE_AGENTE(1,tbl_com_dir_reg.cod_agente_distr) as nombre_direccion,
         TRUNC(tbl_com_dir_reg.porc) as porcentaje_direccion,
         --tbl_dir_reg_tipo.codtipo as tipo_pago_d,
         TRUNC((prim_com.monto * tbl_com_dir_reg.porc / 100),2) as monto_direccion,
         trunc(sysdate) fecha_reporte
FROM
 (
   SELECT
     idpoliza,
     codagrupador,
     numpolunico,
     cod_agente,
     codcliente,
     fecinivig,
     fecfinvig,
     codplanpago,
     stspoliza,
     fecsts,
     primaneta_local,
     motivanul
   FROM
   polizas
   WHERE
      -- (polizas.stspoliza IN ('EMI','SOL'))
   (polizas.stspoliza IN ('EMI'))
   OR (polizas.stspoliza = 'ANU'
     AND polizas.motivanul IN ('FPA','COT','CAFP'))

 ) pol
LEFT JOIN
 (
   SELECT
   idpoliza,
   COUNT(idetpol) AS num_subgrupos
   FROM
   detalle_poliza
   GROUP BY
   idpoliza
 )tbl_ns
ON
 pol.idpoliza = tbl_ns.idpoliza

LEFT JOIN
 (
   SELECT
   idpoliza,
   sum(prima_local) AS prima_neta
   FROM
   detalle_poliza
   GROUP BY
   idpoliza
 )tbl_prima_neta
ON
 pol.idpoliza = tbl_prima_neta.idpoliza

LEFT JOIN
 (
   SELECT
   idpoliza,
   idtiposeg,
   plancob
   FROM
   detalle_poliza
   GROUP BY
   idpoliza,
   idtiposeg,
   plancob
 ) depo
ON pol.idpoliza = depo.idpoliza

LEFT JOIN
 (
   SELECT
   idpoliza,
   NVL(SUM(Monto_Det_Local),0) as monto
   FROM
   DETALLE_FACTURAS D,
   FACTURAS F
   WHERE
   f.stsfact IN ('PAG', 'EMI')
   AND D.codcpto IN (SELECT codconcepto FROM catalogo_de_conceptos WHERE indcptoprimas = 'S' OR indcptoservicio = 'S')
   AND D.IdFactura = F.IdFactura
   GROUP BY
   idpoliza
 ) prim_com
ON
 prim_com.idpoliza = pol.idpoliza
LEFT JOIN
 (
   SELECT
   idpoliza,
   NVL(SUM(Monto_Det_Local),0) as monto
   FROM
   DETALLE_FACTURAS D,
   FACTURAS F
   WHERE
   f.stsfact IN ('PAG', 'EMI')
   AND D.codcpto IN (SELECT codconcepto FROM catalogo_de_conceptos WHERE indcptoprimas = 'S' OR indcptoservicio = 'S')
   AND D.IdFactura = F.IdFactura
   GROUP BY
   idpoliza
 ) tbl_prim_base
ON
 tbl_prim_base.idpoliza = pol.idpoliza
LEFT JOIN plan_de_pagos plpa
  ON plpa.codplanpago = pol.codplanpago
LEFT JOIN (select * from VALORES_DE_LISTAS where codlista LIKE 'ESTADOS') vls
   ON pol.stspoliza = vls.codvalor
LEFT JOIN (select * from VALORES_DE_LISTAS where codlista LIKE 'MTOANUFA') vla
   ON pol.motivanul = vla.codvalor
LEFT JOIN
 (
   SELECT
   idpoliza,
   NVL(SUM(Monto_Det_Local),0) as monto
   FROM
   DETALLE_FACTURAS D,
   FACTURAS F
   WHERE
   f.stsfact IN ('PAG','EMI')
   AND D.IdFactura = F.IdFactura
   GROUP BY
   idpoliza
 ) tbl_prim_total
ON
 tbl_prim_total.idpoliza = pol.idpoliza
LEFT JOIN
 (
   SELECT
   idpoliza,
   NVL(SUM(Monto_Det_Local),0) as monto
   FROM
   DETALLE_FACTURAS D,
   FACTURAS F
   WHERE
   f.stsfact IN ('PAG','EMI')
   AND D.codcpto = 'DEREMI'
   AND D.IdFactura = F.IdFactura
   GROUP BY
   idpoliza
 ) tbl_der_emi
ON
 tbl_der_emi.idpoliza = pol.idpoliza
LEFT JOIN
 (
   SELECT
   idpoliza,
   NVL(SUM(Monto_Det_Local),0) as monto
   FROM
   DETALLE_FACTURAS D,
   FACTURAS F
   WHERE
   f.stsfact IN ( 'PAG' , 'EMI')
   AND D.codcpto = 'IVASIN'
   AND D.IdFactura = F.IdFactura
   GROUP BY
   idpoliza
 ) tbl_iva
ON
 tbl_iva.idpoliza = pol.idpoliza
LEFT JOIN
 (
   select
   f.idpoliza,
   sum(df.Monto_Det_Local) as monto
   from
   facturas f,
   detalle_facturas df
   where
   f.stsfact IN ('PAG','EMI')
   AND f.idfactura = df.idfactura
   AND codcpto = 'RECFIN'
   GROUP BY
   f.idpoliza
 ) tbl_rec
ON
 pol.idpoliza = tbl_rec.idpoliza
LEFT JOIN
 (
   SELECT
   codcia,
   idpoliza,
   cod_agente_distr,
   codnivel,
   MAX(porc_com_distribuida) AS porc
   FROM
   agentes_distribucion_comision
   WHERE
   codnivel = 1
   GROUP BY
   codcia,
   idpoliza,
   cod_agente_distr,
   codnivel
 ) tbl_com_dir_reg
ON
 pol.idpoliza = tbl_com_dir_reg.idpoliza
LEFT JOIN
 (
   SELECT
   codcia,
   idpoliza,
   cod_agente_distr,
   codnivel,
   MAX(porc_com_distribuida) as porc
   FROM
   agentes_distribucion_comision
   WHERE
   codnivel = 2
   GROUP BY
   codcia,
   idpoliza,
   cod_agente_distr,
   codnivel
 ) tbl_com_prom
ON
 pol.idpoliza = tbl_com_prom.idpoliza
LEFT JOIN
 (
   SELECT
   codcia,
   idpoliza,
   cod_agente_distr,
   codnivel,
   MAX(porc_com_distribuida) as porc
   FROM
   agentes_distribucion_comision
   WHERE
   codnivel = 3
   GROUP BY
   codcia,
   idpoliza,
   cod_agente_distr,
   codnivel
 ) tbl_com_age
ON
 pol.idpoliza = tbl_com_age.idpoliza
LEFT JOIN
 (
   SELECT
   idpoliza,
   cod_agente,
   SUM(comision_local) AS monto
   FROM
   comisiones
   WHERE
   estado IN ('LIQ', 'REC')
   GROUP BY
   idpoliza,
   cod_agente
 ) tbl_commnt_age
ON
 pol.idpoliza = tbl_commnt_age.idpoliza
 AND tbl_commnt_age.cod_agente = tbl_com_age.cod_agente_distr
LEFT JOIN
 (
   SELECT
   idpoliza,
   cod_agente,
   SUM(comision_local) AS monto
   FROM
   comisiones
   WHERE
   estado IN ('LIQ', 'REC')
   GROUP BY
   idpoliza,
   cod_agente
 ) tbl_commnt_prom
ON
 pol.idpoliza = tbl_commnt_prom.idpoliza
 AND tbl_commnt_prom.cod_agente = tbl_com_prom.cod_agente_distr
LEFT JOIN
 (
   SELECT
   idpoliza,
   cod_agente,
   SUM(comision_local) AS monto
   FROM
   comisiones
   WHERE
   estado IN ('LIQ', 'REC')
   GROUP BY
   idpoliza,
   cod_agente
 ) tbl_commnt_dir_reg
ON
 pol.idpoliza = tbl_commnt_dir_reg.idpoliza
 AND tbl_commnt_dir_reg.cod_agente = tbl_com_dir_reg.cod_agente_distr
LEFT JOIN
 (
   SELECT
   cod_agente,
   codtipo
   FROM
   agentes
 ) tbl_age_tipo
ON
 tbl_com_age.cod_agente_distr = tbl_age_tipo.cod_agente
LEFT JOIN
 (
   SELECT
   cod_agente,
   codtipo
   FROM
   agentes
 ) tbl_prom_tipo
ON
 tbl_com_prom.cod_agente_distr = tbl_prom_tipo.cod_agente
LEFT JOIN
 (
   SELECT
   cod_agente,
   codtipo
   FROM
   agentes
 ) tbl_dir_reg_tipo
ON
 tbl_com_dir_reg.cod_agente_distr = tbl_dir_reg_tipo.cod_agente
LEFT JOIN
 (
    SELECT idpoliza, SUM(monto_det_local) prima_pagada
    FROM facturas fac, detalle_facturas defa
    WHERE fac.idfactura = defa.idfactura
--    AND fac.stsfact = 'PAG' AND defa.codcpto IN ('MXASIS', 'PRIADI', 'GLASIS', 'ODORED', 'GGRASI', 'PRIMAS', 'PRIBAS')  GROUP BY idpoliza
    AND fac.stsfact = 'PAG' AND defa.codcpto IN ('MXASIS', 'PRIADI', 'GLASIS', 'ODORED', 'GGRASI', 'PRIMAS', 'PRIBAS', 'MADI')  GROUP BY idpoliza
 ) tbl_prima_pagada
ON
  pol.idpoliza = tbl_prima_pagada.idpoliza
;

y x%ROWTYPE;

BEGIN
     FOR y IN x LOOP
         INSERT INTO repcartera
                 (poliza               , consecutivo          , agrupador            , ramo                 , contratante          ,
                  inicio_vig           , fin_vig              , plan_pago            , num_subgrupos        , status               ,
                  fecha_status         , prima_neta           , derecho_poliza       , recargo              , iva                  ,
                  prima_total          , prima_base           , prima_pagada         , codigo_agente        , nombre_agente        ,
                  porcentaje_agente    , cantidad_agente      , codigo_promotor      , nombre_promotor      , porcentaje_promotor  ,
                  monto_promotor       , codigo_direccion     , nombre_direccion     , porcentaje_direccion , monto_direccion      ,
                  fecha_reporte        )
          VALUES (y.poliza             , y.consecutivo        , y.agrupador          , y.ramo               , y.contratante        ,
                  y.inicio_vig         , y.fin_vig            , y.plan_pago          , y.num_subgrupos      , y.status             ,
                  y.fecha_status       , y.prima_neta         , y.derecho_poliza     , y.recargo            , y.iva                ,
                  y.prima_total        , y.prima_base         , y.prima_pagada       , y.codigo_agente      , y.nombre_agente      ,
                  y.porcentaje_agente  , y.cantidad_agente    , y.codigo_promotor    , y.nombre_promotor    , y.porcentaje_promotor,
                  y.monto_promotor     , y.codigo_direccion   , y.nombre_direccion   , y.porcentaje_direccion, y.monto_direccion    ,
                  y.fecha_reporte      );
      END LOOP;
      COMMIT;
END datos_repCartera;
/

--
-- DATOS_REPCARTERA  (Synonym) 
--
--  Dependencies: 
--   DATOS_REPCARTERA (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM DATOS_REPCARTERA FOR SICAS_OC.DATOS_REPCARTERA
/

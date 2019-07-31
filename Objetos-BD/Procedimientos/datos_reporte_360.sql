--
-- DATOS_REPORTE_360  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   PLAN_DE_PAGOS (Table)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_POLIZA (Table)
--   DETALLE_TRANSACCION (Table)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   TRANSACCION (Table)
--   VALORES_DE_LISTAS (Table)
--   SINIESTRO (Table)
--   COMISIONES (Table)
--   CLIENTES (Table)
--   OC_VALORES_DE_LISTAS (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_AGENTES (Package)
--   REPREC360 (Table)
--   OC_PLAN_COBERTURAS (Package)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.DATOS_REPORTE_360 IS
--declare
--PROCEDURE DATOS_REPORTE_360 IS

        CURSOR x IS 
        SELECT recibo,
              poliza,
              nombre_contratante,
              periodicidad_pago,
              origen_recibo,
              SUBGRUPO,
              ENDOSO,
              vencimiento,
              dias_de_vencido,
              antiguedad,
              prima_neta,
              prima_total,
              id_agente,
              nombre_agente,
              comision_porc_ag,
              comision_ag,
              id_promotor,
              nombre_promotor,
              comision_porc_pro,
              comision_pro,
              id_dirreg,
              nombre_direccion,
              comision_porc_dr,
              comision_dr,
              status,
              ramo,
              si_siniestro,
              monto_reserva_pendiente,
              monto_pagado,
              trunc(sysdate) Hoy,
              Last_day(to_date(trunc(sysdate))) finParam
        FROM
           (
              SELECT
                 fa.idfactura                                                                                                                  AS recibo,
                 po.numpolunico                                                                                                                AS poliza,
                 TRANSLATE(UPPER(penaju.nombre)||' '||UPPER(penaju.apellido_paterno)||' '||UPPER(penaju.apellido_materno),
                                               ' ABCDEFGHIJKLMN—OPQRSTU‹VWXYZ01234567890¡…Õ”⁄|∞¨!"#$%&/()=?°ø,;.:-_<>''' ,
                                               ' ABCDEFGHIJKLMNNOPQRSTUUVWXYZ01234567890AEIOU                        ''') AS nombre_contratante                 ,
                 plpa.descplan as periodicidad_pago,
                 CASE fa.idendoso
                    WHEN 0
                    THEN 'POLIZA'
                    ELSE 'ENDOSO'
                 END AS origen_recibo,
                 fa.idetpol as SUBGRUPO,
                 fa.idendoso as ENDOSO,
                 fa.fecvenc AS vencimiento,
                 TRUNC(CURRENT_DATE - fa.fecvenc) AS dias_de_vencido,
                 CASE
                    WHEN TRUNC(CURRENT_DATE - fa.fecvenc) > 120
                    THEN 'Mas de 120'
                    WHEN TRUNC(CURRENT_DATE - fa.fecvenc) > 90
                    THEN '91 a 120'
                    WHEN TRUNC(CURRENT_DATE - fa.fecvenc) > 60
                    THEN '61 a 90'
                    WHEN TRUNC(CURRENT_DATE - fa.fecvenc) > 45
                    THEN '46 a 60'
                    WHEN TRUNC(CURRENT_DATE - fa.fecvenc) > 30
                    THEN '31 a 45'
                    ELSE '1 a 30'
                 END AS antiguedad,
                 NVL(df_pm.monto,0) AS prima_neta,
                 NVL(df_pm.monto,0)+NVL(df_de.monto,0)+NVL(df_rec.monto,0)+NVL(df_iv.monto,0) AS prima_total,
                 mnt_com_ag.cod_agente    AS id_agente,
                 OC_AGENTES.NOMBRE_AGENTE(1,mnt_com_ag.cod_agente) as nombre_agente,
                 porc_com_ag.monto AS comision_porc_ag,
                 NVL(mnt_com_ag.monto,0) AS comision_ag,
                 mnt_com_pro.cod_agente   AS id_promotor,
                 OC_AGENTES.NOMBRE_AGENTE(1,mnt_com_pro.cod_agente) as nombre_promotor,
                 porc_com_pro.monto AS comision_porc_pro,
                 NVL(mnt_com_pro.monto,0) AS comision_pro,
                 mnt_com_dr.cod_agente      AS id_dirreg,
                 OC_AGENTES.NOMBRE_AGENTE(1,mnt_com_dr.cod_agente) as nombre_direccion,
                 porc_com_dr.monto AS comision_porc_dr,
                 NVL(mnt_com_dr.monto,0) AS comision_dr,
                 CONCAT(vls.descvallst,CONCAT(' ',vla.descvallst)) AS status,
                 OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS',oc_plan_coberturas.codigo_subramo(1,1,depo.idtiposeg ,depo.plancob )) as ramo,
                 COALESCE(sinis.si_siniestro, 'SIN SINIESTRO') as si_siniestro,
                 COALESCE(sinis.reserva_pendiente,0) AS monto_reserva_pendiente,
                 COALESCE(sinis.pagado,0) AS monto_pagado
                 FROM
                    (
                       SELECT *
                          FROM facturas
                          WHERE idpoliza NOT IN --No es p?liza que tenga facturas anuladas por FPA o COT que venzan este a?o y correspondan al endoso 0
                          (   SELECT DISTINCT(idpoliza)
                                FROM facturas
                               WHERE (stsfact    = 'ANU'
                                       AND motivanul IN ('FPA','CAFP','COT')
                                     )
                                 AND TRUNC(CURRENT_DATE - fecvenc) >= 365
                                 AND idendoso = 0
                          )
                          AND TRUNC(CURRENT_DATE - fecvenc) <= 365
                          AND( stsfact IN ('EMI', 'PAG', 'ABO')
                             OR (stsfact    = 'ANU' AND
                                 motivanul IN ('FPA','CAFP','COT')
                                )
                             )
                    ) fa
              LEFT JOIN polizas po ON po.idpoliza = fa.idpoliza
              LEFT JOIN plan_de_pagos plpa ON plpa.codplanpago = po.codplanpago
              LEFT JOIN (select * from VALORES_DE_LISTAS where codlista LIKE 'ESTADOS') vls ON fa.stsfact = vls.codvalor
              LEFT JOIN (SELECT idpoliza sin_idpoliza,
                               (SUM(str.monto_reserva_local) - SUM(str.monto_pago_local))  AS reserva_pendiente,
                       SUM(str.monto_pago_local) as pagado,
                       'SINIESTRADA' as si_siniestro
                    FROM siniestro str
                    WHERE str.sts_siniestro IN ('PGP', 'PGT', 'EMI')
                    GROUP BY str.idpoliza
                 ) sinis
                 ON po.idpoliza = sinis.sin_idpoliza
              LEFT JOIN (select * from VALORES_DE_LISTAS where codlista LIKE 'MTOANUFA') vla
                 ON fa.motivanul = vla.codvalor
              LEFT JOIN
              (
                 SELECT idpoliza,
                    idtiposeg,
                    plancob
                 FROM detalle_poliza
                 GROUP BY idpoliza,
                    idtiposeg,
                    plancob
               ) depo
                  ON depo.idpoliza = fa.idpoliza
              LEFT JOIN
              (
                 SELECT
                    codcliente,
                    tipo_doc_identificacion,
                    num_doc_identificacion
                    FROM clientes
               ) cl
               ON cl.codcliente = po.codcliente
               LEFT JOIN
               (
                  SELECT
                     nombre,
                     apellido_paterno,
                     apellido_materno,
                     num_doc_identificacion,
                     tipo_doc_identificacion
                     FROM persona_natural_juridica
               ) penaju
                  ON cl.tipo_doc_identificacion = penaju.tipo_doc_identificacion
                  AND cl.num_doc_identificacion = penaju.num_doc_identificacion
               LEFT JOIN
               (
                  SELECT
                     idfactura,
                     SUM(monto_det_local) AS monto
                     FROM detalle_facturas
                     WHERE CODCPTO IN ('MXASIS', 'PRIADI', 'PRIMAS', 'PRIBAS', 'PRIADI', 'GLASIS', 'GGRASI', 'ODORED', 'MADI')
                     GROUP BY idfactura
               ) df_pm
                  ON fa.idfactura = df_pm.idfactura
               LEFT JOIN
               (
                  SELECT
                     idfactura,
                     SUM(monto_det_local) AS monto
                     FROM detalle_facturas
                     WHERE CODCPTO IN ('DEREMI')
                     GROUP BY idfactura
               ) df_de
               ON fa.idfactura = df_de.idfactura
               LEFT JOIN
               (
                  SELECT
                     idfactura,
                     SUM(monto_det_local) AS monto
                     FROM detalle_facturas
                     WHERE CODCPTO IN ('IVASIN')
                     GROUP BY idfactura
               ) df_iv
                  ON fa.idfactura = df_iv.idfactura
               LEFT JOIN
               (
                  SELECT
                     idfactura,
                     SUM(monto_det_local) AS monto
                     FROM detalle_facturas
                     WHERE CODCPTO IN ('RECFIN')
                     GROUP BY idfactura
               ) df_rec
                  ON fa.idfactura = df_rec.idfactura
               LEFT JOIN
               (
                  SELECT
                     c. idfactura,
                     c. cod_agente,
                     SUM(c.comision_local) AS monto
                     FROM comisiones c, agentes a
                     WHERE c.cod_agente = a.cod_agente
                     and a.codnivel = 1
                     GROUP BY c.idfactura,
                     c.cod_agente
               ) mnt_com_dr
                  ON mnt_com_dr.idfactura = fa.idfactura
               --
               LEFT JOIN
               (
                  SELECT
                     c. idfactura,
                     c. cod_agente,
                     SUM(c.comision_local) AS monto
                     FROM comisiones c, agentes a
                     WHERE c.cod_agente = a.cod_agente
                     and a.codnivel = 2
                     GROUP BY c.idfactura,
                     c.cod_agente
               ) mnt_com_pro
                  ON mnt_com_pro.idfactura = fa.idfactura
               LEFT JOIN
               (
                  SELECT
                     c. idfactura,
                     c. cod_agente,
                     SUM(c.comision_local) AS monto
                     FROM comisiones c, agentes a
                     WHERE c.cod_agente = a.cod_agente
                     and a.codnivel = 3
                     GROUP BY c.idfactura,
                     c.cod_agente
               ) mnt_com_ag
                  ON mnt_com_ag.idfactura = fa.idfactura
               --
               LEFT JOIN
               (
                  SELECT
                     idpoliza,
                     cod_agente_distr,
                     porc_com_distribuida monto
                     FROM agentes_distribucion_comision
                     GROUP BY idpoliza,
                        cod_agente_distr,
                        porc_com_distribuida
               ) porc_com_dr
                  ON porc_com_dr.idpoliza = po.idpoliza
                     AND porc_com_dr.cod_agente_distr = mnt_com_dr.cod_agente
               ---Esto es lo nuevo
               LEFT JOIN
               (
                  SELECT
                     idpoliza,
                     cod_agente_distr,
                     porc_com_distribuida monto
                     FROM agentes_distribucion_comision
                     GROUP BY idpoliza,
                        cod_agente_distr,
                        porc_com_distribuida
               ) porc_com_pro
                  ON porc_com_pro.idpoliza = po.idpoliza
                     AND porc_com_pro.cod_agente_distr = mnt_com_pro.cod_agente
               LEFT JOIN
               (
                  SELECT
                     idpoliza,
                     cod_agente_distr,
                     porc_com_distribuida monto
                     FROM agentes_distribucion_comision
                     GROUP BY idpoliza,
                        cod_agente_distr,
                        porc_com_distribuida
               ) porc_com_ag
                  ON porc_com_ag.idpoliza = po.idpoliza
                     AND porc_com_ag.cod_agente_distr = mnt_com_ag.cod_agente
--            WHERE fa.fecvenc              <= to_date(pfecha,'dd/mm/yyyy')
            WHERE fa.fecvenc              <= last_day(trunc(sysdate))
               AND fa.fecpago               IS NULL
              ---
              ORDER BY vencimiento DESC
           ) tbb
        --Segundo filtrado de recibos
        WHERE  tbb.recibo IN
           (
              SELECT idfactura
                 FROM facturas fa
                 WHERE
                 (--Toma el recibo mas grande--?  Solo muestra recibos que correspondan al ultimo recibo del ultimo proceso de rehabilitacion
                    fa.idfactura IN
                    (
                       SELECT idfactura
                          FROM facturas fa
                          WHERE fa.idtransaccion IN
                             (
                                SELECT MAX(t.idtransaccion)
                                   FROM transaccion t,
                                      detalle_transaccion dt
                                   WHERE t.idtransaccion = dt.idtransaccion
                                      AND idproceso         = 18--Rehabilitacion de polizas
                                      AND correlativo       = 1--Numero de detalle poliza
                                   GROUP BY t.idproceso,
                                      dt.correlativo,
                                      dt.valor1,
                                      dt.valor2
                             )
                    )
                 )
                 OR --Que la poliza no este rehabilitada
                 (
                    fa.idpoliza NOT IN
                    (
                       SELECT DISTINCT(valor1)
                          FROM transaccion t,
                             detalle_transaccion dt
                          WHERE t.idtransaccion = dt.idtransaccion
                             AND idproceso = 18 --rehabilitaci?n
                             AND correlativo = 1 --N?mero de tabla del detalle
                    )
                 )
                 OR
                 (
                    fa.idfactura IN
                    (
                       SELECT idfactura
                          FROM facturas fa
                          WHERE fa.idtransaccion IN
                             (
                                SELECT distinct (tend.idtransaccion) as idtranend
                                  FROM (SELECT t.idtransaccion AS idtransaccion,
                                               valor1,
                                               valor2
                                          FROM transaccion t, detalle_transaccion dt
                                         WHERE t.idtransaccion = dt.idtransaccion
                                           AND t.idproceso = 8
                                   ) tend
                                LEFT JOIN
                                   (
                                      SELECT MAX(t.idtransaccion) idtransaccion, valor1, valor2
                                        FROM transaccion t,
                                             detalle_transaccion dt
                                       WHERE t.idtransaccion = dt.idtransaccion
                                         AND idproceso         = 18
                                       GROUP BY t.idproceso,
                                             dt.correlativo,
                                             dt.valor1,
                                             dt.valor2
                                   ) treh
                                ON tend.valor1 = treh.valor1
                                   AND tend.valor2 = treh.valor2
                                WHERE treh.idtransaccion < tend.idtransaccion
                                  AND treh.idtransaccion is not null
                             )
                    )
                 )
           )
    ;
    y x%ROWTYPE;
BEGIN
    FOR y IN x LOOP 
              INSERT INTO reprec360 (
                          recibo           , poliza        , nombre_contratante, periodicidad_pago      , origen_recibo    , subgrupo       ,
                          endoso           , vencimiento   , dias_de_vencido   , antiguedad             , prima_neta       , prima_total    ,
                          id_agente        , nombre_agente , comision_porc_ag  , comision_ag            , id_promotor      , nombre_promotor,
                          comision_porc_pro, comision_pro  , id_dirreg         , nombre_direccion       , comision_porc_dr , comision_dr    ,
                          status           , ramo          , si_siniestro      , monto_reserva_pendiente, monto_pagado     , fecha_reporte  ,
                          fec_paramfin_rep ) 
                 VALUES ( y.recibo          , y.poliza      , y.nombre_contratante,y.periodicidad_pago  ,y.origen_recibo   , y.SUBGRUPO,
                          y.ENDOSO          , y.vencimiento , y.dias_de_vencido   ,y.antiguedad         ,y.prima_neta      , y.prima_total,
                          y.id_agente       , y.nombre_agente,y.comision_porc_ag  ,y.comision_ag        ,y.id_promotor     , y.nombre_promotor,
                          y.comision_porc_pro,y.comision_pro, y.id_dirreg         ,y.nombre_direccion   ,y.comision_porc_dr, y.comision_dr,
                          y.status,y.ramo   , y.si_siniestro, y.monto_reserva_pendiente,y.monto_pagado  ,y.hoy                    ,
                          y.finParam) ;
                COMMIT;
    END LOOP;
END DATOS_REPORTE_360;

/*begin
--    DATOS_REPORTE_360('30/04/2016');
--PbaSobreEseCuEle.sql
      DATOS_REPORTE_360;
--    delete from reprec360
-- select * from reprec360 WHERE FECHA_REPORTE = TRUNC(SYSDATE) -1;
end;
*/
/

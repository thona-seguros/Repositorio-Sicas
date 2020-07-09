--
-- VW_REPORTE360  (View) 
--
--  Dependencies: 
--   VALORES_DE_LISTAS (Table)
--   OC_AGENTES (Package)
--   SINIESTRO (Table)
--   PLAN_DE_PAGOS (Table)
--   POLIZAS (Table)
--   DETALLE_FACTURAS (Table)
--   OC_VALORES_DE_LISTAS (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   CLIENTES (Table)
--   COMISIONES (Table)
--   OC_PLAN_COBERTURAS (Package)
--   DETALLE_POLIZA (Table)
--   DETALLE_TRANSACCION (Table)
--   FACTURAS (Table)
--   TRANSACCION (Table)
--
CREATE OR REPLACE FORCE VIEW SICAS_OC.VW_REPORTE360
(RECIBO, POLIZA, IDPOLIZA, NOMBRE_CONTRATANTE, PERIODICIDAD_PAGO, 
 ORIGEN_RECIBO, SUBGRUPO, ENDOSO, VENCIMIENTO, DIAS_DE_VENCIDO, 
 ANTIGUEDAD, PRIMA_NETA, PRIMA_TOTAL, ID_AGENTE, NOMBRE_AGENTE, 
 COMISION_PORC_AG, COMISION_AG, ID_PROMOTOR, NOMBRE_PROMOTOR, COMISION_PORC_PRO, 
 COMISION_PRO, ID_DIRREG, NOMBRE_DIRECCION, COMISION_PORC_DR, COMISION_DR, 
 STATUS, RAMO, SI_SINIESTRO, MONTO_RESERVA_PENDIENTE, MONTO_PAGADO, 
 FECHA_REPORTE, FEC_PARAMFIN_REP)
AS 
(SELECT "RECIBO",
           "POLIZA",
           "IDPOLIZA",
           "NOMBRE_CONTRATANTE",
           "PERIODICIDAD_PAGO",
           "ORIGEN_RECIBO",
           "SUBGRUPO",
           "ENDOSO",
           "VENCIMIENTO",
           "DIAS_DE_VENCIDO",
           "ANTIGUEDAD",
           "PRIMA_NETA",
           "PRIMA_TOTAL",
           "ID_AGENTE",
           "NOMBRE_AGENTE",
           "COMISION_PORC_AG",
           "COMISION_AG",
           "ID_PROMOTOR",
           "NOMBRE_PROMOTOR",
           "COMISION_PORC_PRO",
           "COMISION_PRO",
           "ID_DIRREG",
           "NOMBRE_DIRECCION",
           "COMISION_PORC_DR",
           "COMISION_DR",
           "STATUS",
           "RAMO",
           "SI_SINIESTRO",
           "MONTO_RESERVA_PENDIENTE",
           "MONTO_PAGADO",
           "FECHA_REPORTE",
           "FEC_PARAMFIN_REP"
      FROM (  SELECT /*+ RULE + */
                    fa.idfactura AS recibo,
                     po.numpolunico AS poliza,
                     PO.IDPOLIZA,
                     REPLACE (
                        CONCAT (
                           penaju.nombre,
                           CONCAT (
                              ' ',
                              CONCAT (penaju.apellido_paterno,
                                      CONCAT (' ', penaju.apellido_materno)))),
                        '''',
                        ' ')
                        AS nombre_contratante,
                     plpa.descplan AS periodicidad_pago,
                     CASE fa.idendoso WHEN 0 THEN 'POLIZA' ELSE 'ENDOSO' END
                        AS origen_recibo,
                     fa.idetpol AS SUBGRUPO,
                     fa.idendoso AS ENDOSO,
                     fa.fecvenc AS vencimiento,
                     TRUNC (CURRENT_DATE - fa.fecvenc) AS dias_de_vencido,
                     CASE
                        WHEN TRUNC (CURRENT_DATE - fa.fecvenc) > 120
                        THEN
                           'Mas de 120'
                        WHEN TRUNC (CURRENT_DATE - fa.fecvenc) > 90
                        THEN
                           '91 a 120'
                        WHEN TRUNC (CURRENT_DATE - fa.fecvenc) > 60
                        THEN
                           '61 a 90'
                        WHEN TRUNC (CURRENT_DATE - fa.fecvenc) > 45
                        THEN
                           '46 a 60'
                        WHEN TRUNC (CURRENT_DATE - fa.fecvenc) > 30
                        THEN
                           '31 a 45'
                        ELSE
                           '1 a 30'
                     END
                        AS antiguedad,
                     NVL (df_pm.monto, 0) AS prima_neta,
                       NVL (df_pm.monto, 0)
                     + NVL (df_de.monto, 0)
                     + NVL (df_rec.monto, 0)
                     + NVL (df_iv.monto, 0)
                        AS prima_total,
                     mnt_com_ag.cod_agente AS id_agente,
                     OC_AGENTES.NOMBRE_AGENTE (1, mnt_com_ag.cod_agente)
                        AS nombre_agente,
                     porc_com_ag.monto AS comision_porc_ag,
                     NVL (mnt_com_ag.monto, 0) AS comision_ag,
                     NVL (mnt_com_pro.cod_agente, 0) AS id_promotor,
                     OC_AGENTES.NOMBRE_AGENTE (1, mnt_com_pro.cod_agente)
                        AS nombre_promotor,
                     NVL (porc_com_pro.monto, 0) AS comision_porc_pro,
                     NVL (mnt_com_pro.monto, 0) AS comision_pro,
                     NVL (mnt_com_dr.cod_agente, 0) AS id_dirreg,
                     OC_AGENTES.NOMBRE_AGENTE (1, mnt_com_dr.cod_agente)
                        AS nombre_direccion,
                     NVL (porc_com_dr.monto, 0) AS comision_porc_dr,
                     NVL (mnt_com_dr.monto, 0) AS comision_dr,
                     CONCAT (vls.descvallst, CONCAT (' ', vla.descvallst))
                        AS status,
                     OC_VALORES_DE_LISTAS.BUSCA_LVALOR ('SUBRAMOS',
                                                        oc_plan_coberturas.codigo_subramo (
                                                           1,
                                                           1,
                                                           depo.idtiposeg,
                                                           depo.plancob))
                        AS ramo,
                     COALESCE (sinis.si_siniestro, 'SIN SINIESTRO')
                        AS si_siniestro,
                     COALESCE (sinis.reserva_pendiente, 0)
                        AS monto_reserva_pendiente,
                     COALESCE (sinis.pagado, 0) AS monto_pagado,
                     TRUNC (SYSDATE) AS FECHA_REPORTE,
                     LAST_DAY (TRUNC (SYSDATE)) AS FEC_PARAMFIN_REP
                FROM (SELECT /*+ RULE +*/
                            *
                        FROM facturas
                       WHERE                        --idfactura IN (13364) and
                            idpoliza NOT IN --No es p?liza que tenga facturas anuladas por FPA o COT que venzan este a?o y correspondan al endoso 0
                                    (SELECT DISTINCT (idpoliza)
                                       FROM facturas
                                      WHERE     (    stsfact = 'ANU'
                                                 AND motivanul IN
                                                        ('FPA', 'CAFP', 'COT'))
                                            AND TRUNC (CURRENT_DATE - fecvenc) >=
                                                   365
                                            AND idendoso = 0)
                             AND TRUNC (CURRENT_DATE - fecvenc) <= 365
                             AND (   stsfact IN ('EMI', 'PAG', 'ABO')
                                  OR (    stsfact = 'ANU'
                                      AND motivanul IN ('FPA', 'CAFP', 'COT')))) fa
                     LEFT JOIN polizas po ON po.idpoliza = fa.idpoliza
                     LEFT JOIN plan_de_pagos plpa
                        ON plpa.codplanpago = po.codplanpago
                     LEFT JOIN (SELECT *
                                  FROM VALORES_DE_LISTAS
                                 WHERE codlista LIKE 'ESTADOS') vls
                        ON fa.stsfact = vls.codvalor
                     LEFT JOIN
                     (  SELECT idpoliza sin_idpoliza,
                               (  SUM (str.monto_reserva_local)
                                - SUM (str.monto_pago_local))
                                  AS reserva_pendiente,
                               SUM (str.monto_pago_local) AS pagado,
                               'SINIESTRADA' AS si_siniestro
                          FROM siniestro str
                         WHERE str.sts_siniestro IN ('PGP', 'PGT', 'EMI')
                      GROUP BY str.idpoliza) sinis
                        ON po.idpoliza = sinis.sin_idpoliza
                     LEFT JOIN (SELECT *
                                  FROM VALORES_DE_LISTAS
                                 WHERE codlista LIKE 'MTOANUFA') vla
                        ON fa.motivanul = vla.codvalor
                     LEFT JOIN (  SELECT idpoliza, idtiposeg, plancob
                                    FROM detalle_poliza
                                GROUP BY idpoliza, idtiposeg, plancob) depo
                        ON depo.idpoliza = fa.idpoliza
                     LEFT JOIN
                     (SELECT codcliente,
                             tipo_doc_identificacion,
                             num_doc_identificacion
                        FROM clientes) cl
                        ON cl.codcliente = po.codcliente
                     LEFT JOIN
                     (SELECT nombre,
                             apellido_paterno,
                             apellido_materno,
                             num_doc_identificacion,
                             tipo_doc_identificacion
                        FROM persona_natural_juridica) penaju
                        ON     cl.tipo_doc_identificacion =
                                  penaju.tipo_doc_identificacion
                           AND cl.num_doc_identificacion =
                                  penaju.num_doc_identificacion
                     LEFT JOIN
                     (  SELECT idfactura, SUM (monto_det_local) AS monto
                          FROM detalle_facturas
                         WHERE CODCPTO IN
                                  ('MXASIS',
                                   'PRIADI',
                                   'PRIMAS',
                                   'PRIBAS',
                                   'PRIADI',
                                   'GLASIS',
                                   'GGRASI',
                                   'ODORED',
                                   'MADI')
                      GROUP BY idfactura) df_pm
                        ON fa.idfactura = df_pm.idfactura
                     LEFT JOIN
                     (  SELECT idfactura, SUM (monto_det_local) AS monto
                          FROM detalle_facturas
                         WHERE CODCPTO IN ('DEREMI')
                      GROUP BY idfactura) df_de
                        ON fa.idfactura = df_de.idfactura
                     LEFT JOIN
                     (  SELECT idfactura, SUM (monto_det_local) AS monto
                          FROM detalle_facturas
                         WHERE CODCPTO IN ('IVASIN')
                      GROUP BY idfactura) df_iv
                        ON fa.idfactura = df_iv.idfactura
                     LEFT JOIN
                     (  SELECT idfactura, SUM (monto_det_local) AS monto
                          FROM detalle_facturas
                         WHERE CODCPTO IN ('RECFIN')
                      GROUP BY idfactura) df_rec
                        ON fa.idfactura = df_rec.idfactura
                     LEFT JOIN
                     (  SELECT c.idfactura,
                               c.cod_agente,
                               SUM (c.comision_local) AS monto
                          FROM comisiones c, agentes a
                         WHERE c.cod_agente = a.cod_agente AND a.codnivel = 1
                      GROUP BY c.idfactura, c.cod_agente) mnt_com_dr
                        ON mnt_com_dr.idfactura = fa.idfactura
                     --
                     LEFT JOIN
                     (  SELECT c.idfactura,
                               c.cod_agente,
                               SUM (c.comision_local) AS monto
                          FROM comisiones c, agentes a
                         WHERE c.cod_agente = a.cod_agente AND a.codnivel = 2
                      GROUP BY c.idfactura, c.cod_agente) mnt_com_pro
                        ON mnt_com_pro.idfactura = fa.idfactura
                     LEFT JOIN
                     (  SELECT c.idfactura,
                               c.cod_agente,
                               SUM (c.comision_local) AS monto
                          FROM comisiones c, agentes a
                         WHERE c.cod_agente = a.cod_agente AND a.codnivel = 3
                      GROUP BY c.idfactura, c.cod_agente) mnt_com_ag
                        ON mnt_com_ag.idfactura = fa.idfactura
                     --
                     LEFT JOIN
                     (  SELECT idpoliza,
                               cod_agente_distr,
                               porc_com_distribuida monto
                          FROM agentes_distribucion_comision
                      GROUP BY idpoliza, cod_agente_distr, porc_com_distribuida) porc_com_dr
                        ON     porc_com_dr.idpoliza = po.idpoliza
                           AND porc_com_dr.cod_agente_distr =
                                  mnt_com_dr.cod_agente
                     ---Esto es lo nuevo
                     LEFT JOIN
                     (  SELECT idpoliza,
                               cod_agente_distr,
                               porc_com_distribuida monto
                          FROM agentes_distribucion_comision
                      GROUP BY idpoliza, cod_agente_distr, porc_com_distribuida) porc_com_pro
                        ON     porc_com_pro.idpoliza = po.idpoliza
                           AND porc_com_pro.cod_agente_distr =
                                  mnt_com_pro.cod_agente
                     LEFT JOIN
                     (  SELECT idpoliza,
                               cod_agente_distr,
                               porc_com_distribuida monto
                          FROM agentes_distribucion_comision
                      GROUP BY idpoliza, cod_agente_distr, porc_com_distribuida) porc_com_ag
                        ON     porc_com_ag.idpoliza = po.idpoliza
                           AND porc_com_ag.cod_agente_distr =
                                  mnt_com_ag.cod_agente
               WHERE     fa.fecvenc <= LAST_DAY (TRUNC (SYSDATE))
                     AND fa.fecpago IS NULL
            ---
            ORDER BY vencimiento DESC) tbb
     --Segundo filtrado de recibos
     WHERE tbb.recibo IN
              (SELECT /*+ RULE +*/
                     idfactura
                 FROM facturas fa
                WHERE    ( --Toma el recibo m?s grande--?    S?lo muestra recibos que correspondan al ?ltimo recibo del ?ltimo proceso de rehabilitaci?n
                          fa.idfactura IN
                             (SELECT idfactura
                                FROM facturas fa
                               WHERE fa.idtransaccion IN
                                        (  SELECT MAX (t.idtransaccion)
                                             FROM transaccion t,
                                                  detalle_transaccion dt
                                            WHERE     t.idtransaccion =
                                                         dt.idtransaccion
                                                  AND idproceso = 18 --Rehabilitaci?n de p?lizas
                                                  AND correlativo = 1 --N?mero de detalle p?liza
                                         GROUP BY t.idproceso,
                                                  dt.correlativo,
                                                  dt.valor1,
                                                  dt.valor2)))
                      OR                  --Que la p?liza no est? rehabilitada
                         (fa.idpoliza NOT IN
                             (SELECT DISTINCT (valor1)
                                FROM transaccion t, detalle_transaccion dt
                               WHERE     t.idtransaccion = dt.idtransaccion
                                     AND idproceso = 18       --rehabilitaci?n
                                     AND correlativo = 1 --N?mero de tabla del detalle
                                                        ))
                      OR (fa.idfactura IN
                             (SELECT idfactura
                                FROM facturas fa
                               WHERE fa.idtransaccion IN
                                        (SELECT DISTINCT
                                                (tend.idtransaccion)
                                                   AS idtranend
                                           FROM (SELECT t.idtransaccion
                                                           AS idtransaccion,
                                                        valor1,
                                                        valor2
                                                   FROM transaccion t,
                                                        detalle_transaccion dt
                                                  WHERE     t.idtransaccion =
                                                               dt.idtransaccion
                                                        AND t.idproceso = 8) tend
                                                LEFT JOIN
                                                (  SELECT MAX (t.idtransaccion)
                                                             idtransaccion,
                                                          valor1,
                                                          valor2
                                                     FROM transaccion t,
                                                          detalle_transaccion dt
                                                    WHERE     t.idtransaccion =
                                                                 dt.idtransaccion
                                                          AND idproceso = 18
                                                 GROUP BY t.idproceso,
                                                          dt.correlativo,
                                                          dt.valor1,
                                                          dt.valor2) treh
                                                   ON     tend.valor1 =
                                                             treh.valor1
                                                      AND tend.valor2 =
                                                             treh.valor2
                                          WHERE     treh.idtransaccion <
                                                       tend.idtransaccion
                                                AND treh.idtransaccion
                                                       IS NOT NULL)))))
/


--
-- VW_REPORTE360  (Synonym) 
--
--  Dependencies: 
--   VW_REPORTE360 (View)
--
CREATE OR REPLACE PUBLIC SYNONYM VW_REPORTE360 FOR SICAS_OC.VW_REPORTE360
/


GRANT DELETE, INSERT, SELECT, UPDATE ON SICAS_OC.VW_REPORTE360 TO PUBLIC
/

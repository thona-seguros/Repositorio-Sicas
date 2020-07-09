--
-- VW_REPCARTERA  (View) 
--
--  Dependencies: 
--   OC_AGENTES (Package)
--   OC_AGE_DISTRIBUCION_COMISION (Package)
--   POLIZAS (Table)
--   OC_VALORES_DE_LISTAS (Package)
--   AGENTES (Table)
--   AGENTE_POLIZA (Table)
--   OC_DETALLE_FACTURAS (Package)
--   OC_PLAN_COBERTURAS (Package)
--   OC_PLAN_DE_PAGOS (Package)
--   OC_CLIENTES (Package)
--   OC_COMISIONES (Package)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--
CREATE OR REPLACE FORCE VIEW SICAS_OC.VW_REPCARTERA
(CODCIA, CODEMPRESA, CONSECUTIVO, POLIZA, AGRUPADOR, 
 RAMO, CONTRATANTE, INICIO_VIG, FIN_VIG, PLAN_PAGO, 
 NUM_SUBGRUPOS, STATUS, FECHA_STATUS, PRIMA_NETA, DERECHO_POLIZA, 
 RECARGO, IVA, PRIMA_TOTAL, PRIMA_BASE, MONTO_PAGADO, 
 CODIGO_AGENTE, NOMBRE_AGENTE, PORCENTAJE_AGENTE, CANTIDAD_AGENTE, CODIGO_PROMOTOR, 
 NOMBRE_PROMOTOR, PORCENTAJE_PROMOTOR, CANTIDAD_PROMOTOR, CODIGO_DIRECCION, NOMBRE_DIRECCION, 
 PORCENTAJE_DIRECCION, CANTIDAD_DIRECCION)
AS 
SELECT P.CodCia, P.CodEmpresa, P.IdPoliza Consecutivo, 
           P.NumPolUnico Poliza, 
           P.CodAgrupador Agrupador, 
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', OC_PLAN_COBERTURAS.CODIGO_SUBRAMO(1, 1, DP.IdTipoSeg, DP.PlanCob)) Ramo, 
           REPLACE(OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente), '''', ' ') Contratante, 
           P.FecIniVig Inicio_Vig, 
           P.FecFinVig Fin_Vig, 
           OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(P.CodCia, P.CodEmpresa, P.CodPlanPago) Plan_Pago, 
           (SELECT COUNT(IDetPol) 
              FROM DETALLE_POLIZA 
             WHERE IdPoliza = P.IdPoliza 
               AND CodCia = P.CodCia) Num_Subgrupos, 
           CONCAT(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza) || ' ', DECODE(P.MotivAnul, NULL, '', OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MTOANUFA', P.MotivAnul))) Status, 
           P.FecSts Fecha_Status, 
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'PRIMAS') Prima_Neta, 
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'DEREMI') Derecho_Poliza, 
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'RECFIN') Recargo,
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'IVASIN') Iva, 
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'PRIMAS') +
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'DEREMI') +
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'RECFIN') +
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'IVASIN') Prima_Total,
           OC_DETALLE_FACTURAS.MONTO_NETO_CONCEPTO(P.CodCia, P.IdPoliza, 'PRIMAS') Prima_Base, 
           OC_DETALLE_FACTURAS.MONTO_PAGADO_CONCEPTO(P.CodCia, P.IdPoliza, NULL) Monto_Pagado, 
           A.Cod_Agente Codigo_Agente, 
           OC_AGENTES.NOMBRE_AGENTE(1, A.Cod_Agente) Nombre_Agente, 
           OC_AGE_DISTRIBUCION_COMISION.PORCENTAJE_DISTRIBUCION(P.CodCia, P.IdPoliza, DP.IDetPol, 3, A.Cod_Agente) Porcentaje_Agente, 
           OC_COMISIONES.MONTO_COMISION(P.CodCia, P.IdPoliza, 3, A.Cod_Agente, NULL, NULL) Cantidad_Agente,
           OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR(P.CodCia, P.IdPoliza, DP.IDetPol, 2, A.Cod_Agente) Codigo_Promotor, 
           OC_AGENTES.NOMBRE_AGENTE(1, OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR(P.CodCia, P.IdPoliza, DP.IDetPol, 2, A.Cod_Agente)) Nombre_Promotor, 
           OC_AGE_DISTRIBUCION_COMISION.PORCENTAJE_DISTRIBUCION(P.CodCia, P.IdPoliza, DP.IDetPol, 2, A.Cod_Agente) Porcentaje_Promotor, 
           OC_COMISIONES.MONTO_COMISION(P.CodCia, P.IdPoliza, 2, OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR(P.CodCia, P.IdPoliza, DP.IDetPol, 2, A.Cod_Agente), NULL, NULL) Cantidad_Promotor, 
           OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR(P.CodCia, P.IdPoliza, DP.IDetPol, 1, A.Cod_Agente) Codigo_Direccion, 
           OC_AGENTES.NOMBRE_AGENTE(1, OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR(P.CodCia, P.IdPoliza, DP.IDetPol, 1, A.Cod_Agente)) Nombre_Direccion, 
           OC_AGE_DISTRIBUCION_COMISION.PORCENTAJE_DISTRIBUCION(P.CodCia, P.IdPoliza, DP.IDetPol, 1, A.Cod_Agente) Porcentaje_Direccion, 
           OC_COMISIONES.MONTO_COMISION(P.CodCia, P.IdPoliza, 1, OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR(P.CodCia, P.IdPoliza, DP.IDetPol, 1, A.Cod_Agente), NULL, NULL)  Cantidad_Direccion 
      FROM POLIZAS P, DETALLE_POLIZA DP, FACTURAS F, 
           AGENTE_POLIZA AP,  AGENTES A
     WHERE (P.StsPoliza     = 'EMI' 
             OR P.StsPoliza = 'ANU' 
            AND P.MotivAnul IN ('FPA', 'COT', 'CAFP')) 
       AND F.StsFact        IN ('PAG', 'EMI') 
       AND P.IdPoliza       = DP.IdPoliza 
       AND P.IdPoliza       = F.IdPoliza
       AND F.CodCia         = P.CodCia
       AND DP.IDetPol       = F.IDetPol 
       AND DP.IdPoliza      = F.IdPoliza
       AND DP.CodCia        = F.CodCia
       AND AP.CodCia        = P.CodCia
       AND AP.IdPoliza      = P.IdPoliza
       AND AP.Cod_Agente    = A.Cod_Agente
       AND A.CodCia         = P.CodCia
     GROUP BY P.IdPoliza, P.NumPolUnico, P.CodAgrupador, DP.IdTipoSeg, DP.PlanCob, P.CodCliente, P.FecIniVig, P.FecFinVig, P.CodCia, P.CodEmpresa, P.CodPlanPago, DP.IDetPol, P.StsPoliza, P.MotivAnul, P.FecSts, F.StsFact, A.Cod_Agente
/


--
-- VW_REPCARTERA  (Synonym) 
--
--  Dependencies: 
--   VW_REPCARTERA (View)
--
CREATE OR REPLACE PUBLIC SYNONYM VW_REPCARTERA FOR SICAS_OC.VW_REPCARTERA
/


GRANT SELECT ON SICAS_OC.VW_REPCARTERA TO PUBLIC
/

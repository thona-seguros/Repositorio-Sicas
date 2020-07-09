--
-- TH_COMISIONES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_OUTPUT (Synonym)
--   NCR_FACTEXT (Table)
--   NOTAS_DE_CREDITO (Table)
--   SALDOS_COMISIONES (Table)
--   SALDOS_COMISIONES (Table)
--   SALDOS_COMISIONES_DETALLE (Table)
--   SALDOS_COMISIONES_DETALLE (Table)
--   SALDOS_COMISIONES_DIARIOS (Table)
--   SALDOS_COMISIONES_DIARIOS (Table)
--   SALDOS_COMISIONES_PAGOS (Table)
--   SALDOS_COMISIONES_PAGOS (Table)
--   POLIZAS (Table)
--   DETALLE_COMISION (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   OC_VALORES_DE_LISTAS (Package)
--   AGENTES (Table)
--   AGENTES (Table)
--   AGENTES_CEDULA_AUTORIZADA (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   COMISIONES (Table)
--   COMISIONES (Table)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--   FACTURAS (Table)
--   TIPOS_DE_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.th_comisiones IS

  -- Author  : RSERNA
  -- Created : 26/07/2016 15:25:10
  -- Purpose : Procesar los saldos finales de las comisiones.
  
   xCia      saldos_comisiones_detalle.cd_cia%TYPE     ; 
   xAgente   saldos_comisiones_detalle.cd_agente%TYPE  ;
   xFecIni   DATE := TO_DATE('01/01/2015','DD/MM/YYYY');
   xFecFin   DATE := TO_DATE('31/12/2015','DD/MM/YYYY');
   pFecIni   DATE                                      ;
   pFecFin   DATE                                      ;
   vYaLoHice saldos_comisiones.fe_fin_saldo%TYPE       ;
   vDias   NUMBER(4)                                   ;
   xFecNva DATE                                        ;
   DIARIO  CONSTANT NUMBER(2) := 1                     ;
   MENSUAL CONSTANT NUMBER(2) := 30                    ;
   
         CURSOR x (vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                   vAgente IN saldos_comisiones_detalle.cd_agente%TYPE) IS 
         SELECT codcia     cia, 
                cod_agente cve 
           FROM agentes 
          WHERE codcia    = vCia
            AND cod_agente = DECODE(vAgente, 0, cod_agente, vAgente);--Agente;
            t x%ROWTYPE;
  -- Public function and procedure declarations
        PROCEDURE Elimina_movimientos (vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                         vAgente IN saldos_comisiones_detalle.cd_agente%TYPE,
                         vFecIni IN DATE                                    ,
                         vFecFin IN DATE                                    );
    
        PROCEDURE MeteSaldo (vTipo         IN NUMBER                                          ,
                             vCia          IN Saldos_comisiones_diarios.Cd_Cia%TYPE           , 
                             vCveAge       IN Saldos_comisiones_diarios.Cd_Agente%TYPE        , 
                             vTipRamo      IN Saldos_comisiones_diarios.Cd_Tipo_Ramo%TYPE     , 
                             vFecOri       IN Saldos_comisiones_diarios.Fe_Saldo%TYPE         ,
                             vFecFin       IN Saldos_comisiones_diarios.Fe_Saldo%TYPE         ,       
                             vCveMon       IN Saldos_comisiones_diarios.Cd_Moneda%TYPE        , 
                             vSaldoInicial IN Saldos_comisiones_diarios.Mt_Saldo_Inicial%TYPE , 
                             vPagos        IN saldos_comisiones_pagos.mt_pago%TYPE            ,                             
                             vComis        IN Saldos_comisiones_diarios.Mt_Com_Tot%TYPE       , 
                             vIVA          IN Saldos_comisiones_diarios.Mt_Iva_Tot%TYPE       ,
                             vIvaRet       IN Saldos_comisiones_diarios.Mt_Ivaret_Tot%TYPE    , 
                             vISR          IN Saldos_comisiones_diarios.Mt_Isr_Tot%TYPE       , 
                             vIsrRet       IN Saldos_comisiones_diarios.Mt_Isrret_Tot%TYPE    , 
                             vSaldo        IN Saldos_comisiones_diarios.Mt_Subtotal_Tot%TYPE  , 
                             vEncOntra     IN Saldos_comisiones_diarios.Mt_Encontra_Tot%TYPE  ,
                             vAFavor       IN Saldos_comisiones_diarios.Mt_Afavor_Tot%TYPE    ,  
                             vSaldofinal   IN Saldos_comisiones_diarios.Mt_Saldo_Final%TYPE   );


         PROCEDURE CreaSaldosIniciales (vCia       IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                                        vAgente    IN saldos_comisiones_detalle.cd_agente%TYPE,
                                        vFecIniCSI IN saldos_comisiones.fe_ini_saldo%TYPE     ,
                                        vFecFinCSI IN saldos_comisiones.fe_fin_saldo%TYPE     ) ;

         FUNCTION cuenta_movs_com (vCia    IN comisiones.codcia%TYPE    ,
                                   vAgente IN comisiones.cod_agente%TYPE,
                                   vFecIni IN facturas.Fecsts%TYPE      ,
                                   vFecFin IN facturas.Fecsts%TYPE      ) RETURN NUMBER;

        PROCEDURE mete_detalle (pCd_Cia       IN saldos_comisiones_detalle.cd_cia%TYPE       , pCd_agente      IN saldos_comisiones_detalle.cd_agente%TYPE       , 
                                pTipo_ramo    IN saldos_comisiones_detalle.cd_tipo_ramo%TYPE , pFeIniSaldo     IN saldos_comisiones_detalle.fe_ini_saldo%TYPE    , 
                                pFeFinSaldo   IN saldos_comisiones_detalle.fe_fin_saldo%TYPE , pFeProcesoSaldo IN saldos_comisiones_detalle.fe_proceso_saldo%TYPE, 
                                pFeGeneracion IN saldos_comisiones_detalle.fe_generacion%TYPE, pCdNivel        IN saldos_comisiones_detalle.cd_nivel%TYPE        , 
                                pIdPoliza     IN saldos_comisiones_detalle.id_poliza%TYPE    , pIdEndoso       IN saldos_comisiones_detalle.id_endoso%TYPE       , 
                                pIdRecibo     IN saldos_comisiones_detalle.id_recibo%TYPE    , pCdMoneda       IN saldos_comisiones_detalle.cd_moneda%TYPE       , 
                                pMtPmaCom     IN saldos_comisiones_detalle.mt_prima_com%TYPE , pMtComision     IN saldos_comisiones_detalle.mt_comision%TYPE     , 
                                pMtIva        IN saldos_comisiones_detalle.mt_iva%TYPE       , pMtIvaRret      IN saldos_comisiones_detalle.mt_ivaret%TYPE       ,
                                pMtIsr        IN saldos_comisiones_detalle.mt_isr%TYPE       , pMtIsrRet       IN saldos_comisiones_detalle.mt_isrret%TYPE       , 
                                pMtSubTotal   IN saldos_comisiones_detalle.mt_subtotal%TYPE  , pMtEnContra     IN saldos_comisiones_detalle.mt_encontra%TYPE     , 
                                pMtAFavor     IN saldos_comisiones_detalle.mt_afavor%TYPE    , pIdComision     IN saldos_comisiones_detalle.id_comision%TYPE     , 
                                pStComision   IN saldos_comisiones_detalle.st_comision%TYPE  , pPoComDist      IN saldos_comisiones_detalle.po_com_dist%TYPE     ,
                                pPoComProp    IN saldos_comisiones_detalle.po_com_prop%TYPE  , pMtPma          IN saldos_comisiones_detalle.mt_pma%TYPE          , 
                                pMtPmaFactura IN saldos_comisiones_detalle.mt_pmafactura%TYPE, pFePago         IN saldos_comisiones_detalle.fe_pago%TYPE         );

         PROCEDURE DetalleComisiones(vCia    IN comisiones.codcia%TYPE    ,
                                     vAgente IN comisiones.cod_agente%TYPE, 
                                     vFecIni IN DATE                      , 
                                     vFecFin IN DATE                      );

         PROCEDURE ProcesoComisiones ( vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                                       vAgente IN saldos_comisiones_detalle.cd_agente%TYPE,
                                       vFecIni IN DATE                                    ,
                                       vFecFin IN DATE                                    );

         PROCEDURE IniciaSaldosenCero  ( vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                                         vAgente IN saldos_comisiones_detalle.cd_agente%TYPE,
                                         vFecIni IN DATE                                    ,
                                         vFecFin IN DATE                                    ); 
END th_comisiones;
/

--
-- TH_COMISIONES  (Package Body) 
--
--  Dependencies: 
--   TH_COMISIONES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.th_comisiones IS
  -- Private type declarations
    PROCEDURE Elimina_movimientos (vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                     vAgente IN saldos_comisiones_detalle.cd_agente%TYPE,
                     vFecIni IN DATE                                    ,
                     vFecFin IN DATE                                    ) IS 
          y x%ROWTYPE;
    BEGIN 
       OPEN x(vCia, vAgente);
       LOOP 
         FETCH x INTO y;
          EXIT WHEN x%NOTFOUND;
               DELETE FROM saldos_comisiones_detalle
                WHERE cd_cia       = y.cia
                  AND cd_agente    = y.cve
                  AND to_date(to_char(fe_ini_saldo,'dd/mm/yyyy'),'dd/mm/yyyy') >= to_date(to_char(vFecIni,'dd/mm/yyyy'),'dd/mm/yyyy')
                  AND to_date(to_char(fe_fin_saldo,'dd/mm/yyyy'),'dd/mm/yyyy') <= to_date(to_char(vFecFin,'dd/mm/yyyy'),'dd/mm/yyyy');                  
           --
           COMMIT;                    
           --
               DELETE FROM saldos_comisiones_diarios w
                WHERE w.cd_cia     = y.cia
                  AND w.cd_agente  = y.cve 
                  AND to_date(to_char(w.fe_saldo,'dd/mm/yyyy'),'dd/mm/yyyy') between to_date(to_char(vFecIni,'dd/mm/yyyy'),'dd/mm/yyyy')
                                                                                 and to_date(to_char(vFecFin,'dd/mm/yyyy'),'dd/mm/yyyy');   
            --
           COMMIT;                               
           --
               DELETE FROM saldos_comisiones 
                WHERE cd_cia       = y.cia
                  AND cd_agente    = y.cve 
                  AND to_date(to_char(fe_ini_saldo,'dd/mm/yyyy'),'dd/mm/yyyy') >= to_date(to_char(vFecIni,'dd/mm/yyyy'),'dd/mm/yyyy')
                  AND to_date(to_char(fe_fin_saldo,'dd/mm/yyyy'),'dd/mm/yyyy') <= to_date(to_char(vFecFin,'dd/mm/yyyy'),'dd/mm/yyyy');                  
            --
           COMMIT;                    
           --
       END LOOP;
       CLOSE x;
    END Elimina_movimientos;
    
        PROCEDURE PagosPeriodo (vCia IN saldos_comisiones_pagos.cd_cia%TYPE       ,
                               vAgente IN saldos_comisiones_pagos.cd_agente%TYPE ,
                               vFecIni IN saldos_comisiones_pagos.fe_pago%TYPE   ,
                               vFecFin IN saldos_comisiones_pagos.fe_pago%TYPE   ) IS 
 
                 CURSOR p IS          
                 SELECT  Cia                cia         ,
                         AGENTE             Agente      ,
                         TIPO_RAMO          TipRamo     ,
                         FECHA_PAGO         FePago      , 
                         NOTA               Nota        ,
                         Concepto           ,                         
                         TRUNC(sysdate)     Hoy         ,
                         DESCRIPCION        Descripcion ,
                         SUM(ImporteFinal)  ImporteFinal
                  FROM 
                       (
                      SELECT UNIQUE(NC.FECSTS)                                             FECHA_PAGO,
                             c.codcia     Cia   , 
                             c.cod_agente Agente,
                             --OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) tipo_Ramo,
                             PC.CodTipoPlan                                                  tipo_Ramo,
                             concepto                                                       concepto,
                             OC_VALORES_DE_LISTAS.BUSCA_LVALOR('IDCONCEP',DECODE(C.ORIGEN,'C','C','A','C',C.ORIGEN))       Descripcion, 
                             nc.idncr                                                                                      Nota,
                             sum(ImporteFinal)                                             ImporteFinal       
                    FROM comisiones c, 
                         facturas f, 
                         polizas          po, 
                         detalle_poliza   dp, 
                         tipos_de_seguros pc, 
                         notas_de_credito nc, 
                        (SELECT CodCia, IdComision, Concepto, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
                                SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) ImporteFinal
                           FROM (SELECT DC.CodCia, 
                                        DC.IdComision,
                                        DC.CodConcepto Concepto,
                                        DECODE(DC.CodConcepto, 'COMISI', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'AJUCOM', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'AJUHON', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'UDI',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoComisi,
                                        DECODE(DC.CodConcepto, 'IVASIN', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIva,
                                        DECODE(DC.CodConcepto, 'RETIVA', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIvaRet, 
                                        DECODE(DC.CodConcepto, 'ISR',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsr, 
                                        DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsrRet
                                   FROM COMISIONES       C2, 
                                        DETALLE_COMISION DC                      
                                   WHERE C2.CODCIA       = vCia
                                   AND   C2.Cod_Agente   = vAgente
                                   AND   DC.CODCIA     = C2.CODCIA
                                   AND   DC.IDCOMISION = C2.IDCOMISION
                                  GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                          GROUP BY CodCia, IdComision, Concepto) Y      
                   WHERE C.CodCia     = vCia 
                     AND C.Cod_Agente = vAgente
                     AND C.IdComision = Y.IdComision
                     AND C.Estado    !='PRY'
                     AND C.IdFactura  = F.IdFactura
                     ---
                     AND F.StsFact     != 'ANU'
                     AND PO.IdPoliza    = F.IdPoliza 
                     AND DP.IdPoliza    = F.IdPoliza 
                     AND DP.IdetPol     = F.IdetPol 
                     ---
                     AND DP.CodCia      = PC.CodCia
                     AND DP.CodEmpresa  = PC.CodEmpresa
                     AND DP.IdTipoSeg   = PC.IdTipoSeg
                     ---
                     AND NC.STSNCR     = 'PAG'
                     AND NC.IDNOMINA  (+) = C.IDNOMINA 
                     AND NC.FECSTS BETWEEN trunc(vFecIni,'MONTH') and last_day(trunc(vFecFin,'MONTH'))
                     group by c.codcia, c.cod_agente, PC.CodTipoPlan,NC.FECSTS, nc.idncr, Concepto,                                 
                              OC_VALORES_DE_LISTAS.BUSCA_LVALOR('IDCONCEP', DECODE(C.ORIGEN,'C','C','A','C',C.ORIGEN))--,
                  UNION 
                  SELECT UNIQUE(trunc(C.FEC_LIQUIDACION))                                             FECHA_PAGO,
                         c.codcia                                                                     Cia   , 
                         c.cod_agente                                                                 Agente,
                         pc.codtipoplan                                                               tipo_ramo,
                         Concepto                                                                     Concepto, 
                         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('IDCONCEP', DECODE(C.ORIGEN,'C','C','A','C',C.ORIGEN))       Descripcion, 
                         n.idncr                                                                                        nota,
                         sum(ImporteFinal)                                            ImporteFinal              
                    FROM comisiones                      c, 
                         notas_de_credito                n, 
                         polizas                        po, 
                         detalle_poliza                 dp, 
                         tipos_de_seguros               pc,
                        (SELECT CodCia, IdComision, Concepto, SUM(MtoComisi) MtoComisi, SUM(MtoIva)  MtoIva, 
                                SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
                                SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) ImporteFinal
                           FROM ( SELECT 
                                        DC.CodCia, 
                                        DC.IdComision,
                                        DC.CodConcepto Concepto,
                                        DECODE(DC.CodConcepto, 'COMISI', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'AJUCOM', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'AJUHON', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'UDI',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoComisi,
                                        DECODE(DC.CodConcepto, 'IVASIN', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIva,
                                        DECODE(DC.CodConcepto, 'RETIVA', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIvaRet, 
                                        DECODE(DC.CodConcepto, 'ISR',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsr, 
                                        DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsrRet
                                  FROM COMISIONES       C2, 
                                       DETALLE_COMISION DC                      
                                  WHERE C2.CODCIA       = vCia
                                  AND   C2.Cod_Agente   = vAgente
                                  AND   DC.CODCIA     = C2.CODCIA
                                  AND   DC.IDCOMISION = C2.IDCOMISION
                                  GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                           GROUP BY CodCia, IdComision, Concepto) Y       
                   WHERE C.CodCia       = Y.CodCia
                     AND C.IdComision   = Y.IdComision
                     AND C.Cod_Agente   = vAgente
                     AND C.IdNcr        = N.IdNcr
                     --
                     AND N.STSNCR      = 'APL'
                     AND N.IdPoliza     = PO.IdPoliza
                     AND N.IdPoliza     = DP.IdPoliza
                     AND N.IdetPol      = DP.IdetPol
                     AND TRUNC(C.FEC_LIQUIDACION)  BETWEEN trunc(vFecIni,'month') and last_day(trunc(vFecFin,'month'))
                     ---
                     /*AND c.fec_estado BETWEEN TRUNC(vFecIni,'month') 
                                          AND LAST_DAY(TRUNC(vFecFin,'month'))*/
                     ---                     
                     --
                     AND DP.CodCia      = PC.CodCia
                     AND DP.CodEmpresa  = PC.CodEmpresa
                     AND DP.IdTipoSeg   = PC.IdTipoSeg                
                   GROUP BY c.codcia, c.cod_agente, PC.CodTipoPlan, C.FEC_LIQUIDACION, n.idncr, Concepto,
                              OC_VALORES_DE_LISTAS.BUSCA_LVALOR('IDCONCEP', DECODE(C.ORIGEN,'C','C','A','C',C.ORIGEN))--,
                  UNION  
                  SELECT unique(NC.FECSTS)                                             FECHA_PAGO,
                         c.codcia                                                      Cia   , 
                         c.cod_agente                                                  Agente,
                         pc.codtipoplan                                                tipo_ramo,
                         Concepto                                                      Concepto, 
                         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('IDCONCEP', DECODE(C.ORIGEN,'C','C','A','C',C.ORIGEN))       Descripcion, 
                         nc.idncr                                                      Nota,
                         sum(ImporteFinal)                                             ImporteFinal              
                    FROM comisiones                      c, 
                         polizas                        po, 
                         detalle_poliza                 dp, 
                         notas_de_credito               nc, 
                         tipos_de_seguros               pc,                          
                        --- NCR_FACTEXT                    XT,
                         ( SELECT CodCia, IdComision, Concepto, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
                                SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) ImporteFinal
                           FROM ( SELECT 
                                        DC.CodCia, 
                                        DC.IdComision,
                                        DC.CodConcepto Concepto,
                                        DECODE(DC.CodConcepto, 'COMISI', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'AJUCOM', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'AJUHON', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                        DECODE(DC.CodConcepto, 'UDI',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoComisi,
                                        DECODE(DC.CodConcepto, 'IVASIN', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIva,
                                        DECODE(DC.CodConcepto, 'RETIVA', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIvaRet, 
                                        DECODE(DC.CodConcepto, 'ISR',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsr, 
                                        DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsrRet
                                  FROM COMISIONES       C2, 
                                       DETALLE_COMISION DC                      
                                  WHERE C2.CODCIA     = vCia
                                  AND   C2.Cod_Agente = vAgente
                                  AND   C2.FEC_ESTADO BETWEEN TRUNC(vFecIni,'month') AND LAST_DAY(TRUNC(vFecFin,'month'))
                                  AND   DC.CODCIA     = C2.CODCIA
                                  AND   DC.IDCOMISION = C2.IDCOMISION
                                  GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                           GROUP BY CodCia, IdComision, Concepto) Y       
                   WHERE C.CodCia       = Y.CodCia
                     AND C.IdComision   = Y.IdComision
                     AND C.Cod_Agente   = vAgente
                     AND C.IdNcr       IS NULL
                     AND C.IdFactura   IS NULL
                     AND C.IdPoliza     = PO.IdPoliza
                     AND C.IdPoliza     = DP.IdPoliza
                     AND C.IdetPol      = DP.IdetPol
                     AND TRUNC(C.Fec_Generacion) <= LAST_DAY(TRUNC(vFecFin,'month'))
                     --
                     AND DP.CodCia      = PC.CodCia
                     AND DP.CodEmpresa  = PC.CodEmpresa
                     AND DP.IdTipoSeg   = PC.IdTipoSeg
                     --
                     AND NC.STSNCR      = 'PAG'
                     AND NC.IDNOMINA (+) = C.IDNOMINA 
                     AND NC.FECSTS BETWEEN trunc(vFecIni,'month') and last_day(trunc(vFecFin,'month'))                     
                   GROUP BY c.codcia, c.cod_agente, PC.CodTipoPlan, NC.FECSTS,  nc.idncr, Concepto,
                                    OC_VALORES_DE_LISTAS.BUSCA_LVALOR('IDCONCEP', DECODE(C.ORIGEN,'C','C','A','C',C.ORIGEN))
                     ) PEF
              GROUP BY  CIA, Agente,  TIPO_RAMO, FECHA_PAGO, Concepto, NOTA, DESCRIPCION ;     
              pp p%ROWTYPE;
              
         BEGIN
              OPEN p;
              LOOP 
                  FETCH p INTO pp;
                   EXIT WHEN p%NOTFOUND;
                        --DBMS_OUTPUT.PUT_LINE(pp.cia||' '||pp.Agente||' '||pp.TipRamo||' '||pp.FePago||' '||pp.Nota||' '||pp.Hoy||' '||pp.Descripcion||' '||pp.ImporteFinal||')');
                        BEGIN              
                              INSERT INTO saldos_comisiones_pagos (cd_cia, cd_agente      , cd_tipo_ramo   , fe_pago          , fe_proc_pago, 
                                                                   nm_pago, ds_pago       , mt_pago        , ds_concepto_pago)                            
                                                           VALUES (pp.cia , pp.Agente     , pp.TipRamo     , pp.FePago        , pp.Hoy      , 
                                                                   pp.Nota, pp.Descripcion, pp.ImporteFinal, pp.Concepto     );
                        EXCEPTION
                             WHEN dup_val_on_index THEN 
                                  null;
                             WHEN others THEN 
                                  NULL;
                        END;
               END LOOP;
               CLOSE p;
               
        EXCEPTION 
             WHEN no_data_found THEN 
                  null;
             WHEN others THEN 
                  DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END PagosPeriodo;
              
        FUNCTION DimePagos (vCia    IN saldos_comisiones_pagos.cd_cia%TYPE      ,
                            vAgente IN saldos_comisiones_pagos.cd_agente%TYPE   ,
                            vFecIni IN saldos_comisiones_pagos.fe_pago%TYPE     ,
                            vRamo   IN saldos_comisiones_pagos.cd_tipo_ramo%TYPE) RETURN NUMBER IS 
                 xPagos saldos_comisiones_pagos.mt_pago%TYPE;
        BEGIN 
              xPagos := 0;
              SELECT SUM(scp.mt_pago)  
                INTO xPagos
                FROM saldos_comisiones_pagos scp
               WHERE scp.cd_cia    = vCia
                 AND scp.cd_agente = vAgente
                 AND scp.fe_pago   = vFecIni
                 AND scp.cd_tipo_ramo = vRamo;
                 --AND fe_pago BETWEEN TRUNC(vFecIni,'month') AND LAST_DAY(TRUNC(vFecIni,'month'));
              RETURN xPagos;
        EXCEPTION 
             WHEN no_data_found THEN 
                  RETURN 0;
             WHEN others THEN 
                  RETURN 0;             
        END;
        --       MeteSaldo (DIARIO,z1.Cia, z1.CveAge, z1.TipRamo, vFecIni, vFecFin,z1.CveMon, vSaldoInicial,xPagos, pComis, pIVA,pIvaRet, 
        --                         pISR, pIsrRet, pSaldo, pEncOntra,pAFavor,  vSaldofinal);
        PROCEDURE MeteSaldo (vTipo         IN NUMBER                                          ,
                             vCia          IN Saldos_comisiones_diarios.Cd_Cia%TYPE           , 
                             vCveAge       IN Saldos_comisiones_diarios.Cd_Agente%TYPE        , 
                             vTipRamo      IN Saldos_comisiones_diarios.Cd_Tipo_Ramo%TYPE     , 
                             vFecOri       IN Saldos_comisiones_diarios.Fe_Saldo%TYPE         ,
                             vFecFin       IN Saldos_comisiones_diarios.Fe_Saldo%TYPE         ,       
                             vCveMon       IN Saldos_comisiones_diarios.Cd_Moneda%TYPE        , 
                             vSaldoInicial IN Saldos_comisiones_diarios.Mt_Saldo_Inicial%TYPE , 
                             vPagos        IN saldos_comisiones_pagos.mt_pago%TYPE            ,
                             vComis        IN Saldos_comisiones_diarios.Mt_Com_Tot%TYPE       , 
                             vIVA          IN Saldos_comisiones_diarios.Mt_Iva_Tot%TYPE       ,
                             vIvaRet       IN Saldos_comisiones_diarios.Mt_Ivaret_Tot%TYPE    , 
                             vISR          IN Saldos_comisiones_diarios.Mt_Isr_Tot%TYPE       , 
                             vIsrRet       IN Saldos_comisiones_diarios.Mt_Isrret_Tot%TYPE    , 
                             vSaldo        IN Saldos_comisiones_diarios.Mt_Subtotal_Tot%TYPE  , 
                             vEncOntra     IN Saldos_comisiones_diarios.Mt_Encontra_Tot%TYPE  ,
                             vAFavor       IN Saldos_comisiones_diarios.Mt_Afavor_Tot%TYPE    ,  
                             vSaldofinal   IN Saldos_comisiones_diarios.Mt_Saldo_Final%TYPE   ) IS 
            vObserva    saldos_comisiones.ds_observacion%TYPE;
            xSaldofinal Saldos_comisiones_diarios.Mt_Saldo_Final%TYPE;
        BEGIN 
              SELECT 'Saldar la cuenta: '||DECODE(vTipo,DIARIO,' diaria. ',' mensual. ') 
                INTO vObserva 
                FROM dual;

                xSaldoFinal := vSaldoInicial + vComis + vIVA+vIvaRet +vISR + vIsrRet - NVL(vPagos,0);

              IF vTipo = MENSUAL THEN 
                  INSERT INTO saldos_comisiones (cd_cia        , cd_agente         , cd_tipo_ramo    , fe_ini_saldo   , fe_fin_saldo   ,
                                                 fe_proc_saldo , cd_moneda         , mt_saldo_inicial, mt_com_tot     , mt_iva_tot     ,
                                                 mt_ivaret_tot , mt_isr_tot        , mt_isrret_tot   , mt_subtotal_tot, mt_encontra_tot,
                                                 mt_afavor_tot , mt_saldo_final    , ds_observacion)
                                         VALUES (vCia          , vCveAge           , vTipRamo        , vFecOri         , vFecFin         ,
                                                 TRUNC(sysdate), vCveMon           , vSaldoInicial   , NVL(vComis,0)   , NVL(vIVA,0)     ,
                                                 NVL(vIvaRet,0), NVL(vISR,0)       , NVL(vIsrRet,0)  , NVL(vSaldo,0)   , NVL(vEncOntra,0),
                                                 NVL(vAFavor,0), NVL(xSaldofinal,0), vObserva );

              ELSE
                  INSERT INTO Saldos_comisiones_diarios (cd_cia        , cd_agente         , cd_tipo_ramo    , fe_saldo   , 
                                                         fe_proc_saldo , cd_moneda         , mt_saldo_inicial, mt_com_tot     , mt_iva_tot     ,
                                                         mt_ivaret_tot , mt_isr_tot        , mt_isrret_tot   , mt_subtotal_tot, mt_encontra_tot,
                                                         mt_afavor_tot , mt_saldo_final    , ds_observacion)
                                                 VALUES (vCia          , vCveAge           , vTipRamo        , vFecFin         ,
                                                         TRUNC(sysdate), vCveMon           , vSaldoInicial   , NVL(vComis,0)   , NVL(vIVA,0)     ,
                                                         NVL(vIvaRet,0), NVL(vISR,0)       , NVL(vIsrRet,0)  , NVL(vSaldo,0)   , NVL(vEncOntra,0),
                                                         NVL(vAFavor,0), NVL(xSaldofinal,0), vObserva );
              END IF;
              IF SQLCODE <> 0 THEN 
                 DBMS_OUTPUT.PUT_LINE('Tengo problemas insertando el registro: ('||vCia||' - '|| vCveAge||') ('|| SQLERRM||')');
              END IF;              
              
        EXCEPTION 
             WHEN others THEN 
                  IF vTipo = MENSUAL THEN 
                          UPDATE saldos_comisiones
                             SET fe_ini_saldo     = vFecOri          , 
                                 fe_fin_saldo     = vFecFin          ,
                                 fe_proc_saldo    = TRUNC(SYSDATE)   , 
                                 cd_moneda        = vCveMon          , 
                                 mt_saldo_inicial = vSaldoInicial    , 
                                 mt_com_tot       = NVL(vComis,0)    , 
                                 mt_iva_tot       = NVL(vIVA,0)      ,
                                 mt_ivaret_tot    = NVL(vIvaRet,0)   , 
                                 mt_isr_tot       = NVL(vISR,0)      ,   
                                 mt_isrret_tot    = NVL(vIsrRet,0)   , 
                                 mt_subtotal_tot  = NVL(vSaldo,0)    , 
                                 mt_encontra_tot  = NVL(vEncOntra,0) , 
                                 mt_afavor_tot    = NVL(vAFavor,0)   ,
                                 mt_saldo_final   = xSaldofinal      , 
                                 ds_observacion   = vObserva
                           WHERE cd_cia           = vCia 
                             AND cd_agente        = vCveAge
                             AND cd_tipo_ramo     = vTipRamo 
                             AND fe_ini_saldo     = vFecOri;
                 ELSE
                          UPDATE Saldos_comisiones_diarios
                             SET fe_saldo         = vFecFin          ,
                                 fe_proc_saldo    = TRUNC(SYSDATE)   , 
                                 cd_moneda        = vCveMon          , 
                                 mt_saldo_inicial = vSaldoInicial    , 
                                 mt_com_tot       = NVL(vComis,0)   , 
                                 mt_iva_tot       = NVL(vIVA,0)     ,
                                 mt_ivaret_tot    = NVL(vIvaRet,0)  , 
                                 mt_isr_tot       = NVL(vISR,0)     ,   
                                 mt_isrret_tot    = NVL(vIsrRet,0)  , 
                                 mt_subtotal_tot  = NVL(vSaldo,0)   , 
                                 mt_encontra_tot  = NVL(vEncOntra,0), 
                                 mt_afavor_tot    = NVL(vAFavor,0)  ,
                                 mt_saldo_final   = xSaldofinal     , 
                                 ds_observacion   = vObserva
                           WHERE cd_cia           = vCia 
                             AND cd_agente        = vCveAge
                             AND cd_tipo_ramo     = vTipRamo
                             AND fe_saldo         = vFecFin          ;                 
                 END IF;
        END MeteSaldo;


        FUNCTION DimeSaldoAnterior (vCia       IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                                    vAgente    IN saldos_comisiones_detalle.cd_agente%TYPE,
                                    vFecFinDSA IN saldos_comisiones.fe_fin_saldo%TYPE     ,
                                    vRamo      IN saldos_comisiones.cd_tipo_ramo%TYPE     ) RETURN NUMBER IS 
                 vSaldoAnt saldos_comisiones_diarios.mt_saldo_final%TYPE;
                 vFechaBusca DATE;                 
        BEGIN
              vSaldoAnt   := 0;
              vFechaBusca := vFecfinDSA-1;              
              SELECT NVL(b.mt_saldo_final,0) SdoInicial
                INTO vSaldoAnt
                FROM saldos_comisiones_diarios b
               WHERE b.cd_cia       = vCia
                 AND b.cd_agente    = vAgente 
                 AND b.cd_tipo_ramo = vRamo         
                 AND b.fe_saldo     = vfechaBusca; /*(SELECT MAX(b1.fe_saldo)  
                                                        FROM saldos_comisiones_diarios b1
                                                       WHERE b1.cd_cia       = B.cd_cia
                                                         AND b1.cd_agente    = B.cd_agente                 
                                                         AND b1.cd_tipo_ramo = B.cd_tipo_ramo 
                                                         AND b1.fe_saldo = vFecfin-1);*/
                  RETURN vSaldoAnt;
        EXCEPTION 
             WHEN no_data_found THEN 
                  RETURN 0;
             WHEN others THEN 
                  RETURN 0;                  
        END DimeSaldoAnterior;

        PROCEDURE MeteDiario (vCia      IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                              vAgente   IN saldos_comisiones_detalle.cd_agente%TYPE,
                              vFecIniMD IN saldos_comisiones.fe_ini_saldo%TYPE     ,
                              vFecFinMD IN saldos_comisiones.fe_fin_saldo%TYPE     ,
                              vRamoMD   IN saldos_comisiones.cd_tipo_ramo%TYPE     ) IS 
                  vSaldoIniMes saldos_comisiones_diarios.mt_saldo_inicial%TYPE; 
                  vSaldoFinMes saldos_comisiones_diarios.mt_saldo_inicial%TYPE;                  
        BEGIN
                  vSaldoIniMes := 0;
                  vSaldoFinMes := vSaldoIniMes;          
                  vSaldoIniMes := DimeSaldoAnterior (vCia,vAgente ,vFecFinMD,vRamoMD);
                  vSaldoFinMes := vSaldoIniMes;          
        
                  INSERT INTO saldos_comisiones_diarios
                         (cd_cia          , cd_agente      , cd_tipo_ramo , fe_saldo      , fe_proc_saldo , cd_moneda    ,
                          mt_saldo_inicial, mt_com_tot     , mt_iva_tot   , mt_ivaret_tot , mt_isr_tot    , mt_isrret_tot,
                          mt_subtotal_tot , mt_encontra_tot, mt_afavor_tot, mt_saldo_final, ds_observacion)
                  VALUES (vCiA, vAgente, vRamoMD, vFecIniMD, vFecFinMD, 'PS',vSaldoIniMes,0,0,0,0,0,0,0,0,vSaldoFinMes,'Saldo incial Diario'  );
        --
        EXCEPTION 
             WHEN dup_val_on_index THEN 
                  UPDATE saldos_comisiones_diarios
                     SET fe_saldo     = vFecfinMD
                   WHERE cd_cia       = vCia  
                     AND cd_agente    = vAgente 
                     AND cd_tipo_ramo = vRamoMD  
                     AND fe_saldo     = vFecIniMD;
        END; 

        PROCEDURE MeteMes(vCia     IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                          vAgente  IN saldos_comisiones_detalle.cd_agente%TYPE,
                          vFecIniM IN saldos_comisiones.fe_ini_saldo%TYPE     ,
                          vFecFinM IN saldos_comisiones.fe_fin_saldo%TYPE     ,
                          vRamoM    IN saldos_comisiones.cd_tipo_ramo%TYPE     ) IS
                  vSaldoIniMes saldos_comisiones_diarios.mt_saldo_inicial%TYPE; 
                  vSaldoFinMes saldos_comisiones_diarios.mt_saldo_inicial%TYPE;                          
        BEGIN
                  vSaldoIniMes := 0;
                  vSaldoFinMes := vSaldoIniMes;                       
                  vSaldoIniMes := DimeSaldoAnterior (vCia, vAgente ,vFecFinM, vRamoM);
                  vSaldoFinMes := vSaldoIniMes;     
                  INSERT INTO saldos_comisiones 
                         (cd_cia        , cd_agente     , cd_tipo_ramo , fe_ini_saldo, fe_fin_saldo , fe_proc_saldo  , cd_moneda      , mt_saldo_inicial,
                          mt_com_tot    , mt_iva_tot    , mt_ivaret_tot, mt_isr_tot  , mt_isrret_tot, mt_subtotal_tot, mt_encontra_tot, mt_afavor_tot   ,
                          mt_saldo_final, ds_observacion)
                  VALUES (vCiA, vAgente, vRamoM, vFecIniM, vFecFinM, vFecFinM, 'PS',vSaldoIniMes,0,0,0,0,0,0,0,0,vSaldoFinMes,'Saldo incial Mensual'  );
        --
        EXCEPTION 
             WHEN dup_val_on_index THEN 
                  UPDATE saldos_comisiones
                     SET fe_fin_saldo = vFecfinM
                   WHERE cd_cia       = vCia  
                     AND cd_agente    = vAgente 
                     AND cd_tipo_ramo = vRamoM 
                     AND fe_ini_saldo = vFecIniM;
        END;

      PROCEDURE CreaSaldosIniciales (vCia       IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                                     vAgente    IN saldos_comisiones_detalle.cd_agente%TYPE,
                                     vFecIniCSI IN saldos_comisiones.fe_ini_saldo%TYPE     ,
                                     vFecFinCSI IN saldos_comisiones.fe_fin_saldo%TYPE     ) IS 
      BEGIN 
        MeteDiario(vCia, vAgente, vFecIniCSI, vFecFinCSI, '010'); 
        MeteDiario(vCia, vAgente, vFecIniCSI, vFecFinCSI, '030');        
        MeteMes   (vCia, vAgente, vFecIniCSI, vFecFinCSI, '010'); 
        MeteMes   (vCia, vAgente, vFecIniCSI, vFecFinCSI, '030');        
        COMMIT;
     END CreaSaldosIniciales;

         FUNCTION cuenta_movs_com (vCia    IN comisiones.codcia%TYPE    ,
                                   vAgente IN comisiones.cod_agente%TYPE,
                                   vFecIni IN facturas.Fecsts%TYPE      ,
                                   vFecFin IN facturas.Fecsts%TYPE      ) RETURN NUMBER IS 
               mov_de_comis NUMBER(10) := 0;
         BEGIN 
              SELECT MAX(HayMovis) 
                INTO mov_de_comis
                FROM (
                  SELECT count(*) HayMovis
                    FROM comisiones c, facturas f, 
                        (SELECT CodCia, IdComision,  
                                SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, 
                                SUM(MtoIsrRet) MtoIsrRet, 
                                SUM(MtoComisi) + SUM(MtoIva) + 
                                SUM(MtoIvaRet) + SUM(MtoIsr) + 
                                SUM(MtoIsrRet) SubTotal
                           FROM (SELECT CodCia, IdComision, 
                                        DECODE(CodConcepto, 'COMISI', SUM(Monto_mon_local),0) +
                                        DECODE(CodConcepto, 'HONORA', SUM(Monto_mon_local),0) +
                                        DECODE(CodConcepto, 'UDI',    SUM(Monto_mon_local),0) MtoComisi,
                                        DECODE(CodConcepto, 'IVASIN', SUM(Monto_mon_local),0) MtoIva,
                                        DECODE(CodConcepto, 'RETIVA', SUM(Monto_mon_local),0) MtoIvaRet, 
                                        DECODE(CodConcepto, 'ISR',    SUM(Monto_mon_local),0) MtoIsr, 
                                        DECODE(CodConcepto, 'RETISR', SUM(Monto_mon_local),0) MtoIsrRet
                                   FROM DETALLE_COMISION
                                  GROUP BY CodCia, IdComision, CodConcepto) 
                          GROUP BY CodCia, IdComision) y
                   WHERE C.Estado            = 'REC'
                     AND c.Codcia            = vCia
                     AND C.Cod_Agente        = vAgente --&P_AGENTE
                     AND C.IdFactura         = F.IdFactura
                     AND F.StsFact          != 'ANU'
                     AND C.CodCia            = Y.CodCia
                     AND C.IdComision        = Y.IdComision
                     AND f.Fecsts BETWEEN vFecIni AND vFecFin
                                         --to_date('&P_FECDESDE','dd/mm/yyyy') AND to_date('&P_FECHASTA','dd/mm/yyyy')
                     AND c.comision_local <> 0                                         
                  --------------------------- detalle negativos ----------------------------
             UNION ALL -- Negativos
                  SELECT COUNT(*)
                    FROM comisiones c, notas_de_credito n, 
                        (SELECT CodCia, IdComision,
                                SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, 
                                SUM(MtoIsrRet) MtoIsrRet, 
                                SUM(MtoComisi) + SUM(MtoIva) + 
                                SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
                           FROM (SELECT CodCia, IdComision,
                                        DECODE(CodConcepto, 'COMISI', SUM(Monto_mon_local),0) +
                                        DECODE(CodConcepto, 'HONORA', SUM(Monto_mon_local),0) +
                                        DECODE(CodConcepto, 'UDI',    SUM(Monto_mon_local),0) MtoComisi,
                                        DECODE(CodConcepto, 'IVASIN', SUM(Monto_mon_local), 0) MtoIva,
                                        DECODE(CodConcepto, 'RETIVA', SUM(Monto_mon_local), 0) MtoIvaRet, 
                                        DECODE(CodConcepto, 'ISR',    SUM(Monto_mon_local), 0) MtoIsr, 
                                        DECODE(CodConcepto, 'RETISR', SUM(Monto_mon_local), 0) MtoIsrRet
                                   FROM DETALLE_COMISION
                                  GROUP BY CodCia, IdComision, CodConcepto) 
                          GROUP BY CodCia, IdComision) Y
                   WHERE --C.Estado             = 'REC' AND 
                         c.Codcia             = vCia
                     AND C.Cod_Agente         = vAgente 
                     AND C.IdNcr              = N.IdNcr
                     AND N.StsNcr            != 'ANU'
                     AND C.CodCia             = Y.CodCia
                     AND C.IdComision         = Y.IdComision
                     AND c.comision_local <> 0
                     AND ((N.Fecsts BETWEEN vFecIni AND vFecFin) OR
                                            --to_date('&P_FECDESDE','dd/mm/yyyy') AND to_date('&P_FECHASTA','dd/mm/yyyy')) OR 
                          (TRUNC(c.fec_liquidacion) BETWEEN vFecini AND vFecFin)) -- Corrección para igualar los Saldos con el programa de forms (repocomi.fmb ) 03/09/2016
                                            --To_date('&P_FECDESDE','dd/mm/yyyy') AND to_date('&P_FECHASTA','dd/mm/yyyy')))
                     --------------------------- Bonos, ajustes HON, COM, Prestamos, etc.
             UNION  -- Ajustes, movimientos que no estan ligados a ninguna factura.
                    SELECT COUNT(*) 
                      FROM comisiones               c , 
                           agentes                  a ,
                           notas_de_credito         nc,
                           (SELECT CodCia, IdComision , 
                                  SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                  SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
                                  SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) ImporteFinal
                             FROM (SELECT dc.CodCia, 
                                          DC.IdComision,
                                          DECODE(DC.CodConcepto, 'COMISI', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                          DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                          DECODE(DC.CodConcepto, 'AJUCOM', SUM(NVL(DC.Monto_mon_local,0)),0) +                                  
                                          DECODE(DC.CodConcepto, 'AJUHON', SUM(NVL(DC.Monto_mon_local,0)),0) +                                  
                                          DECODE(DC.CodConcepto, 'UDI',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoComisi,
                                          DECODE(DC.CodConcepto, 'IVASIN', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIva,
                                          DECODE(DC.CodConcepto, 'RETIVA', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIvaRet, 
                                          DECODE(DC.CodConcepto, 'ISR',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsr, 
                                          DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsrRet
                                     FROM comisiones       c2, 
                                          detalle_comision dc                      
                                     WHERE c2.codcia       = vCia
                                     AND   c2.cod_agente   = vAgente
                                     AND   dc.codcia     = c2.codcia
                                     AND   dc.idcomision = c2.idcomision
                                    GROUP BY  dc.codcia, dc.idcomision, dc.codconcepto  ) 
                            GROUP BY CodCia, IdComision) Y        
                     WHERE c.codcia       = vCia
                       AND C.Cod_Agente   = vAgente
                       AND C.Cod_Agente   = A.Cod_Agente               
                       AND (C.IdNcr       IS NULL OR C.IdFactura   IS NULL )
                       AND c.idcomision   = y.idcomision
                       AND (C.ESTADO = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN --to_date('&p_fecdesde','dd/mm/yyyy') 
                                                                                  --AND to_date('&p_fechasta','dd/mm/yyyy'))
                                                                                  vFecIni AND vFecFin)                   
                       AND NC.STSNCR      = 'PAG'
                       AND NC.IDNOMINA    = C.IDNOMINA 
                       --AND NC.FECSTS  BETWEEN vFecIni AND vFecFin
                       AND Y.MtoComisi > 0
                 union 
                    SELECT COUNT(*) 
                      FROM comisiones               c , 
                           agentes                  a ,
                           facturas                 f , 
                           notas_de_credito         nc,
                           ncr_factext              xt,
                           agentes_distribucion_comision adc,
                           (SELECT CodCia, IdComision , 
                                  SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                  SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
                                  SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) ImporteFinal
                             FROM (SELECT dc.CodCia, 
                                          DC.IdComision,
                                          DECODE(DC.CodConcepto, 'COMISI', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                          DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_local,0)),0) +
                                          DECODE(DC.CodConcepto, 'AJUCOM', SUM(NVL(DC.Monto_mon_local,0)),0) +                                  
                                          DECODE(DC.CodConcepto, 'AJUHON', SUM(NVL(DC.Monto_mon_local,0)),0) +                                  
                                          DECODE(DC.CodConcepto, 'UDI',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoComisi,
                                          DECODE(DC.CodConcepto, 'IVASIN', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIva,
                                          DECODE(DC.CodConcepto, 'RETIVA', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIvaRet, 
                                          DECODE(DC.CodConcepto, 'ISR',    SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsr, 
                                          DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_local,0)),0) MtoIsrRet
                                     FROM comisiones       c2, 
                                          detalle_comision dc                      
                                     WHERE c2.codcia       = vCia
                                     AND   c2.cod_agente   = vAgente
                                     AND   dc.codcia     = c2.codcia
                                     AND   dc.idcomision = c2.idcomision
                                    GROUP BY  dc.codcia, dc.idcomision, dc.codconcepto  ) 
                            GROUP BY CodCia, IdComision) Y                 
                       WHERE c.codcia       = vCia 
                         AND C.Cod_Agente   = vAgente
                         AND C.IdFactura    = F.IdFactura
                         AND (F.StsFact     != 'ANU' and C.Estado !='PRY')
                         AND C.CodCia       = Y.CodCia
                         AND C.IdComision   = Y.IdComision
                         AND C.Comision_Local  != 0
                         AND (CASE 
                                  WHEN f.stsfact  = 'PAG' AND  f.Fecsts <= vFecFin AND 
                                       TRUNC(C.FEC_LIQUIDACION) > vFecFin THEN  f.Fecsts
                         END ) BETWEEN vFecIni AND vFecFin --TO_DATE('&P_FECDESDE','DD/MM/YYYY') AND TO_DATE('&P_FECHASTA','DD/MM/YYYY')
                         AND C.Cod_Agente         = A.Cod_Agente
                         AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
                         --
                         AND NC.IDNOMINA(+)   = C.IDNOMINA 
                         AND nc.fecsts        >= vFecFin
                         AND XT.IDNCR(+)      = NC.IDNCR); -- 
                                    
               --DBMS_OUTPUT.PUT_LINE('Agente number: '||vAgente||' tiene: '||mov_de_comis||' movimientos a procesar.');
               RETURN mov_de_comis;
               
         EXCEPTION 
              WHEN no_data_found THEN 
                   --DBMS_OUTPUT.PUT_LINE('Agente number: '||vAgente||' NO tiene movimientos a procesar.');
                   RETURN 0;
              WHEN OTHERS THEN 
                   --DBMS_OUTPUT.PUT_LINE('Agente number: '||vAgente||' Tiene errores: '||SQLERRM);             
                   RETURN 0;
         END cuenta_movs_com;
  
    PROCEDURE mete_detalle (pCd_Cia       IN saldos_comisiones_detalle.cd_cia%TYPE       , pCd_agente      IN saldos_comisiones_detalle.cd_agente%TYPE       , 
                  pTipo_ramo    IN saldos_comisiones_detalle.cd_tipo_ramo%TYPE , pFeIniSaldo     IN saldos_comisiones_detalle.fe_ini_saldo%TYPE    , 
                  pFeFinSaldo   IN saldos_comisiones_detalle.fe_fin_saldo%TYPE , pFeProcesoSaldo IN saldos_comisiones_detalle.fe_proceso_saldo%TYPE, 
                  pFeGeneracion IN saldos_comisiones_detalle.fe_generacion%TYPE, pCdNivel        IN saldos_comisiones_detalle.cd_nivel%TYPE        , 
                  pIdPoliza     IN saldos_comisiones_detalle.id_poliza%TYPE    , pIdEndoso       IN saldos_comisiones_detalle.id_endoso%TYPE       , 
                  pIdRecibo     IN saldos_comisiones_detalle.id_recibo%TYPE    , pCdMoneda       IN saldos_comisiones_detalle.cd_moneda%TYPE       , 
                  pMtPmaCom     IN saldos_comisiones_detalle.mt_prima_com%TYPE , pMtComision     IN saldos_comisiones_detalle.mt_comision%TYPE     , 
                  pMtIva        IN saldos_comisiones_detalle.mt_iva%TYPE       , pMtIvaRret      IN saldos_comisiones_detalle.mt_ivaret%TYPE       ,
                  pMtIsr        IN saldos_comisiones_detalle.mt_isr%TYPE       , pMtIsrRet       IN saldos_comisiones_detalle.mt_isrret%TYPE       , 
                  pMtSubTotal   IN saldos_comisiones_detalle.mt_subtotal%TYPE  , pMtEnContra     IN saldos_comisiones_detalle.mt_encontra%TYPE     , 
                  pMtAFavor     IN saldos_comisiones_detalle.mt_afavor%TYPE    , pIdComision     IN saldos_comisiones_detalle.id_comision%TYPE     , 
                  pStComision   IN saldos_comisiones_detalle.st_comision%TYPE  , pPoComDist      IN saldos_comisiones_detalle.po_com_dist%TYPE     ,
                  pPoComProp    IN saldos_comisiones_detalle.po_com_prop%TYPE  , pMtPma          IN saldos_comisiones_detalle.mt_pma%TYPE          , 
                  pMtPmaFactura IN saldos_comisiones_detalle.mt_pmafactura%TYPE, pFePago         IN saldos_comisiones_detalle.fe_pago%TYPE         ) IS
      BEGIN 
            INSERT INTO saldos_comisiones_detalle (
                  cd_cia        , cd_agente      , cd_tipo_ramo, fe_ini_saldo, fe_fin_saldo, fe_proceso_saldo, fe_generacion, cd_nivel   , 
                  id_poliza     , id_endoso      , id_recibo   , cd_moneda   , mt_prima_com, mt_comision     , mt_iva       , mt_ivaret  ,
                  mt_isr        , mt_isrret      , mt_subtotal , mt_encontra , mt_afavor   , id_comision     , st_comision  , po_com_dist  , po_com_prop,
                  mt_pma        , mt_pmafactura  , fe_pago)
                VALUES ( 
                  pCd_Cia       , pCd_agente      , pTipo_ramo , pFeIniSaldo , pFeFinSaldo , pFeProcesoSaldo , pFeGeneracion , pCdNivel   , 
                  pIdPoliza     , pIdEndoso       , pIdRecibo  , pCdMoneda   , pMtPmaCom   , pMtComision     , pMtIva        , pMtIvaRret ,
                  pMtIsr        , pMtIsrRet       , pMtSubTotal, pMtEnContra , pMtAFavor   , pIdComision     , pStComision   , pPoComDist , pPoComProp ,
                  pMtPma        , pMtPmaFactura   , pFePago);
            COMMIT;
      EXCEPTION
           WHEN dup_val_on_index THEN 
                UPDATE saldos_comisiones_detalle
                   SET fe_proceso_saldo  = pFeProcesoSaldo,
                       fe_generacion     = pFeGeneracion  , 
                       mt_prima_com      = pMtPmaCom      , 
                       mt_comision       = pMtComision    ,
                       mt_iva            = pMtIva         , 
                       mt_ivaret         = pMtIvaRret     ,
                       mt_isr            = pMtIsr         , 
                       mt_isrret         = pMtIsrRet      ,
                       mt_subtotal       = pMtSubTotal    , 
                       mt_encontra       = pMtEnContra    , 
                       mt_afavor         = pMtAFavor      , 
                       st_comision       = pStComision    , 
                       mt_pma            = pMtPma         , 
                       mt_pmafactura     = pMtPmaFactura  ,
                       fe_pago           = pFePago
                  WHERE cd_cia           = pCd_Cia      
                    AND cd_agente        = pCd_agente  
                    AND cd_tipo_ramo     = pTipo_ramo   
                    AND id_poliza        = pIdPoliza    
                    AND id_endoso        = pIdEndoso   
                    AND id_recibo        = pIdRecibo    
                    AND id_comision      = pIdComision;				   
               COMMIT;                    
      END mete_detalle;


    PROCEDURE MeteFaltantes( vCia        IN saldos_comisiones_detalle.cd_cia%TYPE       , 
                             vAgente     IN saldos_comisiones_detalle.cd_agente%TYPE    , 
                             vFediaFalta IN saldos_comisiones_detalle.fe_ini_saldo%TYPE ) IS -- Cambios de agente en polizas y las comisiones quedan 
                                                                                             -- ligadas al agente anetrior) 
        CURSOR x IS
        SELECT c.codcia                   codCia     ,
               C.Cod_Agente               Agente     , 
               A.CodNivel                 CodNivel   ,
               F.Fecsts                   Fe_Movim   , 
               f.idpoliza                 IdPoliza   , 
               F.IdEndoso                 IdEndoso   , 
               PC.CodTipoPlan             CodTipoPlan,
               TRIM(TO_CHAR(F.IdFactura)) Recibo     , 
               f.cod_moneda               cd_mon     , 
               f.Monto_Fact_Local         PmaCom     ,
               C.Comision_Local           MtCom      , 
               y.MtoIva                              , 
               y.MtoIvaRet                           ,
               y.MtoIsr                              , 
               y.MtoIsrRet                           , 
               y.SubTotal                            , 
               DECODE(SIGN(y.SubTotal), -1, y.SubTotal, 0) En_contra, 
               DECODE(SIGN(y.SubTotal), -1, 0, y.SubTotal) A_Favor, 
               C.IdComision               IdComision ,
               C.Estado                   EstadoCom  ,
               0.0                        Porc_Com_Distribuida              , 
               0.0                        Porc_Com_Proporcional             , 
               PO.PrimaNeta_Local         Prima_Net  ,
               (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
                  FROM detalle_facturas d, 
                       catalogo_de_conceptos cc
                 WHERE cc.codconcepto      = d.codcpto
                   AND cc.codcia           = f.codcia
                   AND (D.IndCptoPrima    = 'S'
                    OR cc.IndCptoServicio  = 'S')
                   AND D.IdFactura        = F.IdFactura) MtoPrimaFactura,
               NULL                             fecha_pago
          FROM comisiones c , facturas       f , agentes a,
               polizas    po, detalle_poliza dp,
               tipos_de_seguros pc, 
              (SELECT CodCia, IdComision,  
                      SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                      SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, 
                      SUM(MtoIsrRet) MtoIsrRet, 
                      SUM(MtoComisi) + SUM(MtoIva) + 
                      SUM(MtoIvaRet) + SUM(MtoIsr) + 
                      SUM(MtoIsrRet) SubTotal
                 FROM (SELECT CodCia, IdComision, 
                              DECODE(CodConcepto, 'COMISI', SUM(Monto_mon_local),0) +
                              DECODE(CodConcepto, 'HONORA', SUM(Monto_mon_local),0) +
                              DECODE(CodConcepto, 'UDI',    SUM(Monto_mon_local),0) MtoComisi,
                              DECODE(CodConcepto, 'IVASIN', SUM(Monto_mon_local),0) MtoIva,
                              DECODE(CodConcepto, 'RETIVA', SUM(Monto_mon_local),0) MtoIvaRet, 
                              DECODE(CodConcepto, 'ISR',    SUM(Monto_mon_local),0) MtoIsr, 
                              DECODE(CodConcepto, 'RETISR', SUM(Monto_mon_local),0) MtoIsrRet
                         FROM detalle_comision
                        GROUP BY CodCia, IdComision, CodConcepto)
                GROUP BY CodCia, IdComision) y
         WHERE c.idcomision in ( SELECT idcomision
                                   FROM comisiones 
                                  WHERE estado = 'REC'
                                    AND fec_estado BETWEEN TRUNC(vFediaFalta,'MONTH')
                                                      and vFediaFalta
                                    AND COD_AGENTE = vAgente --IN ( 34) --, 17,31,47,54,122,355,538,1018)--= &agente
                      --                (49,50,68,70,73,76,80,105,113,197,207,233,234,258,280,325,326,338,408,432,471,492,502,511,548,570,601,604,610,642,1007,1016,1018,1019)
                               MINUS
                                 SELECT id_comision
                                   FROM saldos_comisiones_detalle
                                  WHERE st_comision = 'REC'
                                    AND CD_AGENTE = vAgente --in --( 34 )--17,31,47,54,122,355,538,1018)--= &agente       
                      --                 (49,50,68,70,73,76,80,105,113,197,207,233,234,258,280,325,326,338,408,432,471,492,502,511,548,570,601,604,610,642,1007,1016,1018,1019)
                                  )  
           AND C.Cod_Agente         = A.Cod_Agente
           AND f.idfactura         = c.idfactura
           AND F.IdPoliza          = DP.IdPoliza
           AND PO.IDPOLIZA         = f.idpoliza
           AND DP.IDPOLIZA         = PO.IDPOLIZA
           AND F.IdetPol           = DP.IdetPol
           AND DP.CodCia           = PC.CodCia
           AND DP.CodEmpresa       = PC.CodEmpresa
           AND DP.IdTipoSeg        = PC.IdTipoSeg
           AND C.CodCia            = Y.CodCia
           AND C.IdComision        = Y.IdComision
           AND C.Comision_Local     <>0             ;
                     
          yCurDet x%ROWTYPE;
          z NUMBER(6);

        BEGIN 
            OPEN x;
            LOOP
               FETCH x INTO yCurDet;
                EXIT WHEN x%NOTFOUND;
                    --DBMS_OUTPUT.PUT_LINE(yCurDet.IdComision||' '||yCurDet.Agente     ||', '|| yCurDet.Fe_Movim  ||' , '||yCurDet.IdPoliza   ||', '||yCurDet.Recibo     ||', '||yCurDet.MtCom      ||', ');
                    mete_detalle(yCurDet.codcia              , yCurDet.Agente               , yCurDet.CodTipoPlan     , yCurDet.Fe_Movim        , yCurDet.Fe_Movim       , trunc(sysdate), 
                                 yCurDet.Fe_Movim            , yCurDet.CodNivel             , yCurDet.IdPoliza        , NVL(yCurDet.IdEndoso,0) , 
                                 yCurDet.Recibo              , yCurDet.cd_mon               , NVL(yCurDet.PmaCom,0)   , NVL(yCurDet.MtCom,0)    , 
                                 NVL(yCurDet.MtoIva,0)       , NVL(yCurDet.MtoIvaRet,0)     , NVL(yCurDet.MtoIsr,0)   , NVL(yCurDet.MtoIsrRet,0),  
                                 NVL(yCurDet.SubTotal,0)     , NVL(yCurDet.En_contra,0)     , NVL(yCurDet.A_Favor,0)  , yCurDet.IdComision      , yCurDet.EstadoCom,      
                                 yCurDet.Porc_Com_Distribuida, yCurDet.Porc_Com_Proporcional, NVL(yCurDet.Prima_Net,0), NVL(yCurDet.MtoPrimaFactura,0),
                                 yCurDet.fecha_pago);            
            END LOOP;
            CLOSE x;
        END;    

        PROCEDURE DetalleComisiones(vCia    IN comisiones.codcia%TYPE    ,
                                    vAgente IN comisiones.cod_agente%TYPE, 
                                    vFecIni IN DATE                      , 
                                    vFecFin IN DATE                      ) IS 
         
                  CURSOR xCurDet IS                   
                  SELECT C.Cod_Agente               , 
                         A.CodNivel                 CodNivel   ,
                         F.Fecsts                   Fe_Movim   , 
                         PO.IdPoliza                IdPoliza   , 
                         F.IdEndoso                 IdEndoso   , 
                         PC.CodTipoPlan             CodTipoPlan,
                         TRIM(TO_CHAR(F.IdFactura)) Recibo     , 
                         f.cod_moneda               cd_mon     , 
                         f.Monto_Fact_Local         PmaCom     ,
                         C.Comision_Local           MtCom      , 
--                         DECODE(C.Estado, 'REC', SubTotal,C.Comision_Local)    MtCom      , -- Esto es incorrecto...
                         y.MtoIva                              , 
                         y.MtoIvaRet                           ,
                         y.MtoIsr                              , 
                         y.MtoIsrRet                           , 
                         y.SubTotal                            , 
                         DECODE(SIGN(y.SubTotal), -1, y.SubTotal, 0) En_contra, 
                         DECODE(SIGN(y.SubTotal), -1, 0, y.SubTotal) A_Favor, 
                         C.IdComision               IdComision ,
                         C.Estado                   EstadoCom  ,
                         adc.Porc_Com_Distribuida              , 
                         adc.Porc_Com_Proporcional             , 
                         PO.PrimaNeta_Local         Prima_Net  ,
                         (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
                            FROM detalle_facturas d, 
                                 catalogo_de_conceptos c
                           WHERE c.codconcepto      = d.codcpto
                             AND c.codcia           = f.codcia
                             AND (D.IndCptoPrima    = 'S'
                              OR C.IndCptoServicio  = 'S')
                             AND D.IdFactura        = F.IdFactura) MtoPrimaFactura,
                         NULL                             fecha_pago
                    FROM comisiones       c , facturas                      f  , polizas po, detalle_poliza dp, 
                         tipos_de_seguros pc, agentes_distribucion_comision adc,
                        (SELECT CodCia, IdComision,  
                                SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, 
                                SUM(MtoIsrRet) MtoIsrRet, 
                                SUM(MtoComisi) + SUM(MtoIva) + 
                                SUM(MtoIvaRet) + SUM(MtoIsr) + 
                                SUM(MtoIsrRet) SubTotal
                           FROM (SELECT CodCia, IdComision, 
                                        DECODE(CodConcepto, 'COMISI', SUM(Monto_mon_local),0) +
                                        DECODE(CodConcepto, 'HONORA', SUM(Monto_mon_local),0) +
                                        DECODE(CodConcepto, 'AJUCOM', SUM(NVL(Monto_mon_local,0)), 0) +                                  
                                        DECODE(CodConcepto, 'AJUHON', SUM(NVL(Monto_mon_local,0)), 0) +                                        
                                        DECODE(CodConcepto, 'UDI',    SUM(Monto_mon_local),0) MtoComisi,
                                        DECODE(CodConcepto, 'IVASIN', SUM(Monto_mon_local),0) MtoIva,
                                        DECODE(CodConcepto, 'RETIVA', SUM(Monto_mon_local),0) MtoIvaRet, 
                                        DECODE(CodConcepto, 'ISR',    SUM(Monto_mon_local),0) MtoIsr, 
                                        DECODE(CodConcepto, 'RETISR', SUM(Monto_mon_local),0) MtoIsrRet
                                   FROM DETALLE_COMISION
                                  GROUP BY CodCia, IdComision, CodConcepto) 
                          GROUP BY CodCia, IdComision) y, 
                         agentes a, agentes_cedula_autorizada ac
                   WHERE C.Estado            = 'REC'
                     AND c.Codcia            = vCia
                     AND C.Cod_Agente        = vAgente --&P_AGENTE
                     AND C.IdFactura         = F.IdFactura
                     AND F.StsFact          != 'ANU'
                     AND F.IdPoliza          = PO.IdPoliza
                     AND F.IdPoliza          = DP.IdPoliza
                     AND F.IdetPol           = DP.IdetPol
                     AND DP.CodCia           = PC.CodCia
                     AND DP.CodEmpresa       = PC.CodEmpresa
                     AND DP.IdTipoSeg        = PC.IdTipoSeg
                     AND C.CodCia            = Y.CodCia
                     AND C.IdComision        = Y.IdComision
                     AND C.Comision_Local     <>0                       
                     AND f.Fecsts BETWEEN vFecIni AND vFecFin --
                                          --to_date('&P_FECDESDE','dd/mm/yyyy') AND to_date('&P_FECHASTA','dd/mm/yyyy')
                     AND A.Cod_Agente         = AC.Cod_Agente(+)
                     AND C.Cod_Agente         = A.Cod_Agente
                     AND DP.IdPoliza          = ADC.IdPoliza
                     AND DP.IdetPol           = ADC.IdetPol 
                     AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
                  --------------------------- detalle negativos ----------------------------
             UNION ALL -- Negativos
                  SELECT C.Cod_Agente                          , 
                         A.CodNivel                 CodNivel   ,
                         N.Fecsts                   Fe_Movim   , 
                         PO.IdPoliza                IdPoliza   , 
                         N.IdEndoso                 IdEndoso   , 
                         PC.CodTipoPlan             CodTipoPlan,
                         'NC-' || N.IdNcr           Recibo     , 
                         N.CodMoneda                cd_mon     , 
                         Monto_Ncr_Local            PmaCom     ,
                         C.Comision_Local           MtCom      , 
                         MtoIva                                , 
                         MtoIvaRet                             , 
                         MtoIsr                                ,           
                         MtoIsrRet                             , 
                         SubTotal                              , 
                         DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, 
                         DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_Favor,
                         C.IdComision               IdComision ,
                         C.Estado                   EstadoCom  ,                         
                         Porc_Com_Distribuida                  , 
                         Porc_Com_Proporcional                 , 
                         PO.PrimaNeta_Local         Prima_Net  ,
                         (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
                            FROM detalle_notas_de_credito d, 
                                 catalogo_de_conceptos c
                           WHERE c.CodConcepto      = D.CodCpto
                             AND c.CodCia           = N.CodCia
                             AND (d.IndCptoPrima    = 'S'
                              OR c.IndCptoServicio  = 'S')
                             AND d.IdNcr            = N.IdNcr) MtoPrimaFactura,
                         CASE 
                           WHEN n.stsncr  = 'APL' THEN TRUNC(c.fec_liquidacion)--AND  n.fecsts IS NULL THEN TRUNC(c.fec_liquidacion)   
                           WHEN n.stsncr  = 'PAG' AND C.Estado = 'LIQ'  THEN TRUNC(n.fecsts) 
                           WHEN n.stsncr  = 'PAG' AND C.Estado = 'REC'  THEN NULL                           
                         END                                                   fecha_pago
                    FROM comisiones c, notas_de_credito n, polizas po, detalle_poliza dp, 
                         tipos_de_seguros pc, agentes_distribucion_comision adc,
                        (SELECT CodCia, IdComision,
                                SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, 
                                SUM(MtoIsrRet) MtoIsrRet, 
                                SUM(MtoComisi) + SUM(MtoIva) + 
                                SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
                           FROM (SELECT CodCia, IdComision,
                                        DECODE(CodConcepto, 'COMISI', SUM(Monto_mon_local),0) +
                                        DECODE(CodConcepto, 'HONORA', SUM(Monto_mon_local),0) +
                                        DECODE(CodConcepto, 'AJUCOM', SUM(NVL(Monto_mon_local,0)), 0) +                                  
                                        DECODE(CodConcepto, 'AJUHON', SUM(NVL(Monto_mon_local,0)), 0) +                                        
                                        DECODE(CodConcepto, 'UDI',    SUM(Monto_mon_local),0) MtoComisi,
                                        DECODE(CodConcepto, 'IVASIN', SUM(Monto_mon_local), 0) MtoIva,
                                        DECODE(CodConcepto, 'RETIVA', SUM(Monto_mon_local), 0) MtoIvaRet, 
                                        DECODE(CodConcepto, 'ISR',    SUM(Monto_mon_local), 0) MtoIsr, 
                                        DECODE(CodConcepto, 'RETISR', SUM(Monto_mon_local), 0) MtoIsrRet
                                   FROM DETALLE_COMISION
                                  GROUP BY CodCia, IdComision, CodConcepto) 
                          GROUP BY CodCia, IdComision) Y,
                         agentes a, agentes_cedula_autorizada ac, NCR_FACTEXT XT
                   WHERE --C.Estado             = 'REC' AND 
                         c.Codcia             = vCia
                     AND C.Cod_Agente         = vAgente 
                     AND C.IdNcr              = N.IdNcr
                     AND (N.StsNcr           != 'ANU' and C.Estado !='PRY')
                     AND N.IdPoliza           = PO.IdPoliza
                     AND N.IdPoliza           = DP.IdPoliza
                     AND N.IdetPol            = DP.IdetPol
                     AND DP.CodCia            = PC.CodCia
                     AND DP.CodEmpresa        = PC.CodEmpresa
                     AND DP.IdTipoSeg         = PC.IdTipoSeg
                     AND C.CodCia             = Y.CodCia
                     AND C.IdComision         = Y.IdComision
                     AND C.Comision_Local     <>0                                        
                  	 AND ((N.Fecsts BETWEEN vFecIni AND vFecFin) OR
                              					  --to_date('&P_FECDESDE','dd/mm/yyyy') AND to_date('&P_FECHASTA','dd/mm/yyyy')) OR 
--                          (TRUNC(c.fec_estado)  BETWEEN vFecini AND vFecFin))    --Aparentemente esto es lo correcto 07/10/2016                                      
                          (TRUNC(c.fec_liquidacion)  BETWEEN vFecini AND vFecFin)) -- Corrección para igualar los Saldos con el programa de forms (repocomi.fmb ) 03/09/2016
--                                                  To_date('&P_FECDESDE','dd/mm/yyyy') AND to_date('&P_FECHASTA','dd/mm/yyyy')))
                     AND A.Cod_Agente         = AC.Cod_Agente(+)
                     AND C.Cod_Agente         = A.Cod_Agente
                     AND DP.IdPoliza          = ADC.IdPoliza
                     AND DP.IdetPol           = ADC.IdetPol 
                     AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
                     AND XT.IDNCR(+)          = N.IDNCR                     
                     --------------------------- Bonos, ajustes HON, COM, Prestamos, etc.
             UNION  -- Ajustes, movimientos que no estan ligados a ninguna factura.
                    SELECT C.Cod_Agente          , 
                           A.CodNivel                 CodNivel   ,
                           F.Fecsts                   Fe_movim   ,
                           PO.IdPoliza                IdPoliza   , 
                           F.IdEndoso                 IdEndoso   , 
                           PC.CodTipoPlan             CodTipoPlan,
                           TRIM(TO_CHAR(F.IdFactura)) Recibo     ,
                           f.cod_moneda               cd_mon     ,           
                           f.Monto_Fact_Local         PmaCom     ,           
                           c.comision_local           MtCom      ,
                           MtoIva                     , 
                           MtoIvaRet                  , 
                           MtoIsr                     ,                     
                           MtoIsrRet                  , 
                           SubTotal                   , 
                           DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, 
                           DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_Favor  ,
                           C.IdComision               IdComision ,
                           C.Estado                   EstadoCom  ,                           
                           adc.Porc_Com_Distribuida   , 
                           ADC.Porc_Com_Proporcional  , 
                           PO.PrimaNeta_Local         Prima_Net,
                           (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
                              FROM detalle_facturas d, 
                                   catalogo_de_conceptos c
                             WHERE C.CodConcepto      = D.CodCpto
                               AND C.CodCia           = F.CodCia
                               AND (D.IndCptoPrima    = 'S'
                                OR C.IndCptoServicio  = 'S')
                               AND D.IdFactura        = F.IdFactura) MtoPrimaFactura    ,
                         CASE 
                           WHEN nc.stsncr  = 'APL' THEN TRUNC(c.fec_liquidacion)--AND  n.fecsts IS NULL THEN TRUNC(c.fec_liquidacion)   
                           WHEN nc.stsncr  = 'PAG' AND C.Estado = 'LIQ'  THEN TRUNC(nc.fecsts) 
                           WHEN nc.stsncr  = 'PAG' AND C.Estado = 'REC'  THEN NULL                           
                         END                                                   fecha_pago
                      FROM comisiones       c , 
                           facturas         f , 
                           polizas          po, 
                           detalle_poliza   dp, 
                           tipos_de_seguros pc, 
                           agentes_distribucion_comision adc,
                          (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                  SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
                                  SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
                             FROM (SELECT DC.CodCia, 
                                          DC.IdComision,
                                          DECODE(DC.CodConcepto, 'COMISI', SUM(NVL(DC.Monto_mon_local,0)), 0) +
                                          DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_local,0)), 0) +
                                          DECODE(DC.CodConcepto, 'AJUCOM', SUM(NVL(DC.Monto_mon_local,0)), 0) +                                  
                                          DECODE(DC.CodConcepto, 'AJUHON', SUM(NVL(DC.Monto_mon_local,0)), 0) +                                          
                                          DECODE(DC.CodConcepto, 'UDI'   , SUM(NVL(DC.Monto_mon_local,0)), 0) MtoComisi,
                                          DECODE(DC.CodConcepto, 'IVASIN', SUM(NVL(DC.Monto_mon_local,0)), 0) MtoIva   ,
                                          DECODE(DC.CodConcepto, 'RETIVA', SUM(NVL(DC.Monto_mon_local,0)), 0) MtoIvaRet, 
                                          DECODE(DC.CodConcepto, 'ISR'   , SUM(NVL(DC.Monto_mon_local,0)), 0) MtoIsr   , 
                                          DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_local,0)), 0) MtoIsrRet
                                     FROM comisiones       c2, 
                                          detalle_comision dc                      
                                     WHERE C2.CODCIA       = vCia
                                     AND   C2.Cod_Agente   = vAgente
                                     AND   DC.CODCIA     = C2.CODCIA
                                     AND   DC.IDCOMISION = C2.IDCOMISION
                                    GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                            GROUP BY CodCia, IdComision) Y,        
                           agentes a, 
                           notas_de_credito nc, 
                           ncr_factext xt
                    WHERE  c.codcia             = vCia
                       AND c.Cod_Agente         = vAgente
                       AND c.IdFactura          = F.IdFactura
                       AND (F.StsFact          != 'ANU' and C.Estado !='PRY')
                       AND F.IdPoliza           = PO.IdPoliza
                       AND F.IdPoliza           = DP.IdPoliza
                       AND F.IdetPol            = DP.IdetPol
                       AND DP.CodCia            = PC.CodCia
                       AND DP.CodEmpresa        = PC.CodEmpresa
                       AND DP.IdTipoSeg         = PC.IdTipoSeg
                       AND C.CodCia             = Y.CodCia
                       AND C.IdComision         = Y.IdComision
                       AND C.Comision_Local    != 0
                       AND (CASE WHEN f.stsfact  = 'PAG' AND  
                                      f.Fecsts <= vFecFin AND  
                                      TRUNC(C.FEC_LIQUIDACION) > vFecFin THEN f.Fecsts 
                       END ) BETWEEN vFecIni AND vFecFin                        
                       AND C.Cod_Agente         = A.Cod_Agente
                       AND DP.IdPoliza          = ADC.IdPoliza
                       AND DP.IdetPol           = ADC.IdetPol 
                       AND DP.CODCIA            = ADC.CODCIA
                       AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
                       AND NC.IDNOMINA(+)   = C.IDNOMINA 
                       and XT.IDNCR(+) = NC.IDNCR
             UNION  --Notas de Credito y Notas Externas                                              
                    SELECT C.Cod_Agente          , 
                           A.CodNivel                 CodNivel   ,
                           c.fec_generacion           Fe_movim   ,
                           f.idpoliza                 IdPoliza   , 
                           f.idendoso                 IdEndoso   , 
                           PC.CodTipoPlan             CodTipoPlan,
                           TRIM(TO_CHAR(F.IdFactura)) Recibo     ,
                           po.cod_moneda              cd_mon     ,           
                           f.Monto_Fact_Local         PmaCom     ,           
                           c.comision_local           MtCom      ,
                           MtoIva                     , 
                           MtoIvaRet                  , 
                           MtoIsr                     ,                     
                           MtoIsrRet                  , 
                           SubTotal                   , 
                           DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, 
                           DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_Favor  ,
                           C.IdComision               IdComision ,
                           C.Estado                   EstadoCom  ,                           
                           adc.Porc_Com_Distribuida   , 
                           ADC.Porc_Com_Proporcional  , 
                           PO.PrimaNeta_Local         Prima_Net,
                           f.monto_fact_local         MtoPrimaFactura    ,
                           CASE 
                               WHEN nc.stsncr  = 'APL' THEN TRUNC(c.fec_liquidacion)--AND  n.fecsts IS NULL THEN TRUNC(c.fec_liquidacion)   
                               WHEN nc.stsncr  = 'PAG' AND C.Estado = 'LIQ'  THEN TRUNC(nc.fecsts) 
                               WHEN nc.stsncr  = 'PAG' AND C.Estado = 'REC'  THEN NULL                           
                           END                                                   fecha_pago                               
                      FROM comisiones       c , 
                           facturas         f ,
                           polizas          po, 
                           detalle_poliza   dp, 
                           tipos_de_seguros pc, 
                           agentes_distribucion_comision adc,
                          (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                                  SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
                                  SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
                             FROM (SELECT DC.CodCia, 
                                          DC.IdComision,
                                          DECODE(DC.CodConcepto, 'COMISI', SUM(NVL(DC.Monto_mon_local,0)), 0) +
                                          DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_local,0)), 0) +
                                          DECODE(DC.CodConcepto, 'AJUCOM', SUM(NVL(DC.Monto_mon_local,0)), 0) +                                  
                                          DECODE(DC.CodConcepto, 'AJUHON', SUM(NVL(DC.Monto_mon_local,0)), 0) +                                          
                                          DECODE(DC.CodConcepto, 'UDI'   , SUM(NVL(DC.Monto_mon_local,0)), 0) MtoComisi,
                                          DECODE(DC.CodConcepto, 'IVASIN', SUM(NVL(DC.Monto_mon_local,0)), 0) MtoIva   ,
                                          DECODE(DC.CodConcepto, 'RETIVA', SUM(NVL(DC.Monto_mon_local,0)), 0) MtoIvaRet, 
                                          DECODE(DC.CodConcepto, 'ISR'   , SUM(NVL(DC.Monto_mon_local,0)), 0) MtoIsr   , 
                                          DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_local,0)), 0) MtoIsrRet
                                     FROM comisiones       c2, 
                                          detalle_comision dc                      
                                     WHERE C2.CODCIA       = vCia
                                     AND   C2.Cod_Agente   = vAgente
                                     AND   DC.CODCIA     = C2.CODCIA
                                     AND   DC.IDCOMISION = C2.IDCOMISION
                                    GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                            GROUP BY CodCia, IdComision) Y,        
                           agentes a, 
                           notas_de_credito nc, 
                           ncr_factext xt
                    WHERE  C.Cod_Agente         = vAgente
                       AND C.IdFactura          = F.IdFactura
                       AND C.Estado             !='PRY'
                       AND c.IdPoliza           = PO.IdPoliza
                       AND po.IdPoliza          = DP.IdPoliza
                       AND f.idpoliza           = po.idpoliza
                       AND F.IdetPol            = DP.IdetPol
                       AND c.idetpol            = dp.idetpol
                       AND DP.CodCia            = PC.CodCia
                       AND DP.CodEmpresa        = PC.CodEmpresa
                       AND DP.IdTipoSeg         = PC.IdTipoSeg
                       AND C.CodCia             = Y.CodCia
                       AND C.IdComision         = Y.IdComision
                       AND C.Comision_Local    != 0
                       AND C.Cod_Agente         = A.Cod_Agente
                       AND DP.IdPoliza          = ADC.IdPoliza
                       AND DP.IdetPol           = ADC.IdetPol 
                       AND DP.CODCIA            = ADC.CODCIA
                       AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
                       AND NC.IDNOMINA(+)   = C.IDNOMINA 
                       AND NC.FECSTS BETWEEN vFecIni AND vFecFin 
                                      -- to_date('&p_fecdesde','dd/mm/yyyy') AND to_date('&p_fechasta','dd/mm/yyyy')  
                       and XT.IDNCR(+) = NC.IDNCR;

             yCurDet xCurDet%ROWTYPE;             
             vHoy DATE := sysdate;

        BEGIN 
             OPEN xCurDet;
             LOOP
                FETCH xCurDet INTO yCurDet;
                 EXIT WHEN xCurDet%NOTFOUND;
                    mete_detalle(vCia                        , vAgente                      , yCurDet.CodTipoPlan     , vFecini , vFecFin       , vHoy         , 
                                 yCurDet.Fe_Movim            , yCurDet.CodNivel             , yCurDet.IdPoliza        , NVL(yCurDet.IdEndoso,0) , 
                                 yCurDet.Recibo              , yCurDet.cd_mon               , NVL(yCurDet.PmaCom,0)   , NVL(yCurDet.MtCom,0)    , 
                                 NVL(yCurDet.MtoIva,0)       , NVL(yCurDet.MtoIvaRet,0)     , NVL(yCurDet.MtoIsr,0)   , NVL(yCurDet.MtoIsrRet,0),  
                                 NVL(yCurDet.SubTotal,0)     , NVL(yCurDet.En_contra,0)     , NVL(yCurDet.A_Favor,0)  , yCurDet.IdComision      , yCurDet.EstadoCom,      
                                 yCurDet.Porc_Com_Distribuida, yCurDet.Porc_Com_Proporcional, NVL(yCurDet.Prima_Net,0), NVL(yCurDet.MtoPrimaFactura,0),
                                 yCurDet.fecha_pago);
             END LOOP;
             CLOSE xCurDet;
        END DetalleComisiones;

         FUNCTION SaldoIni (vCia      IN Saldos_Comisiones_Detalle.cd_cia%TYPE      ,
                            vAgente   IN Saldos_Comisiones_Detalle.cd_agente%TYPE   , 
                            vRamo     IN saldos_comisiones_detalle.cd_tipo_ramo%TYPE,
                            vFecIni   IN saldos_comisiones_detalle.fe_ini_saldo%TYPE,
                            vFecfin   IN saldos_comisiones_detalle.fe_fin_saldo%TYPE) RETURN NUMBER IS 
                  vSaldo NUMBER(18,2);
         BEGIN 
              SELECT nvl(SUM(NVL(a.mt_saldo_final,0)),0)
                INTO vSaldo
                FROM Saldos_Comisiones_Diarios a
               WHERE a.cd_cia       = vCia
                 AND a.cd_agente    = vAgente 
                 AND a.cd_tipo_ramo = vRamo
                 and a.fe_saldo = (SELECT MAX(b.fe_saldo)  
                                         FROM Saldos_Comisiones_Diarios b
                                        WHERE b.cd_cia       = a.cd_cia
                                          AND b.cd_agente    = a.cd_agente                 
                                          AND b.cd_tipo_ramo = a.cd_tipo_ramo 
                                          AND b.fe_saldo = vFecIni-1)-->= vFecIni
                                          --AND b.fe_fin_saldo <= vFecFin-1)                                          
              GROUP BY cd_cia, cd_agente, cd_tipo_ramo; 
              RETURN vSaldo;
              
         EXCEPTION 
              WHEN no_data_found THEN 
                   RETURN 0;
              WHEN others THEN 
                   RETURN SQLCODE;                   
         END SaldoIni;

         FUNCTION SaldoFin (vCia      IN  Saldos_Comisiones_Detalle.cd_cia%TYPE      ,
                            vAgente   IN  Saldos_Comisiones_Detalle.cd_agente%TYPE   , 
                            vRamo     IN  saldos_comisiones_detalle.cd_tipo_ramo%TYPE,                            
                            vFecFin   IN  saldos_comisiones_detalle.fe_ini_saldo%TYPE,
                            --xSaldoIni IN  saldos_comisiones_diarios.mt_saldo_inicial%TYPE,
                            xComis    OUT saldos_comisiones_detalle.mt_comision%TYPE ,
                            xIVA      OUT saldos_comisiones_detalle.Mt_Iva%TYPE      ,
                            xIvaRet   OUT saldos_comisiones_detalle.mt_ivaret%TYPE   ,
                            xISR      OUT saldos_comisiones_detalle.mt_isr%TYPE      ,
                            xIsrRet   OUT saldos_comisiones_detalle.mt_isrret%TYPE   ,
                            xSaldo    OUT saldos_comisiones_detalle.mt_subtotal%TYPE ,
                            xEncOntra OUT saldos_comisiones_detalle.mt_encontra%TYPE ,
                            xAFavor   OUT saldos_comisiones_detalle.mt_afavor%TYPE   ,
                            xMovs     OUT NUMBER                                     ) RETURN NUMBER IS 
                  vSaldoIni saldos_comisiones_diarios.mt_saldo_inicial%TYPE;
                  vComis    saldos_comisiones_detalle.mt_comision%TYPE ;
                  vIVA      saldos_comisiones_detalle.Mt_Iva%TYPE      ;
                  vIvaRet   saldos_comisiones_detalle.mt_ivaret%TYPE   ;
                  vISR      saldos_comisiones_detalle.mt_isr%TYPE      ;
                  vIsrRet   saldos_comisiones_detalle.mt_isrret%TYPE   ;
                  vSaldo    saldos_comisiones_detalle.mt_subtotal%TYPE ;
                  vEncOntra saldos_comisiones_detalle.mt_encontra%TYPE ;
                  vAFavor   saldos_comisiones_detalle.mt_afavor%TYPE   ;
                  vMovis   NUMBER(6) := 0;
         BEGIN 
                vSaldo := 0.00;
                vSaldoIni := 0.00;
                SELECT NVL(SUM(NVL(a.mt_comision,0)),0)  Comis   ,
                       NVL(SUM(NVL(a.mt_iva,0)),0)       IVA     ,
                       NVL(SUM(NVL(a.mt_ivaret,0)),0)    IvaRet  ,
                       NVL(SUM(NVL(a.mt_isr,0)),0)       ISR     ,
                       NVL(SUM(NVL(a.mt_isrret,0)),0)    IsrRet  ,
                       NVL(SUM(NVL(a.mt_subtotal,0)),0)  SubTotal,
                       NVL(SUM(NVL(a.mt_encontra,0)),0)  EncOntra,
                       NVL(SUM(NVL(a.mt_afavor,0)),0)    AFavor  ,
                       COUNT(*)                          Movis
                  INTO vComis   , vIVA   , vIvaRet, vISR, vIsrRet, vSaldo ,  
                       vEncOntra, vAFavor, vMovis
                   FROM Saldos_Comisiones_Detalle a
                 WHERE a.cd_cia       = vCia
                   AND a.cd_agente    = vAgente 
                   AND a.fe_fin_saldo = vFecFin
                   AND a.cd_tipo_ramo = vRamo
                 GROUP BY cd_cia, cd_agente, cd_tipo_ramo, cd_tipo_ramo, cd_moneda
                 HAVING NVL(SUM(NVL(a.mt_subtotal,0)),0)<>0 ;
                 xComis    := vComis   ;  
                 xIVA      := vIVA     ; 
                 xIvaRet   := vIvaRet  ; 
                 xISR      := vISR     ; 
                 xIsrRet   := vIsrRet  ; 
                 xEncOntra := vEncOntra; 
                 xAFavor   := vAFavor  ;              
                 xMovs     := vMovis   ;
                 vSaldo    := vSaldo + vSaldoIni;
                 RETURN vSaldo;

         EXCEPTION 
              WHEN no_data_found THEN 
                   xComis    := 0;  
                   xIVA      := 0; 
                   xIvaRet   := 0; 
                   xISR      := 0; 
                   xIsrRet   := 0; 
                   xEncOntra := 0; 
                   xAFavor   := 0;              
                   xMovs     := 0;
                   xMovs     := 0;
                   RETURN 0;
              WHEN others THEN 
                   xComis    := 0;  
                   xIVA      := 0; 
                   xIvaRet   := 0; 
                   xISR      := 0; 
                   xIsrRet   := 0; 
                   xEncOntra := 0; 
                   xAFavor   := 0;              
                   xMovs     := 0;
                   xMovs     := 0;
                   RETURN SQLCODE;
         END SaldoFin;

         PROCEDURE SaldaCuenta(vCia    IN comisiones.codcia%TYPE    ,
                               vAgente IN comisiones.cod_agente%TYPE, 
                               vFecOri IN saldos_comisiones_detalle.fe_ini_saldo%TYPE,
                               vFecIni IN saldos_comisiones_detalle.fe_ini_saldo%TYPE, 
                               vFecFin IN saldos_comisiones_detalle.fe_fin_saldo%TYPE) IS
                   vSaldoInicial saldos_comisiones_detalle.mt_subtotal%TYPE;
                   vSaldoFinal   saldos_comisiones_detalle.mt_subtotal%TYPE;      
                   xPagos        saldos_comisiones_pagos.mt_pago%TYPE;             

          CURSOR z IS 
          SELECT DISTINCT cd_cia Cia    , 
                 cd_agente       CveAge , 
                 cd_tipo_ramo    TipRamo,
                 cd_moneda       Cvemon                 
            FROM saldos_comisiones_detalle
           WHERE cd_cia       = vCia
             AND cd_agente    = vAgente
             AND fe_fin_saldo = vFecFin
           UNION  
          SELECT DISTINCT  cd_cia Cia    , 
                           cd_agente       CveAge , 
                           cd_tipo_ramo    TipRamo,
                           cd_moneda       Cvemon                 
                      FROM saldos_comisiones_detalle
                     WHERE cd_cia       = vCia
                       AND cd_agente    = vAgente
                       and cd_tipo_ramo IN ('010','030');
 
             pComis    saldos_comisiones_detalle.mt_comision%TYPE;
             pIVA      saldos_comisiones_detalle.Mt_Iva%TYPE     ;
             pIvaRet   saldos_comisiones_detalle.mt_ivaret%TYPE  ;
             pISR      saldos_comisiones_detalle.mt_isr%TYPE     ;
             pIsrRet   saldos_comisiones_detalle.mt_isrret%TYPE  ;
             pSaldo    saldos_comisiones_detalle.mt_subtotal%TYPE;
             pEncOntra saldos_comisiones_detalle.mt_encontra%TYPE;
             pAFavor   saldos_comisiones_detalle.mt_afavor%TYPE  ;
             z1    z%ROWTYPE;
             xMovs NUMBER(6);
         BEGIN 
              OPEN z;
              LOOP 
                  FETCH z INTO z1;
                   EXIT WHEN z%NOTFOUND;
                        vSaldoInicial := SaldoIni (z1.Cia, z1.CveAge, z1.TipRamo, vFecIni, vFecFin); 
                        xPagos        := DimePagos(z1.Cia, z1.CveAge, vFecIni, z1.TipRamo);
                        vSaldoFinal   := SaldoFin (z1.Cia, z1.CveAge, z1.TipRamo, vFecFin, pComis, pIVA, pIvaRet, pISR, pIsrRet, pSaldo, pEncOntra, pAFavor, xMovs);
                        MeteSaldo (DIARIO,z1.Cia, z1.CveAge, z1.TipRamo, vFecIni, vFecFin,z1.CveMon, vSaldoInicial,xPagos, pComis, pIVA,pIvaRet, pISR, pIsrRet, pSaldo, pEncOntra,pAFavor,  vSaldofinal);
                        --IF vSaldoFinal = 0 AND xmovs = 0 THEN
                        --   vSaldoFinal := vSaldoInicial;
                        --END IF;
                        --MeteSaldo (MENSUAL,z1.Cia, z1.CveAge, z1.TipRamo, vFecIni, vFecIni, vFecFin,z1.CveMon, vSaldoInicial, pComis, pIVA,pIvaRet, pISR, pIsrRet, pSaldo, pEncOntra,pAFavor,  vSaldofinal); 
              END LOOP;
              CLOSE z;
         END SaldaCuenta;

   PROCEDURE ProcesoComisiones ( vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                            vAgente IN saldos_comisiones_detalle.cd_agente%TYPE,
                            vFecIni IN DATE                                    ,
                            vFecFin IN DATE                                    ) IS 
     
         y x%ROWTYPE;
         a NUMBER(10);
   BEGIN 
        --Validaciones
        --
        IF x%ISOPEN THEN 
            CLOSE x;
        END IF;
        OPEN x (vCia, vAgente);
        LOOP
            FETCH x INTO y;
             EXIT WHEN x%NOTFOUND;
                  SELECT (vFecFin - vFecIni) , vFecIni
                    INTO vDias, vYaLoHice
                    FROM dual;
                  PagosPeriodo(y.Cia, y.Cve, vFecIni, vFecFin);
            /*      BEGIN
                         SELECT (vFecFin - NVL(MAX(fe_fin_saldo),vFecIni)) , 
                                NVL(MAX(fe_fin_saldo), vFecIni)
                           INTO vDias, vYaLoHice
                           FROM saldos_comisiones
                          WHERE cd_cia    = y.cia
                            AND cd_agente = y.cve;

                    EXCEPTION 
                         WHEN no_data_found THEN 
                              SELECT (vFecFin - vFecIni), vFecIni--vYaLoHice
                                INTO vDias            , vYaLoHice 
                                FROM dual;
                    END;
                    */  
                    FOR a IN 0..vdias LOOP 
                        SELECT vYaLoHice + a
                          INTO xFecNva
                          FROM dual;
                        IF cuenta_movs_com  (y.cia, y.cve, xFecNva, xFecNva) > 0 THEN                       
                           DetalleComisiones(y.cia, y.cve, xFecNva,xFecNva );     
                           MeteFaltantes    (y.cia, y.cve, xFecNva         ); -- Cambios de agente por polizas.
                           SaldaCuenta      (y.cia, y.cve, vFecIni,xFecNva,xFecNva);    
                        ELSE 
                           CreaSaldosIniciales(y.cia,y.cve,xFecNva,xFecNva); --vFecFin );                         
                        END IF;                     
                     END LOOP;
   
            COMMIT;
        END LOOP;
        CLOSE x;
        COMMIT;
   END ProcesoComisiones;

   PROCEDURE IniciaSaldosenCero  ( vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                            vAgente IN saldos_comisiones_detalle.cd_agente%TYPE,
                            vFecIni IN DATE                                    ,
                            vFecFin IN DATE                                    ) IS 
          q NUMBER(6);
   BEGIN 
      q := 0;
      pFecIni := vFecIni;
      pFecFin := vFecFin;
      OPEN x (vCia, vAgente);
      LOOP
          FETCH x INTO t;
           EXIT WHEN x%NOTFOUND;    
               CreaSaldosIniciales(t.cia,t.cve,pFecIni, pFecFin);
               q := q+1;       
            COMMIT;
      END LOOP;
      CLOSE x;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Procesé: '||q*2||' Saldos de '||q||' agentes');
    END;
END th_comisiones;
/

--
-- TH_COMISIONES  (Synonym) 
--
--  Dependencies: 
--   TH_COMISIONES (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM TH_COMISIONES FOR SICAS_OC.TH_COMISIONES
/

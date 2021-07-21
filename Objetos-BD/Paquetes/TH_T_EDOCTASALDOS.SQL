CREATE OR REPLACE PACKAGE TH_T_EDOCTASALDOS IS

-- CREACION     21/01/2021                                        --                JMMDP
-- JMMD 20210628 SE SUSTITUYE EL CURSOR PRINCIPAL POR EL MISMO DEL REPORT CEDOCTA   JMMD20210628
-- JMMD 20210714 SE AGREGAN UNIONES AL CURSOR PRINCIPAL PARA INCLUIR MOVIMIENTOS 
--               DE MESES Y AÑOS ANTERIORES                                         JMMD20210720
-- 
PROCEDURE CARGA_DETALLE_SALDOS(P_AGENTE       NUMBER,
                              P_CODCIA       NUMBER,
                              P_FECDESDE     DATE,
                              P_FECHASTA     DATE,
                              P_MONEDA      VARCHAR2);
--                                                            

PROCEDURE GRABA_MOVIMIENTO(P_COD_AGENTE                      NUMBER,
                            P_FECHA_DESDE                    DATE,                            
                            P_FECHA_HASTA                    DATE,
                            P_NIVEL_AGENTE                   VARCHAR2,
                            P_DESCRIPCION_RAMO               VARCHAR2,        
                            P_CODNIVEL                       NUMBER,
                            P_NUMPOLUNICO                    VARCHAR2,
                            P_FEC_GENERACION                 DATE,
                            P_IDPOLIZA                       NUMBER,
                            P_IDENDOSO                       VARCHAR2,
                            P_NOMCLIENTE                     VARCHAR2,    
                            P_RECIBO                         VARCHAR2,
                            P_MONEDA                         VARCHAR2,
                            P_PRIMA_COMISINABLE_LOCAL        NUMBER,
                            P_MONTO_COMISION                 NUMBER,
                            P_COMI_MONEDA                    NUMBER,
                            P_STT_COMISION                   VARCHAR2,
                            P_STATUS_PAGOF                   VARCHAR2,
                            P_PAGADO                         NUMBER,
                            P_POR_PAGAR                      NUMBER,
                            P_MTOIVA                         NUMBER,
                            P_MTOIVARET                      NUMBER,
                            P_MTOISR                         NUMBER,
                            P_MTOISRRET                      NUMBER,
                            P_SUBTOTAL                       NUMBER,
                            P_CASE_COMISION                  NUMBER,
                            P_CASE_MTOIVA                    NUMBER,
                            P_CASE_MTOIVARET                 NUMBER,
                            P_CASE_MTOISR                    NUMBER,
                            P_CASE_MTOISRRET                 NUMBER,
                            P_POR_PAGAR_SHOWON               NUMBER,
                            P_POR_PAGAR_COMISION             NUMBER,
                            P_POR_PAGAR_MTOIVA               NUMBER,
                            P_POR_PAGAR_MTOIVARET            NUMBER,
                            P_POR_PAGAR_MTOISR               NUMBER,
                            P_CASE_MTOPRIMAFACTURA           NUMBER,
                            P_EN_CONTRA                      NUMBER,
                            P_CODTIPOPLAN                    VARCHAR2,
                            P_A_FAVOR                        NUMBER,
                            P_IDCOMISION                     NUMBER,
                            P_NOMBRE_AGENTE                  VARCHAR2  ,    
                            P_DIRECRES                       VARCHAR2  ,    
                            P_NUM_TRIBUTARIO                 VARCHAR2,
                            P_NUMCEDULA                      VARCHAR2,
                            P_FECVENCIMIENTO                 DATE,
                            P_TIPO_PERSONA                   VARCHAR2,
                            P_NUM_DOC_IDENTIFICACION         VARCHAR2,
                            P_POR_COM_DISTRIBUIDA            NUMBER,
                            P_PORC_COM_PROPORCIONAL          NUMBER,
                            P_PRIMA_NETA                     NUMBER,
                            P_MTOPRIMAFACTURA                NUMBER,
                            P_NOMINA_COM                     NUMBER,
                            P_FECHA_PAGO                     DATE);
--
PROCEDURE BORRA_MOVIMIENTO(P_COD_AGENTE NUMBER,
                            P_FECHA_DESDE                    DATE,                            
                            P_FECHA_HASTA                    DATE );
--                           

END TH_T_EDOCTASALDOS;
/
CREATE OR REPLACE PACKAGE BODY TH_T_EDOCTASALDOS IS
---
-- CREACION     21/01/2021                                        --                JMMDP
-- JMMD 20210628 SE SUSTITUYE EL CURSOR PRINCIPAL POR EL MISMO DEL REPORT CEDOCTA   JMMD20210628
-- JMMD 20210714 SE AGREGAN UNIONES AL CURSOR PRINCIPAL PARA INCLUIR MOVIMIENTOS 
--               DE MESES Y AÑOS ANTERIORES                                         JMMD20210720
PROCEDURE CARGA_DETALLE_SALDOS(P_AGENTE       NUMBER,
                              P_CODCIA       NUMBER,
                              P_FECDESDE     DATE,
                              P_FECHASTA     DATE,
                              P_MONEDA      VARCHAR2) IS
 --  
--  
CURSOR DETALLES IS
SELECT   ---   '01',  NUEVA
           C.Cod_Agente, 
           OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, 
           A.CodNivel CodNivel,
           NumPolUnico, 
           F.Fecsts Fec_Generacion, 
           PO.IdPoliza IdPoliza, 
           F.IdEndoso IdEndoso, 
           OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, TRIM(TO_CHAR(F.IdFactura)) Recibo, 
           OC_MONEDA.MONEDA_ALTERNA(F.Cod_Moneda) Moneda, Monto_Fact_Moneda Prima_Comisinable_Local,
          C.Comision_Moneda Comision
       , C.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       , ' ' STATUSPAGO_F
       ,DECODE(C.Estado,'LIQ', C.comision_moneda,(DECODE(F.StsFact, 'APL', C.comision_moneda, 0))) PAGADO
       ,DECODE(C.Estado, 'REC', SubTotal,0 )    POR_PAGAR,   
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       --------- CASE para poner en Cero Si la fecha de aplicacion es menor al mes en curso  -------        
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END                                                        CASE_Comision,
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END                                                        CASE_MtoIva,
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END                                                        CASE_MtoIvaRet,
      CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0          
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END                                                        CASE_MtoIsr,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END                                                        CASE_MtoIsrRet,

        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then SubTotal
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  SubTotal
        END                                                       POR_PAGAR_SHOWON,  
        -----
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then C.Comision_Moneda
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
        END                                                       POR_PAGAR_Comision,  
        --    ---
                CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIva
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
        END                                                       POR_PAGAR_MtoIva,  
        --    ---
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIvaRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
        END                                                       POR_PAGAR_MtoIvaRet,  
        --    ---
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
        END                                                       POR_PAGAR_MtoIsr,          
        --    ---
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN (F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA ) AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
        END                                                       POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN       0    
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN 
                          (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
                            FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
                           WHERE C.CodConcepto      = D.CodCpto
                             AND C.CodCia           = F.CodCia
                             AND (D.IndCptoPrima    = 'S'
                              OR C.IndCptoServicio  = 'S')
                             AND D.IdFactura        = F.IdFactura)
         ELSE 0                    
        END                                                        CASE_MtoPrimaFactura,            
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula,
        AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, ADC.Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
          FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = F.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdFactura        = F.IdFactura) MtoPrimaFactura
      ,C.IDNOMINA NOMINA_COM, 
    CASE 
       WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then null
     END                                                   FECHA_PAGO
  FROM COMISIONES C, FACTURAS F, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION adc,
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC,
       (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT 
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',         SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA
                 AND   C2.Cod_Agente   = P_AGENTE                  
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y
  WHERE C.Estado = 'REC'
   AND C.Cod_Agente   = DECODE(P_AGENTE,NULL,C.Cod_Agente,P_AGENTE)
   AND C.IdFactura    = F.IdFactura
   AND F.StsFact      != 'ANU'
   AND F.IdPoliza     = PO.IdPoliza
   AND F.IdPoliza     = DP.IdPoliza
   AND F.IdetPol      = DP.IdetPol
   AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision
   AND f.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente         = AC.Cod_Agente(+)
   AND C.Cod_Agente         = A.Cod_Agente
   AND DP.IdPoliza          = ADC.IdPoliza
   AND DP.IdetPol           = ADC.IdetPol 
   AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
   AND C.COD_MONEDA = P_MONEDA
/*   and adc.porc_com_proporcional = (select max(adc1.porc_com_proporcional)
                                      from AGENTES_DISTRIBUCION_COMISION adc1
                                     where adc1.codcia           = adc.codcia
                                       and adc1.idpoliza         = adc.idpoliza
                                       and adc1.idetpol          = adc.idetpol
                                       and adc1.cod_agente_distr = adc.cod_agente_distr )  */
UNION
SELECT    ---  '02',
           C.Cod_Agente, 
           OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, 
           A.CodNivel CodNivel,
           NumPolUnico, 
           F.Fecsts Fec_Generacion, 
           PO.IdPoliza IdPoliza, 
           F.IdEndoso IdEndoso, 
           OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, TRIM(TO_CHAR(F.IdFactura)) Recibo, 
           OC_MONEDA.MONEDA_ALTERNA(F.Cod_Moneda) Moneda, Monto_Fact_Moneda Prima_Comisinable_Local,
          C.Comision_Moneda Comision
       , C.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       ,NC.STSNCR  STATUSPAGO_F
       ,DECODE(C.Estado,'LIQ', C.comision_moneda
                       ,  (DECODE(F.StsFact, 'APL', C.comision_moneda, 0))) PAGADO
       ,DECODE(C.Estado, 'REC', SubTotal                   
                       ,0 )    POR_PAGAR,   
      
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       --------- CASE para poner en Cero Si la fecha de aplicacion es menor al mes en curso  -------        
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
          
        END                                                        CASE_Comision,
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END                                                        CASE_MtoIva,
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END                                                        CASE_MtoIvaRet,
      CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0          
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END                                                        CASE_MtoIsr,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END                                                        CASE_MtoIsrRet,
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then SubTotal
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  SubTotal
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_SHOWON,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then C.Comision_Moneda
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_Comision,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIva
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIva,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIvaRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIvaRet,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')   
                 
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIsr,          
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN (F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA ) AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN       0    
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN 
                          (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
                            FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
                           WHERE C.CodConcepto      = D.CodCpto
                             AND C.CodCia           = F.CodCia
                             AND (D.IndCptoPrima    = 'S'
                              OR C.IndCptoServicio  = 'S')
                             AND D.IdFactura        = F.IdFactura)
         ELSE 0                    
        END                                                        CASE_MtoPrimaFactura,            
       ---------------------------------------------------------------------------------------------
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula,
        AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, ADC.Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
          FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = F.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdFactura        = F.IdFactura) MtoPrimaFactura
      ,C.IDNOMINA NOMINA_COM, 
    CASE 
       WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then null--TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY') 
       WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
       WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')        
     END                                                   FECHA_PAGO
  FROM COMISIONES C, FACTURAS F, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION ADC,
      (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT  
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',        SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA
                 AND   C2.Cod_Agente   = P_AGENTE                 
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y,        
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC
       ,NOTAS_DE_CREDITO NC, NCR_FACTEXT XT
WHERE  C.Cod_Agente  =  P_AGENTE
   AND C.COD_MONEDA = P_MONEDA
   AND C.IdFactura    = F.IdFactura
   AND (F.StsFact     != 'ANU' and C.Estado !='PRY')
   AND F.IdPoliza     = PO.IdPoliza
   AND F.IdPoliza     = DP.IdPoliza
   AND F.IdetPol      = DP.IdetPol
   AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision
   AND C.Comision_Moneda  != 0
    and (     
     CASE 
--       WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then  f.Fecsts  ----JMMD2021 SE AGREGA EL IGUAL
       WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then  f.Fecsts       
     END ) BETWEEN P_FECDESDE AND P_FECHASTA
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente         = AC.Cod_Agente(+)
   AND C.Cod_Agente         = A.Cod_Agente
   AND DP.IdPoliza          = ADC.IdPoliza
   AND DP.IdetPol           = ADC.IdetPol 
   AND DP.CODCIA            = ADC.CODCIA
   AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
   --
   AND NC.IDNOMINA(+)   = C.IDNOMINA 
  and XT.IDNCR(+) = NC.IDNCR     
UNION -- QUERY 3
SELECT    ---  '03',
           C.Cod_Agente, 
           OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, 
           A.CodNivel CodNivel,
           NumPolUnico, 
           F.Fecsts Fec_Generacion, 
           PO.IdPoliza IdPoliza, 
           F.IdEndoso IdEndoso, 
           OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, TRIM(TO_CHAR(F.IdFactura)) Recibo, 
           OC_MONEDA.MONEDA_ALTERNA(F.Cod_Moneda) Moneda, Monto_Fact_Moneda Prima_Comisinable_Local,
          C.Comision_Moneda Comision
       , C.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       ,NC.STSNCR  STATUSPAGO_F
       ,DECODE(C.Estado,'LIQ', C.comision_moneda,  (DECODE(F.StsFact, 'APL', C.comision_moneda, 0))) PAGADO
       ,DECODE(C.Estado, 'REC', SubTotal,0 )    POR_PAGAR,   
      
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END                                                        CASE_Comision,
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END                                                        CASE_MtoIva,
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END                                                        CASE_MtoIvaRet,
      CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END                                                        CASE_MtoIsr,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END                                                        CASE_MtoIsrRet,
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')  THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  SubTotal
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_SHOWON,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_Comision,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIva,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIvaRet,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIsr,          
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR IN ('PAG','APL')   THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
          WHEN (CASE 
                  WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------      
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN       0          
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN 
                          (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
                            FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
                           WHERE C.CodConcepto      = D.CodCpto
                             AND C.CodCia           = F.CodCia
                             AND (D.IndCptoPrima    = 'S'
                              OR C.IndCptoServicio  = 'S')
                             AND D.IdFactura        = F.IdFactura)
        END                                                        CASE_MtoPrimaFactura,            
       ---------------------------------------------------------------------------------------------
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula,
        AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, ADC.Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
          FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = F.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdFactura        = F.IdFactura) MtoPrimaFactura
      ,C.IDNOMINA NOMINA_COM,     
     CASE 
       WHEN NC.STSNCR IN ('PAG','APL')  AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
       WHEN NC.STSNCR IN ('PAG','APL')   THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')        
     END                                                   FECHA_PAGO
  FROM COMISIONES C, FACTURAS F, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION ADC,
      (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT  
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',        SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA
                 AND   C2.Cod_Agente   = P_AGENTE                 
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y,        
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC
       ,NOTAS_DE_CREDITO NC, NCR_FACTEXT XT
WHERE  C.Cod_Agente  =  P_AGENTE
   AND C.COD_MONEDA = P_MONEDA
   AND C.IdFactura    = F.IdFactura
   AND (F.StsFact     != 'ANU' and C.Estado !='PRY')
   AND F.IdPoliza     = PO.IdPoliza
   AND F.IdPoliza     = DP.IdPoliza
   AND F.IdetPol      = DP.IdetPol
   AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision
   AND C.Comision_Moneda  != 0
  -- AND f.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA -- Esto estaba comentado para que no buscara facturas APLICADAS en el periodo. RSR 0404/2016
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente         = AC.Cod_Agente(+)
   AND C.Cod_Agente         = A.Cod_Agente
   AND DP.IdPoliza          = ADC.IdPoliza
   AND DP.IdetPol           = ADC.IdetPol 
   AND DP.CODCIA            = ADC.CODCIA
   AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
   --
   AND NC.IDNOMINA(+)   = C.IDNOMINA 
  AND NC.FECSTS  BETWEEN P_FECDESDE AND P_FECHASTA   ----  AEVS  Limita la busqueda a  notas de credito   
  and XT.IDNCR(+) = NC.IDNCR    
UNION   -- QUERY 4 
SELECT   ---  '04',
           C.Cod_Agente, 
           OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, 
           A.CodNivel CodNivel,
           NumPolUnico, 
           F.Fecsts Fec_Generacion, 
           PO.IdPoliza IdPoliza, 
           F.IdEndoso IdEndoso, 
           OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, TRIM(TO_CHAR(F.IdFactura)) Recibo, 
           OC_MONEDA.MONEDA_ALTERNA(F.Cod_Moneda) Moneda, Monto_Fact_Moneda Prima_Comisinable_Local,
          C.Comision_Moneda Comision
       , C.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       ,NC.STSNCR  STATUSPAGO_F
       ,DECODE(C.Estado,'LIQ', C.comision_moneda,  (DECODE(F.StsFact, 'APL', C.comision_moneda, 0))) PAGADO
       ,DECODE(C.Estado, 'REC', SubTotal,0 )    POR_PAGAR,   
      
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END                                                        CASE_Comision,
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END                                                        CASE_MtoIva,
       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END                                                        CASE_MtoIvaRet,
      CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END                                                        CASE_MtoIsr,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END                                                        CASE_MtoIsrRet,
        ---ETSSSPERIMENTO  FECHAS ---
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR = 'PAG'  THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  SubTotal
          WHEN (CASE 
                  WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR = 'PAG'  THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_SHOWON,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR = 'PAG'  THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
          WHEN (CASE 
                  WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR = 'PAG'  THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_Comision,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR = 'PAG'  THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
          WHEN (CASE 
                  WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR = 'PAG'  THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIva,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR = 'PAG'  THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
          WHEN (CASE 
                  WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR = 'PAG'  THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIvaRet,  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR = 'PAG'  THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN (CASE 
                  WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR = 'PAG'  THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIsr,          
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND NC.STSNCR = 'PAG'  THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
          WHEN (CASE 
                  WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN NC.STSNCR = 'PAG'  THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------  
        CASE
          WHEN F.Fecsts < P_FECDESDE THEN       0          
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN 
                          (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
                            FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
                           WHERE C.CodConcepto      = D.CodCpto
                             AND C.CodCia           = F.CodCia
                             AND (D.IndCptoPrima    = 'S'
                              OR C.IndCptoServicio  = 'S')
                             AND D.IdFactura        = F.IdFactura)
        END                                                        CASE_MtoPrimaFactura,            
       ---------------------------------------------------------------------------------------------
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula,
        AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, ADC.Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
          FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = F.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdFactura        = F.IdFactura) MtoPrimaFactura
      ,C.IDNOMINA NOMINA_COM, 
    CASE 
       WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
       WHEN NC.STSNCR = 'PAG'  THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')        
     END                                                   FECHA_PAGO
  FROM COMISIONES C, FACTURAS F, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION ADC,
      (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT  
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',        SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA
                 AND   C2.Cod_Agente   = P_AGENTE                 
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y,        
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC
       ,NOTAS_DE_CREDITO NC, NCR_FACTEXT XT
WHERE  C.Cod_Agente  =  P_AGENTE
   AND C.COD_MONEDA = P_MONEDA
   AND C.IdFactura    = F.IdFactura
   AND (F.StsFact     != 'ANU' and C.Estado !='PRY')
   AND F.IdPoliza     = PO.IdPoliza
   AND F.IdPoliza     = DP.IdPoliza
   AND F.IdetPol      = DP.IdetPol
   AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision
   AND C.Comision_Moneda  != 0
    and (     
     CASE 
       WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) < P_FECHASTA then  NC.FECSTS--f.Fecsts
     END )     BETWEEN P_FECDESDE AND P_FECHASTA   
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente         = AC.Cod_Agente(+)
   AND C.Cod_Agente         = A.Cod_Agente
   AND DP.IdPoliza          = ADC.IdPoliza
   AND DP.IdetPol           = ADC.IdetPol 
   AND DP.CODCIA            = ADC.CODCIA
   AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
   --
   AND NC.IDNOMINA(+)   = C.IDNOMINA 
  and XT.IDNCR(+) = NC.IDNCR     
  
UNION 
------------->>>>>>>
SELECT --- '05',
       C.Cod_Agente, OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, A.CodNivel CodNivel,
       NumPolUnico, N.Fecsts Fec_Generacion, PO.IdPoliza IdPoliza, N.IdEndoso IdEndoso, 
       OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, 'NC-' || N.IdNcr Recibo, 
       OC_MONEDA.MONEDA_ALTERNA(N.CodMoneda) Moneda, Monto_Ncr_Moneda Prima_Comisinable_Local,
       C.Comision_Moneda Comision
       , c.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       , N.StsNcr  STATUSPAGO
       --------------------------------,DECODE(N.StsNcr,'APL', (DECODE(C.Estado, 'REC', 0, c.comision_moneda))) PAGADO       AEVS 09102017                
       ,DECODE(N.StsNcr,'PAG', (DECODE(C.Estado, 'REC',c.comision_moneda, 0 ))
                       ,'APL', ((DECODE(C.Estado, 'REC',c.comision_moneda, 0 )))) PAGADO                   
/*       ,DECODE(N.StsNcr,'PAG', (DECODE(C.Estado, 'REC',SubTotal, 0 ))
                       ,'APL', ((DECODE(C.Estado, 'REC',SubTotal, 0 )))) POR_PAGAR */ --JMMD20210712 ASI ESTABA
        ,CASE 
           WHEN N.StsNcr IN( 'PAG','APL') AND C.ESTADO = 'REC' THEN SUBTOTAL
           WHEN N.StsNcr IN( 'PAG','APL') AND C.ESTADO = 'LIQ' AND TRUNC(FEC_LIQUIDACION) BETWEEN P_FECDESDE AND P_FECHASTA THEN 0
           WHEN N.StsNcr IN( 'PAG','APL') AND C.ESTADO = 'LIQ' AND TRUNC(FEC_LIQUIDACION) > P_FECHASTA  THEN SUBTOTAL
           WHEN N.StsNcr IN( 'PAG','APL') AND C.ESTADO = 'LIQ' AND TRUNC(FEC_LIQUIDACION) < P_FECDESDE  THEN 0
        END			POR_PAGAR ,
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END                                                       CASE_COMISION,
       CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END                                                        CASE_MtoIva,
       CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END                                                        CASE_MtoIvaRet,
      CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END                                                        CASE_MtoIsr,  
        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END                                                        CASE_MtoIsrRet,
        ---ETSSSPERIMENTO  FECHAS ---
        CASE
          WHEN ( (N.Fecsts  < P_FECDESDE) OR (C.FEC_LIQUIDACION  < P_FECDESDE ))  THEN 0
-----          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0   --JMMD20210712 ASI ESTABA
-------------
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND (TRUNC(FEC_LIQUIDACION) BETWEEN P_FECDESDE AND P_FECHASTA OR TRUNC(FEC_LIQUIDACION) < P_FECDESDE))   THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND TRUNC(FEC_LIQUIDACION) > P_FECHASTA )   THEN SUBTOTAL
-------------          
          WHEN ( (N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'REC' )) THEN  SubTotal --OR (C.FEC_LIQUIDACION BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')))   THEN  SubTotal-----0 AEVS
          WHEN ( (N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  ) OR (C.FEC_LIQUIDACION BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  ))THEN  SubTotal
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_SHOWON,  
        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
---JMMD20210712          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0  --ASI ESTABA
-------------
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND (TRUNC(FEC_LIQUIDACION) BETWEEN P_FECDESDE AND P_FECHASTA OR TRUNC(FEC_LIQUIDACION) < P_FECDESDE))   THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND TRUNC(FEC_LIQUIDACION) > P_FECHASTA )   THEN C.Comision_Moneda
-------------
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'REC'  THEN  C.Comision_Moneda----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_Comision,  
        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva          
----JMMD20210713          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN MtoIva ----jmmd20190724 0 ---JMMD 20190521  MtoIva----0 AEVS
----------
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ'
                                             AND TRUNC(FEC_LIQUIDACION) BETWEEN P_FECDESDE AND P_FECHASTA THEN 0   
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' 
                                             AND TRUNC(FEC_LIQUIDACION) < P_FECDESDE  THEN 0          
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' 
                                             AND TRUNC(FEC_LIQUIDACION) > P_FECHASTA THEN MtoIva 
----------                                                
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIva,  
        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
-----JMMD20210713          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN 0 ----JMMD20190521 MtoIvaRet----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
-------------jmmd20210712
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND (TRUNC(FEC_LIQUIDACION) BETWEEN P_FECDESDE AND P_FECHASTA OR TRUNC(FEC_LIQUIDACION) < P_FECDESDE))   THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND TRUNC(FEC_LIQUIDACION) > P_FECHASTA )   THEN MtoIvaRet
-------------jmmd20210712           
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL') THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIvaRet,  
        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
-------------jmmd20210712
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND (TRUNC(FEC_LIQUIDACION) BETWEEN P_FECDESDE AND P_FECHASTA OR TRUNC(FEC_LIQUIDACION) < P_FECDESDE))   THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND TRUNC(FEC_LIQUIDACION) > P_FECHASTA )   THEN MtoIsr
-------------jmmd20210712          
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN 0 ----JMMD20190521 MtoIsr----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIsr,          
        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
----jmmd20210712          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0
-------------jmmd20210712
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND (TRUNC(FEC_LIQUIDACION) BETWEEN P_FECDESDE AND P_FECHASTA OR TRUNC(FEC_LIQUIDACION) < P_FECDESDE))   THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ' AND TRUNC(FEC_LIQUIDACION) > P_FECHASTA )   THEN MtoIsrRet
-------------jmmd20210712     
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN MtoIsrRet----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END                                                       POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------          
        CASE
          WHEN N.Fecsts < P_FECDESDE THEN       0          
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN 
                      (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
                        FROM DETALLE_NOTAS_DE_CREDITO D, CATALOGO_DE_CONCEPTOS C
                       WHERE C.CodConcepto      = D.CodCpto
                         AND C.CodCia           = N.CodCia
                         AND (D.IndCptoPrima    = 'S'
                          OR C.IndCptoServicio  = 'S')
                         AND D.IdNcr            = N.IdNcr)
        END                                                        CASE_MtoPrimaFactura,                
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula, AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
          FROM DETALLE_NOTAS_DE_CREDITO D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = N.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdNcr            = N.IdNcr) MtoPrimaFactura
        ,C.IDNOMINA NOMINA_COMISION,
      --%%%%%%%-----        
    CASE 
       WHEN N.STSNCR IN ('PAG','APL') AND TRUNC(C.FEC_LIQUIDACION) <= P_FECHASTA  THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
       WHEN N.STSNCR IN ('PAG','APL') AND TRUNC(C.FEC_LIQUIDACION) IS NULL THEN NULL
       ELSE TO_CHAR(N.FECSTS, 'DD/MM/YYYY')
     END                                                   FECHA_PAGO            
      
  FROM COMISIONES C, NOTAS_DE_CREDITO N, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION adc,
       (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT 
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',         SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA
                 AND   C2.Cod_Agente   = P_AGENTE                 
                 ----AND   C2.FEC_ESTADO BETWEEN P_FECDESDE AND P_FECHASTA
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y,
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC      
       , NCR_FACTEXT XT
WHERE  C.Cod_Agente   = P_AGENTE
   AND C.COD_MONEDA = P_MONEDA
  ----- AND C.FEC_ESTADO BETWEEN P_FECDESDE AND P_FECHASTA
   AND C.IdNcr        = N.IdNcr
   AND ( N.StsNcr      != 'ANU' and C.Estado !='PRY') 
   AND N.IdPoliza     = PO.IdPoliza
   AND N.IdPoliza     = DP.IdPoliza
   AND N.IdetPol      = DP.IdetPol
  AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision
   AND C.Comision_Moneda  != 0
    AND ( (N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA) OR
       (C.FEC_LIQUIDACION  BETWEEN P_FECDESDE AND P_FECHASTA)) 
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente            = AC.Cod_Agente(+)
   AND C.Cod_Agente            = A.Cod_Agente
   AND DP.IdPoliza             =  ADC.IdPoliza
   AND DP.IdetPol              = ADC.IdetPol 
   AND DP.CODCIA               = ADC.CODCIA
   AND ADC.COD_AGENTE_DISTR    = C.Cod_Agente 
   and XT.IDNCR(+)             = N.IDNCR
   ------------->>>>>>>>>>>
UNION 
SELECT --- '06', 
       C.Cod_Agente, OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, A.CodNivel CodNivel,
       NumPolUnico, C.Fec_Generacion, PO.IdPoliza IdPoliza, 0 IdEndoso, 
       OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, TRIM(TO_CHAR(0)) Recibo, 
       OC_MONEDA.MONEDA_ALTERNA(PO.Cod_Moneda) Moneda, 0 Prima_Comisinable_Local
       , C.Comision_Moneda Comision
       , C.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       , 'NIDENT' STATUSPAGO
       ,DECODE(C.Estado,'LIQ', C.comision_moneda
                       , 0) PAGADO
       ,DECODE(C.Estado, 'REC', C.comision_moneda
                       , 0) POR_PAGAR,
       ---------
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       --------- 
       C.Comision_Moneda                                              CASE_Comision,        
       MtoIva                                                        CASE_MtoIva,      
       MtoIvaRet                                                     CASE_MtoIvaRet,      
       MtoIsr                                                        CASE_MtoIsr,        
       MtoIsrRet                                                     CASE_MtoIsrRet, 
       --------------------------------------------------------------------------------            
       CASE 
           WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN       SubTotal   
           WHEN NC.STSNCR = 'PAG'  THEN  0        
       END                                                           POR_PAGAR_SHOWON,
       CASE 
           WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN      C.Comision_Moneda 
           WHEN NC.STSNCR = 'PAG'  THEN  0 
       END                                                           POR_PAGAR_Comision,
       CASE 
           WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN MtoIva        
           WHEN NC.STSNCR = 'PAG'  THEN  0 
       END                                                           POR_PAGAR_MtoIva,
       CASE 
           WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN MtoIvaRet        
           WHEN NC.STSNCR = 'PAG'  THEN  0 
       END                                                           POR_PAGAR_MtoIvaRet,
       CASE 
           WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN MtoIsr        
           WHEN NC.STSNCR = 'PAG'  THEN  0 
       END                                                           POR_PAGAR_MtoIsr,
       CASE 
           WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN MtoIsrRet        
           WHEN NC.STSNCR = 'PAG'  THEN  0 
       END                                                           POR_PAGAR_MtoIsrRet,
       ----------------------
       0                                                             CASE_MtoPrimaFactura,               
       ---------                       
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula, AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       0 MtoPrimaFactura
       ,C.IDNOMINA,
      CASE 
       WHEN NC.STSNCR = 'APL' AND  NC.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
       WHEN NC.STSNCR = 'PAG'  THEN  TO_CHAR(NC.FECSTS, 'DD/MM/YYYY')        
     END                                                   FECHA_PAGO
  FROM COMISIONES C, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION adc,
      (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT --C2.COD_AGENTE  CodAgente ,
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(dc.CodConcepto, 'AJUCOM',   SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(dc.CodConcepto, 'AJUHON',   SUM(NVL(DC.Monto_mon_extranjera,0)),0) +                      
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',     SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',   SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',          SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA
                 AND   C2.Cod_Agente   = P_AGENTE                 
                 AND   C2.FEC_ESTADO BETWEEN P_FECDESDE AND P_FECHASTA
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y,
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC
        ,NOTAS_DE_CREDITO NC, NCR_FACTEXT XT
WHERE  C.Cod_Agente       = P_AGENTE
   AND C.COD_MONEDA = P_MONEDA
   AND C.FEC_ESTADO BETWEEN P_FECDESDE AND P_FECHASTA
   AND C.IdNcr             IS NULL
   AND C.IdFactura         IS NULL
   AND C.IdPoliza           = PO.IdPoliza
   AND C.IdPoliza           = DP.IdPoliza
   AND C.IdetPol            = DP.IdetPol
   AND DP.CodCia            = PC.CodCia
   AND DP.CodEmpresa        = PC.CodEmpresa
   AND DP.IdTipoSeg         = PC.IdTipoSeg
   AND C.CodCia             = Y.CodCia
   AND C.IdComision         = Y.IdComision
   AND C.Comision_Moneda  != 0
   AND TRUNC(C.Fec_Generacion)    <= P_FECHASTA  
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente         = AC.Cod_Agente(+)
   AND C.Cod_Agente         = A.Cod_Agente
   AND DP.IdPoliza          = ADC.IdPoliza
   AND DP.IdetPol           = ADC.IdetPol 
   AND ADC.COD_AGENTE_DISTR = C.Cod_Agente
   AND DP.CODCIA            = ADC.CODCIA
   AND NC.IDNOMINA(+)   = C.IDNOMINA 
   and XT.IDNCR(+) = NC.IDNCR       
UNION
SELECT   ---   '07',  NUEVA
           C.Cod_Agente, 
           OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, 
           A.CodNivel CodNivel,
           NumPolUnico, 
           F.Fecsts Fec_Generacion, 
           PO.IdPoliza IdPoliza, 
           F.IdEndoso IdEndoso, 
           OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, TRIM(TO_CHAR(F.IdFactura)) Recibo, 
           OC_MONEDA.MONEDA_ALTERNA(F.Cod_Moneda) Moneda, Monto_Fact_Moneda Prima_Comisinable_Local,
          C.Comision_Moneda Comision
       , C.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       , ' ' STATUSPAGO_F
       ,DECODE(C.Estado,'LIQ', C.comision_moneda,(DECODE(F.StsFact, 'APL', C.comision_moneda, 0))) PAGADO
       ,DECODE(C.Estado, 'REC', SubTotal,0 )    POR_PAGAR,   
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       --------- CASE para poner en Cero Si la fecha de aplicacion es menor al mes en curso  -------        
/*JMMD20210719       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END */    C.Comision_Moneda                                                   CASE_Comision,
/*JMMD20210719       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END  */   MtoIva                                                   CASE_MtoIva,
/*JMMD20210719       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END */  MtoIvaRet                                                     CASE_MtoIvaRet,
/*JMMD20210719      CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0          
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END  */    MtoIsr                                                  CASE_MtoIsr,  
/*JMMD20210719        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END  */   MtoIsrRet                                                   CASE_MtoIsrRet,

/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then SubTotal
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  SubTotal
        END   */  SubTotal                                                    POR_PAGAR_SHOWON,  
        -----
  /*      CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then C.Comision_Moneda
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
        END     */ C.Comision_Moneda                                                  POR_PAGAR_Comision,  
        --    ---
 /*               CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIva
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
        END        */    MtoIva                                           POR_PAGAR_MtoIva,  
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIvaRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
        END    */  MtoIvaRet                                                 POR_PAGAR_MtoIvaRet,  
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
        END  */      MtoIsrRet                                               POR_PAGAR_MtoIsr,          
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN (F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA ) AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
        END     */   MtoIsrRet                                               POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------  
        CASE
          WHEN F.Fecsts < P_FECDESDE OR F.Fecsts > P_FECHASTA THEN 
/*JMMD20210720          WHEN F.Fecsts < P_FECDESDE THEN       0                       
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN */   
                          (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
                            FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
                           WHERE C.CodConcepto      = D.CodCpto
                             AND C.CodCia           = F.CodCia
                             AND (D.IndCptoPrima    = 'S'
                              OR C.IndCptoServicio  = 'S')
                             AND D.IdFactura        = F.IdFactura)
         ELSE 0                    
        END                                                        CASE_MtoPrimaFactura,            
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula,
        AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, ADC.Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
          FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = F.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdFactura        = F.IdFactura) MtoPrimaFactura
      ,C.IDNOMINA NOMINA_COM, 
    CASE 
       WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then null
     END                                                   FECHA_PAGO  
  FROM COMISIONES C , FACTURAS F, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION adc,
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC,
       (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT 
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',         SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA 
                 AND   C2.Cod_Agente   = P_AGENTE                  
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y  
  WHERE C.Estado = 'REC'
   AND TRUNC(C.FEC_ESTADO) BETWEEN '01/07/2019' AND P_FECDESDE - 1  ----- JMMD20210701
--   AND  TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA----- JMMD20210701
   AND C.Cod_Agente   = DECODE(P_AGENTE,NULL,C.Cod_Agente,P_AGENTE)
   AND C.IdFactura    = F.IdFactura
   AND F.StsFact      != 'ANU'
   AND F.IdPoliza     = PO.IdPoliza
   AND F.IdPoliza     = DP.IdPoliza
   AND F.IdetPol      = DP.IdetPol
   AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision
   AND C.Comision_Moneda  != 0
--   AND f.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA
--   AND f.Fecsts < P_FECDESDE   
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente         = AC.Cod_Agente(+)
   AND C.Cod_Agente         = A.Cod_Agente
   AND DP.IdPoliza          = ADC.IdPoliza
   AND DP.IdetPol           = ADC.IdetPol 
   AND ADC.COD_AGENTE_DISTR = C.Cod_Agente  
   AND C.COD_MONEDA = P_MONEDA
UNION
SELECT   ---   '08',  NUEVA
           C.Cod_Agente, 
           OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, 
           A.CodNivel CodNivel,
           NumPolUnico, 
           F.Fecsts Fec_Generacion, 
           PO.IdPoliza IdPoliza, 
           F.IdEndoso IdEndoso, 
           OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, TRIM(TO_CHAR(F.IdFactura)) Recibo, 
           OC_MONEDA.MONEDA_ALTERNA(F.Cod_Moneda) Moneda, Monto_Fact_Moneda Prima_Comisinable_Local,
          C.Comision_Moneda Comision
       , C.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       , ' ' STATUSPAGO_F
       ,DECODE(C.Estado,'LIQ', C.comision_moneda,(DECODE(F.StsFact, 'APL', C.comision_moneda, 0))) PAGADO
-----JMMD20210702       ,DECODE(C.Estado, 'REC', SubTotal,0 )    POR_PAGAR,   
       ,DECODE(C.Estado, 'LIQ', SubTotal,0 )    POR_PAGAR,       
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       --------- CASE para poner en Cero Si la fecha de aplicacion es menor al mes en curso  -------        
/*JMMD20210719        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END  */      C.Comision_Moneda                                                CASE_Comision,
/*JMMD20210719        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END */   MtoIva                                                     CASE_MtoIva,
/*JMMD20210719        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END */   MtoIvaRet                                                     CASE_MtoIvaRet,
/*JMMD20210719       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0          
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END */   MtoIsr                                                     CASE_MtoIsr,  
/*JMMD20210719         CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END  */  MtoIsrRet                                                     CASE_MtoIsrRet,

/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then SubTotal
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  SubTotal
        END   */ SubTotal                                                    POR_PAGAR_SHOWON,  
        -----
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then C.Comision_Moneda
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
        END  */         C.Comision_Moneda                                            POR_PAGAR_Comision,  
        --    ---
/*                CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIva
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
        END  */    MtoIva                                                 POR_PAGAR_MtoIva,  
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIvaRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
        END     */     MtoIvaRet                                             POR_PAGAR_MtoIvaRet,  
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
        END   */    MtoIsrRet                                                POR_PAGAR_MtoIsr,          
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN (F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA ) AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
        END    */     MtoIsrRet                                              POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------  
        CASE
/*  JMMD20210720        WHEN F.Fecsts < P_FECDESDE THEN       0    
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN */
-------
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN 0
          ELSE
-------          
                          (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
                            FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
                           WHERE C.CodConcepto      = D.CodCpto
                             AND C.CodCia           = F.CodCia
                             AND (D.IndCptoPrima    = 'S'
                              OR C.IndCptoServicio  = 'S')
                             AND D.IdFactura        = F.IdFactura)
----- JMMD20210720         ELSE 0                    
        END                                                        CASE_MtoPrimaFactura,            
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula,
        AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, ADC.Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
          FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = F.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdFactura        = F.IdFactura) MtoPrimaFactura
      ,C.IDNOMINA NOMINA_COM, 
    CASE 
       WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then null
     END                                                   FECHA_PAGO  
  FROM COMISIONES C , FACTURAS F, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION adc,
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC,
       (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT 
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',         SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA 
                 AND   C2.Cod_Agente   = P_AGENTE                  
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y  
  WHERE C.Estado = 'LIQ'
   AND TRUNC(C.FEC_ESTADO) BETWEEN '01/07/2019' AND P_FECDESDE - 1  ----- JMMD20210701
   AND  TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA----- JMMD20210701
   AND C.Cod_Agente   = DECODE(P_AGENTE,NULL,C.Cod_Agente,P_AGENTE)
   AND C.IdFactura    = F.IdFactura
   AND F.StsFact      != 'ANU'
   AND F.IdPoliza     = PO.IdPoliza
   AND F.IdPoliza     = DP.IdPoliza
   AND F.IdetPol      = DP.IdetPol
   AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision
   AND C.Comision_Moneda  != 0
--   AND f.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA
--   AND f.Fecsts < P_FECDESDE   
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente         = AC.Cod_Agente(+)
   AND C.Cod_Agente         = A.Cod_Agente
   AND DP.IdPoliza          = ADC.IdPoliza
   AND DP.IdetPol           = ADC.IdetPol 
   AND ADC.COD_AGENTE_DISTR = C.Cod_Agente  
   AND C.COD_MONEDA = P_MONEDA                                      
UNION
SELECT --- '09',
       C.Cod_Agente, OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, A.CodNivel CodNivel,
       NumPolUnico, N.Fecsts Fec_Generacion, PO.IdPoliza IdPoliza, N.IdEndoso IdEndoso, 
       OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, 'NC-' || N.IdNcr Recibo, 
       OC_MONEDA.MONEDA_ALTERNA(N.CodMoneda) Moneda, Monto_Ncr_Moneda Prima_Comisinable_Local,
       C.Comision_Moneda Comision
       , c.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       , N.StsNcr  STATUSPAGO
       --------------------------------,DECODE(N.StsNcr,'APL', (DECODE(C.Estado, 'REC', 0, c.comision_moneda))) PAGADO       AEVS 09102017                
       ,DECODE(N.StsNcr,'PAG', (DECODE(C.Estado, 'REC',c.comision_moneda, 0 ))
                       ,'APL', ((DECODE(C.Estado, 'REC',c.comision_moneda, 0 )))) PAGADO                   
       ,DECODE(N.StsNcr,'PAG', (DECODE(C.Estado, 'REC',SubTotal, 0 ))
                       ,'APL', ((DECODE(C.Estado, 'REC',SubTotal, 0 )))) POR_PAGAR,
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
/*JMMD20210719        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END   */  C.Comision_Moneda                                                  CASE_COMISION,
/*JMMD20210719        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END  */  MtoIva                                                    CASE_MtoIva,
/*JMMD20210719        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END  */  MtoIvaRet                                                    CASE_MtoIvaRet,
/*JMMD20210719       CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END */  MtoIsr                                                     CASE_MtoIsr,  
/*JMMD20210719         CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END  */  MtoIsrRet                                                    CASE_MtoIsrRet,
        ---ETSSSPERIMENTO  FECHAS ---
/*        CASE
          WHEN ( (N.Fecsts  < P_FECDESDE) OR (C.FEC_LIQUIDACION  < P_FECDESDE ))  THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0
          WHEN ( (N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'REC' )) THEN  SubTotal --OR (C.FEC_LIQUIDACION BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')))   THEN  SubTotal-----0 AEVS
          WHEN ( (N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  ) OR (C.FEC_LIQUIDACION BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  ))THEN  SubTotal
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END   */  SubTotal                                                    POR_PAGAR_SHOWON,  
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'REC'  THEN  C.Comision_Moneda----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END   */   C.Comision_Moneda                                                 POR_PAGAR_Comision,  
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN MtoIva ----jmmd20190724 0 ---JMMD 20190521  MtoIva----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END   */     MtoIva                                               POR_PAGAR_MtoIva,  
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN 0 ----JMMD20190521 MtoIvaRet----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL') THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END  */    MtoIvaRet                                                 POR_PAGAR_MtoIvaRet,  
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN 0 ----JMMD20190521 MtoIsr----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END  */  MtoIsr                                                   POR_PAGAR_MtoIsr,          
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN MtoIsrRet----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END   */   MtoIsrRet                                                 POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------          
        CASE       
          WHEN N.Fecsts < P_FECDESDE OR N.Fecsts > P_FECHASTA THEN   
/*JMMD20210720          WHEN N.Fecsts < P_FECDESDE THEN       0                      
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN */
                      (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
                        FROM DETALLE_NOTAS_DE_CREDITO D, CATALOGO_DE_CONCEPTOS C
                       WHERE C.CodConcepto      = D.CodCpto
                         AND C.CodCia           = N.CodCia
                         AND (D.IndCptoPrima    = 'S'
                          OR C.IndCptoServicio  = 'S')
                         AND D.IdNcr            = N.IdNcr)
        ELSE 0  -----JMMD20210720
        END                                                        CASE_MtoPrimaFactura,                
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula, AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
          FROM DETALLE_NOTAS_DE_CREDITO D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = N.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdNcr            = N.IdNcr) MtoPrimaFactura
        ,C.IDNOMINA NOMINA_COMISION,
      --%%%%%%%-----        
    CASE 
       WHEN N.STSNCR IN ('PAG','APL') AND TRUNC(C.FEC_LIQUIDACION) <= P_FECHASTA  THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
       WHEN N.STSNCR IN ('PAG','APL') AND TRUNC(C.FEC_LIQUIDACION) IS NULL THEN NULL
       ELSE NULL  ----- JMMD20210702 TO_CHAR(N.FECSTS, 'DD/MM/YYYY')
     END                                                   FECHA_PAGO            
      
  FROM COMISIONES C, NOTAS_DE_CREDITO N , POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION adc,
       (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT 
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',         SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA 
                 AND   C2.Cod_Agente   = P_AGENTE                 
                 ----AND   C2.FEC_ESTADO BETWEEN P_FECDESDE AND P_FECHASTA
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y,
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC      
       , NCR_FACTEXT XT  
WHERE  C.Cod_Agente   = P_AGENTE
   AND C.COD_MONEDA = P_MONEDA
  ----- AND C.FEC_ESTADO BETWEEN P_FECDESDE AND P_FECHASTA
   AND C.IdNcr        = N.IdNcr
   AND ( N.StsNcr      != 'ANU' and C.Estado ='REC') 
   AND N.IdPoliza     = PO.IdPoliza
   AND N.IdPoliza     = DP.IdPoliza
   AND N.IdetPol      = DP.IdetPol
  AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision  
   AND C.Comision_Moneda  != 0
 --  AND N.Fecsts < P_FECDESDE 
   AND TRUNC(C.FEC_ESTADO) BETWEEN '01/07/2019' AND  P_FECDESDE - 1
--   OR TRUNC(C.FEC_LIQUIDACION)  > P_FECHASTA )
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente            = AC.Cod_Agente(+)
   AND C.Cod_Agente            = A.Cod_Agente
   AND DP.IdPoliza             =  ADC.IdPoliza
   AND DP.IdetPol              = ADC.IdetPol 
   AND DP.CODCIA               = ADC.CODCIA
   AND ADC.COD_AGENTE_DISTR    = C.Cod_Agente 
   and XT.IDNCR(+)             = N.IDNCR  
UNION
SELECT --- '10',
       C.Cod_Agente, OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, A.CodNivel CodNivel,
       NumPolUnico, N.Fecsts Fec_Generacion, PO.IdPoliza IdPoliza, N.IdEndoso IdEndoso, 
       OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, 'NC-' || N.IdNcr Recibo, 
       OC_MONEDA.MONEDA_ALTERNA(N.CodMoneda) Moneda, Monto_Ncr_Moneda Prima_Comisinable_Local,
       C.Comision_Moneda Comision
       , c.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       , N.StsNcr  STATUSPAGO
       --------------------------------,DECODE(N.StsNcr,'APL', (DECODE(C.Estado, 'REC', 0, c.comision_moneda))) PAGADO       AEVS 09102017                
       ,DECODE(N.StsNcr,'PAG', (DECODE(C.Estado, 'REC',c.comision_moneda, 0 ))
                       ,'APL', ((DECODE(C.Estado, 'REC',c.comision_moneda, 0 )))) PAGADO                   
/*       ,DECODE(N.StsNcr,'PAG', (DECODE(C.Estado, 'REC',SubTotal, 0 ))
                       ,'APL', ((DECODE(C.Estado, 'REC',SubTotal, 0 )))) POR_PAGAR,  */ ----- JMMD20210702
       ,DECODE(N.StsNcr,'PAG', (DECODE(C.Estado, 'LIQ',SubTotal, 0 ))
                       ,'APL', ((DECODE(C.Estado, 'LIQ',SubTotal, 0 )))) POR_PAGAR,
                       
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
/*JMMD20210719       CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END  */  C.Comision_Moneda                                                   CASE_COMISION,
/*JMMD20210719       CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END  */  MtoIva                                                    CASE_MtoIva,
/*JMMD20210719       CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END  */ MtoIvaRet                                                     CASE_MtoIvaRet,
/*JMMD20210719      CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END  */ MtoIsr                                                     CASE_MtoIsr,  
/*JMMD20210719        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END   */  MtoIsrRet                                                   CASE_MtoIsrRet,
        ---ETSSSPERIMENTO  FECHAS ---
/*        CASE
          WHEN ( (N.Fecsts  < P_FECDESDE) OR (C.FEC_LIQUIDACION  < P_FECDESDE ))  THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0
          WHEN ( (N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'REC' )) THEN  SubTotal --OR (C.FEC_LIQUIDACION BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')))   THEN  SubTotal-----0 AEVS
          WHEN ( (N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  ) OR (C.FEC_LIQUIDACION BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  ))THEN  SubTotal
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END   */  SubTotal                                                    POR_PAGAR_SHOWON,  
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL') AND C.Estado = 'REC'  THEN  C.Comision_Moneda----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END   */  C.Comision_Moneda                                                  POR_PAGAR_Comision,  
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN MtoIva ----jmmd20190724 0 ---JMMD 20190521  MtoIva----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END  */   MtoIva                                                  POR_PAGAR_MtoIva,  
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN 0 ----JMMD20190521 MtoIvaRet----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL') THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END  */   MtoIvaRet                                                  POR_PAGAR_MtoIvaRet,  
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN 0 ----JMMD20190521 MtoIsr----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END   */   MtoIsr                                                 POR_PAGAR_MtoIsr,          
/*        CASE
          WHEN N.Fecsts < P_FECDESDE THEN 0
          WHEN ( N.STSNCR IN ('PAG','APL') AND C.Estado = 'LIQ')   THEN 0
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND N.STSNCR IN ('PAG','APL')  THEN MtoIsrRet----0 AEVS
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
          WHEN (CASE 
                  WHEN N.STSNCR IN ('PAG','APL') AND  N.FECSTS IS NULL THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
                  WHEN N.STSNCR IN ('PAG','APL')  THEN  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')    ---FECHA_PAGO    
                END  ) > P_FECHASTA THEN 0
        END    */   MtoIsrRet                                                POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------          
        CASE
          WHEN N.Fecsts < P_FECDESDE THEN       0          
          WHEN N.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN 
                      (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
                        FROM DETALLE_NOTAS_DE_CREDITO D, CATALOGO_DE_CONCEPTOS C
                       WHERE C.CodConcepto      = D.CodCpto
                         AND C.CodCia           = N.CodCia
                         AND (D.IndCptoPrima    = 'S'
                          OR C.IndCptoServicio  = 'S')
                         AND D.IdNcr            = N.IdNcr)
        END                                                        CASE_MtoPrimaFactura,                
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula, AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       Porc_Com_Distribuida, Porc_Com_Proporcional, PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(D.Monto_Det_Moneda),0)
          FROM DETALLE_NOTAS_DE_CREDITO D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = N.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdNcr            = N.IdNcr) MtoPrimaFactura
        ,C.IDNOMINA NOMINA_COMISION,
      --%%%%%%%-----        
    CASE 
       WHEN N.STSNCR IN ('PAG','APL') AND TRUNC(C.FEC_LIQUIDACION) <= P_FECHASTA  THEN TO_CHAR(TRUNC(C.FEC_LIQUIDACION), 'DD/MM/YYYY')   
       WHEN N.STSNCR IN ('PAG','APL') AND TRUNC(C.FEC_LIQUIDACION) IS NULL THEN NULL
       ELSE NULL ----- JMMD20210702  TO_CHAR(N.FECSTS, 'DD/MM/YYYY')
     END                                                   FECHA_PAGO            
      
  FROM COMISIONES C, NOTAS_DE_CREDITO N , POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION adc,
       (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT 
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',         SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA 
                 AND   C2.Cod_Agente   = P_AGENTE                 
                 ----AND   C2.FEC_ESTADO BETWEEN P_FECDESDE AND P_FECHASTA
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y,
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC      
       , NCR_FACTEXT XT  
WHERE  C.Cod_Agente   = P_AGENTE
   AND C.COD_MONEDA = P_MONEDA
  ----- AND C.FEC_ESTADO BETWEEN P_FECDESDE AND P_FECHASTA
   AND C.IdNcr        = N.IdNcr
   AND ( N.StsNcr      != 'ANU' and C.Estado ='LIQ') 
   AND N.IdPoliza     = PO.IdPoliza
   AND N.IdPoliza     = DP.IdPoliza
   AND N.IdetPol      = DP.IdetPol
  AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision  
   AND C.Comision_Moneda  != 0
 --  AND N.Fecsts < P_FECDESDE 
   AND (TRUNC(C.FEC_ESTADO) BETWEEN '01/07/2019' AND  P_FECDESDE - 1
   AND TRUNC(C.FEC_LIQUIDACION)  > P_FECHASTA )
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente            = AC.Cod_Agente(+)
   AND C.Cod_Agente            = A.Cod_Agente
   AND DP.IdPoliza             =  ADC.IdPoliza
   AND DP.IdetPol              = ADC.IdetPol 
   AND DP.CODCIA               = ADC.CODCIA
   AND ADC.COD_AGENTE_DISTR    = C.Cod_Agente 
   and XT.IDNCR(+)             = N.IDNCR  
UNION ----- 11
 SELECT   ---   '11',  NUEVA
           C.Cod_Agente, 
           OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
           OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', PC.CodTipoPlan) Ramo, 
           A.CodNivel CodNivel,
           NumPolUnico, 
           F.Fecsts Fec_Generacion, 
           PO.IdPoliza IdPoliza, 
           F.IdEndoso IdEndoso, 
           OC_CLIENTES.NOMBRE_CLIENTE(PO.CodCliente) NomCliente, TRIM(TO_CHAR(F.IdFactura)) Recibo, 
           OC_MONEDA.MONEDA_ALTERNA(F.Cod_Moneda) Moneda, Monto_Fact_Moneda Prima_Comisinable_Local,
          C.Comision_Moneda Comision
       , C.comision_moneda COMI_MONEDA
       , C.Estado  STT_COMISION
       , ' ' STATUSPAGO_F
       ,DECODE(C.Estado,'LIQ', C.comision_moneda,(DECODE(F.StsFact, 'APL', C.comision_moneda, 0))) PAGADO
       ,DECODE(C.Estado, 'REC', SubTotal,0 )    POR_PAGAR,   
       MtoIva, MtoIvaRet, MtoIsr, MtoIsrRet, SubTotal, 
       --------- CASE para poner en Cero Si la fecha de aplicacion es menor al mes en curso  -------        
/*JMMD20210719       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN C.Comision_Moneda
        END  */  C.Comision_Moneda                                                    CASE_Comision,
/*JMMD20210719       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIva
        END */   MtoIva                                                    CASE_MtoIva,
/*JMMD20210719       CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIvaRet
        END  */   MtoIvaRet                                                   CASE_MtoIvaRet,
/*JMMD20210719      CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0          
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsr
        END  */   MtoIsr                                                   CASE_MtoIsr,  
/*JMMD20210719        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0         
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN MtoIsrRet
        END */  MtoIsrRet                                                     CASE_MtoIsrRet,

/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then SubTotal
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  SubTotal
        END   */  SubTotal                                                    POR_PAGAR_SHOWON,  
        -----
  /*      CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then C.Comision_Moneda
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  C.Comision_Moneda
        END     */ C.Comision_Moneda                                                  POR_PAGAR_Comision,  
        --    ---
 /*               CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIva
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIva
        END        */    MtoIva                                           POR_PAGAR_MtoIva,  
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.STSFACT  = 'PAG' and  f.Fecsts < P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then MtoIvaRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIvaRet
        END    */  MtoIvaRet                                                 POR_PAGAR_MtoIvaRet,  
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsr
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
        END  */      MtoIsrRet                                               POR_PAGAR_MtoIsr,          
        --    ---
/*        CASE
          WHEN F.Fecsts < P_FECDESDE THEN 0
          WHEN (F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA ) AND  F.STSFACT  = 'PAG'   THEN MtoIsrRet
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA  AND C.Estado = 'REC'  THEN  MtoIsrRet
        END     */   MtoIsrRet                                               POR_PAGAR_MtoIsrRet,         
        ----  ETSSPERIMENTO  OFF ------------------------------  
        CASE
          WHEN F.Fecsts < P_FECDESDE OR F.Fecsts > P_FECHASTA THEN    ----- JMMD20210720  
/*JMMD20210720          WHEN F.Fecsts < P_FECDESDE THEN       0          
          WHEN F.Fecsts BETWEEN P_FECDESDE AND P_FECHASTA THEN */
                          (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
                            FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
                           WHERE C.CodConcepto      = D.CodCpto
                             AND C.CodCia           = F.CodCia
                             AND (D.IndCptoPrima    = 'S'
                              OR C.IndCptoServicio  = 'S')
                             AND D.IdFactura        = F.IdFactura)
         ELSE 0                    
        END                                                        CASE_MtoPrimaFactura,            
       DECODE(SIGN(SubTotal), -1, SubTotal, 0) En_contra, PC.CodTipoPlan CodTipoPlan,
       DECODE(SIGN(SubTotal), -1, 0, SubTotal) A_FAVOR, C.IdComision IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula,
        AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       ADC.Porc_Com_Distribuida, ADC.Porc_Com_Proporcional, 
       PO.PrimaNeta_Moneda Prima_Net,
       (SELECT NVL(SUM(NVL(D.Monto_Det_Moneda,0)),0)
          FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
         WHERE C.CodConcepto      = D.CodCpto
           AND C.CodCia           = F.CodCia
           AND (D.IndCptoPrima    = 'S'
            OR C.IndCptoServicio  = 'S')
           AND D.IdFactura        = F.IdFactura) MtoPrimaFactura
      ,C.IDNOMINA NOMINA_COM, 
    CASE 
       WHEN F.STSFACT  = 'PAG' and  f.Fecsts <= P_FECHASTA and TRUNC(C.FEC_LIQUIDACION) > P_FECHASTA then null
     END                                                   FECHA_PAGO  
  FROM COMISIONES C , FACTURAS F, POLIZAS PO, DETALLE_POLIZA DP, 
       TIPOS_DE_SEGUROS PC, AGENTES_DISTRIBUCION_COMISION adc,
       AGENTES A, PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC,
       (SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
              SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
              SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
         FROM (SELECT 
                      DC.CodCia, 
                      DC.IdComision,
                      DECODE(DC.CodConcepto, 'COMISI',    SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'HONORA', SUM(NVL(DC.Monto_mon_extranjera,0)),0) +
                      DECODE(DC.CodConcepto, 'UDI',          SUM(NVL(DC.Monto_mon_extranjera,0)),0) MtoComisi,
                      DECODE(DC.CodConcepto, 'IVASIN',    SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIva,
                      DECODE(DC.CodConcepto, 'RETIVA',  SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIvaRet, 
                      DECODE(DC.CodConcepto, 'ISR',         SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsr, 
                      DECODE(DC.CodConcepto, 'RETISR', SUM(NVL(DC.Monto_mon_extranjera,0)), 0) MtoIsrRet
                 FROM COMISIONES       C2, 
                      DETALLE_COMISION DC                      
                 WHERE C2.CODCIA       = P_CODCIA 
                 AND   C2.Cod_Agente   = P_AGENTE                  
                 AND   DC.CODCIA     = C2.CODCIA
                 AND   DC.IDCOMISION = C2.IDCOMISION
                GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
        GROUP BY CodCia, IdComision) Y  
  WHERE C.Estado = 'PRY'
   AND TRUNC(C.FEC_ESTADO) > P_FECHASTA
   AND C.Cod_Agente   = DECODE(P_AGENTE,NULL,C.Cod_Agente,P_AGENTE)
   AND C.IdFactura    = F.IdFactura
   AND F.StsFact      = 'ANU'
   AND F.MOTIVANUL    = 'CCO'      
   AND F.IdPoliza     = PO.IdPoliza
   AND F.IdPoliza     = DP.IdPoliza
   AND F.IdetPol      = DP.IdetPol
   AND DP.CodCia      = PC.CodCia
   AND DP.CodEmpresa  = PC.CodEmpresa
   AND DP.IdTipoSeg   = PC.IdTipoSeg
   AND C.CodCia       = Y.CodCia
   AND C.IdComision   = Y.IdComision
   AND C.Comision_Moneda  != 0
   AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
   AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
   AND A.Cod_Agente         = AC.Cod_Agente(+)
   AND C.Cod_Agente         = A.Cod_Agente
   AND DP.IdPoliza          = ADC.IdPoliza
   AND DP.IdetPol           = ADC.IdetPol 
   AND ADC.COD_AGENTE_DISTR = C.Cod_Agente  
   AND C.COD_MONEDA = P_MONEDA

      
 ---------------------------------------------------------- JMMD20210115 SEAGREGA DUMMY
/* UNION
SELECT --- DUMMY, 
       A.COD_AGENTE AGENTE , OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,  
       NULL Ramo, a.codnivel CodNivel,
       NULL, SYSDATE Fec_Generacion, 99999999999 IdPoliza, 0 IdEndoso, 
       NULL NomCliente, '9999999' Recibo, 
       'M.N' Moneda, 0 Prima_Comisinable_Local
       , 0 Comision
       , 0 COMI_MONEDA
       , NULL  STT_COMISION
       , 'NIDENT' STATUSPAGO
       ,0 PAGADO
       ,0 POR_PAGAR,
       ---------
       0 MtoIva, 0 MtoIvaRet, 0 MtoIsr, 0 MtoIsrRet, 0 SubTotal, 
       --------- 
       0  CASE_Comision,        
       0  CASE_MtoIva,      
       0  CASE_MtoIvaRet,      
       0  CASE_MtoIsr,        
       0 CASE_MtoIsrRet, 
       --------------------------------------------------------------------------------            
       0  POR_PAGAR_SHOWON,
       0  POR_PAGAR_Comision,
       0  POR_PAGAR_MtoIva,
       0  POR_PAGAR_MtoIvaRet,
       0  POR_PAGAR_MtoIsr,
       0  POR_PAGAR_MtoIsrRet,
       ----------------------
       0  CASE_MtoPrimaFactura,               
       ---------                       
       0 En_contra,  NULL  CodTipoPlan,
       0 A_FAVOR, 0 IdComision,
       P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno Nombre,
       OC_AGENTES.DIRECCION_AGENTE(a.Cod_Agente) DirecRes,
       P.Num_Tributario, AC.NumCedula, AC.FecVencimiento, P.Tipo_Persona, P.Num_Doc_Identificacion,
       0 Porc_Com_Distribuida, 0 Porc_Com_Proporcional, 0 Prima_Net,
       0 MtoPrimaFactura
       ,0 IDNOMINA,
       NULL     FECHA_PAGO
FROM AGENTES A,
PERSONA_NATURAL_JURIDICA P, AGENTES_CEDULA_AUTORIZADA AC
 WHERE  A.COD_AGENTE = P_AGENTE
   AND p.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
   AND p.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
   AND AC.Cod_Agente(+)         = A.Cod_Agente  */

--------------------------------------------------------- 
 ORDER BY  1,2,6 --3- --RSR 16032016----CodNivel, CodTipoPlan, IdPoliza, IdComision 
;  
--
BEGIN
      FOR D IN DETALLES LOOP
          --
          TH_T_EDOCTASALDOS.GRABA_MOVIMIENTO(D.COD_AGENTE,P_FECDESDE , P_FECHASTA,
                                             D.NIVEL_AGENTE,D.RAMO, D.CODNIVEL,
                                             D.NUMPOLUNICO,D.FEC_GENERACION,D.IDPOLIZA ,D.IDENDOSO,
                                             D.NOMCLIENTE , D.RECIBO,D.MONEDA ,D.PRIMA_COMISINABLE_LOCAL,
                                             D.COMISION ,D.COMI_MONEDA,D.STT_COMISION ,D.STATUSPAGO_F ,
                                             D.PAGADO ,D.POR_PAGAR ,D.MTOIVA ,D.MTOIVARET ,
                                             D.MTOISR ,D.MTOISRRET ,D.SUBTOTAL,D.CASE_COMISION ,
                                             D.CASE_MTOIVA ,D.CASE_MTOIVARET ,D.CASE_MTOISR ,D.CASE_MTOISRRET ,
                                             D.POR_PAGAR_SHOWON ,D.POR_PAGAR_COMISION ,D.POR_PAGAR_MTOIVA ,
                                             D.POR_PAGAR_MTOIVARET ,D.POR_PAGAR_MTOISRRET ,D.CASE_MTOPRIMAFACTURA ,
                                             D.EN_CONTRA ,D.CODTIPOPLAN ,D.A_FAVOR ,D.IDCOMISION ,D.NOMBRE ,    
                                             D.DIRECRES,D.NUM_TRIBUTARIO,D.NUMCEDULA ,D.FECVENCIMIENTO ,
                                             D.TIPO_PERSONA ,D.NUM_DOC_IDENTIFICACION ,D.Porc_Com_Distribuida,
                                             D.PORC_COM_PROPORCIONAL ,D.PRIMA_NET ,D.MTOPRIMAFACTURA ,
                                             D.NOMINA_COM ,D.FECHA_PAGO );
--          DBMS_OUTPUT.PUT_LINE(D.ORDEN||' - '||D.CONCEPTO||' - '||D.MONTO||' - '||W_TIPOFONDO||' - '||D.FECHA);
          --
      END LOOP;
  --
END CARGA_DETALLE_SALDOS;
--
PROCEDURE GRABA_MOVIMIENTO(P_COD_AGENTE                      NUMBER,
                            P_FECHA_DESDE                    DATE,                            
                            P_FECHA_HASTA                    DATE,
                            P_NIVEL_AGENTE                   VARCHAR2,
                            P_DESCRIPCION_RAMO               VARCHAR2,        
                            P_CODNIVEL                       NUMBER,
                            P_NUMPOLUNICO                    VARCHAR2,
                            P_FEC_GENERACION                 DATE,
                            P_IDPOLIZA                       NUMBER,
                            P_IDENDOSO                       VARCHAR2,
                            P_NOMCLIENTE                     VARCHAR2,    
                            P_RECIBO                         VARCHAR2,
                            P_MONEDA                         VARCHAR2,
                            P_PRIMA_COMISINABLE_LOCAL        NUMBER,
                            P_MONTO_COMISION                 NUMBER,
                            P_COMI_MONEDA                    NUMBER,
                            P_STT_COMISION                   VARCHAR2,
                            P_STATUS_PAGOF                   VARCHAR2,
                            P_PAGADO                         NUMBER,
                            P_POR_PAGAR                      NUMBER,
                            P_MTOIVA                         NUMBER,
                            P_MTOIVARET                      NUMBER,
                            P_MTOISR                         NUMBER,
                            P_MTOISRRET                      NUMBER,
                            P_SUBTOTAL                       NUMBER,
                            P_CASE_COMISION                  NUMBER,
                            P_CASE_MTOIVA                    NUMBER,
                            P_CASE_MTOIVARET                 NUMBER,
                            P_CASE_MTOISR                    NUMBER,
                            P_CASE_MTOISRRET                 NUMBER,
                            P_POR_PAGAR_SHOWON               NUMBER,
                            P_POR_PAGAR_COMISION             NUMBER,
                            P_POR_PAGAR_MTOIVA               NUMBER,
                            P_POR_PAGAR_MTOIVARET            NUMBER,
                            P_POR_PAGAR_MTOISR               NUMBER,
                            P_CASE_MTOPRIMAFACTURA           NUMBER,
                            P_EN_CONTRA                      NUMBER,
                            P_CODTIPOPLAN                    VARCHAR2,
                            P_A_FAVOR                        NUMBER,
                            P_IDCOMISION                     NUMBER,
                            P_NOMBRE_AGENTE                  VARCHAR2  ,    
                            P_DIRECRES                       VARCHAR2  ,    
                            P_NUM_TRIBUTARIO                 VARCHAR2,
                            P_NUMCEDULA                      VARCHAR2,
                            P_FECVENCIMIENTO                 DATE,
                            P_TIPO_PERSONA                   VARCHAR2,
                            P_NUM_DOC_IDENTIFICACION         VARCHAR2,
                            P_POR_COM_DISTRIBUIDA            NUMBER,
                            P_PORC_COM_PROPORCIONAL          NUMBER,
                            P_PRIMA_NETA                     NUMBER,
                            P_MTOPRIMAFACTURA                NUMBER,
                            P_NOMINA_COM                     NUMBER,
                            P_FECHA_PAGO                     DATE) IS
--
BEGIN
  --
  INSERT INTO T_EDOSCTA_ARRASTRE 
    (COD_AGENTE,FECHA_DESDE, FECHA_HASTA, NIVEL_AGENTE,DESCRIPCION_RAMO, CODNIVEL,
     NUMPOLUNICO,FEC_GENERACION,IDPOLIZA ,IDENDOSO,NOMCLIENTE ,    
     RECIBO,MONEDA ,PRIMA_COMISINABLE_LOCAL,MONTO_COMISION ,
     COMI_MONEDA,STT_COMISION ,STATUS_PAGOF ,PAGADO ,
     POR_PAGAR ,MTOIVA ,MTOIVARET ,MTOISR ,
     MTOISRRET ,SUBTOTAL,CASE_COMISION ,CASE_MTOIVA ,
     CASE_MTOIVARET ,CASE_MTOISR ,CASE_MTOISRRET ,POR_PAGAR_SHOWON ,
     POR_PAGAR_COMISION ,POR_PAGAR_MTOIVA ,POR_PAGAR_MTOIVARET ,POR_PAGAR_MTOISR ,
     CASE_MTOPRIMAFACTURA ,EN_CONTRA ,CODTIPOPLAN ,A_FAVOR ,
     IDCOMISION ,NOMBRE_AGENTE , DIRECRES, NUM_TRIBUTARIO,
     NUMCEDULA ,FECVENCIMIENTO ,TIPO_PERSONA ,NUM_DOC_IDENTIFICACION ,
     POR_COM_DISTRIBUIDA ,PORC_COM_PROPORCIONAL ,PRIMA_NETA ,MTOPRIMAFACTURA ,
     NOMINA_COM , FECHA_PAGO)
  VALUES
    (P_COD_AGENTE ,  P_FECHA_DESDE , P_FECHA_HASTA ,
     P_NIVEL_AGENTE , P_DESCRIPCION_RAMO, P_CODNIVEL ,
     P_NUMPOLUNICO , P_FEC_GENERACION  , P_IDPOLIZA  , P_IDENDOSO  ,
     P_NOMCLIENTE ,  P_RECIBO , P_MONEDA, P_PRIMA_COMISINABLE_LOCAL ,
     P_MONTO_COMISION,P_COMI_MONEDA ,P_STT_COMISION ,P_STATUS_PAGOF ,
     P_PAGADO , P_POR_PAGAR, P_MTOIVA , P_MTOIVARET ,
     P_MTOISR , P_MTOISRRET  , P_SUBTOTAL , P_CASE_COMISION ,P_CASE_MTOIVA ,
     P_CASE_MTOIVARET , P_CASE_MTOISR , P_CASE_MTOISRRET ,P_POR_PAGAR_SHOWON ,
     P_POR_PAGAR_COMISION , P_POR_PAGAR_MTOIVA ,P_POR_PAGAR_MTOIVARET ,
     P_POR_PAGAR_MTOISR , P_CASE_MTOPRIMAFACTURA , P_EN_CONTRA ,
     P_CODTIPOPLAN , P_A_FAVOR , P_IDCOMISION , P_NOMBRE_AGENTE  ,    
     P_DIRECRES  ,  P_NUM_TRIBUTARIO  , P_NUMCEDULA  , P_FECVENCIMIENTO ,
     P_TIPO_PERSONA  , P_NUM_DOC_IDENTIFICACION , P_POR_COM_DISTRIBUIDA,
     P_PORC_COM_PROPORCIONAL  , P_PRIMA_NETA , P_MTOPRIMAFACTURA  ,P_NOMINA_COM ,P_FECHA_PAGO);
  --
  COMMIT;   
  --  
END GRABA_MOVIMIENTO;
--
--
--
PROCEDURE BORRA_MOVIMIENTO(P_COD_AGENTE NUMBER,
                           P_FECHA_DESDE DATE,
                           P_FECHA_HASTA DATE  ) IS
--
BEGIN
  --
  DELETE T_EDOSCTA_ARRASTRE 
    WHERE COD_AGENTE    = P_COD_AGENTE
      AND FECHA_DESDE   = P_FECHA_DESDE
      AND FECHA_HASTA   = P_FECHA_HASTA ;
  --
  COMMIT;   
  --  
END BORRA_MOVIMIENTO;
--
--
END TH_T_EDOCTASALDOS;
/

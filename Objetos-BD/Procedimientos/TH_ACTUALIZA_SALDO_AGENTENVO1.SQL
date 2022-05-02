CREATE OR REPLACE PROCEDURE TH_ACTUALIZA_SALDO_AGENTENVO1  IS
----- JMMD20210623          SE AGREGA QUERY PARA RECUPERAR RECIBOS QUE SE PAGAN Y DESPAGAN EL MISMO DIA
----- JMMD20210721          SE AGREGA VALIDACION PARA CAMBIO DE COMISIONES DE FACTURAS Y NOTAS DE CREDITO
----- JMMD20210806          SE COMPLEMENTA QUERY PARA RECUPERAR RECIBOS QUE SE PAGAN Y DESPAGAN EL MISMO DIA
----- JMMD20210813          SE COMPLEMENTA QUERY PARA RECUPERAR RECIBOS QUE SE PAGAN VARIAS VECES EL MISMO RECIBO EN EL MISMO DIA
----- JMMD20210823          SE COMPLEMENTA QUERY PARA RECUPERAR RECIBOS QUE SE DESPAGAN Y SE HACE UN ENDOSO DE CANCELACION POR REEXPEDICION
----- JMMD20210902          SE COMPLEMENTA QUERY PARA RECUPERAR TODOS LOS RECIBOS QUE SE PAGAN SIN IMPORTAR EL STATUS DEL RECIBO EN FACTURAS
----- JMMD20211007          SE COMPLEMENTA QUERY PARA EVITAR DUPLICIDAD DE RECIBOS ANULADOS POR CAMBIO DE COMISIONES
---- JMMD20211103-20211112  SE COMENTA UN QUERY DEL CURSOR PARA EVITAR DUPLICIDAD EN DESPAGOS
---- JMMD20220502           SE AGREGA CODIGO DE RAMOS PARA POLIZAS VIFLEX '099'

nCdAgente          AGENTES.COD_AGENTE%TYPE;

nMtoIsr            DETALLE_COMISION.MONTO_MON_LOCAL%TYPE; 

nMtoIva            DETALLE_COMISION.MONTO_MON_LOCAL%TYPE; 
nMtoIvaRet         DETALLE_COMISION.MONTO_MON_LOCAL%TYPE; 
nMtoIsrRet         DETALLE_COMISION.MONTO_MON_LOCAL%TYPE; 
cCodTipoPlan       TIPOS_DE_SEGUROS.CODTIPOPLAN%TYPE;
nMtoEnContra       DETALLE_COMISION.MONTO_MON_LOCAL%TYPE; 
nMtoAFavor         DETALLE_COMISION.MONTO_MON_LOCAL%TYPE; 
nOtrosMovtos       DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nSALDO_FINAL       DETALLE_COMISION.MONTO_MON_LOCAL%TYPE :=0;
nMT_SALDO_INICIAL     DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_SALDO_FINAL        DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nPagado_mes            DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;            
nA_Favor_mes       DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nEn_Contra_mes     DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nPOR_PAGAR_COMISION_MES      DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMtoComi_moneda_Mes DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMtoIva_Mes         DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMtoIvaRet_Mes      DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMtoIsr_Mes         DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMtoIsrRet_Mes      DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMtoComi_moneda     DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nSubtotal           DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_COM_TOT            DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_IVA_TOT            DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_IVARET_TOT        DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_ISR_TOT            DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_ISRRET_TOT        DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_SUBTOTAL_TOT      DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_ENCONTRA_TOT      DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nMT_AFAVOR_TOT        DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nEn_Contra            DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nA_Favor               DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;

nComision              DETALLE_COMISION.MONTO_MON_LOCAL%TYPE; 
nIva                   DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nIvaret                DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nIsr                   DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nIsrret                DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;

nPAGO_COMISION         DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nPAGO_IVA              DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nPAGO_IVARET           DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nPAGO_ISR              DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nPAGO_ISRRET           DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nTOTAL_PAGO            DETALLE_COMISION.MONTO_MON_LOCAL%TYPE;
nCOD_AGENTEPAGO        AGENTES.COD_AGENTE%TYPE;
cRamoPago              tipos_de_seguros.codtipoplan%type;

cCodUser               VARCHAR2(30);
W_ID_TERMINAL          CONTROL_PROCESOS_AUTOMATICOS.ID_TERMINAL%TYPE;
W_ID_USER              CONTROL_PROCESOS_AUTOMATICOS.ID_USER%TYPE;
W_ID_ENVIO             CONTROL_PROCESOS_AUTOMATICOS.ID_ENVIO%TYPE;
----
cCodMoneda             VARCHAR2(5) := '%';
  
nCodCia                NUMBER := 1;
nCodEmpresa            NUMBER := 1;
cNomCia                VARCHAR2(100);

dFecDesde              DATE;
dFecHasta              DATE;
dFecDesdeMesSig        DATE;
dFecHastaMesSig        DATE;
dfechaControl          DATE;
dfechaControlFin       DATE;
nSPV                   NUMBER := 0;
----

CURSOR AGENTES_Q IS
SELECT A.COD_AGENTE, VL.CODVALOR,MO.COD_MONEDA
FROM AGENTES A,
VALORES_DE_LISTAS VL,
MONEDA MO
WHERE CODLISTA = 'CODRAMOS'
AND CODVALOR IN('010', '030','099')
--AND A.COD_AGENTE in(3479)
AND COD_MONEDA IN('PS','USD')
ORDER BY COD_AGENTE, COD_MONEDA, CODVALOR;      

---------------------------   INICIA PROCEDIMIENTO --------------------------------------

BEGIN
   SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID')
     INTO cCodUser
     FROM DUAL;
  
    SELECT SYS_CONTEXT('userenv', 'terminal'), 
           USER
      INTO W_ID_TERMINAL,
           W_ID_USER
      FROM DUAL;
----
     INSERT INTO CONTROL_PROCESOS_AUTOMATICOS
      VALUES('TH_ACTUALIZA_SALDO_AGENTENVO1',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
      --
      COMMIT;  
----
    select 
    TRUNC(sysdate - 1) first,
    TRUNC(sysdate - 1) last,
    TRUNC(sysdate - 1) control    

-----   to_date('15/'|| 06 ||'/' ||(to_char(sysdate, 'YYYY') ), 'dd/mm/yyyy') first  ,    
-----   to_date('15/'|| 06 ||'/' ||(to_char(sysdate, 'YYYY') ), 'dd/mm/yyyy') last    ,
-----   to_date('21/'|| 06 ||'/' ||(to_char(sysdate, 'YYYY') ), 'dd/mm/yyyy') control    

  INTO dFecDesde, dFecHasta, dFechacontrolFin
  from  dual ;
  
  dbms_output.put_line('jmmd1 dFecDesde '||dFecDesde);

  dbms_output.put_line(' dFechacontrolFin '||dFechacontrolFin);
          
   BEGIN
      SELECT NomCia
        INTO cNomCia
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cNomCia := 'COMPAÑIA - NO EXISTE!!!';
   END ;
         
  dbms_output.put_line('dPrimerDia '||dFecDesde);
  dbms_output.put_line('dUltimoDia '||dFecHasta);
  dbms_output.put_line('dFecDesdeMesSig '||dFecDesdeMesSig);
  dbms_output.put_line('dFecHastaMesSig '||dFecHastaMesSig);  
----
WHILE dFecHasta <= dfechaControlFin LOOP

  SELECT dFecHasta + 1 , dFecHasta + 1
    INTO dFecDesdeMesSig, dFecHastaMesSig
    from dual;
    
FOR X IN AGENTES_Q LOOP
      nCdAgente := X.COD_AGENTE;
      nSPV := 0;
      nCdAgente := X.COD_AGENTE;
 ------       dbms_output.put_line('JMMD EN FOR X  COD_AGENTE '||X.COD_AGENTE ||'  RAMO  '||X.CODVALOR||'  MONEDA  '||X.COD_MONEDA);
    BEGIN
     SELECT  nvl(SCM.MT_SALDO_INICIAL,0), nvl(SCM.MT_SALDO_FINAL,0), NVL(SCM.MT_IVA_MES,0), NVL(SCM.MT_IVARET_MES,0),
             NVL(SCM.MT_ISR_MES,0), NVL(SCM.MT_ISRRET_MES,0), NVL(SCM.MT_ENCONTRA_MES,0), NVL(SCM.MT_AFAVOR_MES,0)
       INTO nMT_SALDO_INICIAL  , nMT_SALDO_FINAL,nMtoIva, nMtoIvaRet, nMtoIsr, nMtoIsrRet, nMtoEnContra, nMtoAFavor
       FROM SALDOS_COMISIONES_MES SCM
      WHERE SCM.CD_AGENTE        = X.COD_AGENTE    
        AND SCM.FE_INI_SALDO     = dFecDesde
--        AND SCM.FE_INI_SALDO     = dFecHasta         
        AND SCM.CD_TIPO_RAMO     = X.CODVALOR
        AND SCM.CD_MONEDA  = X.COD_MONEDA;
     EXCEPTION WHEN OTHERS THEN
           nSPV := 1;
           nMT_SALDO_INICIAL := 0;
           nMT_SALDO_FINAL   := 0; 
           nMtoIva           := 0;
           nMtoIvaRet        := 0;
           nMtoIsr           := 0;
           nMtoIsrRet        := 0;
           nMtoEnContra      := 0;
           nMtoAFavor        := 0;
 --          DBMS_OUTPUT.put_line('JMMD NO 1   '||SQLERRM||' nSPV  '||nSPV );  
     END;    
        
   ----------------
          nMtoComi_moneda_Mes := 0; 
          nMtoIva_Mes         := 0;
          nMtoIvaRet_Mes      := 0;
          nMtoIsr_Mes         := 0;
          nMtoIsrRet_Mes      := 0;
          nA_Favor_mes        := 0; 
          nEn_Contra_mes      := 0;
          nPOR_PAGAR_COMISION_MES := 0;
          nPagado_mes         := 0;
          nSALDO_FINAL        := 0;
          
         BEGIN 
 --        SELECT SUM(Comision) ,SUM(POR_PAGAR_MTOIVA), SUM(POR_PAGAR_MTOIVARET), SUM(POR_PAGAR_MtoIsr), SUM(POR_PAGAR_MTOISRRET), 
   --      SUM(A_FAVOR), SUM(EN_CONTRA),SUM(POR_PAGAR_COMISION),SUM(PAGADO),X.CODVALOR        
           SELECT NVL(SUM(COMISION),0), NVL(SUM(MONTO_IVA),0), NVL(SUM(MONTO_IVARET),0), NVL(SUM(MONTO_ISR),0), NVL(SUM(MONTO_ISRRET),0),
                  NVL(SUM(EN_CONTRA),0), NVL(SUM(A_FAVOR),0),NVL(SUM(PAGADO),0) , X.CODVALOR
        INTO  nMtoComi_moneda_Mes, nMtoIva_Mes, nMtoIvaRet_Mes,nMtoIsr_Mes, nMtoIsrRet_Mes, nEn_Contra_mes, nA_Favor_mes, 
              nPagado_mes,cCodTipoPlan
        FROM (

select C.IDFACTURA, C.IDNCR, 
--                    C.Comision_Moneda Comision  -- jmmd20201204 se cambio por case de abajo
       case 
       WHEN trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta  AND trunc(C.FEC_ESTADO) = TRUNC(C.FEC_LIQUIDACION) THEN 0  -----JMMD20211007       
       when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda
       else 0
       end  Comision ,
       C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
       Y.MTOCOMISI MONTO_COMISION, 
       case 
       WHEN trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta  AND trunc(C.FEC_ESTADO) = TRUNC(C.FEC_LIQUIDACION) THEN 0  -----JMMD20211007       
       when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA
       else 0
       end  MONTO_IVA, 
       case 
       WHEN trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta  AND trunc(C.FEC_ESTADO) = TRUNC(C.FEC_LIQUIDACION) THEN 0  -----JMMD20211007       
       when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET
       else 0
       end  MONTO_IVARET, 
       case 
       WHEN trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta  AND trunc(C.FEC_ESTADO) = TRUNC(C.FEC_LIQUIDACION) THEN 0  -----JMMD20211007       
       when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR
       else 0
       end   MONTO_ISR, 
       case 
       WHEN trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta  AND trunc(C.FEC_ESTADO) = TRUNC(C.FEC_LIQUIDACION) THEN 0  -----JMMD20211007       
       when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET
       else 0
       end  MONTO_ISRRET, 
       Y.SUBTOTAL MONTO_SUBTOTAL,
               DECODE(SIGN(Y.SubTotal), -1, Y.SubTotal, 0) En_contra,-- PC.CodTipoPlan CodTipoPlan,                            
               DECODE(SIGN(Y.SubTotal), -1, 0, Y.SubTotal) A_FAVOR, 
               CASE 
                  WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
                  THEN  C.comision_moneda
                   ELSE 0
               END   PAGADO,                  
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                  
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
FACTURAS         F                                   
where C.cod_agente = X.COD_AGENTE
----- and C.estado != 'PRY' ----20210813
and C.estado NOT IN( 'PRY','REC')
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND F.IDFACTURA = C.IDFACTURA
UNION ALL  ----- NOTAS DE CREDITO
select C.IDFACTURA, C.IDNCR, 
--C.COMISION_MONEDA COMISION, 
   case when
      trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda
      else 0
   end  Comision ,
C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
       Y.MTOCOMISI MONTO_COMISION, 
----- JMMD202101/20       Y.MTOIVA MONTO_IVA, Y.MTOIVARET MONTO_IVARET, Y.MTOISR MONTO_ISR, Y.MTOISRRET MONTO_ISRRET, 
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA
           else 0
       end  MONTO_IVA, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET
          else 0
       end  MONTO_IVARET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR
          else 0
       end   MONTO_ISR, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET
          else 0
       end  MONTO_ISRRET, 

Y.SUBTOTAL MONTO_SUBTOTAL,
               DECODE(SIGN(Y.SubTotal), -1, Y.SubTotal, 0) En_contra,-- PC.CodTipoPlan CodTipoPlan,                            
               DECODE(SIGN(Y.SubTotal), -1, 0, Y.SubTotal) A_FAVOR, 
               CASE 
                  WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
                  THEN  C.comision_moneda
                   ELSE 0
               END   PAGADO,                  
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                 
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
NOTAS_DE_CREDITO NC                                 
where C.cod_agente = X.COD_AGENTE
and C.estado NOT IN( 'PRY')
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
--AND IDFACTURA = 260176
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND NC.IDNCR = C.IDNCR
/*UNION ALL ----- CAMBIO DE COMISIONES FACTURAS  ----- JMMD20211001 
select C.IDFACTURA, C.IDNCR, 
--                    C.Comision_Moneda Comision  -- jmmd20201204 se cambio por case de abajo
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda * -1
       else 0
       end  Comision ,
       C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then 
           Y.MTOCOMISI * -1       
        else 0
       end  MONTO_COMISION,    
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA * -1
           else 0
       end  MONTO_IVA, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET * -1
          else 0
       end  MONTO_IVARET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR * -1      
          else 0
       end   MONTO_ISR, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET * -1           
          else 0
       end  MONTO_ISRRET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then
           Y.SUBTOTAL * -1                  
          else 0
       end  MONTO_SUBTOTAL, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then
           DECODE(SIGN(Y.SubTotal * -1), -1, Y.SubTotal, 0)                 
          else 0
       end  En_contra, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then 
           DECODE(SIGN(Y.SubTotal * -1), -1, 0, Y.SubTotal)                 
          else 0
       end  A_FAVOR,               

       CASE 
          WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
          THEN  C.comision_moneda * -1
           ELSE 0
       END   PAGADO,             
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                  
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
FACTURAS         F                                   
where C.cod_agente = X.COD_AGENTE
and C.estado = 'PRY'
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
--AND IDFACTURA = 260176
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND F.IDFACTURA = C.IDFACTURA
----
AND TRUNC(C.FEC_GENERACION) != TRUNC(C.FEC_ESTADO)
AND F.STSFACT = 'ANU'
AND F.MOTIVANUL = 'CCO'
----- JMMD20210721
AND TRUNC(F.FECSTS) BETWEEN dFecDesde AND dFecHasta 
----- JMMD20210721
*/
UNION ALL  ----- CAMBIO DE COMISIONES NOTAS DE CREDITO
select C.IDFACTURA, C.IDNCR, 
--C.COMISION_MONEDA COMISION, 
   case when
      trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda * -1
       else 0
       end  Comision ,
C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
        case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then 
           Y.MTOCOMISI * -1               
           else 0
       end  MONTO_COMISION, 
----- JMMD202101/20       Y.MTOIVA MONTO_IVA, Y.MTOIVARET MONTO_IVARET, Y.MTOISR MONTO_ISR, Y.MTOISRRET MONTO_ISRRET, 
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA * -1      
           else 0
       end  MONTO_IVA, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET * -1        
          else 0
       end  MONTO_IVARET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR * -1            
          else 0
       end   MONTO_ISR, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET * -1                 
          else 0
       end  MONTO_ISRRET, 
-----
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then 
           Y.SUBTOTAL * -1                  
          else 0
       end  MONTO_SUBTOTAL, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then 
           DECODE(SIGN(Y.SubTotal * -1), -1, Y.SubTotal, 0)                 
          else 0
       end  En_contra, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then 
           DECODE(SIGN(Y.SubTotal * -1), -1, 0, Y.SubTotal)                 
          else 0
       end  A_FAVOR,               

-----

--Y.SUBTOTAL * -1 MONTO_SUBTOTAL,
--               DECODE(SIGN(Y.SubTotal * -1), -1, Y.SubTotal, 0) En_contra,-- PC.CodTipoPlan CodTipoPlan,                            
--               DECODE(SIGN(Y.SubTotal * -1), -1, 0, Y.SubTotal) A_FAVOR, 
       CASE 
          WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
          THEN  C.comision_moneda * -1
           ELSE 0
       END   PAGADO,               
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                   
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
NOTAS_DE_CREDITO NC                                 
where C.cod_agente = X.COD_AGENTE
and C.estado  = 'PRY'
AND TRUNC(FEC_ESTADO) != TRUNC(FEC_LIQUIDACION)   -------------JMMD20210622
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
--AND IDFACTURA = 260176
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND NC.IDNCR = C.IDNCR
----
AND NC.STSNCR  = 'ANU'
AND NC.MOTIVANUL = 'CCO'
-----JMMD20210721
AND TRUNC(NC.FECSTS) BETWEEN  dFecDesde AND dFecHasta
-----JMMD20210721
-----JMMD20211103
/*UNION ALL  ----- DESPAGO DE RECIBOS
select C.IDFACTURA, C.IDNCR, 
--                    C.Comision_Moneda Comision  -- jmmd20201204 se cambio por case de abajo
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda * -1
          else 0
       end  Comision ,
       C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOCOMISI * -1 
       else 0
       end      MONTO_COMISION, 
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA * -1
           else 0
       end  MONTO_IVA, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET * -1
          else 0
       end  MONTO_IVARET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR * -1
          else 0
       end   MONTO_ISR, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET * -1
          else 0
       end  MONTO_ISRRET, 
-----   JMMD20210806   Y.SUBTOTAL MONTO_SUBTOTAL,
       Y.SUBTOTAL * - 1     MONTO_SUBTOTAL,
               DECODE(SIGN(Y.SubTotal * -1), -1, Y.SubTotal, 0) En_contra,-- PC.CodTipoPlan CodTipoPlan,                            
               DECODE(SIGN(Y.SubTotal * -1), -1, 0, Y.SubTotal) A_FAVOR, 
       CASE 
          WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
          THEN  C.comision_moneda * -1
           ELSE 0
       END   PAGADO,                  
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                   
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
FACTURAS         F  ,
DETALLE_TRANSACCION      DTR  ,
TRANSACCION TR                                               
where C.cod_agente = X.COD_AGENTE
and C.estado = 'PRY'
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
--AND IDFACTURA = 260176
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND F.IDFACTURA = C.IDFACTURA
--------
AND F.STSFACT = 'EMI'
AND DTR.CODSUBPROCESO = 'REVPAG'
AND DTR.VALOR4 = TO_CHAR(C.IDFACTURA)
AND DTR.VALOR1 = TO_CHAR(C.IDPOLIZA)
AND TR.IDTRANSACCION = DTR.IDTRANSACCION 
--AND TR.IDPROCESO = 12
AND TRUNC(TR.FECHATRANSACCION) = TRUNC(FEC_ESTADO) */
-----JMMD20211103
UNION ALL  ----- PAGO/DESPAGO DE RECIBOS EL MISMO DIA
select C.IDFACTURA, C.IDNCR, 
--                    C.Comision_Moneda Comision  -- jmmd20201204 se cambio por case de abajo
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda * -1
          else 0
       end  Comision ,
       C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOCOMISI  * -1
       else 0
       end      MONTO_COMISION, 
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA * -1
           else 0
       end  MONTO_IVA, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET * -1
          else 0
       end  MONTO_IVARET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR * -1
          else 0
       end   MONTO_ISR, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET * -1
          else 0
       end  MONTO_ISRRET, 
       Y.SUBTOTAL * -1   MONTO_SUBTOTAL,
               DECODE(SIGN(Y.SubTotal * -1 ), -1, Y.SubTotal, 0) En_contra,-- PC.CodTipoPlan CodTipoPlan,                            
               DECODE(SIGN(Y.SubTotal * -1 ), -1, 0, Y.SubTotal) A_FAVOR, 
       CASE 
          WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
          THEN  C.comision_moneda 
           ELSE 0
       END   PAGADO,                  
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                   
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
FACTURAS         F  ,
DETALLE_TRANSACCION      DTR  ,
TRANSACCION TR                                               
where C.cod_agente = X.COD_AGENTE
----- JMMD 20210805   and C.estado = 'PRY'
and C.estado = 'REC'
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
--AND IDFACTURA = 260176
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND F.IDFACTURA = C.IDFACTURA
--------
----- JMMD 20210805   AND F.STSFACT = 'EMI'
AND F.STSFACT IN( 'EMI', 'PAG')
AND DTR.CODSUBPROCESO = 'REVPAG'
AND DTR.VALOR4 = TO_CHAR(C.IDFACTURA)
AND DTR.VALOR1 = TO_CHAR(C.IDPOLIZA)
AND TR.IDTRANSACCION = DTR.IDTRANSACCION 
--AND TR.IDPROCESO = 12
AND TRUNC(TR.FECHATRANSACCION) = TRUNC(FEC_ESTADO)
--------------------------------------------- JMMD20210813
UNION ALL  ----- VARIOS PAGOS EN EL MISMO DÍA PARA EL MISMO RECIBO 
select C.IDFACTURA, C.IDNCR, 
--                    C.Comision_Moneda Comision  -- jmmd20201204 se cambio por case de abajo
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda 
          else 0
       end  Comision ,
       C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOCOMISI 
       else 0
       end      MONTO_COMISION, 
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA 
           else 0
       end  MONTO_IVA, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET 
          else 0
       end  MONTO_IVARET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR 
          else 0
       end   MONTO_ISR, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET 
          else 0
       end  MONTO_ISRRET, 
-----   JMMD20210806   Y.SUBTOTAL MONTO_SUBTOTAL,
       Y.SUBTOTAL      MONTO_SUBTOTAL,
               DECODE(SIGN(Y.SubTotal ), -1, Y.SubTotal, 0) En_contra,-- PC.CodTipoPlan CodTipoPlan,                            
               DECODE(SIGN(Y.SubTotal ), -1, 0, Y.SubTotal) A_FAVOR, 
       CASE 
          WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
          THEN  C.comision_moneda * -1
           ELSE 0
       END   PAGADO,                  
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                   
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
FACTURAS         F  ,
DETALLE_TRANSACCION      DTR  ,
TRANSACCION TR                                               
where C.cod_agente = X.COD_AGENTE
-----JMMD20210902 SE COMENTA LA LINEA PARA QUE TOME TODOS LOS PAGOS and C.estado = 'REC'
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
--AND IDFACTURA = 260176
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND F.IDFACTURA = C.IDFACTURA
--------
-----JMMD20210902 SE COMENTA LA LINEA PORQUE PUDO HABER PAGO Y EL STATUS ESTE ANULADO AND F.STSFACT = 'PAG'
AND DTR.CODSUBPROCESO = 'PAG'
AND DTR.VALOR4 = TO_CHAR(C.IDFACTURA)
AND DTR.VALOR1 = TO_CHAR(C.IDPOLIZA)
AND TR.IDTRANSACCION = DTR.IDTRANSACCION 
--AND TR.IDPROCESO = 12
AND TRUNC(TR.FECHATRANSACCION) = TRUNC(FEC_ESTADO)
--------------------------------------------- JMMD20210813
--------------------------------------------- JMMD20211112
/*UNION ALL  ------ PAGO/DESPAGO EN EL MISMO DÍA   
select C.IDFACTURA, C.IDNCR, 
--                    C.Comision_Moneda Comision  -- jmmd20201204 se cambio por case de abajo
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda 
          else 0
       end  Comision ,
       C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOCOMISI 
       else 0
       end      MONTO_COMISION, 
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA 
           else 0
       end  MONTO_IVA, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET 
          else 0
       end  MONTO_IVARET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR 
          else 0
       end   MONTO_ISR, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET 
          else 0
       end  MONTO_ISRRET, 
-----   JMMD20210806   Y.SUBTOTAL MONTO_SUBTOTAL,
       Y.SUBTOTAL      MONTO_SUBTOTAL,
               DECODE(SIGN(Y.SubTotal ), -1, Y.SubTotal, 0) En_contra,-- PC.CodTipoPlan CodTipoPlan,                            
               DECODE(SIGN(Y.SubTotal ), -1, 0, Y.SubTotal) A_FAVOR, 
       CASE 
          WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
          THEN  C.comision_moneda * -1
           ELSE 0
       END   PAGADO,                  
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                   
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
FACTURAS         F  ,
DETALLE_TRANSACCION      DTR  ,
TRANSACCION TR                                               
where C.cod_agente = X.COD_AGENTE
and C.estado = 'PRY'
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
--AND IDFACTURA = 260176
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND F.IDFACTURA = C.IDFACTURA
--------
AND F.STSFACT = 'EMI'
AND DTR.CODSUBPROCESO = 'PAG'
AND DTR.VALOR4 = TO_CHAR(C.IDFACTURA)
AND DTR.VALOR1 = TO_CHAR(C.IDPOLIZA)
AND TR.IDTRANSACCION = DTR.IDTRANSACCION 
--AND TR.IDPROCESO = 12
AND TRUNC(TR.FECHATRANSACCION) = TRUNC(FEC_ESTADO)  jmmd20211112 */
--------------------------------------------- JMMD20210813
--------------------------------------------- JMMD20210823
----- JMMD20210903 SE QUITA EL ALL PORQUE ESTABA DUPLICANDO REGISTROS  UNION ALL  ----- DESPAGO DE RECIBOS POR ENDOSO DE ANULACION
UNION ALL ----- DESPAGO DE RECIBOS POR ENDOSO DE ANULACION
select C.IDFACTURA, C.IDNCR, 
--                    C.Comision_Moneda Comision  -- jmmd20201204 se cambio por case de abajo
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then C.Comision_Moneda * -1
          else 0
       end  Comision ,
       C.ESTADO, TRUNC(C.FEC_GENERACION) FECHA_GENERA, TRUNC(C.FEC_LIQUIDACION) FECHA_LIQUIDA,
       C.IDENDOSO ENDOSO, C.FEC_ESTADO FECHA_ESTADO, C.IDNOMINA NOMINA, C.ORIGEN ORIGEN,
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOCOMISI * -1 
       else 0
       end      MONTO_COMISION, 
       case when
            trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVA * -1
           else 0
       end  MONTO_IVA, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOIVARET * -1
          else 0
       end  MONTO_IVARET, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISR * -1
          else 0
       end   MONTO_ISR, 
       case when
          trunc(C.FEC_ESTADO) BETWEEN dFecDesde AND dFecHasta then Y.MTOISRRET * -1
          else 0
       end  MONTO_ISRRET, 
-----   JMMD20210806   Y.SUBTOTAL MONTO_SUBTOTAL,
       Y.SUBTOTAL * - 1     MONTO_SUBTOTAL,
               DECODE(SIGN(Y.SubTotal * -1), -1, Y.SubTotal, 0) En_contra,-- PC.CodTipoPlan CodTipoPlan,                            
               DECODE(SIGN(Y.SubTotal * -1), -1, 0, Y.SubTotal) A_FAVOR, 
       CASE 
          WHEN  C.Estado = 'LIQ' AND trunc(C.FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta 
          THEN  C.comision_moneda * -1
           ELSE 0
       END   PAGADO,                  
               TS.CODTIPOPLAN TIPOPLAN     
from comisiones C,
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = X.COD_AGENTE   
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                   
                           AND   DC.CODCIA     = C2.CODCIA
                           AND   DC.IDCOMISION = C2.IDCOMISION
                          GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto  ) 
                  GROUP BY CodCia, IdComision) Y,
DETALLE_POLIZA DP,
TIPOS_DE_SEGUROS TS,
FACTURAS         F  ,
DETALLE_TRANSACCION      DTR  ,
TRANSACCION TR                                               
where C.cod_agente = X.COD_AGENTE
and C.estado = 'PRY'
AND (TRUNC(FEC_ESTADO ) BETWEEN dFecDesde AND dFecHasta
OR TRUNC(FEC_LIQUIDACION) BETWEEN dFecDesde AND dFecHasta)
--AND IDFACTURA = 260176
AND Y.IDCOMISION = C.IDCOMISION
AND C.COD_MONEDA = X.COD_MONEDA
AND DP.IDPOLIZA = C.IDPOLIZA
AND DP.IDETPOL = (SELECT MIN(DP1.IDETPOL)
                   FROM DETALLE_POLIZA DP1
                  WHERE DP1.IDPOLIZA = DP.IDPOLIZA)
AND TS.IDTIPOSEG = DP.IDTIPOSEG
AND TS.CODTIPOPLAN = X.CODVALOR
AND F.IDFACTURA = C.IDFACTURA
--------
----- JMMD20211007 AND F.STSFACT = 'ANU'
AND DTR.CODSUBPROCESO = 'REVPAG'
AND DTR.VALOR4 = TO_CHAR(C.IDFACTURA)
AND DTR.VALOR1 = TO_CHAR(C.IDPOLIZA)
AND TR.IDTRANSACCION = DTR.IDTRANSACCION 
--AND TR.IDPROCESO = 12
AND TRUNC(TR.FECHATRANSACCION) = TRUNC(FEC_ESTADO)
--------------------------------------------- JMMD20210823
        )
          GROUP BY X.CODVALOR
      ;  
       EXCEPTION WHEN OTHERS THEN
         NULL;
         nMtoComi_moneda_Mes := 0;
         nMtoIva_Mes         := 0; 
         nMtoIvaRet_Mes      := 0; 
         nMtoIsr_Mes         := 0; 
         nMtoIsrRet_Mes      := 0;  
         nA_Favor_mes        := 0;
         nEn_Contra_mes      := 0;
         nPOR_PAGAR_COMISION_MES := 0;
      --     DBMS_OUTPUT.put_line('JMMD NO 2 ANTES DE ETIQUETA OTROS  '||SQLERRM);
       END;  
------------------- JMMD20210107 SE AGREGA EL PAGO DE IMPUESTOS DEL DÍA
begin
SELECT TO_NUMBER(COD_AGENTE) COD_AGENTE, RAMO RAMO, NVL(SUM(COMISION),0) COMISION,  NVL(SUM(MTOIVA),0) MTOIVA,  
NVL(SUM(MTOIVARET),0) MTOIVARET, NVL(SUM(MTOISRRET),0) MTOISRRET
INTO nCOD_AGENTEPAGO, cRamoPago, nPAGO_COMISION , nPAGO_IVA , nPAGO_IVARET , nPAGO_ISRRET
FROM (
 select c.cod_agente, c.idcomision,ts.codtipoplan RAMO,  mtocomisi COMISION, MtoIva, MtoIvaRet,  MtoIsrRet
from  COMISIONES C,
detalle_poliza dp,
tipos_de_seguros ts,
(SELECT CodCia, IdComision, SUM(MtoComisi) MtoComisi, SUM(MtoIva) MtoIva, 
                        SUM(MtoIvaRet) MtoIvaRet, SUM(MtoIsr) MtoIsr, SUM(MtoIsrRet) MtoIsrRet, 
                        SUM(MtoComisi) + SUM(MtoIva) + SUM(MtoIvaRet) + SUM(MtoIsr) + SUM(MtoIsrRet) SubTotal
                   FROM (
       SELECT 
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
                           WHERE C2.CODCIA       = 1
                           AND   C2.Cod_Agente   = C2.COD_AGENTE
                           AND   C2.COD_MONEDA   = X.COD_MONEDA                    
                           AND   DC.CODCIA     = 1
                           AND   DC.IDCOMISION = C2.IDCOMISION
                         GROUP BY  DC.CodCia, DC.IdComision, DC.CodConcepto )
                         GROUP BY CODCIA, IDCOMISION
         ) Y
where c.codcia = 1
and C.COD_AGENTE = X.COD_AGENTE
AND C.COD_MONEDA = X.COD_MONEDA
AND TRUNC(C.FEC_LIQUIDACION) = dFecDesde
and Y.codcia = c.codcia
and Y.idcomision = c.idcomision
and dp.idpoliza = c.idpoliza
and dp.idetpol = c.idetpol
and ts.codcia = dp.codcia
and ts.codempresa = dp.codempresa
and ts.idtiposeg = dp.idtiposeg
and ts.codtipoplan = X.CODVALOR
)
GROUP BY COD_AGENTE, RAMO
ORDER BY COD_AGENTE ASC, RAMO DESC;
       EXCEPTION WHEN OTHERS THEN
         NULL;         
         nPAGO_COMISION := 0;
         nPAGO_IVA         := 0; 
         nPAGO_IVARET      := 0;  
         nPAGO_ISRRET      := 0;  
      --     DBMS_OUTPUT.put_line('JMMD NO 2 ANTES DE ETIQUETA OTROS  '||SQLERRM);
       END;  
-------------------
/*      DBMS_OUTPUT.put_line('JMMD nPAGO_COMISION  '||nPAGO_COMISION||' PAGO_IVA   '||nPAGO_IVA||'  nPAGO_IVARET  '||nPAGO_IVARET);
      DBMS_OUTPUT.put_line('JMMD  nPAGO_ISR  '|| nPAGO_ISR||'  nPAGO_ISRRET  '||nPAGO_ISRRET); 
     DBMS_OUTPUT.put_line('JMMD fecha '||dFecHasta||' agente  '||X.COD_AGENTE);      
      DBMS_OUTPUT.put_line('JMMD ramo '||X.CODVALOR||' nMtoComi_moneda_Mes  '||nMtoComi_moneda_Mes||' EN nMtoIva_mes  '||nMtoIva_mes||' nMtoIvaRet_mes  '||nMtoIvaRet_mes);
      DBMS_OUTPUT.put_line(' nMtoIsrRet  '||nMtoIsrRet_mes||'  nA_Favor '||nA_Favor_mes||' nEn_contra  '||nEn_contra_mes);    

      DBMS_OUTPUT.put_line('JMMD ramo '||X.CODVALOR||' nMtoIva  '||nMtoIva||' nMtoIvaRet  '||nMtoIvaRet||' nMtoIsr  '||nMtoIsr);
      DBMS_OUTPUT.put_line(' nMtoIsrRet  '||nMtoIsrRet||'  nMtoEnContra '||nMtoEnContra||' nMtoAFavor  '||nMtoAFavor);  */
--      nSaldoFinal := nvl(nMtoComi_moneda,0) - nvl(nOtrosMovtos,0) + nvl(nMtoIva,0) - nvl(nMtoIvaRet,0) - nvl(nPg_mtoisr,0);
/*        nMT_SALDO_INICIAL  := 0; --nMtoComi_moneda + W.PAGO_COMISION ;
--        nMT_COM_TOT        := nMtoComi_moneda - W.PAGO_COMISION;
*/
--        nMT_SUBTOTAL_TOT  :=  
--        nTOTAL_PAGO := nPAGO_COMISION + nPAGO_IVA + nPAGO_IVARET + nPAGO_ISR + nPAGO_ISRRET;
-----  nPAGO_COMISION , nPAGO_IVA , nPAGO_IVARET , nPAGO_ISRRET      
--        DBMS_OUTPUT.put_line(' nTOTAL_PAGO  '||nTOTAL_PAGO);      
--       INTO nMT_SALDO_INICIAL  , nMT_SALDO_FINAL,nMtoIva, nMtoIvaRet, nMtoIsr, nMtoIsrRet, nMtoEnContra, nMtoAFavor 
        nMT_IVA_TOT        := nMtoIva_Mes + nMtoIva - nPAGO_IVA;
        nMT_IVARET_TOT    := nMtoIvaRet_Mes + nMtoIvaRet - nPAGO_IVARET;
        nMT_ISR_TOT        := nMtoIsr_Mes + nMtoIsr;
        nMT_ISRRET_TOT    := nMtoIsrRet_Mes + nMtoIsrRet - nPAGO_ISRRET;  
        nMT_ENCONTRA_TOT  := nEn_Contra_mes + nMtoEnContra;
        nMT_AFAVOR_TOT    := nA_Favor_mes + nMtoAFavor;
        nSALDO_FINAL    := nMT_SALDO_INICIAL + nMtoComi_moneda_Mes - nPAGO_COMISION ;
----JMMD20201202 SALDO FINAL DEBERA SER IGUAL A COMI_MONEDA - PAGADO DEL QUERY PRINCIPAL DE 6 UNION
/*      DBMS_OUTPUT.put_line('  SALDO FINAL  COMISION  '|| nCOMISION|| ' MT_IVA_TOT  '||nMT_IVA_TOT||'  MT_IVARET_TOT  '||nMT_IVARET_TOT||
      '  MT_ISR_TOT  '||nMT_ISR_TOT||'  MT_ISRRET_TOT   '||nMT_ISRRET_TOT );    */
 --     DBMS_OUTPUT.PUT_LINE('  PAGOS  ' ||W.PAGO_COMISION);
--      DBMS_OUTPUT.PUT_LINE('  nMT_SALDO_INICIAL  ' ||nMT_SALDO_INICIAL||' nSALDO_FINAL  '||nSALDO_FINAL||'  nSPV  '||nSPV);  
      IF nSPV = 1 THEN
/*         DBMS_OUTPUT.PUT_LINE('JMMD NO ENCONTRE SALDO Y VOY A INSERTARLO');
         DBMS_OUTPUT.PUT_LINE('JMMD nMT_SALDO_INICIAL  '||nMT_SALDO_INICIAL||' nSALDO_FINAL  '||nSALDO_FINAL);   */      
          begin
          
            INSERT INTO SALDOS_COMISIONES_MES(CD_CIA,CD_AGENTE,CD_TIPO_RAMO,FE_INI_SALDO,FE_FIN_SALDO,FE_PROC_SALDO,
            CD_MONEDA,MT_SALDO_INICIAL,MT_COMISION_MES,MT_IVA_MES,MT_IVARET_MES,MT_ISR_MES,MT_ISRRET_MES,MT_ENCONTRA_MES,
            MT_AFAVOR_MES,MT_SALDO_FINAL,DS_OBSERVACIONES)        
            VALUES(nCodCia,X.COD_AGENTE , X.CODVALOR, dFecDesde, dFecHasta,trunc(sysdate),x.cod_moneda,nMT_SALDO_INICIAL,
 /*           nMtoComi_moneda_Mes, nMtoIva_Mes, nMtoIvaRet_Mes, nMtoIsr_Mes, nMtoIsrRet_Mes, nEn_Contra_mes, nA_Favor_mes,
            nMtoComi_moneda_Mes,'CARGA SALDO');  */
/*            nMtoComi_moneda_Mes, nMtoIva_Mes, nMtoIvaRet_Mes, nMtoIsr_Mes, nMtoIsrRet_Mes, nEn_Contra_mes, nA_Favor_mes,
            nSALDO_FINAL,'CARGA SALDO');  */  ---- jmmd20210107
            nMtoComi_moneda_Mes, nMT_IVA_TOT, nMT_IVARET_TOT, nMT_ISR_TOT, nMT_ISRRET_TOT, nEn_Contra_mes, nA_Favor_mes,
            nSALDO_FINAL,'CARGA SALDO');
            
            COMMIT;  
    
            INSERT INTO SALDOS_COMISIONES_MES(CD_CIA,CD_AGENTE,CD_TIPO_RAMO,FE_INI_SALDO,FE_FIN_SALDO,FE_PROC_SALDO,
            CD_MONEDA,MT_SALDO_INICIAL,MT_COMISION_MES,MT_IVA_MES,MT_IVARET_MES,MT_ISR_MES,MT_ISRRET_MES,MT_ENCONTRA_MES,
            MT_AFAVOR_MES,MT_SALDO_FINAL,DS_OBSERVACIONES)        
            VALUES(nCodCia,X.COD_AGENTE ,X.CODVALOR, dFecDesdeMesSig, dFecHastaMesSig,trunc(sysdate),x.cod_moneda,nSALDO_FINAL,
/*            0, 0, 0, 0, 0, 0, 0, nMT_SALDO_FINAL,'CARGA SALDO');   */ ----- jmmd20210107
            0, nMT_IVA_TOT, nMT_IVARET_TOT, nMT_ISR_TOT, nMT_ISRRET_TOT, 0, 0, nMT_SALDO_FINAL,'CARGA SALDO');            
                    
            COMMIT;  
           EXCEPTION WHEN OTHERS THEN
            NULL;
--            commit;
--              DBMS_OUTPUT.PUT_LINE(' ERROR AL GRABAR  '||SQLERRM );
           END;     
      ELSE
 --       DBMS_OUTPUT.PUT_LINE(' EN ACTUALIZA SALDO  '||SQLERRM );
        BEGIN
        UPDATE SALDOS_COMISIONES_MES
           SET MT_COMISION_MES = nMtoComi_moneda_Mes,
               MT_IVA_MES = nMT_IVA_TOT ,
               MT_IVARET_MES = nMT_IVARET_TOT,
               MT_ISR_MES = nMT_ISR_TOT ,
               MT_ISRRET_MES = nMT_ISRRET_TOT ,
               MT_ENCONTRA_MES = nMT_ENCONTRA_TOT ,
               MT_AFAVOR_MES = nMT_AFAVOR_TOT ,
               MT_SALDO_FINAL = nSALDO_FINAL ,
               FE_FIN_SALDO = dFecHasta,
               DS_OBSERVACIONES = 'ACTUALIZACION DE SALDO SIGUIENTE MES'
        WHERE CD_AGENTE = X.COD_AGENTE
          AND CD_TIPO_RAMO = X.CODVALOR
          AND CD_MONEDA = x.cod_moneda
          AND FE_INI_SALDO = dFecHasta;
          COMMIT;
        EXCEPTION WHEN OTHERS THEN
        NULL;
 --         DBMS_OUTPUT.PUT_LINE('ERROR EN ACTUALIZA SALDO  '||SQLERRM );
        END;
 --       DBMS_OUTPUT.PUT_LINE('DESPUES DE ACTUALIZAR SALDO EL nMtoComi_moneda_Mes  '||nMtoComi_moneda_Mes );
        IF nMtoComi_moneda_Mes = 0 THEN
           nMtoComi_moneda_Mes := nMT_SALDO_INICIAL;
        END IF;
        
        INSERT INTO SALDOS_COMISIONES_MES(CD_CIA,CD_AGENTE,CD_TIPO_RAMO,FE_INI_SALDO,FE_FIN_SALDO,FE_PROC_SALDO,
        CD_MONEDA,MT_SALDO_INICIAL,MT_COMISION_MES,MT_IVA_MES,MT_IVARET_MES,MT_ISR_MES,MT_ISRRET_MES,MT_ENCONTRA_MES,
        MT_AFAVOR_MES,MT_SALDO_FINAL,DS_OBSERVACIONES)        
        VALUES(nCodCia,X.COD_AGENTE ,X.CODVALOR, dFecDesdeMesSig, dFecHastaMesSig,trunc(sysdate),x.cod_moneda,nSALDO_FINAL,
/*        0, 0, 0, 0, 0, 0, 0, nSALDO_FINAL,'CARGA SALDO SIGUIENTE MES');  */ ----- jmmd20210107
            0, nMT_IVA_TOT, nMT_IVARET_TOT, nMT_ISR_TOT, nMT_ISRRET_TOT, 0, 0, nMT_SALDO_FINAL,'CARGA SALDO SIGUIENTE MES');   
                    
       COMMIT;          
      END IF;
    ----------------
--      END LOOP;
  --    DBMS_OUTPUT.PUT_LINE('nSPV LOOP PAGOS '||nSPV);      

  END LOOP;
  dFecDesde := dFecDesde + 1;
  dFecHasta := dFecHasta + 1;  
--  DBMS_OUTPUT.PUT_LINE('JMMD NUEVA dFecDesde '||dFecDesde||' dFechacontrolfin  '||dfechaControlFin);      
 END LOOP;  
EXCEPTION
   WHEN OTHERS THEN
   dbms_output.put_line('me fui por el exception');
      OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   RAISE_APPLICATION_ERROR(-20000, 'Error en actualiza saldos ' || SQLERRM);
END;
/

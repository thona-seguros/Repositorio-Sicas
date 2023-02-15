PROCEDURE          "PROC_ALOGEM" AUTHID CURRENT_USER IS

--
--CAMBIO AHORITA
--
cLimitador      VARCHAR2(1) :='|';
cCadena         VARCHAR2(5000);
cArchivo        VARCHAR2(300) := 'ARCHIVO_LOGEM'||TO_CHAR(SYSDATE,'DDMMYYYYHH24MISS')||'.TXT';
v_archivo       utl_file.file_type;
wAGENTE         AGENTES_DISTRIBUCION_POLIZA.COD_AGENTE%TYPE;
wNivelAgente    AGENTES_DISTRIBUCION_POLIZA.CODNIVEL%TYPE;
wAGENTEReg      AGENTES_DISTRIBUCION_POLIZA.COD_AGENTE%TYPE;
cNombreRegional VARCHAR2(300); 
wRegional       VARCHAR2(300); 
dIdFactura      FACTURAS.IDFACTURA%TYPE;
FecPago         DATE;        


--
CURSOR POL_Q IS
 ---  trae al Agente  ---  no esta liberado porque no han dado VoBo  ---
SELECT 'INDIVIDUAL-COLECTIVO'
       ,A.IDPOLIZA                                                          IdPOLIZA
       ,D.CODCLIENTE                                                        CODIGO_DEL_CONTRATANTE
       ,E.NOMBRE||' '||E.APELLIDO_PATERNO||' '||E.APELLIDO_MATERNO          NOMBRE_CONTRATANTE
       ,B.COD_ASEGURADO                                                     CODIGO_DEL_ASEGURADO         
       ,C.NOMBRE||' '||C.APELLIDO_PATERNO||' '||C.APELLIDO_MATERNO          NOMBRE_ASEGURADO
       ,FA.COD_ASEGURADO                                                    CODIGO_ASEGURADO_CERTIFICADO
       ,G.NOMBRE||' '||G.APELLIDO_PATERNO||' '||G.APELLIDO_MATERNO          NOMBRE_ASEGURADO_CERTIFICADO 
       ,A.NUMPOLUNICO                                                       POLIZA_UNICA
       ,CASE                                                          
         WHEN A.STSPOLIZA = 'EMI' THEN 'VIGENTE EMITIDA'            
         WHEN A.STSPOLIZA = 'ANU' THEN 'ANULADA'                      
         WHEN A.STSPOLIZA = 'SOL' THEN 'SOLICITUD'                       
         WHEN A.STSPOLIZA = 'REN' THEN 'VIGENTE RENOVADA'          
       END                                                                  VIGENCIA   
      ,A2.CODFILIAL                                                         SUB_GRUPO
      ,OC_FILIALES.NOMBRE_FILIAL(1,A.CODGRUPOEC ,  A2.CODFILIAL )           NOMBRE_SUBGRUPO
      ,A2.IDTIPOSEG                                                         PRODUCTO
      ,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A2.CodCia, A2.CodEmpresa, A2.IdTipoSeg, A2.PlanCob) PLAN_COBERTURA--DescPlanCobro
      ,TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')                                    INICIO_DE_VIGENCIA
      ,TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')                                    FIN_DE_VIGENCIA
      ,CASE
      WHEN  FF2.FECVENC IS NOT NULL THEN TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')
      END                                                                   PAGADO_HASTA
      ,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A2.CodCia, A2.CodEmpresa, A2.IdTipoSeg, A2.PlanCob) ESTATUS_DE_GRUPO--DescPlanCobro
      ,CASE                                                          
         WHEN A.STSPOLIZA = 'EMI' THEN 'VIGENTE EMITIDA'            
         WHEN A.STSPOLIZA = 'ANU' THEN 'ANULADA'                      
         WHEN A.STSPOLIZA = 'SOL' THEN 'SOLICITUD'                       
         WHEN A.STSPOLIZA = 'REN' THEN 'VIGENTE RENOVADA'          
       END                                                                  ESTATUS_DE_PAGO
      --,D.CODCLIENTE                                                         CODIGO_DEL_CONTRATANTE
      ---,E.NOMBRE||' '||E.APELLIDO_PATERNO||' '||E.APELLIDO_MATERNO           NOMBRE_CONTRATANTE 
      ,OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(1, A2.CodEmpresa, A2.CodPlanPago)  PLAN__DE__PAGOS 
      ,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL',A.TipoAdministracion)   TIPO_DE_ADMINISTRACION 
      ,FA.SUMAASEG_LOCAL                                                    SUMA_ASEGURADA
      ,FA.DEDUCIBLE_LOCAL                                                   DEDUCIBLE    
      --
      ,AP.COD_AGENTE                                                                         CODAGENTE
      ,OC_AGENTES.NOMBRE_AGENTE(A2.CodCia, AP.COD_AGENTE)                                    NOMAGENTE 
      ,A.INDFACTURAPOL    
      ,A.CODCIA
      ,A2.IDETPOL
FROM   POLIZAS                   A   -- 7067 POLIZAS
      ,DETALLE_POLIZA            A2 
      ,ASEGURADO                 B
      ,PERSONA_NATURAL_JURIDICA  C
      ,CLIENTES                  D  
      ,PERSONA_NATURAL_JURIDICA  E 
      ,COBERT_ACT                FA  
      ,PERSONA_NATURAL_JURIDICA  G 
      ,ASEGURADO                 H
      ,FACTURAS                  FF2 
      , AGENTE_POLIZA            AP   
WHERE A.FECINIVIG BETWEEN ADD_MONTHS(TRUNC(SYSDATE),-14) AND TRUNC(SYSDATE)
AND   A.STSPOLIZA IN ('EMI','REN','ANU')
AND   ( (A.MOTIVANUL IN ('FPA','COT','CAFP')) OR (A.MOTIVANUL IS NULL ))
---
AND   A2.CODCIA     = 1
AND   A2.CODEMPRESA = 1
AND   A2.IDPOLIZA   = A.IDPOLIZA
---
AND   B.CODCIA     = 1
AND   B.CODEMPRESA = 1
AND   B.COD_ASEGURADO = A2.COD_ASEGURADO
---
AND  C.TIPO_DOC_IDENTIFICACION = B.TIPO_DOC_IDENTIFICACION
AND  C.NUM_DOC_IDENTIFICACION  = B.NUM_DOC_IDENTIFICACION
--
AND  D.CODCLIENTE              = A.CODCLIENTE
AND  D.TIPO_DOC_IDENTIFICACION = E.TIPO_DOC_IDENTIFICACION
AND  D.NUM_DOC_IDENTIFICACION  = E.NUM_DOC_IDENTIFICACION
-- 
AND  FA.CODEMPRESA = A2.CODEMPRESA
AND  FA.CODCIA     = A2.CODCIA
AND  FA.IDPOLIZA   = A2.IDPOLIZA
AND  FA.IDETPOL    = A2.IDETPOL
AND  FA.IDTIPOSEG  = A2.IDTIPOSEG  
AND  FA.CODCOBERT  = 'GMXA'
--
AND  H.COD_ASEGURADO     = FA.COD_ASEGURADO
AND  H.CODEMPRESA        = 1
AND  H.CODCIA            = 1
--
AND  G.TIPO_DOC_IDENTIFICACION = H.TIPO_DOC_IDENTIFICACION
AND  G.NUM_DOC_IDENTIFICACION  = H.NUM_DOC_IDENTIFICACION
--
AND FF2.IDPOLIZA   = A2.IDPOLIZA
AND FF2.IDETPOL    = A2.IDETPOL
AND FF2.IDFACTURA  = (SELECT MAX(FF3.IdFactura) 
                      -- INTO dIdFactura
                      FROM FACTURAS  FF3
                      WHERE FF3.IdPoliza = FF2.IDPOLIZA
                      AND   FF3.IDetPol  = FF2.IDETPOL
                      AND   FF3.StsFact  = 'PAG'
                      AND   FF3.IDENDOSO = FF2.IDENDOSO)
AND AP.CODCIA   = A.CODCIA
AND AP.IDPOLIZA = A.IDPOLIZA                      
---AND ROWNUM < 100
---------------------
UNION
SELECT 'COLECTIVO-INDIVIDUAL'
       ,A.IDPOLIZA                                                        IdPOLIZA 
       ,D.CODCLIENTE                                                      CODIGO_DEL_CONTRATANTE
       ,E.NOMBRE||' '||E.APELLIDO_PATERNO||' '||E.APELLIDO_MATERNO        NOMBRE_CONTRATANTE
       ,B.COD_ASEGURADO                                                   CODIGO_DEL_ASEGURADO         
       ,C.NOMBRE||' '||C.APELLIDO_PATERNO||' '||C.APELLIDO_MATERNO        NOMBRE_ASEGURADO
       ,F.COD_ASEGURADO                                                   CODIGO_ASEGURADO_CERTIFICADO
       ,G.NOMBRE||' '||G.APELLIDO_PATERNO||' '||G.APELLIDO_MATERNO        NOMBRE_ASEGURADO_CERTIFICADO

      ,A.NUMPOLUNICO                                                      POLIZA_UNICA
      ,CASE                                                          
         WHEN A.STSPOLIZA = 'EMI' THEN 'VIGENTE EMITIDA'            
         WHEN A.STSPOLIZA = 'ANU' THEN 'ANULADA'                      
         WHEN A.STSPOLIZA = 'SOL' THEN 'SOLICITUD'                       
         WHEN A.STSPOLIZA = 'REN' THEN 'VIGENTE RENOVADA'          
       END                                                                 VIGENCIA   
      ,A2.CODFILIAL                                                        SUB_GRUPO
      ,OC_FILIALES.NOMBRE_FILIAL(1,A.CODGRUPOEC ,  A2.CODFILIAL )          NOMBRE_SUBGRUPO
      ,A2.IDTIPOSEG                                                        PRODUCTO
      ,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A2.CodCia, A2.CodEmpresa, A2.IdTipoSeg, A2.PlanCob) PLAN_COBERTURA--DescPlanCobro
      ,TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')                                   INICIO_DE_VIGENCIA
      ,TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')                                   FIN_DE_VIGENCIA
      ,CASE
      WHEN  FF2.FECVENC IS NOT NULL THEN TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')
      END                                                                  PAGADO_HASTA
      ,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A2.CodCia, A2.CodEmpresa, A2.IdTipoSeg, A2.PlanCob) ESTATUS_DE_GRUPO--DescPlanCobro
            ,CASE                                                          
         WHEN A.STSPOLIZA = 'EMI' THEN 'VIGENTE EMITIDA'            
         WHEN A.STSPOLIZA = 'ANU' THEN 'ANULADA'                      
         WHEN A.STSPOLIZA = 'SOL' THEN 'SOLICITUD'                       
         WHEN A.STSPOLIZA = 'REN' THEN 'VIGENTE RENOVADA'          
       END                                                                 ESTATUS_DE_PAGO
      --,D.CODCLIENTE                                                        CODIGO_DEL_CONTRATANTE
      --,E.NOMBRE||' '||E.APELLIDO_PATERNO||' '||E.APELLIDO_MATERNO          NOMBRE_CONTRATANTE 
      --,A2.CODPLANPAGO                                                    CODIGO_DE_PLAN_DE_PAGO
      ,OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(1, A2.CodEmpresa, A2.CodPlanPago) PLAN__DE__PAGOS 
      ,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL',A.TipoAdministracion)  TIPO_DE_ADMINISTRACION 
      ,F.SUMA_ASEGURADA_LOCAL                                                 SUMA_ASEGURADA
      ,F.DEDUCIBLE_LOCAL                                                     DEDUCIBLE 
      --
      ,AP.COD_AGENTE                                                                         CODAGENTE
      ,OC_AGENTES.NOMBRE_AGENTE(A2.CodCia, AP.COD_AGENTE)                                    NOMAGENTE  
      ,A.INDFACTURAPOL  
      ,A.CODCIA  
      ,A2.IDETPOL
FROM   POLIZAS                   A   -- 7067 POLIZAS
      ,DETALLE_POLIZA            A2 
      ,ASEGURADO                 B
      ,PERSONA_NATURAL_JURIDICA  C
      ,CLIENTES                  D  
      ,PERSONA_NATURAL_JURIDICA  E 
      ,COBERTURA_ASEG            F   
      ,PERSONA_NATURAL_JURIDICA  G 
      ,ASEGURADO                 H
      ,FACTURAS                  FF2
      , AGENTE_POLIZA            AP      
WHERE A.FECINIVIG BETWEEN ADD_MONTHS(TRUNC(SYSDATE),-14) AND TRUNC(SYSDATE)
AND   A.STSPOLIZA IN ('EMI','REN','ANU')
AND   ( (A.MOTIVANUL IN ('FPA','COT','CAFP')) OR (A.MOTIVANUL IS NULL ))
---
AND   A2.CODCIA     = 1
AND   A2.CODEMPRESA = 1
AND   A2.IDPOLIZA   = A.IDPOLIZA
---
AND   B.CODCIA     = 1
AND   B.CODEMPRESA = 1
AND   B.COD_ASEGURADO = A2.COD_ASEGURADO
---
AND  C.TIPO_DOC_IDENTIFICACION = B.TIPO_DOC_IDENTIFICACION
AND  C.NUM_DOC_IDENTIFICACION  = B.NUM_DOC_IDENTIFICACION
--
AND  D.CODCLIENTE              = A.CODCLIENTE
AND  D.TIPO_DOC_IDENTIFICACION = E.TIPO_DOC_IDENTIFICACION
AND  D.NUM_DOC_IDENTIFICACION  = E.NUM_DOC_IDENTIFICACION
--   
AND  F.CODEMPRESA = A2.CODEMPRESA
AND  F.CODCIA     = A2.CODCIA
AND  F.IDPOLIZA   = A2.IDPOLIZA
AND  F.IDETPOL    = A2.IDETPOL
AND  F.IDTIPOSEG  = A2.IDTIPOSEG  
--AND  F.IDENDOSO   = 0
AND  F.CODCOBERT  = 'GMXA'
--
AND  H.COD_ASEGURADO     = F.COD_ASEGURADO
AND  H.CODEMPRESA        = 1
AND  H.CODCIA            = 1
--
AND  G.TIPO_DOC_IDENTIFICACION = H.TIPO_DOC_IDENTIFICACION
AND  G.NUM_DOC_IDENTIFICACION  = H.NUM_DOC_IDENTIFICACION
--
AND FF2.IDPOLIZA   = A2.IDPOLIZA
AND FF2.IDETPOL    = A2.IDETPOL
AND FF2.IDFACTURA  = (SELECT MAX(FF3.IdFactura) 
                      -- INTO dIdFactura
                      FROM FACTURAS  FF3
                      WHERE FF3.IdPoliza = FF2.IDPOLIZA
                      AND   FF3.IDetPol  = FF2.IDETPOL
                      AND   FF3.StsFact  = 'PAG'
                      AND   FF3.IDENDOSO = FF2.IDENDOSO )
AND AP.CODCIA   = A.CODCIA
AND AP.IDPOLIZA = A.IDPOLIZA                       
---AND ROWNUM < 100
---------------------
ORDER BY 1,2;
/*SELECT 'INDIVIDUAL-COLECTIVO'
       ,D.CODCLIENTE                                                        CODIGO_DEL_CONTRATANTE
       ,E.NOMBRE||' '||E.APELLIDO_PATERNO||' '||E.APELLIDO_MATERNO          NOMBRE_CONTRATANTE
       ,B.COD_ASEGURADO                                                     CODIGO_DEL_ASEGURADO         
       ,C.NOMBRE||' '||C.APELLIDO_PATERNO||' '||C.APELLIDO_MATERNO          NOMBRE_ASEGURADO
       ,FA.COD_ASEGURADO                                                    CODIGO_ASEGURADO_CERTIFICADO
       ,G.NOMBRE||' '||G.APELLIDO_PATERNO||' '||G.APELLIDO_MATERNO          NOMBRE_ASEGURADO_CERTIFICADO 
       ,A.NUMPOLUNICO                                                       POLIZA_UNICA
       ,CASE                                                          
         WHEN A.STSPOLIZA = 'EMI' THEN 'VIGENTE EMITIDA'            
         WHEN A.STSPOLIZA = 'ANU' THEN 'ANULADA'                      
         WHEN A.STSPOLIZA = 'SOL' THEN 'SOLICITUD'                       
         WHEN A.STSPOLIZA = 'REN' THEN 'VIGENTE RENOVADA'          
       END                                                                  VIGENCIA   
      ,A2.CODFILIAL                                                         SUB_GRUPO
      ,OC_FILIALES.NOMBRE_FILIAL(1,A.CODGRUPOEC ,  A2.CODFILIAL )           NOMBRE_SUBGRUPO
      ,A2.IDTIPOSEG                                                         PRODUCTO
      ,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A2.CodCia, A2.CodEmpresa, A2.IdTipoSeg, A2.PlanCob) PLAN_COBERTURA--DescPlanCobro
      ,TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')                                    INICIO_DE_VIGENCIA
      ,TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')                                    FIN_DE_VIGENCIA
      ,CASE
      WHEN  FF2.FECVENC IS NOT NULL THEN TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')
      END                                                                   PAGADO_HASTA
      ,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A2.CodCia, A2.CodEmpresa, A2.IdTipoSeg, A2.PlanCob) ESTATUS_DE_GRUPO--DescPlanCobro
      ,CASE                                                          
         WHEN A.STSPOLIZA = 'EMI' THEN 'VIGENTE EMITIDA'            
         WHEN A.STSPOLIZA = 'ANU' THEN 'ANULADA'                      
         WHEN A.STSPOLIZA = 'SOL' THEN 'SOLICITUD'                       
         WHEN A.STSPOLIZA = 'REN' THEN 'VIGENTE RENOVADA'          
       END                                                                  ESTATUS_DE_PAGO
      --,D.CODCLIENTE                                                         CODIGO_DEL_CONTRATANTE
      ---,E.NOMBRE||' '||E.APELLIDO_PATERNO||' '||E.APELLIDO_MATERNO           NOMBRE_CONTRATANTE 
      ,OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(1, A2.CodEmpresa, A2.CodPlanPago)  PLAN__DE__PAGOS 
      ,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL',A.TipoAdministracion)   TIPO_DE_ADMINISTRACION 
      ,FA.SUMAASEG_LOCAL                                                    SUMA_ASEGURADA
      ,FA.DEDUCIBLE_LOCAL                                                   DEDUCIBLE      
FROM   POLIZAS                   A   -- 7067 POLIZAS
      ,DETALLE_POLIZA            A2 
      ,ASEGURADO                 B
      ,PERSONA_NATURAL_JURIDICA  C
      ,CLIENTES                  D  
      ,PERSONA_NATURAL_JURIDICA  E 
      ,COBERT_ACT                FA  
      ,PERSONA_NATURAL_JURIDICA  G 
      ,ASEGURADO                 H
      ,FACTURAS                  FF2   
WHERE A.FECINIVIG BETWEEN ADD_MONTHS(TRUNC(SYSDATE),-14) AND TRUNC(SYSDATE)
AND   A.STSPOLIZA IN ('EMI','REN','ANU')
AND   ( (A.MOTIVANUL IN ('FPA','COT','CAFP')) OR (A.MOTIVANUL IS NULL ))
---
AND   A2.CODCIA     = 1
AND   A2.CODEMPRESA = 1
AND   A2.IDPOLIZA   = A.IDPOLIZA
---
AND   B.CODCIA     = 1
AND   B.CODEMPRESA = 1
AND   B.COD_ASEGURADO = A2.COD_ASEGURADO
---
AND  C.TIPO_DOC_IDENTIFICACION = B.TIPO_DOC_IDENTIFICACION
AND  C.NUM_DOC_IDENTIFICACION  = B.NUM_DOC_IDENTIFICACION
--
AND  D.CODCLIENTE              = A.CODCLIENTE
AND  D.TIPO_DOC_IDENTIFICACION = E.TIPO_DOC_IDENTIFICACION
AND  D.NUM_DOC_IDENTIFICACION  = E.NUM_DOC_IDENTIFICACION
-- 
AND  FA.CODEMPRESA = A2.CODEMPRESA
AND  FA.CODCIA     = A2.CODCIA
AND  FA.IDPOLIZA   = A2.IDPOLIZA
AND  FA.IDETPOL    = A2.IDETPOL
AND  FA.IDTIPOSEG  = A2.IDTIPOSEG  
AND  FA.CODCOBERT  = 'GMXA'
--
AND  H.COD_ASEGURADO     = FA.COD_ASEGURADO
AND  H.CODEMPRESA        = 1
AND  H.CODCIA            = 1
--
AND  G.TIPO_DOC_IDENTIFICACION = H.TIPO_DOC_IDENTIFICACION
AND  G.NUM_DOC_IDENTIFICACION  = H.NUM_DOC_IDENTIFICACION
--
AND FF2.IDPOLIZA   = A2.IDPOLIZA
AND FF2.IDETPOL    = A2.IDETPOL
AND FF2.IDFACTURA  = (SELECT MAX(FF3.IdFactura) 
                      -- INTO dIdFactura
                      FROM FACTURAS  FF3
                      WHERE FF3.IdPoliza = FF2.IDPOLIZA
                      AND   FF3.IDetPol  = FF2.IDETPOL
                      AND   FF3.StsFact  = 'PAG'
                      AND   FF3.IDENDOSO = FF2.IDENDOSO)
---AND ROWNUM < 100
---------------------
UNION
SELECT 'COLECTIVO-INDIVIDUAL'
     ,D.CODCLIENTE                                                      CODIGO_DEL_CONTRATANTE
       ,E.NOMBRE||' '||E.APELLIDO_PATERNO||' '||E.APELLIDO_MATERNO        NOMBRE_CONTRATANTE
       ,B.COD_ASEGURADO                                                   CODIGO_DEL_ASEGURADO         
       ,C.NOMBRE||' '||C.APELLIDO_PATERNO||' '||C.APELLIDO_MATERNO        NOMBRE_ASEGURADO
       ,F.COD_ASEGURADO                                                   CODIGO_ASEGURADO_CERTIFICADO
       ,G.NOMBRE||' '||G.APELLIDO_PATERNO||' '||G.APELLIDO_MATERNO        NOMBRE_ASEGURADO_CERTIFICADO

      ,A.NUMPOLUNICO                                                      POLIZA_UNICA
      ,CASE                                                          
         WHEN A.STSPOLIZA = 'EMI' THEN 'VIGENTE EMITIDA'            
         WHEN A.STSPOLIZA = 'ANU' THEN 'ANULADA'                      
         WHEN A.STSPOLIZA = 'SOL' THEN 'SOLICITUD'                       
         WHEN A.STSPOLIZA = 'REN' THEN 'VIGENTE RENOVADA'          
       END                                                                 VIGENCIA   
      ,A2.CODFILIAL                                                        SUB_GRUPO
      ,OC_FILIALES.NOMBRE_FILIAL(1,A.CODGRUPOEC ,  A2.CODFILIAL )          NOMBRE_SUBGRUPO
      ,A2.IDTIPOSEG                                                        PRODUCTO
      ,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A2.CodCia, A2.CodEmpresa, A2.IdTipoSeg, A2.PlanCob) PLAN_COBERTURA--DescPlanCobro
      ,TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')                                   INICIO_DE_VIGENCIA
      ,TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')                                   FIN_DE_VIGENCIA
      ,CASE
      WHEN  FF2.FECVENC IS NOT NULL THEN TO_CHAR(A.FECINIVIG,'DD/MM/YYYY')
      END                                                                  PAGADO_HASTA
      ,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(A2.CodCia, A2.CodEmpresa, A2.IdTipoSeg, A2.PlanCob) ESTATUS_DE_GRUPO--DescPlanCobro
            ,CASE                                                          
         WHEN A.STSPOLIZA = 'EMI' THEN 'VIGENTE EMITIDA'            
         WHEN A.STSPOLIZA = 'ANU' THEN 'ANULADA'                      
         WHEN A.STSPOLIZA = 'SOL' THEN 'SOLICITUD'                       
         WHEN A.STSPOLIZA = 'REN' THEN 'VIGENTE RENOVADA'          
       END                                                                 ESTATUS_DE_PAGO
      --,D.CODCLIENTE                                                        CODIGO_DEL_CONTRATANTE
      --,E.NOMBRE||' '||E.APELLIDO_PATERNO||' '||E.APELLIDO_MATERNO          NOMBRE_CONTRATANTE 
      --,A2.CODPLANPAGO                                                    CODIGO_DE_PLAN_DE_PAGO
      ,OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(1, A2.CodEmpresa, A2.CodPlanPago) PLAN__DE__PAGOS 
      ,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL',A.TipoAdministracion)  TIPO_DE_ADMINISTRACION 
      ,F.SUMA_ASEGURADA_LOCAL                                                 SUMA_ASEGURADA
      ,F.DEDUCIBLE_LOCAL                                                   DEDUCIBLE     
FROM   POLIZAS                   A   -- 7067 POLIZAS
      ,DETALLE_POLIZA            A2 
      ,ASEGURADO                 B
      ,PERSONA_NATURAL_JURIDICA  C
      ,CLIENTES                  D  
      ,PERSONA_NATURAL_JURIDICA  E 
      ,COBERTURA_ASEG            F   
      ,PERSONA_NATURAL_JURIDICA  G 
      ,ASEGURADO                 H
      ,FACTURAS                  FF2     
WHERE A.FECINIVIG BETWEEN ADD_MONTHS(TRUNC(SYSDATE),-14) AND TRUNC(SYSDATE)
AND   A.STSPOLIZA IN ('EMI','REN','ANU')
AND   ( (A.MOTIVANUL IN ('FPA','COT','CAFP')) OR (A.MOTIVANUL IS NULL ))
---
AND   A2.CODCIA     = 1
AND   A2.CODEMPRESA = 1
AND   A2.IDPOLIZA   = A.IDPOLIZA
---
AND   B.CODCIA     = 1
AND   B.CODEMPRESA = 1
AND   B.COD_ASEGURADO = A2.COD_ASEGURADO
---
AND  C.TIPO_DOC_IDENTIFICACION = B.TIPO_DOC_IDENTIFICACION
AND  C.NUM_DOC_IDENTIFICACION  = B.NUM_DOC_IDENTIFICACION
--
AND  D.CODCLIENTE              = A.CODCLIENTE
AND  D.TIPO_DOC_IDENTIFICACION = E.TIPO_DOC_IDENTIFICACION
AND  D.NUM_DOC_IDENTIFICACION  = E.NUM_DOC_IDENTIFICACION
--   
AND  F.CODEMPRESA = A2.CODEMPRESA
AND  F.CODCIA     = A2.CODCIA
AND  F.IDPOLIZA   = A2.IDPOLIZA
AND  F.IDETPOL    = A2.IDETPOL
AND  F.IDTIPOSEG  = A2.IDTIPOSEG  
AND  F.IDENDOSO   = 0
AND  F.CODCOBERT  = 'GMXA'
--
AND  H.COD_ASEGURADO     = F.COD_ASEGURADO
AND  H.CODEMPRESA        = 1
AND  H.CODCIA            = 1
--
AND  G.TIPO_DOC_IDENTIFICACION = H.TIPO_DOC_IDENTIFICACION
AND  G.NUM_DOC_IDENTIFICACION  = H.NUM_DOC_IDENTIFICACION
--
AND FF2.IDPOLIZA   = A2.IDPOLIZA
AND FF2.IDETPOL    = A2.IDETPOL
AND FF2.IDFACTURA  = (SELECT MAX(FF3.IdFactura) 
                      -- INTO dIdFactura
                      FROM FACTURAS  FF3
                      WHERE FF3.IdPoliza = FF2.IDPOLIZA
                      AND   FF3.IDetPol  = FF2.IDETPOL
                      AND   FF3.StsFact  = 'PAG'
                      AND   FF3.IDENDOSO = FF2.IDENDOSO )
---AND ROWNUM < 100
---------------------
ORDER BY 1,2; */



 /*SELECT OC_CLIENTES.NOMBRE_CLIENTE(PO.CODCLIENTE) CONTRATANTE,
         PO.CODCLIENTE CODIGO_CONTRATANTE,
         OC_ASEGURADO.NOMBRE_ASEGURADO(PO.CODCIA, PO.CODEMPRESA, AC.COD_ASEGURADO) ASEGURADO,
         AC.COD_ASEGURADO CODIGO_ASEGURADO,
         PO.NUMPOLUNICO NUMERO_POLIZA,
         DP.IDETPOL NUMERO_SUBGRUPO,
         PO.IDPOLIZA
    FROM ASEGURADO_CERTIFICADO AC, DETALLE_POLIZA DP, POLIZAS PO
   WHERE AC.CODCIA       = DP.CODCIA
     AND AC.IDPOLIZA     = DP.IDPOLIZA
     AND AC.IDETPOL      = DP.IDETPOL
     AND DP.IDPOLIZA     = PO.IDPOLIZA
  UNION
  SELECT OC_CLIENTES.NOMBRE_CLIENTE(PO.CODCLIENTE) CONTRATANTE,
         PO.CODCLIENTE CODIGO_CONTRATANTE,
         OC_ASEGURADO.NOMBRE_ASEGURADO(PO.CODCIA, PO.CODEMPRESA, DP.COD_ASEGURADO) ASEGURADO,
         DP.COD_ASEGURADO CODIGO_ASEGURADO,
         PO.NUMPOLUNICO NUMERO_POLIZA,
         DP.IDETPOL NUMERO_SUBGRUPO,
         PO.IDPOLIZA
    FROM DETALLE_POLIZA DP, POLIZAS PO
   WHERE DP.IDPOLIZA     = PO.IDPOLIZA;*/
--
--AUTHID CURRENT_USER
--AS
BEGIN
  --
  v_archivo := utl_file.fopen ('DPDMP', cArchivo, 'w');   ---'DPDMP''LOGEM_BC', cArchivo, 'w');   ---);'DIR_TMP', cArchivo, 'w');
  --
  cCadena := 'CODIGO_DEL_CONTRATANTE'||cLimitador||'NOMBRE_CONTRATANTE '||cLimitador||'CODIGO_DEL_ASEGURADO'||cLimitador||'NOMBRE_ASEGURADO'||cLimitador||
             'CODIGO_ASEGURADO_CERTIFICADO'||cLimitador||'NOMBRE_ASEGURADO_CERTIFICADO '||cLimitador||'POLIZA_UNICA'||cLimitador||'VIGENCIA'||cLimitador||
             'SUB_GRUPO'||cLimitador||'NOMBRE_SUBGRUPO '||cLimitador||'PRODUCTO'||cLimitador||'PLAN_COBERTURA'||cLimitador||
             'INICIO_DE_VIGENCIA'||cLimitador||'FIN_DE_VIGENCIA '||cLimitador||'PAGADO_HASTA'||cLimitador||'ESTATUS_DE_GRUPO'||cLimitador||
             'ESTATUS_DE_PAGO'||cLimitador||'CODIGO_DEL_CONTRATANTE '||cLimitador||'NOMBRE_CONTRATANTE'||cLimitador||'PLAN__DE__PAGOS'||cLimitador||
             'TIPO_DE_ADMINISTRACION'||cLimitador||'SUMA_ASEGURADA '||cLimitador||'DEDUCIBLE'||cLimitador||'CODAGENTE'||cLimitador||'NOMAGENTE'||cLimitador||
             ' REGIONAL '
             ;
  --
  utl_file.put_line (v_archivo, cCadena);
  --
  dbms_output.put_line('     Inicia    LOGEM ');
  FOR X IN POL_Q LOOP

    -----------------------------   REGINONAL  ----------------------------------------------

      dbms_output.put_line('     X.IdPOLIZA '||X.IdPOLIZA);
       dbms_output.put_line('     X.CODAGENTE '|| X.CODAGENTE);
     BEGIN
       SELECT S.COD_AGENTE , S.CODNIVEL
         INTO wAGENTE      , wNivelAgente
       FROM AGENTES_DISTRIBUCION_POLIZA S
       WHERE S.IDPOLIZA         = X.IdPOLIZA
       AND   S.COD_AGENTE       = X.CODAGENTE 
       AND   S.COD_AGENTE_DISTR = X.CODAGENTE ;
     EXCEPTION  WHEN OTHERS  THEN 
       wAGENTE  := NULL;   wNivelAgente  := NULL;   
     END;  
    --
       dbms_output.put_line('     wNivelAgente '||wNivelAgente);
     IF wNivelAgente =  1 THEN
      wRegional := X.NOMAGENTE;
      dbms_output.put_line('1     wRegional '||wRegional);
     ELSIF wNivelAgente IN (4,5)  THEN
      wRegional := 'No pertenece a un Regional';  
      dbms_output.put_line('2     wRegional '||wRegional);   
     ELSIF  wNivelAgente IN (2,3)  THEN
            BEGIN
             SELECT S2.COD_AGENTE_DISTR  
               INTO wAGENTEReg       
             FROM AGENTES_DISTRIBUCION_POLIZA S2
             WHERE S2.IDPOLIZA   = X.IdPOLIZA
             AND   S2.CODNIVEL   = 1 ; 
            EXCEPTION WHEN OTHERS THEN
                wAGENTEReg := NULL;
            END; 
            dbms_output.put_line('      wAGENTEReg '||wAGENTEReg);    
          BEGIN
            SELECT Nombre||' '||Apellido_paterno||' '||Apellido_Materno
               INTO cNombreRegional
              FROM PERSONA_NATURAL_JURIDICA PNJ, AGENTES AG
             WHERE PNJ.TIPO_DOC_IDENTIFICACION = AG.TIPO_DOC_IDENTIFICACION
               AND PNJ.NUM_DOC_IDENTIFICACION = AG.NUM_DOC_IDENTIFICACION
               AND AG.CODCIA     =  1
               AND AG.COD_AGENTE =  wAGENTEReg;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cNombreRegional := 'NO TIENE JEFE';
            WHEN TOO_MANY_ROWS THEN
               cNombreRegional:= 'NO TIENE JEFE';
          END;
          wRegional := cNombreRegional;    
          dbms_output.put_line('3     wRegional '||wRegional); 
     END IF;
    -----------------------------   PAGADO HASTA   -------------------------------------------
     /*BEGIN
      SELECT MAX(IdFactura)
        INTO dIdFactura
        FROM FACTURAS
       WHERE IdPoliza = X.IdPOLIZA
         --AND IDetPol  = X.IDetPol
         AND StsFact  = 'PAG';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        dIdFactura := NULL;
      WHEN OTHERS THEN         --JICO
        dIdFactura := NULL;    --JICO
    END;

      dbms_output.put_line('dIdFactura   '||dIdFactura);
    IF dIdFactura IS NOT NULL THEN       --JICO
        FecPago := OC_FACTURAS.VIGENCIA_FINAL(1,dIdFactura);        
    ELSE
        FecPago := NULL;
    END IF; */

     IF X.INDFACTURAPOL = 'S' THEN  
          BEGIN
            SELECT  MAX(OC_FACTURAS.VIGENCIA_FINAL(a.codcia,a.idfactura))
             INTO FecPago ----dIdFactura a
            FROM FACTURAS a
            WHERE a.Codcia   = x.CODCIA
            AND   a.IdPoliza = X.IdPoliza
            AND   a.StsFact  = 'PAG'
             ;
               --MESSAGE('1 :BK_POLIZAS.FecPago  :  '||:BK_POLIZAS.FecPago);     synchronize;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 FecPago  := NULL; 
              WHEN OTHERS THEN
                  FecPago  := NULL; 
          END;    
    ELSE
          BEGIN
            SELECT  MAX(OC_FACTURAS.VIGENCIA_FINAL(a.codcia,a.idfactura))
             INTO FecPago ----dIdFactura a
            FROM FACTURAS a
            WHERE a.Codcia   = x.CodCia
            AND   a.IdPoliza = X.IdPoliza
            AND   A.IDETPOL  = X.IDetPol
             AND  a.StsFact  = 'PAG'
             ;
               --MESSAGE('1 :BK_POLIZAS.FecPago  :  '||:BK_POLIZAS.FecPago);     synchronize;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                  FecPago  := NULL; 
                WHEN OTHERS THEN
                    FecPago  := NULL; 
          END;    

    END IF;
     dbms_output.put_line('      FecPago '||FecPago);  
    ------------------------------------------------------------------------------------------
    cCadena := 
                X.CODIGO_DEL_CONTRATANTE       ||cLimitador||
                X.NOMBRE_CONTRATANTE           ||cLimitador||
                X.CODIGO_DEL_ASEGURADO         ||cLimitador||
                X.NOMBRE_ASEGURADO             ||cLimitador||
                X.CODIGO_ASEGURADO_CERTIFICADO ||cLimitador||
                X.NOMBRE_ASEGURADO_CERTIFICADO ||cLimitador||
                X.POLIZA_UNICA                 ||cLimitador||
                X.VIGENCIA                     ||cLimitador||
                X.SUB_GRUPO                    ||cLimitador||
                X.NOMBRE_SUBGRUPO              ||cLimitador||
                X.PRODUCTO                     ||cLimitador||
                X.PLAN_COBERTURA               ||cLimitador||
                X.INICIO_DE_VIGENCIA           ||cLimitador||
                X.FIN_DE_VIGENCIA              ||cLimitador||
                FecPago                        ||cLimitador||--X.PAGADO_HASTA                 ||cLimitador||
                X.ESTATUS_DE_GRUPO             ||cLimitador||
                X.ESTATUS_DE_PAGO              ||cLimitador||
                X.CODIGO_DEL_CONTRATANTE       ||cLimitador||
                X.NOMBRE_CONTRATANTE           ||cLimitador||   
                X.PLAN__DE__PAGOS              ||cLimitador||     
                X.TIPO_DE_ADMINISTRACION       ||cLimitador||      
                X.SUMA_ASEGURADA               ||cLimitador||       
                X.DEDUCIBLE                    ||cLimitador||
                X.CODAGENTE                    ||cLimitador||
                X.NOMAGENTE                    ||cLimitador||
                wRegional
                ;





              /* 
               X.CONTRATANTE         ||cLimitador||
               X.CODIGO_CONTRATANTE  ||cLimitador||
               X.ASEGURADO           ||cLimitador||
               X.CODIGO_ASEGURADO    ||cLimitador||
               X.NUMERO_POLIZA       ||cLimitador||
               X.NUMERO_SUBGRUPO     ||CHR(13);*/
    --
    utl_file.put_line (v_archivo, cCadena);
    --
  END LOOP;
  --
  dbms_output.put_line('     Termina    LOGEM ');
  utl_file.fclose(v_archivo); 
  --
exception
  when utl_file.invalid_operation then
    dbms_output.put_line ('Error: utl_file.invalid_operation');
END;

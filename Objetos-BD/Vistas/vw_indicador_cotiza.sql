--
-- VW_INDICADOR_COTIZA  (View) 
--
--  Dependencies: 
--   VALORES_DE_LISTAS (Table)
--   PLAN_COBERTURAS (Table)
--   COTIZACIONES (Table)
--   COTIZACIONES_DETALLE (Table)
--   OFICINAS (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   AGENTES (Table)
--   CATEGORIAS (Table)
--   TIPOS_DE_SEGUROS (Table)
--
CREATE OR REPLACE FORCE VIEW SICAS_OC.VW_INDICADOR_COTIZA
(COT_CODCIA, COT_CODEMPRESA, COT_IDCOTIZACION, COT_IDTIPOSEG, COT_CODRAMO, 
 COT_RAMO, COT_PLANCOB, COT_CODSUBRAMO, COT_SUBRAMO, COT_IDPOLIZA, 
 COT_NUMRENOV, COT_CODGRUPOEC, COT_CONTRA_REA, COT_CLIENTE, COT_IDECOTIZA, 
 COT_NUMUNICOCOTIZACION, COT_STSCOTIZACION, COT_FECSTATUS, COT_FECCOTIZACION, COT_FECINIVIGCOT, 
 COT_FECFINVIGCOT, COT_FECRENOVA, COT_FECVENCECOTIZACION, COT_CODAGENTE, COT_AGENTE, 
 COT_CODPROMOTOR, COT_PROMOTOR, COT_CODDR, COT_DR, COT_CODPLANPAGO, 
 COT_CODCANALFORMAVENTA, COT_CANALFORMAVENTA, COT_CODAGRUPADOR, COT_AGRUPADOR, COT_CODTIPONEGOCIO, 
 COT_TIPONEGOCIO, COT_CODCATEGO, COT_CATEGORIA, COT_CODFUENTERECURSOS, COT_FUENTERECURSOS, 
 COT_CODOFICINA, COT_OFICINA, COT_GIRONEGOCIO, COT_ESCONTRIBUTORIO, COT_PORCENCONTRIBUTORIO, 
 COT_PLATAFOMA_WEB, COT_CODPAQCOMERCIAL, COT_COD_MONEDA, COT_SUMAASEGCOTLOCAL, COT_SUMAASEGCOTMONEDA, 
 COT_PRIMACOTLOCAL, COT_PRIMACOTMONEDA)
AS 
(
 SELECT 
        COT.CODCIA                    COT_CODCIA,
        COT.CODEMPRESA                COT_CODEMPRESA,
        COT.IDCOTIZACION              COT_IDCOTIZACION,
        COT.IDTIPOSEG                 COT_IDTIPOSEG,
        TIP.CODTIPOPLAN               COT_CODRAMO,
        RAM.DESCVALLST                COT_RAMO,
        COT.PLANCOB                   COT_PLANCOB,        
        PLA.CODTIPOPLAN               COT_CODSUBRAMO,
        SUB.DESCVALLST                COT_SUBRAMO,
        COT.IDPOLIZA                  COT_IDPOLIZA,
        NULL                          COT_NUMRENOV,
        NULL                          COT_CODGRUPOEC,        
        NULL                          COT_CONTRA_REA,
        COT.NOMBRECONTRATANTE         COT_CLIENTE,
        COUNT(DET.IDETCOTIZACION)     COT_IDECOTIZA,                    
        COT.NUMUNICOCOTIZACION        COT_NUMUNICOCOTIZACION,
        COT.STSCOTIZACION             COT_STSCOTIZACION,
        COT.FECSTATUS                 COT_FECSTATUS,
        COT.FECCOTIZACION             COT_FECCOTIZACION,
        COT.FECINIVIGCOT              COT_FECINIVIGCOT,
        COT.FECFINVIGCOT              COT_FECFINVIGCOT,
        NULL                          COT_FECRENOVA,
        COT.FECVENCECOTIZACION        COT_FECVENCECOTIZACION,
        --
        TRIM(TO_CHAR(COT.CODAGENTE))  COT_CODAGENTE,
        TRIM(PAG.NOMBRE || ' ' || PAG.APELLIDO_PATERNO || ' ' || PAG.APELLIDO_MATERNO) COT_AGENTE,
        --
        NULL                    COT_CODPROMOTOR,
        NULL                    COT_PROMOTOR,
        --
        NULL                    COT_CODDR,
        NULL                    COT_DR,
        --
        COT.CODPLANPAGO               COT_CODPLANPAGO,
        COT.CANALFORMAVENTA           COT_CODCANALFORMAVENTA,
        CAN.DESCVALLST                COT_CANALFORMAVENTA,
        NULL                          COT_CODAGRUPADOR,
        NULL                          COT_AGRUPADOR,
        --
        COT.CODTIPONEGOCIO            COT_CODTIPONEGOCIO,
        NEG.DESCVALLST                                                  COT_TIPONEGOCIO,
        --
        COT.CODCATEGO                                                   COT_CODCATEGO,
        CGO.DESCCATEGO                                                  COT_CATEGORIA,
        --
        COT.FUENTERECURSOSPRIMA                                         COT_CODFUENTERECURSOS,
        FTE.DESCVALLST                                                  COT_FUENTERECURSOS,
        --
        COT.CODOFICINA                                                  COT_CODOFICINA,
        OFI.DESCOFICINA                                                 COT_OFICINA,
        --
        UPPER(COT.DESCGIRONEGOCIO)                                      COT_GIRONEGOCIO, 
        DECODE(NVL(COT.PORCENCONTRIBUTORIO, 0), 0, 'N', 'S')            COT_ESCONTRIBUTORIO,
        NVL(COT.PORCENCONTRIBUTORIO, 0)                                 COT_PORCENCONTRIBUTORIO,       
        NVL(NVL(COT.INDCOTIZACIONWEB, COT.INDCOTIZACIONBASEWEB), 'N')   COT_PLATAFOMA_WEB,
        COT.CODPAQCOMERCIAL                                             COT_CODPAQCOMERCIAL,
        COT.COD_MONEDA                COT_COD_MONEDA,
        SUM(DET.SUMAASEGDETLOCAL)     COT_SUMAASEGCOTLOCAL,
        SUM(DET.SUMAASEGDETMONEDA)    COT_SUMAASEGCOTMONEDA,
        SUM(DET.PRIMADETLOCAL)        COT_PRIMACOTLOCAL,
        SUM(DET.PRIMADETMONEDA)       COT_PRIMACOTMONEDA        
  FROM COTIZACIONES    COT  LEFT JOIN VALORES_DE_LISTAS         FTE  ON FTE.CODLISTA = 'TIPNEGO'   AND FTE.CODVALOR = COT.FUENTERECURSOSPRIMA 
                            LEFT JOIN VALORES_DE_LISTAS         NEG  ON NEG.CODLISTA = 'FUENTEREC' AND NEG.CODVALOR = COT.CODTIPONEGOCIO
                            LEFT JOIN CATEGORIAS                CGO  ON CGO.CODCIA   = COT.CODCIA  AND CGO.CODEMPRESA = COT.CODEMPRESA AND CGO.CODTIPONEGOCIO = COT.CODTIPONEGOCIO AND CGO.CODCATEGO = COT.CODCATEGO
                            LEFT JOIN OFICINAS                  OFI  ON OFI.CODOFICINA = COT.CODOFICINA
                            LEFT JOIN COTIZACIONES_DETALLE      DET  ON DET.CODCIA   = COT.CODCIA  AND DET.CODEMPRESA = COT.CODEMPRESA AND DET.IDCOTIZACION = COT.IDCOTIZACION
                            LEFT JOIN TIPOS_DE_SEGUROS          TIP  ON TIP.CODCIA   = COT.CODCIA  AND TIP.CODEMPRESA = COT.CODEMPRESA AND TIP.IDTIPOSEG    = COT.IDTIPOSEG
                            LEFT JOIN VALORES_DE_LISTAS         RAM  ON RAM.CODLISTA = 'CODRAMOS'  AND RAM.CODVALOR   = TIP.CODTIPOPLAN                            
                            LEFT JOIN PLAN_COBERTURAS           PLA  ON PLA.CODCIA   = COT.CODCIA  AND PLA.CODEMPRESA = COT.CODEMPRESA AND PLA.IDTIPOSEG    = COT.IDTIPOSEG  AND PLA.PLANCOB = COT.PLANCOB                          
                            LEFT JOIN VALORES_DE_LISTAS         SUB  ON SUB.CODLISTA = 'SUBRAMOS'  AND SUB.CODVALOR   = PLA.CODTIPOPLAN
                            LEFT JOIN VALORES_DE_LISTAS         CAN  ON CAN.CODLISTA = 'FORMVENT'  AND CAN.CODVALOR   = COT.CANALFORMAVENTA
                            LEFT JOIN AGENTES                   AGE  ON AGE.CODCIA   = COT.CODCIA  AND AGE.CODEMPRESA = COT.CODEMPRESA AND AGE.COD_AGENTE = COT.CODAGENTE
                            LEFT JOIN PERSONA_NATURAL_JURIDICA  PAG  ON PAG.TIPO_DOC_IDENTIFICACION = AGE.TIPO_DOC_IDENTIFICACION AND PAG.NUM_DOC_IDENTIFICACION = AGE.NUM_DOC_IDENTIFICACION
--WHERE COT.IDCOTIZACION = 3682              
GROUP BY 
        COT.CODCIA                    ,
        COT.CODEMPRESA                ,
        COT.IDCOTIZACION              ,
        COT.IDTIPOSEG                 ,
        TIP.CODTIPOPLAN               ,
        RAM.DESCVALLST                ,
        COT.PLANCOB                   ,
        PLA.CODTIPOPLAN               ,
        SUB.DESCVALLST                ,
        COT.IDPOLIZA                  ,
        COT.NOMBRECONTRATANTE         ,
        COT.NUMUNICOCOTIZACION        ,
        COT.STSCOTIZACION             ,
        COT.FECSTATUS                 ,
        COT.FECCOTIZACION             ,
        COT.FECINIVIGCOT              ,
        COT.FECFINVIGCOT              ,
        COT.FECVENCECOTIZACION        ,        
        TRIM(TO_CHAR(COT.CODAGENTE))  ,
        TRIM(PAG.NOMBRE || ' ' || PAG.APELLIDO_PATERNO || ' ' || PAG.APELLIDO_MATERNO),
        COT.CODPLANPAGO               , 
        COT.CANALFORMAVENTA           , 
        CAN.DESCVALLST                ,
        --
        COT.CODTIPONEGOCIO            ,            
        NEG.DESCVALLST                ,                               
        --
        COT.CODCATEGO                 ,                               
        CGO.DESCCATEGO                ,                               
        --
        COT.FUENTERECURSOSPRIMA       ,                               
        FTE.DESCVALLST                ,                               
        --
        COT.CODOFICINA                ,                               
        OFI.DESCOFICINA               ,                               
        --
        UPPER(COT.DESCGIRONEGOCIO)    ,                                
        NVL(COT.PORCENCONTRIBUTORIO, 0),          
        NVL(NVL(COT.INDCOTIZACIONWEB, COT.INDCOTIZACIONBASEWEB), 'N'),
        COT.CODPAQCOMERCIAL           ,
        COT.COD_MONEDA    )
/


--
-- VW_INDICADOR_COTIZA  (Synonym) 
--
--  Dependencies: 
--   VW_INDICADOR_COTIZA (View)
--
CREATE OR REPLACE PUBLIC SYNONYM VW_INDICADOR_COTIZA FOR SICAS_OC.VW_INDICADOR_COTIZA
/


GRANT SELECT ON SICAS_OC.VW_INDICADOR_COTIZA TO PUBLIC
/

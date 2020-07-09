--
-- FN_INDICADORES_CODDIFER  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   GT_WEB_SERVICES (Package)
--
CREATE OR REPLACE FUNCTION SICAS_OC.FN_INDICADORES_CODDIFER(CODDIFER VARCHAR2 := '000000000000000000000000000') RETURN VARCHAR2 IS
    RESPUESTA VARCHAR2(3200);
BEGIN
        WITH DATA AS(
            SELECT NULL                  DESCRIP, 0  CODIGO FROM DUAL UNION ALL --0     
            SELECT 'IDCOTIZACION'        DESCRIP, 1  CODIGO FROM DUAL UNION ALL --1     
            SELECT 'IDTIPOSEG'           DESCRIP, 2  CODIGO FROM DUAL UNION ALL --2      
            SELECT 'CODRAMO'             DESCRIP, 3  CODIGO FROM DUAL UNION ALL --3      
            SELECT 'PLANCOB'             DESCRIP, 4  CODIGO FROM DUAL UNION ALL --4      
            SELECT 'CODSUBRAMO'          DESCRIP, 5  CODIGO FROM DUAL UNION ALL --5      
            SELECT 'IDECOTIZA'           DESCRIP, 6  CODIGO FROM DUAL UNION ALL --6      
            SELECT 'FECSTATUS'           DESCRIP, 7  CODIGO FROM DUAL UNION ALL --7      
            SELECT 'FECCOTIZACION'       DESCRIP, 8  CODIGO FROM DUAL UNION ALL --8      
            SELECT 'FECINIVIGCOT'        DESCRIP, 9  CODIGO FROM DUAL UNION ALL --9      
            SELECT 'FECFINVIGCOT'        DESCRIP, 10 CODIGO FROM DUAL UNION ALL --10     
            SELECT 'CODAGENTE'           DESCRIP, 11 CODIGO FROM DUAL UNION ALL --11     
            SELECT 'CODPLANPAGO'         DESCRIP, 12 CODIGO FROM DUAL UNION ALL --12     
            SELECT 'CODCANALFORMAVENTA'  DESCRIP, 13 CODIGO FROM DUAL UNION ALL --13     
            SELECT 'TIPONEGOCIO'         DESCRIP, 14 CODIGO FROM DUAL UNION ALL --14     
            SELECT 'CODCATEGO'           DESCRIP, 15 CODIGO FROM DUAL UNION ALL --15     
            SELECT 'CATEGORIA'           DESCRIP, 16 CODIGO FROM DUAL UNION ALL --16     
            SELECT 'CODFUENTERECURSOS'   DESCRIP, 17 CODIGO FROM DUAL UNION ALL --17     
            SELECT 'CODOFICINA'          DESCRIP, 18 CODIGO FROM DUAL UNION ALL --18     
            SELECT 'GIRONEGOCIO'         DESCRIP, 19 CODIGO FROM DUAL UNION ALL --19     
            SELECT 'CONTRIBUTORIO'       DESCRIP, 20 CODIGO FROM DUAL UNION ALL --20     
            SELECT 'PLATAFOMA_WEB'       DESCRIP, 21 CODIGO FROM DUAL UNION ALL --21     
            SELECT 'CODPAQCOMERCIAL'     DESCRIP, 22 CODIGO FROM DUAL UNION ALL --22     
            SELECT 'COD_MONEDA'          DESCRIP, 23 CODIGO FROM DUAL UNION ALL --23     
            SELECT 'SUMAASEGCOTLOCAL'    DESCRIP, 24 CODIGO FROM DUAL UNION ALL --24     
            SELECT 'SUMAASEGCOTMONEDA'   DESCRIP, 25 CODIGO FROM DUAL UNION ALL --25     
            SELECT 'PRIMACOTLOCAL'       DESCRIP, 26 CODIGO FROM DUAL UNION ALL --26     
            SELECT 'PRIMACOTMONEDA'      DESCRIP, 27 CODIGO FROM DUAL          )--27
        SELECT GT_WEB_SERVICES.JOIN(CURSOR(
          SELECT DESCRIP FROM DATA WHERE CODIGO = DECODE(CODDIFER, '000000000000000000000000000', 0) OR     
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  1, 1), '1', 1) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  2, 1), '1', 2) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  3, 1), '1', 3) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  4, 1), '1', 4) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  5, 1), '1', 5) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  6, 1), '1', 6) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  7, 1), '1', 7) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  8, 1), '1', 8) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER,  9, 1), '1', 9) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 10, 1), '1', 10) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 11, 1), '1', 11) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 12, 1), '1', 12) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 13, 1), '1', 13) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 14, 1), '1', 14) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 15, 1), '1', 15) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 16, 1), '1', 16) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 17, 1), '1', 17) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 18, 1), '1', 18) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 19, 1), '1', 19) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 20, 1), '1', 20) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 21, 1), '1', 21) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 22, 1), '1', 22) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 23, 1), '1', 23) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 24, 1), '1', 24) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 25, 1), '1', 25) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 26, 1), '1', 26) OR
                                         CODIGO = DECODE(SUBSTR(CODDIFER, 27, 1), '1', 27))) DIFERENCIAS 
        INTO RESPUESTA
        FROM DUAL;
        --
        RETURN RESPUESTA;
        
END FN_INDICADORES_CODDIFER;
/

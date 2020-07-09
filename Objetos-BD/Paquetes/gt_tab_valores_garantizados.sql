--
-- GT_TAB_VALORES_GARANTIZADOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   VALGAR_COB_SEX_EDAD_RIESG (Table)
--   PLAN_COBERTURAS (Table)
--   POLIZAS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT (Table)
--   TAB_VALORES_GARANTIZADOS (Table)
--   TAB_VALORES_GARANTIZADOS (Table)
--   OC_GENERALES (Package)
--   OC_ASEGURADO (Package)
--   DETALLE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_TAB_VALORES_GARANTIZADOS IS

  PROCEDURE INSERTA
    (
    in_CODCIA                IN TAB_VALORES_GARANTIZADOS.CODCIA%TYPE
                      ,in_CODEMPRESA            IN TAB_VALORES_GARANTIZADOS.CODEMPRESA%TYPE
                      ,in_IDPOLIZA              IN TAB_VALORES_GARANTIZADOS.IDPOLIZA%TYPE
                      ,in_IDETPOL               IN TAB_VALORES_GARANTIZADOS.IDETPOL%TYPE
                      ,in_IDENDOSO              IN TAB_VALORES_GARANTIZADOS.IDENDOSO%TYPE
                      ,in_COD_ASEGURADO         IN TAB_VALORES_GARANTIZADOS.COD_ASEGURADO%TYPE
                      ,in_ANIOPOLIZA            IN TAB_VALORES_GARANTIZADOS.ANIOPOLIZA%TYPE
    );

  PROCEDURE ACTUALIZA
    (
     in_CODCIA                IN TAB_VALORES_GARANTIZADOS.CODCIA%TYPE
    ,in_CODEMPRESA            IN TAB_VALORES_GARANTIZADOS.CODEMPRESA%TYPE
    ,in_IDPOLIZA              IN TAB_VALORES_GARANTIZADOS.IDPOLIZA%TYPE
    ,in_IDETPOL               IN TAB_VALORES_GARANTIZADOS.IDETPOL%TYPE
    ,in_IDENDOSO              IN TAB_VALORES_GARANTIZADOS.IDENDOSO%TYPE
    ,in_COD_ASEGURADO         IN TAB_VALORES_GARANTIZADOS.COD_ASEGURADO%TYPE
    ,in_ANIOPOLIZA            IN TAB_VALORES_GARANTIZADOS.ANIOPOLIZA%TYPE
    ,in_ANIO                  IN TAB_VALORES_GARANTIZADOS.ANIO%TYPE
    ,in_EDAD                  IN TAB_VALORES_GARANTIZADOS.EDAD%TYPE
    ,in_PRIMA_ANUAL_LOCAL     IN TAB_VALORES_GARANTIZADOS.PRIMA_ANUAL_LOCAL%TYPE
    ,in_PRIMA_ANUAL_MONEDA    IN TAB_VALORES_GARANTIZADOS.PRIMA_ANUAL_MONEDA%TYPE
    ,in_SUMA_ASEGURADA_LOCAL  IN TAB_VALORES_GARANTIZADOS.SUMA_ASEGURADA_LOCAL%TYPE
    ,in_SUMA_ASEGURADA_MONEDA IN TAB_VALORES_GARANTIZADOS.SUMA_ASEGURADA_MONEDA%TYPE
    ,in_VALOR_RESCATE_LOCAL   IN TAB_VALORES_GARANTIZADOS.VALOR_RESCATE_LOCAL%TYPE
    ,in_VALOR_RESCATE_MONEDA  IN TAB_VALORES_GARANTIZADOS.VALOR_RESCATE_MONEDA%TYPE
    ,in_SEGURO_SALDADO_LOCAL  IN TAB_VALORES_GARANTIZADOS.SEGURO_SALDADO_LOCAL%TYPE
    ,in_SEGURO_SALDADO_MONEDA IN TAB_VALORES_GARANTIZADOS.SEGURO_SALDADO_MONEDA%TYPE
    ,in_PRORROGADO_ANIOS      IN TAB_VALORES_GARANTIZADOS.PRORROGADO_ANIOS%TYPE
    ,in_PRORROGADO_DIAS       IN TAB_VALORES_GARANTIZADOS.PRORROGADO_DIAS%TYPE
    ,in_EFECTIVO_FINAL_LOCAL  IN TAB_VALORES_GARANTIZADOS.EFECTIVO_FINAL_LOCAL%TYPE
    ,in_EFECTIVO_FINAL_MONEDA IN TAB_VALORES_GARANTIZADOS.EFECTIVO_FINAL_MONEDA%TYPE
    ,in_USUARIO_MODIFICO      IN TAB_VALORES_GARANTIZADOS.USUARIO_MODIFICO%TYPE
    ,in_FECHA_MODIFICACION    IN TAB_VALORES_GARANTIZADOS.FECHA_MODIFICACION%TYPE
    );

END GT_TAB_VALORES_GARANTIZADOS;
/

--
-- GT_TAB_VALORES_GARANTIZADOS  (Package Body) 
--
--  Dependencies: 
--   GT_TAB_VALORES_GARANTIZADOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_TAB_VALORES_GARANTIZADOS IS

    PROCEDURE INSERTA (in_CODCIA                IN TAB_VALORES_GARANTIZADOS.CODCIA%TYPE
                      ,in_CODEMPRESA            IN TAB_VALORES_GARANTIZADOS.CODEMPRESA%TYPE
                      ,in_IDPOLIZA              IN TAB_VALORES_GARANTIZADOS.IDPOLIZA%TYPE
                      ,in_IDETPOL               IN TAB_VALORES_GARANTIZADOS.IDETPOL%TYPE
                      ,in_IDENDOSO              IN TAB_VALORES_GARANTIZADOS.IDENDOSO%TYPE
                      ,in_COD_ASEGURADO         IN TAB_VALORES_GARANTIZADOS.COD_ASEGURADO%TYPE
                      ,in_ANIOPOLIZA            IN TAB_VALORES_GARANTIZADOS.ANIOPOLIZA%TYPE
                        ) IS
    --                        
        nANIO                   TAB_VALORES_GARANTIZADOS.ANIO%TYPE;
        nEDAD                   TAB_VALORES_GARANTIZADOS.EDAD%TYPE;                      
        nEDADtab                TAB_VALORES_GARANTIZADOS.EDAD%TYPE;                      
        nPRIMA_ANUAL_LOCAL      TAB_VALORES_GARANTIZADOS.PRIMA_ANUAL_LOCAL%TYPE;   
        nPRIMA_ANUAL_MONEDA     TAB_VALORES_GARANTIZADOS.PRIMA_ANUAL_MONEDA%TYPE;
        nSUMA_ASEGURADA_LOCAL   TAB_VALORES_GARANTIZADOS.SUMA_ASEGURADA_LOCAL%TYPE;
        nSUMA_ASEGURADA_MONEDA  TAB_VALORES_GARANTIZADOS.SUMA_ASEGURADA_MONEDA%TYPE;
        nVALOR_RESCATE_LOCAL    TAB_VALORES_GARANTIZADOS.VALOR_RESCATE_LOCAL%TYPE;
        nVALOR_RESCATE_MONEDA   TAB_VALORES_GARANTIZADOS.VALOR_RESCATE_MONEDA%TYPE;
        nSEGURO_SALDADO_LOCAL   TAB_VALORES_GARANTIZADOS.SEGURO_SALDADO_LOCAL%TYPE;
        nSEGURO_SALDADO_MONEDA  TAB_VALORES_GARANTIZADOS.SEGURO_SALDADO_MONEDA%TYPE;
        nPRORROGADO_ANIOS       TAB_VALORES_GARANTIZADOS.PRORROGADO_ANIOS%TYPE;
        nPRORROGADO_DIAS        TAB_VALORES_GARANTIZADOS.PRORROGADO_DIAS%TYPE;
        nEFECTIVO_FINAL_LOCAL   TAB_VALORES_GARANTIZADOS.EFECTIVO_FINAL_LOCAL%TYPE;
        nEFECTIVO_FINAL_MONEDA  TAB_VALORES_GARANTIZADOS.EFECTIVO_FINAL_MONEDA%TYPE;
        nSumaEFECTIVO_LOCAL     TAB_VALORES_GARANTIZADOS.EFECTIVO_FINAL_LOCAL%TYPE;
        nSumaEFECTIVO_MONEDA    TAB_VALORES_GARANTIZADOS.EFECTIVO_FINAL_MONEDA%TYPE;
        --
        nEXISTE                 NUMBER(3) := 0;
        nTasa_Cambio            number := 0;
        CCODCOBERT              VARCHAR2(100);
        CIDTIPOSEG              VARCHAR2(100);
        CPLANCOB                VARCHAR2(100);
        cCOD_MONEDA             VARCHAR2(100);
        nDuracionPlan           NUMBER(10);
        dFechIniVig             DATE;
        cHabitoTarifa           VARCHAR2(2);
        --  
    BEGIN
        SELECT COUNT(1)
          INTO nEXISTE
          FROM TAB_VALORES_GARANTIZADOS
         WHERE
                CODCIA                  = in_CODCIA
            AND CODEMPRESA              = in_CODEMPRESA
            AND IDPOLIZA                = in_IDPOLIZA
            AND IDETPOL                 = in_IDETPOL
            AND IDENDOSO                = in_IDENDOSO
            AND COD_ASEGURADO           = in_COD_ASEGURADO
            AND ANIOPOLIZA              = in_ANIOPOLIZA;
                  
        IF nEXISTE > 0 THEN
            DELETE FROM TAB_VALORES_GARANTIZADOS
             WHERE
                CODCIA                  = in_CODCIA
            AND CODEMPRESA              = in_CODEMPRESA
            AND IDPOLIZA                = in_IDPOLIZA
            AND IDETPOL                 = in_IDETPOL
            AND IDENDOSO                = in_IDENDOSO
            AND COD_ASEGURADO           = in_COD_ASEGURADO
            AND ANIOPOLIZA              = in_ANIOPOLIZA;        
         END IF;
            
            BEGIN
                SELECT TRUNC(months_between(FECFINVIG, P.FECINIVIG)/12),
                        P.FECFINVIG
                  INTO nDuracionPlan,
                       dFechIniVig
                  FROM POLIZAS P
                 WHERE CODCIA                  = in_CODCIA
                   AND CODEMPRESA              = in_CODEMPRESA
                   AND IDPOLIZA                = in_IDPOLIZA;
            EXCEPTION WHEN NO_DATA_FOUND THEN          
                nDuracionPlan := 0;
            END;
            
            BEGIN
                SELECT D.IDTIPOSEG, D.PLANCOB, D.TASA_CAMBIO, HabitoTarifa,
                       D.PRIMA_LOCAL,
                       D.PRIMA_MONEDA
                  INTO CIDTIPOSEG, CPLANCOB, nTasa_Cambio, cHabitoTarifa,
                       nPRIMA_ANUAL_LOCAL,                             
                       nPRIMA_ANUAL_MONEDA                   
                  FROM DETALLE_POLIZA D
                 WHERE D.IDPOLIZA      = in_IDPOLIZA 
                   AND D.COD_ASEGURADO = in_COD_ASEGURADO
                   AND D.CODCIA        = IN_CODCIA
                   AND D.CODEMPRESA    = in_CODEMPRESA;
            EXCEPTION WHEN NO_DATA_FOUND THEN          
                CIDTIPOSEG := NULL;
                CPLANCOB := NULL;
            END;
              
            FOR ENT_COB IN (                        
                 SELECT S.CODCOBERT  --, P.DURACIONPLAN
                   ---INTO CCODCOBERT   --, nDuracionPlan
                   FROM COBERTURAS_DE_SEGUROS   S,
                        PLAN_COBERTURAS         P   --INNER JOIN PLAN_COBERTURAS P ON S.CODCIA = P.CODCIA AND S.CODEMPRESA = P.CODEMPRESA AND S.IDTIPOSEG = P.IDTIPOSEG AND S.PLANCOB = P.PLANCOB
                  WHERE S.CODCIA                 = IN_CODCIA
                    AND S.CODEMPRESA             = in_CODEMPRESA
                    AND S.INDVALORGARANT         = 'S'                    
                    AND S.IDTIPOSEG              = CIDTIPOSEG 
                    AND S.PLANCOB                = CPLANCOB
                    AND P.CODCIA                 = S.CODCIA
                    AND P.CODEMPRESA             = S.CODEMPRESA
                    AND P.IDTIPOSEG              = S.IDTIPOSEG
                    AND P.ID_LARGO_PLAZO         = 'S') LOOP
--            EXCEPTION WHEN NO_DATA_FOUND THEN
--                            RAISE_APPLICATION_ERROR(-20225,'No existe cobertura asignada básica con identificador de SA de valores garantizados');
--                      WHEN TOO_MANY_ROWS THEN
--                            RAISE_APPLICATION_ERROR(-20225,'Existen varias coberturas básicas asignadas con el identificador de SA de valores Garantizados');
--            END;
                    
                
                BEGIN
                    SELECT 
                           C.SUMAASEG_LOCAL,
                           C.SUMAASEG_MONEDA,
                           C.COD_MONEDA
                      INTO  
                           nSUMA_ASEGURADA_LOCAL,  
                           nSUMA_ASEGURADA_MONEDA,
                           cCOD_MONEDA 
                      FROM COBERT_ACT C
                     WHERE C.CODCIA          = IN_CODCIA
                       AND C.CODEMPRESA      = in_CODEMPRESA
                       AND C.IDPOLIZA        = in_IDPOLIZA
                       AND C.IDETPOL         = in_IDETPOL
                       AND C.IDENDOSO        = in_IDENDOSO
                       AND C.COD_ASEGURADO   = in_COD_ASEGURADO
                       AND C.CODCOBERT       = ENT_COB.CODCOBERT;            
                EXCEPTION WHEN NO_DATA_FOUND THEN          
                    nPRIMA_ANUAL_LOCAL := 0;                
                    nPRIMA_ANUAL_MONEDA := 0;                                           
                END;
                    
                --nTasa_Cambio := GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(dFechIniVig, cCOD_MONEDA);
                IF nTasa_Cambio = 0 THEN
                    RAISE_APPLICATION_ERROR(-20225,'La tasa de cambio esta en cero, favor de validar('|| cCOD_MONEDA || ')');
                END IF;                 

                nANIO := 0;
                nEdad := TRUNC(OC_GENERALES.EDAD(IN_CODCIA, in_CODEMPRESA, in_COD_ASEGURADO)/365);   

                nEDADtab := nEDAD;
                
                FOR I IN 1..nDuracionPlan LOOP
                    --
                    nANIO := nANIO + 1;            
                    --
                    BEGIN
                                       
                        SELECT (T.FactorRescate * nSUMA_ASEGURADA_LOCAL)/1000         VALOR_RESCATE_LOCAL,
                               (FactorSeguroSaldado * nSUMA_aSEGURADA_LOCAL)/1000     SEGURO_SALDADO_LOCAL,
                               (T.FactorRescate * nSUMA_ASEGURADA_MONEDA)/1000         VALOR_RESCATE_MONEDA,
                               (FactorSeguroSaldado * nSUMA_ASEGURADA_MONEDA)/1000     SEGURO_SALDADO_MONEDA,
                                ProrrAnios,
                                ProrrDias
                          INTO nVALOR_RESCATE_LOCAL,
                               NSEGURO_SALDADO_LOCAL,
                               nVALOR_RESCATE_MONEDA,
                               NSEGURO_SALDADO_MONEDA,
                               nPRORROGADO_ANIOS,
                               nPRORROGADO_DIAS
                          FROM VALGAR_COB_SEX_EDAD_RIESG T                       
                        WHERE T.CODCIA      = IN_CODCIA
                          AND T.CODEMPRESA  = in_CODEMPRESA 
                          AND T.IDTIPOSEG   = CIDTIPOSEG
                          AND T.PLANCOB     = CPLANCOB
                          AND T.CODCOBERT   = ENT_COB.CODCOBERT
                          AND nEDAD         BETWEEN T.EDADINITARIFA AND T.EDADFINTARIFA
                          AND T.SEXOTARIFA  = OC_ASEGURADO.SEXO_ASEGURADO(IN_CODCIA,in_CODEMPRESA,in_COD_ASEGURADO) 
                          AND T.RIESGOTARIFA = cHabitoTarifa
                          and T.ANIOPOL = nANIO;
                        --
                        nSumaEFECTIVO_LOCAL := 0;
                        nSumaEFECTIVO_MONEDA:= 0;
                        --                        
                        INSERT INTO TAB_VALORES_GARANTIZADOS
                          (CODCIA                   ,CODEMPRESA             ,IDPOLIZA            
                          ,IDETPOL                  ,IDENDOSO               ,COD_ASEGURADO,         CODCOBERT            
                          ,ANIOPOLIZA               ,ANIO                   ,EDAD 
                          ,COD_MONEDA           
                          ,PRIMA_ANUAL_LOCAL        
                          ,PRIMA_ANUAL_MONEDA     
                          ,SUMA_ASEGURADA_LOCAL            
                          ,SUMA_ASEGURADA_MONEDA    
                          ,VALOR_RESCATE_LOCAL    
                          ,VALOR_RESCATE_MONEDA            
                          ,SEGURO_SALDADO_LOCAL     
                          ,SEGURO_SALDADO_MONEDA  
                          ,PRORROGADO_ANIOS            
                          ,PRORROGADO_DIAS          
                          ,EFECTIVO_FINAL_LOCAL   
                          ,EFECTIVO_FINAL_MONEDA)
                        VALUES
                          (in_CODCIA                  ,in_CODEMPRESA              ,in_IDPOLIZA
                          ,in_IDETPOL                 ,in_IDENDOSO                ,in_COD_ASEGURADO, ENT_COB.CODCOBERT
                          ,in_ANIOPOLIZA              ,nANIO                      ,nEDADtab
                          ,cCOD_MONEDA
                          ,nPRIMA_ANUAL_LOCAL    
                          ,nPRIMA_ANUAL_MONEDA 
                          ,nSUMA_ASEGURADA_LOCAL 
                          ,nSUMA_ASEGURADA_MONEDA      
                          ,nVALOR_RESCATE_LOCAL       
                          ,nVALOR_RESCATE_MONEDA
                          ,nSEGURO_SALDADO_LOCAL     
                          ,nSEGURO_SALDADO_MONEDA    
                          ,nPRORROGADO_ANIOS
                          ,nPRORROGADO_DIAS           ,nSumaEFECTIVO_LOCAL, nSumaEFECTIVO_MONEDA );
                        --
                    EXCEPTION WHEN OTHERS THEN                
                        nVALOR_RESCATE_LOCAL  := 0;
                        NSEGURO_SALDADO_LOCAL := 0;
--                        DBMS_OUTPUT.PUT_LINE( IN_CODCIA  
--                                       || '-' || in_CODEMPRESA 
--                                       || '-' || CIDTIPOSEG
--                                       || '-' || CPLANCOB
--                                       || '-' || ENT_COB.CODCOBERT
--                                       || '-' || nEDAD      
--                                       || '-' || OC_ASEGURADO.SEXO_ASEGURADO(IN_CODCIA,in_CODEMPRESA,in_COD_ASEGURADO) 
--                                       || '-' || cHabitoTarifa
--                                       || '-' || nANIO);
                        --RAISE_APPLICATION_ERROR(-20225,'Hay incosistencia en la tabla de Valores Garantizados Cob Sex Edad Habito, se encontraron más de una factor o una cubertura inexistente en ella'|| SQLERRM);
                    END;   
                    nEDADtab := nEDADtab + 1;                 
                END LOOP;
            END LOOP;
        --END IF;

    END INSERTA;
    --
    PROCEDURE ACTUALIZA
        (
         in_CODCIA                IN TAB_VALORES_GARANTIZADOS.CODCIA%TYPE
        ,in_CODEMPRESA            IN TAB_VALORES_GARANTIZADOS.CODEMPRESA%TYPE
        ,in_IDPOLIZA              IN TAB_VALORES_GARANTIZADOS.IDPOLIZA%TYPE
        ,in_IDETPOL               IN TAB_VALORES_GARANTIZADOS.IDETPOL%TYPE
        ,in_IDENDOSO              IN TAB_VALORES_GARANTIZADOS.IDENDOSO%TYPE
        ,in_COD_ASEGURADO         IN TAB_VALORES_GARANTIZADOS.COD_ASEGURADO%TYPE
        ,in_ANIOPOLIZA            IN TAB_VALORES_GARANTIZADOS.ANIOPOLIZA%TYPE
        ,in_ANIO                  IN TAB_VALORES_GARANTIZADOS.ANIO%TYPE
        ,in_EDAD                  IN TAB_VALORES_GARANTIZADOS.EDAD%TYPE
        ,in_PRIMA_ANUAL_LOCAL     IN TAB_VALORES_GARANTIZADOS.PRIMA_ANUAL_LOCAL%TYPE
        ,in_PRIMA_ANUAL_MONEDA    IN TAB_VALORES_GARANTIZADOS.PRIMA_ANUAL_MONEDA%TYPE
        ,in_SUMA_ASEGURADA_LOCAL  IN TAB_VALORES_GARANTIZADOS.SUMA_ASEGURADA_LOCAL%TYPE
        ,in_SUMA_ASEGURADA_MONEDA IN TAB_VALORES_GARANTIZADOS.SUMA_ASEGURADA_MONEDA%TYPE
        ,in_VALOR_RESCATE_LOCAL   IN TAB_VALORES_GARANTIZADOS.VALOR_RESCATE_LOCAL%TYPE
        ,in_VALOR_RESCATE_MONEDA  IN TAB_VALORES_GARANTIZADOS.VALOR_RESCATE_MONEDA%TYPE
        ,in_SEGURO_SALDADO_LOCAL  IN TAB_VALORES_GARANTIZADOS.SEGURO_SALDADO_LOCAL%TYPE
        ,in_SEGURO_SALDADO_MONEDA IN TAB_VALORES_GARANTIZADOS.SEGURO_SALDADO_MONEDA%TYPE
        ,in_PRORROGADO_ANIOS      IN TAB_VALORES_GARANTIZADOS.PRORROGADO_ANIOS%TYPE
        ,in_PRORROGADO_DIAS       IN TAB_VALORES_GARANTIZADOS.PRORROGADO_DIAS%TYPE
        ,in_EFECTIVO_FINAL_LOCAL  IN TAB_VALORES_GARANTIZADOS.EFECTIVO_FINAL_LOCAL%TYPE
        ,in_EFECTIVO_FINAL_MONEDA IN TAB_VALORES_GARANTIZADOS.EFECTIVO_FINAL_MONEDA%TYPE
        ,in_USUARIO_MODIFICO      IN TAB_VALORES_GARANTIZADOS.USUARIO_MODIFICO%TYPE
        ,in_FECHA_MODIFICACION    IN TAB_VALORES_GARANTIZADOS.FECHA_MODIFICACION%TYPE
        ) IS
    BEGIN
        UPDATE TAB_VALORES_GARANTIZADOS
        SET 
            EDAD                    = in_EDAD
           ,PRIMA_ANUAL_LOCAL       = in_PRIMA_ANUAL_LOCAL
           ,PRIMA_ANUAL_MONEDA      = in_PRIMA_ANUAL_MONEDA
           ,SUMA_ASEGURADA_LOCAL    = in_SUMA_ASEGURADA_LOCAL
           ,SUMA_ASEGURADA_MONEDA   = in_SUMA_ASEGURADA_MONEDA
           ,VALOR_RESCATE_LOCAL     = in_VALOR_RESCATE_LOCAL
           ,VALOR_RESCATE_MONEDA    = in_VALOR_RESCATE_MONEDA
           ,SEGURO_SALDADO_LOCAL    = in_SEGURO_SALDADO_LOCAL
           ,SEGURO_SALDADO_MONEDA   = in_SEGURO_SALDADO_MONEDA
           ,PRORROGADO_ANIOS        = in_PRORROGADO_ANIOS
           ,PRORROGADO_DIAS         = in_PRORROGADO_DIAS
           ,EFECTIVO_FINAL_LOCAL    = in_EFECTIVO_FINAL_LOCAL
           ,EFECTIVO_FINAL_MONEDA   = in_EFECTIVO_FINAL_MONEDA
           ,USUARIO_MODIFICO        = in_USUARIO_MODIFICO
           ,FECHA_MODIFICACION      = in_FECHA_MODIFICACION
        WHERE
            CODCIA                  = in_CODCIA
        AND CODEMPRESA              = in_CODEMPRESA
        AND IDPOLIZA                = in_IDPOLIZA
        AND IDETPOL                 = in_IDETPOL
        AND IDENDOSO                = in_IDENDOSO
        AND COD_ASEGURADO           = in_COD_ASEGURADO
        AND ANIOPOLIZA              = in_ANIOPOLIZA
        AND ANIO                    = in_ANIO;
    END ACTUALIZA;

END GT_TAB_VALORES_GARANTIZADOS;
/

--
-- GT_TAB_VALORES_GARANTIZADOS  (Synonym) 
--
--  Dependencies: 
--   GT_TAB_VALORES_GARANTIZADOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_TAB_VALORES_GARANTIZADOS FOR SICAS_OC.GT_TAB_VALORES_GARANTIZADOS
/


GRANT EXECUTE ON SICAS_OC.GT_TAB_VALORES_GARANTIZADOS TO PUBLIC
/

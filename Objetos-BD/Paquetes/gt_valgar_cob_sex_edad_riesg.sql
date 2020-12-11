--
-- GT_VALGAR_COB_SEX_EDAD_RIESG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   VALGAR_COB_SEX_EDAD_RIESG (Table)
--   PLAN_COBERTURAS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   TARIFA_SEXO_EDAD_RIESGO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_VALGAR_COB_SEX_EDAD_RIESG IS

    PROCEDURE COPIAR(nCodCia number, nCodEmpresa number,  cIdTipoSeg    varchar2, cPlanCob    varchar2,
                                                          cIdTipoSegDes varchar2, cPlanCobDes varchar2);
    
END GT_VALGAR_COB_SEX_EDAD_RIESG;
/

--
-- GT_VALGAR_COB_SEX_EDAD_RIESG  (Package Body) 
--
--  Dependencies: 
--   GT_VALGAR_COB_SEX_EDAD_RIESG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_VALGAR_COB_SEX_EDAD_RIESG IS

    PROCEDURE COPIAR(nCodCia number, nCodEmpresa number,  cIdTipoSeg varchar2,    cPlanCob varchar2,
                                                          cIdTipoSegDes varchar2, cPlanCobDes varchar2) is    
        nDummy NUMBER := 0;
        KONT   NUMBER :=0;
    BEGIN
        SELECT COUNT(*)
            INTO KONT
            FROM VALGAR_COB_SEX_EDAD_RIESG T
                      WHERE T.CODCIA                 = nCodCia
                        AND T.CODEMPRESA             = nCodEmpresa
                        AND T.IDTIPOSEG              = cIdTipoSeg
                        AND T.PLANCOB                = cPlanCob;
        IF KONT != 0 THEN    
            SELECT DURACIONPLAN
              INTO KONT
                FROM PLAN_COBERTURAS T
           WHERE T.CODCIA                 = nCodCia
             AND T.CODEMPRESA             = nCodEmpresa
             AND T.IDTIPOSEG              = cIdTipoSeg
             AND T.PLANCOB                = cPlanCob
             AND ID_LARGO_PLAZO           = 'S';    
            
            FOR nDummy IN 1..KONT LOOP
                INSERT INTO VALGAR_COB_SEX_EDAD_RIESG (
                          CODCIA, CODEMPRESA, IDTIPOSEG, PLANCOB, CODCOBERT, EDADINITARIFA, EDADFINTARIFA, ANIOPOL, SEXOTARIFA, RIESGOTARIFA, 
                          FACTORRESCATE, FACTORSEGUROSALDADO, PRORRANIOS, PRORRDIAS, IDTARIFA) 
                 SELECT CODCIA, CODEMPRESA, IDTIPOSEG, PLANCOB, CODCOBERT, EDADINITARIFA, EDADFINTARIFA, nDummy, SEXOTARIFA, HABITOTARIFA,
                          0,                         0,                                         0,                 0,                  IDTARIFA
                   FROM TARIFA_SEXO_EDAD_RIESGO T 
                      WHERE T.CODCIA                 = nCodCia
                        AND T.CODEMPRESA             = nCodEmpresa
                        AND T.IDTIPOSEG              = cIdTipoSeg
                        AND T.PLANCOB                =cPlanCob
                        AND T.CODCOBERT IN (SELECT S.CODCOBERT 
                                              FROM COBERTURAS_DE_SEGUROS   S,
                                                   PLAN_COBERTURAS         P       
                                             WHERE S.CODCIA                 = nCodCia
                                               AND S.CODEMPRESA             = nCodEmpresa
                                               AND S.INDVALORGARANT         = 'S'
                                               AND S.IDTIPOSEG              = cIdTipoSeg 
                                               AND S.PLANCOB                = cPlanCob
                                               AND P.CODCIA                 = S.CODCIA
                                               AND P.CODEMPRESA             = S.CODEMPRESA
                                               AND P.IDTIPOSEG              = S.IDTIPOSEG
                                               AND P.ID_LARGO_PLAZO         = 'S');             
            END LOOP;
            
        END IF;   
   END; 
   
END GT_VALGAR_COB_SEX_EDAD_RIESG;
/

--
-- GT_VALGAR_COB_SEX_EDAD_RIESG  (Synonym) 
--
--  Dependencies: 
--   GT_VALGAR_COB_SEX_EDAD_RIESG (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_VALGAR_COB_SEX_EDAD_RIESG FOR SICAS_OC.GT_VALGAR_COB_SEX_EDAD_RIESG
/


GRANT EXECUTE ON SICAS_OC.GT_VALGAR_COB_SEX_EDAD_RIESG TO PUBLIC
/

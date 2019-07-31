--
-- GT_DIAS_FESTIVOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DIAS_FESTIVOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_DIAS_FESTIVOS AS
    --
    FUNCTION ES_FESTIVO(dFecha DATE) RETURN NUMBER;
    --
END GT_DIAS_FESTIVOS;
/

--
-- GT_DIAS_FESTIVOS  (Package Body) 
--
--  Dependencies: 
--   GT_DIAS_FESTIVOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_DIAS_FESTIVOS AS
    --
    FUNCTION ES_FESTIVO(dFecha DATE) RETURN NUMBER
    AS
        nRetorno    NUMBER(1) :=0;
    BEGIN    
        ---
        SELECT 1
          INTO nRetorno 
          FROM DIAS_FESTIVOS F
         WHERE FECHA = TRUNC(dFecha);
        ---        
        RETURN nRetorno;
        ---
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN 0;
    END;
    --
END GT_DIAS_FESTIVOS;
/

CREATE OR REPLACE PACKAGE GT_DIAS_FESTIVOS AS
    --
    FUNCTION ES_FESTIVO(dFecha DATE) RETURN NUMBER;
    --
END GT_DIAS_FESTIVOS;
/

CREATE OR REPLACE PACKAGE BODY GT_DIAS_FESTIVOS AS
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

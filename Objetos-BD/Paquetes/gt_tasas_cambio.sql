--
-- GT_TASAS_CAMBIO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   XMLTYPE (Synonym)
--   GT_WEB_SERVICES (Package)
--   TASAS_CAMBIO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_TASAS_CAMBIO AS

  PROCEDURE INSERTA(FECHA DATE, TIPO_MONEDA VARCHAR2, MONTO NUMBER);
  PROCEDURE ACTUALIZA(FECHA DATE, TIPO_MONEDA VARCHAR2, MONTO NUMBER);
  PROCEDURE EJECUTA_PROCESO_WS_TASA_CAMBIO;
  FUNCTION CONSULTA_TASA_CAMBIO(FECHA DATE, TIPO_MONEDA VARCHAR2) RETURN NUMBER;

END GT_TASAS_CAMBIO;
/

--
-- GT_TASAS_CAMBIO  (Package Body) 
--
--  Dependencies: 
--   GT_TASAS_CAMBIO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_TASAS_CAMBIO AS
    --
    PROCEDURE INSERTA(FECHA DATE, TIPO_MONEDA VARCHAR2, MONTO NUMBER) IS    
    BEGIN
        INSERT INTO TASAS_CAMBIO 
                        (FECHA_HORA_CAMBIO, COD_MONEDA,         TASA_CAMBIO)
               VALUES   (trunc(FECHA),             TIPO_MONEDA,        MONTO );
               
    END INSERTA;
    --
    PROCEDURE ACTUALIZA (FECHA DATE, TIPO_MONEDA VARCHAR2, MONTO NUMBER) IS
        nMonto NUMBER;
    BEGIN
        --
        BEGIN
            nMonto := MONTO;            
        EXCEPTION WHEN OTHERS THEN
            nMONTO := 0;
        END;
        --
        IF nMonto = 0 THEN
           SELECT T.TASA_CAMBIO 
             INTO nMonto
             FROM TASAS_CAMBIO T            
            WHERE T.FECHA_HORA_CAMBIO = (SELECT MAX(TT.FECHA_HORA_CAMBIO) 
                                           FROM TASAS_CAMBIO TT            
                                          WHERE TT.TASA_CAMBIO > 0
                                            AND TT.COD_MONEDA        =  TIPO_MONEDA)
              AND T.COD_MONEDA        =  TIPO_MONEDA;
        END IF;
        --   
        UPDATE TASAS_CAMBIO T SET T.TASA_CAMBIO = nMONTO
         WHERE T.FECHA_HORA_CAMBIO = trunc(FECHA)
           AND T.COD_MONEDA        =  TIPO_MONEDA;
        --
        IF sql%rowcount = 0 THEN                            
           INSERTA (trunc(FECHA), TIPO_MONEDA,  nMONTO );
        END IF;   
        --
    END ACTUALIZA;
    --    
    PROCEDURE EJECUTA_PROCESO_WS_TASA_CAMBIO  IS    
        RESULTADO   VARCHAR2(32728);
        PPARAMSQL   VARCHAR2(32728);
        RETORNO     XMLTYPE;
    BEGIN
        RETORNO := GT_WEB_SERVICES.EJECUTA_WS(1, 1, 3000, -3000, RESULTADO, PPARAMSQL);
        --DBMS_OUTPUT.PUT_LINE(RETORNO.getStringVal());
        RETORNO := GT_WEB_SERVICES.EJECUTA_WS(1, 1, 3010, -3010, RESULTADO, PPARAMSQL);
        --DBMS_OUTPUT.PUT_LINE(RETORNO.getStringVal());        
    END EJECUTA_PROCESO_WS_TASA_CAMBIO;
    --    
    FUNCTION CONSULTA_TASA_CAMBIO(FECHA DATE, TIPO_MONEDA VARCHAR2) RETURN NUMBER IS
        nRetorna    NUMBER;
    BEGIN
        --
         SELECT T.TASA_CAMBIO
           INTO nRetorna
          FROM TASAS_CAMBIO T 
         WHERE T.FECHA_HORA_CAMBIO = trunc(FECHA)
           AND T.COD_MONEDA        =  TIPO_MONEDA;
        --
        RETURN   nRetorna;
        --
    EXCEPTION WHEN OTHERS THEN
        RETURN 0;         
    END CONSULTA_TASA_CAMBIO;
    --
END GT_TASAS_CAMBIO;
/

--
-- GT_TASAS_CAMBIO  (Synonym) 
--
--  Dependencies: 
--   GT_TASAS_CAMBIO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_TASAS_CAMBIO FOR SICAS_OC.GT_TASAS_CAMBIO
/


GRANT EXECUTE ON SICAS_OC.GT_TASAS_CAMBIO TO PUBLIC
/

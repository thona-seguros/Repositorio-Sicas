DECLARE
    KUPDATE NUMbER :=0;
    KLEIDOS NUMbER :=0;
BEGIN
    -- COTIZACIONES
    FOR ENT IN (SELECT C.CODCIA, C.CODEMPRESA, C.IDCOTIZACION, C.CODPAQCOMERCIAL, P.CODPAQUETE
                  FROM COTIZACIONES C INNER JOIN PAQUETE_COMERCIAL P ON P.CODCIA      = C.CODCIA  
                                                                    AND P.CODEMPRESA  = C.CODEMPRESA 
                                                                    AND P.DESCPAQUETE = C.CODPAQCOMERCIAL
                 WHERE C.CODPAQCOMERCIAL IS NOT NULL) LOOP
        --                 
        KLEIDOS := KLEIDOS + 1;
        --
        UPDATE COTIZACIONES SET CODPAQCOMERCIAL =  ENT.CODPAQUETE
         WHERE  CODCIA          = ENT.CODCIA
           AND  CODEMPRESA      = ENT.CODEMPRESA
           AND  IDCOTIZACION    = ENT.IDCOTIZACION
           AND  CODPAQCOMERCIAL = ENT.CODPAQCOMERCIAL;            
        --                         
        KUPDATE := KUPDATE + SQL%ROWCOUNT;
        IF MOD(KUPDATE, 1500) = 1 THEN
            COMMIT;
        END IF;
        --
    END LOOP;                 
    
    DBMS_OUTPUT.PUT_LINE('Numero de registros leidos: ' || KLEIDOS);
    DBMS_OUTPUT.PUT_LINE('Numero de registros actualizados: ' || KUPDATE);
   COMMIT;
   KLEIDOS := 0;
   KUPDATE := 0;
    -- COTIZACIONES
    FOR ENT IN (SELECT C.CODCIA, C.CODEMPRESA, C.IDPOLIZA, C.CODPAQCOMERCIAL, P.CODPAQUETE
                  FROM POLIZAS C INNER JOIN PAQUETE_COMERCIAL P ON P.CODCIA      = C.CODCIA  
                                                                    AND P.CODEMPRESA  = C.CODEMPRESA 
                                                                    AND P.DESCPAQUETE = C.CODPAQCOMERCIAL
                 WHERE C.CODPAQCOMERCIAL IS NOT NULL) LOOP
        --                 
        KLEIDOS := KLEIDOS + 1;
        --
        UPDATE POLIZAS SET CODPAQCOMERCIAL =  ENT.CODPAQUETE
         WHERE  CODCIA          = ENT.CODCIA
           AND  CODEMPRESA      = ENT.CODEMPRESA
           AND  IDPOLIZA        = ENT.IDPOLIZA
           AND  CODPAQCOMERCIAL = ENT.CODPAQCOMERCIAL;            
        --                         
        KUPDATE := KUPDATE + SQL%ROWCOUNT;
        IF MOD(KUPDATE, 1500) = 1 THEN
            COMMIT;
        END IF;
        --
    END LOOP;                 
    
    DBMS_OUTPUT.PUT_LINE('Numero de registros leidos: ' || KLEIDOS);
    DBMS_OUTPUT.PUT_LINE('Numero de registros actualizados: ' || KUPDATE);
   COMMIT;
END;          

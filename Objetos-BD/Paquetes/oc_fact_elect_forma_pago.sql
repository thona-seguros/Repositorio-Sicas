--
-- OC_FACT_ELECT_FORMA_PAGO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FACT_ELECT_FORMA_PAGO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACT_ELECT_FORMA_PAGO AS
    FUNCTION NUMERO_FORMA_PAGO(nCodCia NUMBER) RETURN NUMBER;
    FUNCTION FORMA_PAGO_FACT_ELECT(nCodCia NUMBER,cCodFormaPago VARCHAR2) RETURN VARCHAR2;
    PROCEDURE ACTUALIZA_ESTATUS(nCodCia NUMBER,nIdFormaPago NUMBER, cStsIni VARCHAR2, cStsFin VARCHAR2);
END OC_FACT_ELECT_FORMA_PAGO;
/

--
-- OC_FACT_ELECT_FORMA_PAGO  (Package Body) 
--
--  Dependencies: 
--   OC_FACT_ELECT_FORMA_PAGO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACT_ELECT_FORMA_PAGO AS
    FUNCTION NUMERO_FORMA_PAGO(nCodCia NUMBER) RETURN NUMBER IS
        nIdFormaPago FACT_ELECT_FORMA_PAGO.IdFormaPago%TYPE;
    BEGIN
        SELECT NVL(MAX(IdFormaPago),0) + 1
          INTO nIdFormaPago 
          FROM FACT_ELECT_FORMA_PAGO
         WHERE CodCia = nCodCia;
         
        RETURN nIdFormaPago;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            nIdFormaPago := 1;
            RETURN nIdFormaPago;   
    END NUMERO_FORMA_PAGO;
    --
    --
    FUNCTION FORMA_PAGO_FACT_ELECT(nCodCia NUMBER,cCodFormaPago VARCHAR2) RETURN VARCHAR2 IS
        cFormaPagoFE FACT_ELECT_FORMA_PAGO.CodFormaPagoFE%TYPE;
    BEGIN
        SELECT NVL(CodFormaPagoFE,'NA')
          INTO cFormaPagoFE
          FROM FACT_ELECT_FORMA_PAGO
         WHERE CodCia       = nCodCia
           AND CodFormaPago = cCodFormaPago
           AND StsFormaPago = 'ACT'
           AND TRUNC(SYSDATE) BETWEEN FecIniVig AND FecFinVig;
           
        RETURN cFormaPagoFE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'NO EXISTE FORMA PAGO';
        WHEN TOO_MANY_ROWS THEN
            RETURN 'MAS DE UNA FORMA PAGO';
    END FORMA_PAGO_FACT_ELECT;
    --
    --
    PROCEDURE ACTUALIZA_ESTATUS(nCodCia NUMBER,nIdFormaPago NUMBER, cStsIni VARCHAR2, cStsFin VARCHAR2) IS
    BEGIN
        IF cStsFin = 'SUS' THEN
            UPDATE FACT_ELECT_FORMA_PAGO
               SET StsFormaPago = cStsFin,
                   FecSts       = TRUNC(SYSDATE),
                   FecFinVig    = TRUNC(SYSDATE)
             WHERE CodCia       = nCodCia
               AND IdFormaPago  = nIdFormaPago;
        ELSE
            UPDATE FACT_ELECT_FORMA_PAGO
               SET StsFormaPago = cStsFin,
                   FecSts       = TRUNC(SYSDATE)
             WHERE CodCia       = nCodCia
               AND IdFormaPago  = nIdFormaPago;
        END IF;
    END;
END OC_FACT_ELECT_FORMA_PAGO;
/

--
-- OC_FACT_ELECT_FORMA_PAGO  (Synonym) 
--
--  Dependencies: 
--   OC_FACT_ELECT_FORMA_PAGO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_FACT_ELECT_FORMA_PAGO FOR SICAS_OC.OC_FACT_ELECT_FORMA_PAGO
/


GRANT EXECUTE ON SICAS_OC.OC_FACT_ELECT_FORMA_PAGO TO PUBLIC
/

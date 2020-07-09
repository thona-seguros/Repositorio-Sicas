--
-- GT_DETALLE_DOMICI_REFERE  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_FACTURAS (Package)
--   DETALLE_DOMICI_REFERE (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_DETALLE_DOMICI_REFERE AS
    FUNCTION ESTADO_FACTURA (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2;
    FUNCTION NUMERO_APROBACION (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN NUMBER;
    FUNCTION TIPO_AUTORIZACION (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2;
    FUNCTION INTENTOS_CUMPLIDOS (nCodCia IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2;
    FUNCTION FECHA_COBRO (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN DATE;
    FUNCTION NUMERO_INTENTOS (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN NUMBER;
    PROCEDURE MARCA_INTENTOS_CUMPLIDOS (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER);
    FUNCTION FEC_ULTIMO_INTENTO (nCodCia IN NUMBER, nIdFactura IN NUMBER) RETURN DATE;
    FUNCTION EXISTE_FACTURA (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2;
    FUNCTION FORMA_PAGO (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2;
END GT_DETALLE_DOMICI_REFERE;
/

--
-- GT_DETALLE_DOMICI_REFERE  (Package Body) 
--
--  Dependencies: 
--   GT_DETALLE_DOMICI_REFERE (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_DETALLE_DOMICI_REFERE AS
    FUNCTION ESTADO_FACTURA(nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2 IS
        cEstado DETALLE_DOMICI_REFERE.Estado%TYPE;
    BEGIN 
        BEGIN
            SELECT NVL(Estado,'NA')
              INTO cEstado
              FROM DETALLE_DOMICI_REFERE
             WHERE CodCia       = nCodCia 
               AND IdProceso    = nIdProceso 
               AND IdFactura    = nIdFactura;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cEstado := 'NA';
        END;
        RETURN cEstado;
    END ESTADO_FACTURA;
    
    FUNCTION NUMERO_APROBACION (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN NUMBER IS
        nNumAprob DETALLE_DOMICI_REFERE.NumAprob%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(NumAprob,0)
              INTO nNumAprob
              FROM DETALLE_DOMICI_REFERE
             WHERE CodCia       = nCodCia 
               AND IdProceso    = nIdProceso 
               AND IdFactura    = nIdFactura;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                nNumAprob := 0;
        END;
        RETURN nNumAprob;
    END NUMERO_APROBACION;
    
    FUNCTION TIPO_AUTORIZACION (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2 IS
        cTipoAutorizacion DETALLE_DOMICI_REFERE.TipoAutorizacion%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(TipoAutorizacion,'0')
              INTO cTipoAutorizacion
              FROM DETALLE_DOMICI_REFERE
             WHERE CodCia       = nCodCia 
               AND IdProceso    = nIdProceso 
               AND IdFactura    = nIdFactura;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cTipoAutorizacion := '0';
        END;
        RETURN cTipoAutorizacion;
    END TIPO_AUTORIZACION;
    
    FUNCTION INTENTOS_CUMPLIDOS(nCodCia IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2 IS
        cExiste VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT 'S'
              INTO cExiste
              FROM DETALLE_DOMICI_REFERE
             WHERE CodCia       = nCodCia 
               AND IdFactura    = nIdFactura
               AND Estado       = 'CNOR';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
                cExiste := 'S';
        END;
        RETURN cExiste;
    END INTENTOS_CUMPLIDOS;
    
    FUNCTION FECHA_COBRO (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN DATE IS
        dFechaCobro DETALLE_DOMICI_REFERE.FechaCobro%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(FechaCobro,TO_DATE('01/01/1999','DD/MM/YYYY'))
              INTO dFechaCobro
              FROM DETALLE_DOMICI_REFERE
             WHERE CodCia       = nCodCia 
               AND IdProceso    = nIdProceso 
               AND IdFactura    = nIdFactura;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                dFechaCobro := TO_DATE('01/01/1999','DD/MM/YYYY');
        END;
        RETURN dFechaCobro;
    END FECHA_COBRO;
    
    FUNCTION NUMERO_INTENTOS (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN NUMBER IS
        nCantidad_Intentos DETALLE_DOMICI_REFERE.Cantidad_Intentos%TYPE;
    BEGIN
        SELECT SUM(Cantidad_Intentos)
          INTO nCantidad_Intentos
          FROM DETALLE_DOMICI_REFERE
         WHERE CodCia     = nCodCia
           AND IdFactura  = nIdFactura
           AND Estado    != 'EXC';
        RETURN nCantidad_Intentos;
    END NUMERO_INTENTOS;
    
    PROCEDURE MARCA_INTENTOS_CUMPLIDOS (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) IS
    BEGIN
        UPDATE DETALLE_DOMICI_REFERE
           SET Estado     = 'CNOR'
         WHERE CodCia     = nCodCia
           AND IdFactura  = nIdFactura
           AND IdProceso  = nIdProceso;
    END MARCA_INTENTOS_CUMPLIDOS;
    
    FUNCTION FEC_ULTIMO_INTENTO (nCodCia IN NUMBER, nIdFactura IN NUMBER) RETURN DATE IS
        dFecAplica DETALLE_DOMICI_REFERE.FecAplica%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(MAX(FecAplica),TRUNC(SYSDATE))
              INTO dFecAplica
              FROM DETALLE_DOMICI_REFERE
             WHERE CodCia       = nCodCia
               AND IdFactura    = nIdFactura
               AND Estado  NOT IN ('PAG','GEN','CNOR')
               AND OC_FACTURAS.INTENTOS_COBRANZA_CUMPLIDOS(IdFactura, CodCia) = 'N';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                dFecAplica := TRUNC(SYSDATE);
        END;   
        RETURN dFecAplica;
    END FEC_ULTIMO_INTENTO;
    
    FUNCTION EXISTE_FACTURA (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2 IS
        cExiste VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT 'S'
              INTO cExiste
              FROM DETALLE_DOMICI_REFERE
             WHERE CodCia     = nCodCia
               AND IdFactura  = nIdFactura
               AND IdProceso  = nIdProceso;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN 
                cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
                cExiste := 'S';
        END;
        RETURN cExiste;
    END EXISTE_FACTURA;
    
   FUNCTION FORMA_PAGO (nCodCia IN NUMBER, nIdProceso IN NUMBER, nIdFactura IN NUMBER) RETURN VARCHAR2 IS
   cCodFormaPago DETALLE_DOMICI_REFERE.CodFormaPago%TYPE;
   BEGIN
      BEGIN
         SELECT CodFormaPago
           INTO cCodFormaPago
           FROM DETALLE_DOMICI_REFERE
          WHERE CodCia     = nCodCia
            AND IdFactura  = nIdFactura
            AND IdProceso  = nIdProceso;
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN 
             RAISE_APPLICATION_ERROR(-20000,'No se ha establecido una forma de cobro para el recibo'||nIdFactura||' en el Proceso No. '||nIdProceso|| ' ' ||SQLERRM);
      END;
      RETURN cCodFormaPago;
   END FORMA_PAGO;    
END GT_DETALLE_DOMICI_REFERE;
/

--
-- GT_DETALLE_DOMICI_REFERE  (Synonym) 
--
--  Dependencies: 
--   GT_DETALLE_DOMICI_REFERE (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_DETALLE_DOMICI_REFERE FOR SICAS_OC.GT_DETALLE_DOMICI_REFERE
/


GRANT EXECUTE ON SICAS_OC.GT_DETALLE_DOMICI_REFERE TO PUBLIC
/

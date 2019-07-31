--
-- OC_DETALLE_APROBACION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_APROBACION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DETALLE_APROBACION IS
  FUNCTION NUMERO_DETALLE(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER) RETURN NUMBER;
  PROCEDURE INSERTA_DETALLE(nIdSiniestro  NUMBER, nNum_Aprobacion NUMBER, cCod_Pago VARCHAR2,
                           nMonto_Local NUMBER, nMonto_Moneda NUMBER, cCodTransac VARCHAR2,
                           cCodCptoTransac VARCHAR2);
  FUNCTION NUM_DETALLE_CONCEPTO(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, cCodCptoTransac VARCHAR2) RETURN NUMBER;
  FUNCTION MONTO_DETALLE_LOCAL(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, cCodCptoTransac VARCHAR2 DEFAULT NULL) RETURN NUMBER;
  FUNCTION MONTO_DETALLE_MONEDA(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, cCodCptoTransac VARCHAR2 DEFAULT NULL) RETURN NUMBER;
  FUNCTION CODIGO_TRANSACCCION(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, nIdDetAprob NUMBER) RETURN VARCHAR2;
  FUNCTION CONCEPTO_TRANSACCCION(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, nIdDetAprob NUMBER) RETURN VARCHAR2;
  FUNCTION CONCEPTO_DE_PAGO(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, nIdDetAprob NUMBER) RETURN VARCHAR2;

END OC_DETALLE_APROBACION;
/

--
-- OC_DETALLE_APROBACION  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_APROBACION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DETALLE_APROBACION IS

FUNCTION NUMERO_DETALLE(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER) RETURN NUMBER IS
nIdDetAprob        DETALLE_APROBACION.IdDetAprob%TYPE;
BEGIN
   SELECT NVL(MAX(IdDetAprob),0) + 1
     INTO nIdDetAprob
     FROM DETALLE_APROBACION
    WHERE IdSiniestro    = nIdSiniestro
      AND Num_Aprobacion = nNum_Aprobacion;

   RETURN(nIdDetAprob);
END NUMERO_DETALLE;

PROCEDURE INSERTA_DETALLE(nIdSiniestro  NUMBER, nNum_Aprobacion NUMBER, cCod_Pago VARCHAR2,
                          nMonto_Local NUMBER, nMonto_Moneda NUMBER, cCodTransac VARCHAR2,
                          cCodCptoTransac VARCHAR2) IS

nIdDetAprob        DETALLE_APROBACION.IdDetAprob%TYPE;
BEGIN
   BEGIN
      nIdDetAprob := OC_DETALLE_APROBACION.NUMERO_DETALLE(nIdSiniestro, nNum_Aprobacion);

      INSERT INTO DETALLE_APROBACION
            (Num_Aprobacion, IdDetAprob, Cod_Pago,  Monto_Local,  Monto_Moneda,
             IdSiniestro, CodTransac, CodCptoTransac)
      VALUES(nNum_Aprobacion, nIdDetAprob, cCod_Pago,  nMonto_Local,  nMonto_Moneda,
             nIdSiniestro, cCodTransac, cCodCptoTransac);
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'INSERTA DETALLE_APROBACION - Error: '||SQLERRM);
   END;
END INSERTA_DETALLE;

FUNCTION NUM_DETALLE_CONCEPTO(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, cCodCptoTransac VARCHAR2) RETURN NUMBER IS
nIdDetAprob        DETALLE_APROBACION.IdDetAprob%TYPE;
BEGIN
   BEGIN
      SELECT IdDetAprob
        INTO nIdDetAprob
        FROM DETALLE_APROBACION
       WHERE IdSiniestro    = nIdSiniestro
         AND Num_Aprobacion = nNum_Aprobacion
         AND CodCptoTransac = cCodCptoTransac;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Detalle de Aprobación para Concepto ' || cCodCptoTransac || 
                                 ' en Aprobación No. ' || nNum_Aprobacion || ' del Siniestro No. ' || nIdSiniestro);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Detalles de Aprobación para Concepto ' || cCodCptoTransac ||
                                 ' para Aprobación No. ' || nNum_Aprobacion || ' del Siniestro No. ' || nIdSiniestro);
   END;
   RETURN(nIdDetAprob);
END NUM_DETALLE_CONCEPTO;

FUNCTION MONTO_DETALLE_LOCAL(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, cCodCptoTransac VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
nMonto_Local        DETALLE_APROBACION.Monto_Local%TYPE;
BEGIN
    IF cCodCptoTransac IS NULL THEN 
        SELECT NVL(SUM(Monto_Local),0)
          INTO nMonto_Local
          FROM DETALLE_APROBACION
         WHERE IdSiniestro    = nIdSiniestro
           AND Num_Aprobacion = nNum_Aprobacion
           AND Cod_Pago       NOT IN ('DEDUC','IMPTO','RETENC');
    ELSE 
        SELECT NVL(SUM(Monto_Local),0)
          INTO nMonto_Local
          FROM DETALLE_APROBACION
         WHERE IdSiniestro    = nIdSiniestro
           AND Num_Aprobacion = nNum_Aprobacion
           AND CodCptoTransac = cCodCptoTransac;
    END IF;
   RETURN(nMonto_Local);
END MONTO_DETALLE_LOCAL;

FUNCTION MONTO_DETALLE_MONEDA(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, cCodCptoTransac VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
nMonto_Moneda        DETALLE_APROBACION.Monto_Moneda%TYPE;
BEGIN
    IF cCodCptoTransac IS NULL THEN 
        SELECT NVL(SUM(Monto_Moneda),0)
          INTO nMonto_Moneda
          FROM DETALLE_APROBACION
         WHERE IdSiniestro    = nIdSiniestro
           AND Num_Aprobacion = nNum_Aprobacion
           AND Cod_Pago       NOT IN ('DEDUC','IMPTO','RETENC');
    ELSE
        SELECT NVL(SUM(Monto_Moneda),0)
          INTO nMonto_Moneda
          FROM DETALLE_APROBACION
         WHERE IdSiniestro    = nIdSiniestro
           AND Num_Aprobacion = nNum_Aprobacion
           AND CodCptoTransac = cCodCptoTransac;
    END IF;
   RETURN(nMonto_Moneda);
END MONTO_DETALLE_MONEDA;

FUNCTION CODIGO_TRANSACCCION(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, nIdDetAprob NUMBER) RETURN VARCHAR2 IS
cCodTransac        DETALLE_APROBACION.CodTransac%TYPE;
BEGIN
   BEGIN
      SELECT CodTransac
        INTO cCodTransac
        FROM DETALLE_APROBACION
       WHERE IdSiniestro    = nIdSiniestro
         AND Num_Aprobacion = nNum_Aprobacion
         AND IdDetAprob     = nIdDetAprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Código de Transacción para Detalle No. ' || nIdDetAprob || 
                                 ' en Aprobación No. ' || nNum_Aprobacion || ' del Siniestro No. ' || nIdSiniestro);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Códigos de Transacción par Detalle No. ' || nIdDetAprob ||
                                 ' para Aprobación No. ' || nNum_Aprobacion || ' del Siniestro No. ' || nIdSiniestro);
   END;
   RETURN(cCodTransac);
END CODIGO_TRANSACCCION;

FUNCTION CONCEPTO_TRANSACCCION(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, nIdDetAprob NUMBER) RETURN VARCHAR2 IS
cCodCptoTransac        DETALLE_APROBACION.CodCptoTransac%TYPE;
BEGIN
   BEGIN
      SELECT CodCptoTransac
        INTO cCodCptoTransac
        FROM DETALLE_APROBACION
       WHERE IdSiniestro    = nIdSiniestro
         AND Num_Aprobacion = nNum_Aprobacion
         AND IdDetAprob     = nIdDetAprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Concepto de Transacción para Detalle No. ' || nIdDetAprob || 
                                 ' en Aprobación No. ' || nNum_Aprobacion || ' del Siniestro No. ' || nIdSiniestro);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Conceptos de Transacción par Detalle No. ' || nIdDetAprob ||
                                 ' para Aprobación No. ' || nNum_Aprobacion || ' del Siniestro No. ' || nIdSiniestro);
   END;
   RETURN(cCodCptoTransac);
END CONCEPTO_TRANSACCCION;

FUNCTION CONCEPTO_DE_PAGO(nIdSiniestro NUMBER, nNum_Aprobacion NUMBER, nIdDetAprob NUMBER) RETURN VARCHAR2 IS
cCod_Pago        DETALLE_APROBACION.Cod_Pago%TYPE;
BEGIN
   BEGIN
      SELECT Cod_Pago
        INTO cCod_Pago
        FROM DETALLE_APROBACION
       WHERE IdSiniestro    = nIdSiniestro
         AND Num_Aprobacion = nNum_Aprobacion
         AND IdDetAprob     = nIdDetAprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Concepto de Pago para Detalle No. ' || nIdDetAprob || 
                                 ' en Aprobación No. ' || nNum_Aprobacion || ' del Siniestro No. ' || nIdSiniestro);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Conceptos de Pago par Detalle No. ' || nIdDetAprob ||
                                 ' para Aprobación No. ' || nNum_Aprobacion || ' del Siniestro No. ' || nIdSiniestro);
   END;
   RETURN(cCod_Pago);
END CONCEPTO_DE_PAGO;

END OC_DETALLE_APROBACION;
/

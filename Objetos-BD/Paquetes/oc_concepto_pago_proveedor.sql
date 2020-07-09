--
-- OC_CONCEPTO_PAGO_PROVEEDOR  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONCEPTO_PAGO_PROVEEDOR (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONCEPTO_PAGO_PROVEEDOR IS

  FUNCTION TIENE_CONCEPTOS(nCodCia NUMBER, cCodTipoProv VARCHAR2) RETURN VARCHAR2;

  FUNCTION PORCENTAJE_CONCEPTO(nCodCia NUMBER, cCodTipoProv VARCHAR2, cCodConcepto VARCHAR2) RETURN VARCHAR2;

  FUNCTION MONTO_CONCEPTO(nCodCia NUMBER, cCodTipoProv VARCHAR2, cCodConcepto VARCHAR2) RETURN VARCHAR2;

  PROCEDURE ACTIVAR(nCodCia NUMBER, cCodTipoProv VARCHAR2, cCodConcepto VARCHAR2);

  PROCEDURE ANULAR(nCodCia NUMBER, cCodTipoProv VARCHAR2, cCodConcepto VARCHAR2);
  
END OC_CONCEPTO_PAGO_PROVEEDOR;
/

--
-- OC_CONCEPTO_PAGO_PROVEEDOR  (Package Body) 
--
--  Dependencies: 
--   OC_CONCEPTO_PAGO_PROVEEDOR (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONCEPTO_PAGO_PROVEEDOR IS

FUNCTION TIENE_CONCEPTOS(nCodCia NUMBER, cCodTipoProv VARCHAR2) RETURN VARCHAR2 IS
cExisten   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisten
        FROM CONCEPTO_PAGO_PROVEEDOR
       WHERE CodCia     = nCodCia
         AND CodTipoProv    = cCodTipoProv;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisten := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisten := 'S';
   END;
   RETURN(cExisten);
END TIENE_CONCEPTOS;

FUNCTION PORCENTAJE_CONCEPTO(nCodCia NUMBER, cCodTipoProv VARCHAR2, cCodConcepto VARCHAR2) RETURN VARCHAR2 IS
nPorcCpto     CONCEPTO_PAGO_PROVEEDOR.PorcCpto%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcCpto,0)
        INTO nPorcCpto
        FROM CONCEPTO_PAGO_PROVEEDOR
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipoProv = cCodTipoProv;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcCpto  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros del Conceptos de Pago a Proveedores '|| cCodConcepto);
   END;
   RETURN(nPorcCpto);
END PORCENTAJE_CONCEPTO;

FUNCTION MONTO_CONCEPTO(nCodCia NUMBER, cCodTipoProv VARCHAR2, cCodConcepto VARCHAR2) RETURN VARCHAR2 IS
nMtoCpto     CONCEPTO_PAGO_PROVEEDOR.MtoCpto%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MtoCpto,0)
        INTO nMtoCpto
        FROM CONCEPTO_PAGO_PROVEEDOR
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipoProv = cCodTipoProv;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMtoCpto  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros del Conceptos de Pago a Proveedores '|| cCodConcepto);
   END;
   RETURN(nMtoCpto);
END MONTO_CONCEPTO;

PROCEDURE ACTIVAR(nCodCia NUMBER, cCodTipoProv VARCHAR2, cCodConcepto VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE CONCEPTO_PAGO_PROVEEDOR
         SET Estado  = 'ACTIVA'
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipoProv = cCodTipoProv;
   END;
END ACTIVAR;

PROCEDURE ANULAR(nCodCia NUMBER, cCodTipoProv VARCHAR2, cCodConcepto VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE CONCEPTO_PAGO_PROVEEDOR
         SET Estado  = 'ANULAD'
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipoProv = cCodTipoProv;
   END;
END ANULAR;

END OC_CONCEPTO_PAGO_PROVEEDOR;
/

--
-- OC_CONCEPTO_PAGO_PROVEEDOR  (Synonym) 
--
--  Dependencies: 
--   OC_CONCEPTO_PAGO_PROVEEDOR (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONCEPTO_PAGO_PROVEEDOR FOR SICAS_OC.OC_CONCEPTO_PAGO_PROVEEDOR
/


GRANT EXECUTE ON SICAS_OC.OC_CONCEPTO_PAGO_PROVEEDOR TO PUBLIC
/

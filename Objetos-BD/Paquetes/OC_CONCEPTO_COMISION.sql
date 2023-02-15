CREATE OR REPLACE PACKAGE OC_CONCEPTO_COMISION IS

  FUNCTION TIENE_CONCEPTOS(nCodCia NUMBER, cCodTipo VARCHAR2) RETURN VARCHAR2;

  FUNCTION PORCENTAJE_CONCEPTO(nCodCia NUMBER, cCodTipo VARCHAR2, cCodConcepto VARCHAR2) RETURN VARCHAR2;

  FUNCTION MONTO_CONCEPTO(nCodCia NUMBER, cCodTipo VARCHAR2, cCodConcepto VARCHAR2) RETURN VARCHAR2;

  PROCEDURE ACTIVAR(nCodCia NUMBER, cCodTipo VARCHAR2, cCodConcepto VARCHAR2);

  PROCEDURE ANULAR(nCodCia NUMBER, cCodTipo VARCHAR2, cCodConcepto VARCHAR2);
  
  PROCEDURE ESTADO(cCodCia VARCHAR2, cCodCpto VARCHAR2, cEstado VARCHAR2);

  PROCEDURE CREAR_MODIFICACION(cCodCia VARCHAR2, cCodConcepto VARCHAR2, fFecIniValid DATE, fFecFinValid DATE, 
                               nPorcCpto NUMBER, nMtoCpto NUMBER,CCodTipo VARCHAR2,cOrigen VARCHAR2);

END OC_CONCEPTO_COMISION;
/

CREATE OR REPLACE PACKAGE BODY OC_CONCEPTO_COMISION IS

FUNCTION TIENE_CONCEPTOS(nCodCia NUMBER, cCodTipo VARCHAR2) RETURN VARCHAR2 IS
cExisten   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisten
        FROM CONCEPTO_COMISION
       WHERE CodCia     = nCodCia
         AND CodTipo    = cCodTipo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisten := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisten := 'S';
   END;
   RETURN(cExisten);
END TIENE_CONCEPTOS;

FUNCTION PORCENTAJE_CONCEPTO(nCodCia NUMBER, cCodTipo VARCHAR2, cCodConcepto VARCHAR2) RETURN VARCHAR2 IS
nPorcCpto     CONCEPTO_COMISION.PorcCpto%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcCpto,0)
        INTO nPorcCpto
        FROM CONCEPTO_COMISION
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipo     = cCodTipo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcCpto  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros del Conceptos de Comisiones '|| cCodConcepto);
   END;
   RETURN(nPorcCpto);
END PORCENTAJE_CONCEPTO;

FUNCTION MONTO_CONCEPTO(nCodCia NUMBER, cCodTipo VARCHAR2, cCodConcepto VARCHAR2) RETURN VARCHAR2 IS
nMtoCpto     CONCEPTO_COMISION.MtoCpto%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MtoCpto,0)
        INTO nMtoCpto
        FROM CONCEPTO_COMISION
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipo     = cCodTipo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMtoCpto  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros del Conceptos de Comisiones '|| cCodConcepto);
   END;
   RETURN(nMtoCpto);
END MONTO_CONCEPTO;

PROCEDURE ACTIVAR(nCodCia NUMBER, cCodTipo VARCHAR2, cCodConcepto VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE CONCEPTO_COMISION
         SET Estado = 'ACTIVA'
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipo     = cCodTipo;
   END;
END ACTIVAR;

PROCEDURE ANULAR(nCodCia NUMBER, cCodTipo VARCHAR2, cCodConcepto VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE CONCEPTO_COMISION
         SET Estado = 'ANULAD'
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipo     = cCodTipo;
   END;
END ANULAR;

PROCEDURE ESTADO(cCodCia VARCHAR2, cCodCpto VARCHAR2, cEstado VARCHAR2) IS
BEGIN
   IF NVL(cEstado, 'X') IN ('ACTIVA','SUSPEN') THEN
      BEGIN
         UPDATE CONCEPTO_COMISION
            SET Estado = cEstado
          WHERE CodCia = cCodCia
            AND CodConcepto = cCodCpto;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20100, 'Error al intentar actualizar CONCEPTO_COMISION');
      END;
   ELSE
      RAISE_APPLICATION_ERROR(-20100, 'Error de dato en parametro ESTADO');
   END IF;
END ESTADO;

PROCEDURE CREAR_MODIFICACION(cCodCia VARCHAR2, cCodConcepto VARCHAR2, fFecIniValid DATE, fFecFinValid DATE, 
                             nPorcCpto NUMBER, nMtoCpto NUMBER,cCodTipo VARCHAR2,cOrigen VARCHAR2) IS
nModif    NUMBER(10);
nExiste   NUMBER(2);
BEGIN
   BEGIN
      SELECT 1
        INTO nExiste
        FROM MODIFICACION_CONCEPTO_COMISION
       WHERE CodCia = cCodCia
         AND CodConcepto = cCodConcepto
         AND CodTipo = cCodTipo
         AND Origen  = cOrigen;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nExiste:= 0;
      WHEN TOO_MANY_ROWS THEN
         nExiste:= 1;
   END;

   IF nExiste = 0 THEN
      BEGIN
         INSERT INTO MODIFICACION_CONCEPTO_COMISION
               (CodCia, CodConcepto, nModificacion, FecIniValid, FecFinValid, PorcCpto, MtoCpto, CodTipo, Origen)
         VALUES(cCodCia, cCodConcepto, 1, fFecIniValid, fFecFinValid, nPorcCpto, nMtoCpto, cCodTipo, cOrigen);
      END;
   ELSE
      RAISE_APPLICATION_ERROR(-20100, 'Intenta Creación Automática por Nuevo Concepto de Comisión, pero Ya Existen Registros');
   END IF;
END CREAR_MODIFICACION;

END OC_CONCEPTO_COMISION;

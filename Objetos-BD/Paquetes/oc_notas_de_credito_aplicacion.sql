--
-- OC_NOTAS_DE_CREDITO_APLICACION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   NOTAS_DE_CREDITO_APLICACION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_NOTAS_DE_CREDITO_APLICACION IS

PROCEDURE INSERTAR(nCodCia NUMBER, nIdNcr NUMBER, nCodCliente NUMBER, nIdRecibo NUMBER,
                   nIdFactura NUMBER, nIdPoliza NUMBER, nMontoAplicado NUMBER,
                   cTipoMov VARCHAR2);

FUNCTION CORRELATIVO(nIdNcr NUMBER) RETURN NUMBER;

END OC_NOTAS_DE_CREDITO_APLICACION;
/

--
-- OC_NOTAS_DE_CREDITO_APLICACION  (Package Body) 
--
--  Dependencies: 
--   OC_NOTAS_DE_CREDITO_APLICACION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_NOTAS_DE_CREDITO_APLICACION IS

PROCEDURE INSERTAR(nCodCia NUMBER, nIdNcr NUMBER, nCodCliente NUMBER, nIdRecibo NUMBER, 
                   nIdFactura NUMBER, nIdPoliza NUMBER, nMontoAplicado NUMBER,
                   cTipoMov VARCHAR2) IS
nCorrelativo     NOTAS_DE_CREDITO_APLICACION.Correlativo%TYPE;
BEGIN
   nCorrelativo := OC_NOTAS_DE_CREDITO_APLICACION.CORRELATIVO(nIdNcr);

   BEGIN
      INSERT INTO NOTAS_DE_CREDITO_APLICACION
             (CodCia, IdNcr, Correlativo, CodCliente, IdRecibo, IdFactura,
              IdPoliza, TipMov, MontoAplicadoMoneda, StsAplicacion, FecSts)
      VALUES (nCodCia, nIdNcr, nCorrelativo, nCodCliente, nIdRecibo, nIdFactura,
              nIdPoliza, cTipoMov, nMontoAplicado, 'APLICA', TRUNC(SYSDATE));
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'No. de Detalle ' || nCorrelativo || ', Ya existe en Aplicación de Nota de Crédito ');
   END;
END INSERTAR;

FUNCTION CORRELATIVO(nIdNcr NUMBER) RETURN NUMBER IS
nCorrelativo     NOTAS_DE_CREDITO_APLICACION.Correlativo%TYPE;
BEGIN
   SELECT NVL(MAX(Correlativo),0)+1
     INTO nCorrelativo
     FROM NOTAS_DE_CREDITO_APLICACION
    WHERE IdNcr = nIdNcr;

   RETURN(nCorrelativo);
END CORRELATIVO;

END OC_NOTAS_DE_CREDITO_APLICACION;
/

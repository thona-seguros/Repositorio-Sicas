--
-- OC_CATALOGO_CONCEPTOS_RANGOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   POLIZAS (Table)
--   DETALLE_POLIZA (Table)
--   OC_DETALLE_POLIZA (Package)
--   CATALOGO_CONCEPTOS_RANGOS (Table)
--   OC_ENDOSO (Package)
--   OC_GENERALES (Package)
--   OC_POLIZAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CATALOGO_CONCEPTOS_RANGOS IS

  PROCEDURE VALOR_CONCEPTO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodConcepto VARCHAR2, 
                           cIdTipoSeg VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                           nIdEndoso NUMBER, nMtoCpto IN OUT NUMBER, nPorcCpto IN OUT NUMBER);

END OC_CATALOGO_CONCEPTOS_RANGOS;
/

--
-- OC_CATALOGO_CONCEPTOS_RANGOS  (Package Body) 
--
--  Dependencies: 
--   OC_CATALOGO_CONCEPTOS_RANGOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CATALOGO_CONCEPTOS_RANGOS IS

PROCEDURE VALOR_CONCEPTO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodConcepto VARCHAR2, 
                         cIdTipoSeg VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER, 
                         nIdEndoso NUMBER, nMtoCpto IN OUT NUMBER, nPorcCpto IN OUT NUMBER) IS
cCodTipoRango     CATALOGO_CONCEPTOS_RANGOS.CodTipoRango%TYPE;
nCantMonto        CATALOGO_CONCEPTOS_RANGOS.RangoInicial%TYPE;
nTasaCambio       DETALLE_POLIZA.Tasa_Cambio%TYPE;
cCodMoneda        POLIZAS.Cod_Moneda%TYPE;
BEGIN
   BEGIN
      SELECT DISTINCT CodTipoRango
        INTO cCodTipoRango
        FROM CATALOGO_CONCEPTOS_RANGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodConcepto = cCodConcepto
         AND IdTipoSeg   = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No Existen Rangos para Concepto ' || cCodConcepto || ' del Tipo de Seguro '|| cIdTipoSeg);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error de Configuración. Existen Varios Tipos de Rangos para Concepto ' || 
                                 cCodConcepto || ' del Tipo de Seguro '|| cIdTipoSeg);
   END;

   SELECT Cod_Moneda
     INTO cCodMoneda
     FROM POLIZAS
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;

   nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

   -- Rango por Monto de Prima
   IF cCodTipoRango = 'MTOPRI' THEN
      -- Prima a Nivel Póliza
      IF nIdPoliza != 0 AND nIDetPol = 0 AND nIdEndoso = 0 THEN
         nCantMonto := OC_POLIZAS.TOTAL_PRIMA(nCodCia, nCodEmpresa, nIdPoliza);
      ELSIF nIdPoliza != 0 AND nIDetPol != 0 AND nIdEndoso = 0 THEN
         nCantMonto := OC_DETALLE_POLIZA.TOTAL_PRIMA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
      ELSIF nIdPoliza != 0 AND nIDetPol != 0 AND nIdEndoso != 0 THEN
         nCantMonto := OC_ENDOSO.TOTAL_PRIMA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
      ELSE
         nCantMonto := 0;
      END IF;
   -- Rango por Cantidad de Asegurados
   ELSIF cCodTipoRango = 'CANASE' THEN
      IF nIdPoliza != 0 AND nIDetPol = 0 AND nIdEndoso = 0 THEN
         nCantMonto := OC_POLIZAS.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza);
      ELSIF nIdPoliza != 0 AND nIDetPol != 0 AND nIdEndoso = 0 THEN
         nCantMonto := OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
      ELSIF nIdPoliza != 0 AND nIDetPol != 0 AND nIdEndoso != 0 THEN
         nCantMonto := OC_ENDOSO.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
      ELSE
         nCantMonto := 0;
      END IF;
   -- Miembros de Familia
   ELSIF cCodTipoRango = 'FAMILI' THEN
      IF nIdPoliza != 0 AND nIDetPol = 0 AND nIdEndoso = 0 THEN
         nCantMonto := OC_POLIZAS.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza);
      ELSIF nIdPoliza != 0 AND nIDetPol != 0 AND nIdEndoso = 0 THEN
         nCantMonto := OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
      ELSIF nIdPoliza != 0 AND nIDetPol != 0 AND nIdEndoso != 0 THEN
         nCantMonto := OC_ENDOSO.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
      ELSE
         nCantMonto := 0;
      END IF;
   ELSE
      nCantMonto := 0;
   END IF;

   BEGIN
      SELECT PorcConcepto, MontoConcepto / nTasaCambio -- Convierte a Moneda Local
        INTO nPorcCpto, nMtoCpto
        FROM CATALOGO_CONCEPTOS_RANGOS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodConcepto   = cCodConcepto
         AND IdTipoSeg     = cIdTipoSeg
         AND CodTipoRango  = cCodTipoRango
         AND RangoInicial <= nCantMonto
         AND RangoFinal   >= nCantMonto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcCpto := 0;
         nMtoCpto  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error de Configuración. Existen Varios Tipos de Rangos para Concepto ' || 
                                 cCodConcepto || ' del Tipo de Seguro '|| cIdTipoSeg);
   END;
   
   -- Miembros de Familia
   IF cCodTipoRango = 'FAMILI' AND nMtoCpto != 0 AND nCantMonto != 0 THEN
      nMtoCpto := nCantMonto * nMtoCpto;
   END IF;
END VALOR_CONCEPTO;

END OC_CATALOGO_CONCEPTOS_RANGOS;
/

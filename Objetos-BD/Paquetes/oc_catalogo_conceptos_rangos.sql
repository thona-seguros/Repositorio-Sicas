CREATE OR REPLACE PACKAGE OC_CATALOGO_CONCEPTOS_RANGOS IS

PROCEDURE VALOR_CONCEPTO(nCodCia      NUMBER,
                         nCodEmpresa  NUMBER, 
                         cCodConcepto VARCHAR2, 
                         cIdTipoSeg   VARCHAR2,    
                         nIdPoliza    NUMBER, 
                         nIDetPol     NUMBER, 
                         nIdEndoso    NUMBER,      
                         nMtoCpto     IN OUT NUMBER, 
                         nPorcCpto    IN OUT NUMBER);

END OC_CATALOGO_CONCEPTOS_RANGOS;
/
CREATE OR REPLACE PACKAGE BODY OC_CATALOGO_CONCEPTOS_RANGOS IS
--
-- BITACORA DE CAMBIOS
--
-- Se adicionara la funcionalida de productros de largo plazo     JICO 2019/07/09    --LARPLA
--
PROCEDURE VALOR_CONCEPTO(nCodCia      NUMBER,
                         nCodEmpresa  NUMBER, 
                         cCodConcepto VARCHAR2, 
                         cIdTipoSeg   VARCHAR2,    
                         nIdPoliza    NUMBER, 
                         nIDetPol     NUMBER, 
                         nIdEndoso    NUMBER,      
                         nMtoCpto     IN OUT NUMBER, 
                         nPorcCpto    IN OUT NUMBER) IS
cCodTipoRango     CATALOGO_CONCEPTOS_RANGOS.CodTipoRango%TYPE;
nCantMonto        CATALOGO_CONCEPTOS_RANGOS.RangoInicial%TYPE;
nTasaCambio       DETALLE_POLIZA.Tasa_Cambio%TYPE;
cCodMoneda        POLIZAS.Cod_Moneda%TYPE;
NA�O_POLIZA       NUMBER;
CIDTIPOSEG        DETALLE_POLIZA.IDTIPOSEG%TYPE;
CID_LARGO_PLAZO   TIPOS_DE_SEGUROS.ID_LARGO_PLAZO%TYPE;

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
         RAISE_APPLICATION_ERROR(-20220,'Error de Configuraci�n. Existen Varios Tipos de Rangos para Concepto ' || 
                                 cCodConcepto || ' del Tipo de Seguro '|| cIdTipoSeg);
   END;
   --
   SELECT P.COD_MONEDA , 
          TO_NUMBER(TO_CHAR(P.FECRENOVACION,'YYYY')) - TO_NUMBER(TO_CHAR(P.FECINIVIG,'YYYY')) A�O_POLIZA,
          DP.IDTIPOSEG,
          TS.ID_LARGO_PLAZO
     INTO cCodMoneda,
          NA�O_POLIZA,
          CIDTIPOSEG,
          CID_LARGO_PLAZO     
     FROM POLIZAS          P,
          DETALLE_POLIZA   DP,
          TIPOS_DE_SEGUROS TS
    WHERE P.CODCIA   = nCodCia
      AND P.IDPOLIZA = nIdPoliza
      --
      AND DP.CODCIA   = P.CODCIA
      AND DP.IDPOLIZA = P.IDPOLIZA
      AND DP.IDETPOL  = (SELECT MAX(DP1.IDETPOL)
                           FROM DETALLE_POLIZA DP1
                          WHERE DP1.CODCIA   = P.CODCIA
                            AND DP1.IDPOLIZA = P.IDPOLIZA)
      --
      AND TS.IDTIPOSEG  = DP.IDTIPOSEG
      AND TS.CODEMPRESA = DP.CODEMPRESA
      AND TS.CODCIA     = DP.CODCIA;
   --   

   nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

   -- Rango por Monto de Prima
   IF cCodTipoRango = 'MTOPRI' THEN
      -- Prima a Nivel P�liza
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
         RAISE_APPLICATION_ERROR(-20220,'Error de Configuraci�n. Existen Varios Tipos de Rangos para Concepto ' || 
                                 cCodConcepto || ' del Tipo de Seguro '|| cIdTipoSeg);
   END;
   
   -- Miembros de Familia
   IF cCodTipoRango = 'FAMILI' AND nMtoCpto != 0 AND nCantMonto != 0 THEN
      nMtoCpto := nCantMonto * nMtoCpto;
   END IF;
END VALOR_CONCEPTO;

END OC_CATALOGO_CONCEPTOS_RANGOS;
/

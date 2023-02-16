CREATE OR REPLACE PACKAGE OC_TARIFA_DINAMICA_FORMULA IS

  FUNCTION APLICA_FORMULA(nIdTarifa NUMBER, nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                          cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, nCod_Asegurado NUMBER, cCodPlantilla VARCHAR2,
                          cCodCobert VARCHAR2, cTipoTarifa VARCHAR2, nIdCampo NUMBER,
                          nValorTarifa NUMBER, cTipoProceso VARCHAR2) RETURN NUMBER;
  PROCEDURE COPIAR (nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER);

END OC_TARIFA_DINAMICA_FORMULA;
 
/

CREATE OR REPLACE PACKAGE BODY OC_TARIFA_DINAMICA_FORMULA IS

FUNCTION APLICA_FORMULA(nIdTarifa NUMBER, nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                        cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, nCod_Asegurado NUMBER, cCodPlantilla VARCHAR2,
                        cCodCobert VARCHAR2, cTipoTarifa VARCHAR2, nIdCampo NUMBER,
                        nValorTarifa NUMBER, cTipoProceso VARCHAR2) RETURN NUMBER IS

cSentencia      VARCHAR2(4000);
nValorTarRemp   TARIFA_DINAMICA_FORMULA.ValorOperacion%TYPE;
nValorFormula   TARIFA_DINAMICA_FORMULA.ValorOperacion%TYPE;

CURSOR FORMULA_Q IS
   SELECT TipoOperacion, ValorOperacion, ValorCampo, OrdenProcValCampo
     FROM TARIFA_DINAMICA_FORMULA
    WHERE IdTarifa   = nIdTarifa
      AND CodCobert  = cCodCobert
      AND IdCampo    = nIdCampo
      AND TipoTarifa = cTipoTarifa
    ORDER BY IdOrdenFormula;
BEGIN
   nValorTarRemp := nValorTarifa;
   FOR X IN FORMULA_Q LOOP
      IF NVL(X.ValorOperacion,0) != 0 THEN
         nValorFormula := X.ValorOperacion;
      ELSIF X.ValorCampo IS NOT NULL THEN
         IF OC_CONFIG_PLANTILLAS_PLANCOB.AREA_APLICACION(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso) = 'POLDET' THEN
            nValorFormula := TO_NUMBER(TRIM(OC_DATOS_PART_EMISION.VALOR_CAMPO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cCodPlantilla,
                                                                             X.OrdenProcValCampo, X.ValorCampo)),'999999.999999');
         ELSIF OC_CONFIG_PLANTILLAS_PLANCOB.AREA_APLICACION(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso) = 'ASEDET' THEN
            nValorFormula := TO_NUMBER(TRIM(OC_ASEGURADO_CERTIFICADO.VALOR_CAMPO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado,
                                                                                 cCodPlantilla, X.OrdenProcValCampo, X.ValorCampo)),'999999.999999');
         END IF;
      END IF;
     IF X.TipoOperacion != 'POWER' THEN
        cSentencia := 'SELECT '  || TO_CHAR(nValorTarRemp,'999999.999999') || ' ' || X.TipoOperacion || ' ' || nValorFormula || ' FROM DUAL';
     ELSE
        cSentencia := 'SELECT POWER('  || nValorTarRemp || ', ' || nValorFormula || ') FROM DUAL';
     END IF;

     EXECUTE IMMEDIATE cSentencia INTO nValorTarRemp;

   END LOOP;
   RETURN(nValorTarRemp);
END APLICA_FORMULA;

PROCEDURE COPIAR (nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO TARIFA_DINAMICA_FORMULA
            (IdTarifa, CodCobert, TipoTarifa, IdOrdenFormula, TipoOperacion,
             ValorOperacion, ValorCampo, OrdenProcValCampo, CodUsuario, FecUltCambio)
      SELECT nIdTarifaDest, CodCobert, TipoTarifa, IdOrdenFormula, TipoOperacion,
             ValorOperacion, ValorCampo, OrdenProcValCampo, USER, TRUNC(SYSDATE)
        FROM TARIFA_DINAMICA_FORMULA
       WHERE IdTarifa   = nIdTarifaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de TARIFA_DINAMICA_FORMULA '|| SQLERRM);
   END;
END COPIAR;

END OC_TARIFA_DINAMICA_FORMULA;

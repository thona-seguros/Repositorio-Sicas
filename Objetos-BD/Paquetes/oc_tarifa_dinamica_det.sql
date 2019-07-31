--
-- OC_TARIFA_DINAMICA_DET  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DATOS_PART_EMISION (Table)
--   TARIFA_DINAMICA (Table)
--   TARIFA_DINAMICA_DET (Table)
--   OC_DATOS_PART_EMISION (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   CONFIG_PLANTILLAS_PLANCOB (Table)
--   OC_TARIFA_DINAMICA (Package)
--   OC_TARIFA_DINAMICA_FORMULA (Package)
--   OC_ASEGURADO_CERTIFICADO (Package)
--   OC_CONFIG_PLANTILLAS_CAMPOS (Package)
--   OC_CONFIG_PLANTILLAS_PLANCOB (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TARIFA_DINAMICA_DET IS

  FUNCTION CALCULAR_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                           cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cCodCobert VARCHAR2, 
                           cTipoTarifa VARCHAR2, dFecTarifa DATE, nCod_Asegurado NUMBER,
                           cTipoProceso VARCHAR2) RETURN NUMBER;
  PROCEDURE COPIAR (nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER);

END OC_TARIFA_DINAMICA_DET;
/

--
-- OC_TARIFA_DINAMICA_DET  (Package Body) 
--
--  Dependencies: 
--   OC_TARIFA_DINAMICA_DET (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TARIFA_DINAMICA_DET IS

FUNCTION CALCULAR_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cCodCobert VARCHAR2,
                         cTipoTarifa VARCHAR2, dFecTarifa DATE, nCod_Asegurado NUMBER,
                         cTipoProceso VARCHAR2) RETURN NUMBER IS
nIdTarifa       TARIFA_DINAMICA.IdTarifa%TYPE;
cValorCampo     DATOS_PART_EMISION.Campo1%TYPE;
cCodPlantilla   CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cTipoCampo      CONFIG_PLANTILLAS_CAMPOS.TipoCampo%TYPE;
cValorIniCond   VARCHAR2(100);
cValorFinCond   VARCHAR2(100);
cValCampoComp   VARCHAR2(100);
nValorTarifa    TARIFA_DINAMICA_DET.ValorTarifa%TYPE;
cSentencia      VARCHAR2(4000);
cResultado      VARCHAR2(10);
nValorTarifac    VARCHAR2(4000);

CURSOR DET_Q IS
   SELECT IndAplicFormula, CodCampo, OrdenProcCampo, CodCondicion, OrdenCampo,
          ValorIniCond, ValorFinCond, ValorTarifa, CampoValor, OrdenProcCampoVal,
          IdCampo
     FROM TARIFA_DINAMICA_DET
    WHERE IdTarifa    = nIdTarifa
      AND CodCobert   = cCodCobert
      AND TipoTarifa  = cTipoTarifa
      AND TipoProceso = cTipoProceso
    ORDER BY IdCampo;
BEGIN
   nIdTarifa := OC_TARIFA_DINAMICA.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecTarifa);

   IF nIdTarifa != 0 THEN
      cCodPlantilla := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso);
      nValorTarifa  := 0;
      FOR X IN DET_Q LOOP
         IF X.CodCampo IS NOT NULL THEN
            IF OC_CONFIG_PLANTILLAS_PLANCOB.AREA_APLICACION(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso) = 'POLDET' THEN
               cValorCampo := OC_DATOS_PART_EMISION.VALOR_CAMPO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cCodPlantilla,
                                                                X.OrdenProcCampo, X.CodCampo);
            ELSIF OC_CONFIG_PLANTILLAS_PLANCOB.AREA_APLICACION(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso) = 'ASEDET' THEN
               cValorCampo := OC_ASEGURADO_CERTIFICADO.VALOR_CAMPO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, 
                                                                   cCodPlantilla, X.OrdenProcCampo, X.CodCampo);
            END IF;
            cTipoCampo  := OC_CONFIG_PLANTILLAS_CAMPOS.TIPO_CAMPO(nCodCia, nCodEmpresa, cCodPlantilla,
                                                                  X.OrdenCampo,X.OrdenProcCampo, X.CodCampo);
            IF cTipoCampo != 'NUMBER' THEN
                cValCampoComp := '''' || TRIM(cValorCampo) || '''';
                cValorIniCond := '''' || TRIM(cValorIniCond) || '''';
                cValorFinCond := '''' || TRIM(cValorFinCond) || '''';
            END IF;
            IF cTipoCampo = 'DATE' THEN
               cValorIniCond := 'TO_DATE(' || CHR(39) || TRIM(X.ValorIniCond) || CHR(39) || ', ''DD/MM/YYYY'')';
               cValorFinCond := 'TO_DATE(' || CHR(39) || TRIM(X.ValorFinCond) || CHR(39) || ', ''DD/MM/YYYY'')';
               cValCampoComp := 'TO_DATE(' || CHR(39) || TRIM(cValorCampo) || CHR(39) || ', ''DD/MM/YYYY'')';
            ELSE
               cValorIniCond := X.ValorIniCond;
               cValorFinCond := X.ValorFinCond;
               cValCampoComp := cValorCampo;
            END IF;
            IF X.CodCondicion != 'BETWEEN' THEN
               cSentencia := 'SELECT ' || CHR(39) || 'S' || CHR(39) || ' FROM DUAL WHERE ';
               IF cTipoCampo != 'NUMBER' THEN
                  cSentencia := cSentencia || CHR(39) || cValCampoComp || CHR(39) || ' ';
                  cSentencia := cSentencia || X.CodCondicion || ' ';
                  cSentencia := cSentencia || CHR(39) || cValorIniCond || CHR(39);
               ELSE
                  cSentencia := cSentencia || cValCampoComp || ' ';
                  cSentencia := cSentencia || X.CodCondicion || ' ';
                  cSentencia := cSentencia || cValorIniCond;
               END IF;
            ELSE
               cSentencia := 'SELECT ' || CHR(39) || 'S' || CHR(39) || ' FROM DUAL WHERE ' ||
                              cValCampoComp || ' BETWEEN ' || cValorIniCond || ' AND ' || cValorFinCond;
            END IF;
            BEGIN
               EXECUTE IMMEDIATE cSentencia INTO cResultado;
            EXCEPTION
               WHEN OTHERS THEN
                  cResultado := 'N';
            END;
            IF NVL(TRIM(cResultado),'N') = 'S' THEN
               IF NVL(X.ValorTarifa,0) != 0 THEN
                  nValorTarifa := X.ValorTarifa;
               ELSIF X.CampoValor IS NOT NULL THEN
                  IF OC_CONFIG_PLANTILLAS_PLANCOB.AREA_APLICACION(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso) = 'POLDET' THEN
                     nValorTarifa := TO_NUMBER(TRIM(OC_DATOS_PART_EMISION.VALOR_CAMPO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cCodPlantilla,
                                                                                      X.OrdenProcCampo, X.CampoValor)),'999999.999999');
                  ELSIF OC_CONFIG_PLANTILLAS_PLANCOB.AREA_APLICACION(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso) = 'ASEDET' THEN
                     nValorTarifa := TO_NUMBER(TRIM(OC_ASEGURADO_CERTIFICADO.VALOR_CAMPO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado,
                                                                                         cCodPlantilla, X.OrdenProcCampo, X.CampoValor)),'999999.999999');
                  END IF;
               END IF;
            END IF;
         ELSE
            IF NVL(X.ValorTarifa,0) != 0 THEN
               nValorTarifa := X.ValorTarifa;
            ELSIF X.CampoValor IS NOT NULL THEN
               IF OC_CONFIG_PLANTILLAS_PLANCOB.AREA_APLICACION(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso) = 'POLDET' THEN
                  nValorTarifa := TO_NUMBER(TRIM(OC_DATOS_PART_EMISION.VALOR_CAMPO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cCodPlantilla,
                                                                                   X.OrdenProcCampo, X.CampoValor)),'999999.999999');
               ELSIF OC_CONFIG_PLANTILLAS_PLANCOB.AREA_APLICACION(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso) = 'ASEDET' THEN
                  nValorTarifa := TO_NUMBER(TRIM(OC_ASEGURADO_CERTIFICADO.VALOR_CAMPO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado,
                                                                                      cCodPlantilla,X.OrdenProcCampo, X.CampoValor)),'999999.999999');
               END IF;
            END IF;
         END IF;
         IF NVL(nValorTarifa,0) != 0 AND X.IndAplicFormula = 'S' THEN
            nValorTarifa := OC_TARIFA_DINAMICA_FORMULA.APLICA_FORMULA(nIdTarifa, nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                      cIdTipoSeg, cPlanCob, nCod_Asegurado, cCodPlantilla,
                                                                      cCodCobert, cTipoTarifa, X.IdCampo, NVL(nValorTarifa,0), cTipoProceso);
            EXIT;
         ELSIF NVL(nValorTarifa,0) != 0 THEN
            EXIT;
         END IF;
      END LOOP;
      RETURN(nValorTarifa);
   ELSE
      RETURN(0);
   END IF;
END CALCULAR_TARIFA;

PROCEDURE COPIAR (nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO TARIFA_DINAMICA_DET
            (IdTarifa, CodCobert, TipoTarifa, IdCampo, IndAplicFormula,
             CodCampo, OrdenProcCampo, CodCondicion, ValorIniCond, ValorFinCond,
             ValorTarifa, CampoValor, OrdenProcCampoVal, CodUsuario, FecUltCambio,
             TipoProceso)
      SELECT nIdTarifaDest, CodCobert, TipoTarifa, IdCampo, IndAplicFormula,
             CodCampo, OrdenProcCampo, CodCondicion, ValorIniCond, ValorFinCond,
             ValorTarifa, CampoValor, OrdenProcCampoVal, USER, TRUNC(SYSDATE),
             TipoProceso
        FROM TARIFA_DINAMICA_DET
       WHERE IdTarifa   = nIdTarifaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de TARIFA_DINAMICA_DET  '|| SQLERRM);
   END;
END COPIAR;

END OC_TARIFA_DINAMICA_DET;
/

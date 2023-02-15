CREATE OR REPLACE PACKAGE OC_COBERT_ACT_ASEG IS

---- SE INCLUYE IDRAMOREAL A LOS CURSORES E INSERTS           JMMD20220122
-- HOMOLOGACION VIFLEX                                                       2022/03/01  JMMD

PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nTasaCambio NUMBER, nCod_Asegurado NUMBER, cCodCobert VARCHAR2,
                            nSumaAsegManual NUMBER, nSalarioMensual NUMBER, nVecesSalario NUMBER,
                            nEdad_Minima NUMBER, nEdad_Maxima NUMBER, nEdad_Exclusion NUMBER,
                            nSumaAseg_Minima NUMBER, nSumaAseg_Maxima NUMBER, nPorcExtraPrima NUMBER,
                            nMontoExtraPrima NUMBER, nSumaIngresada NUMBER);

FUNCTION CALCULO_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                           cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                           nCod_Asegurado NUMBER, nTasaCambio NUMBER, cCodCobert VARCHAR2,
                           cTipo VARCHAR2) RETURN NUMBER;

FUNCTION EXISTE_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                          cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2;
PROCEDURE CARGAR_COBERTURAS_SIN_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                       cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                                       nTasaCambio NUMBER, nCod_Asegurado NUMBER,nSuma NUMBER);

FUNCTION CAMBIO_POR_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER,
                         cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;

PROCEDURE HEREDA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nCod_Asegurado NUMBER,  cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);

PROCEDURE ELIMINAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);

PROCEDURE COPIAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPolOrig NUMBER, nIdPolizaDest NUMBER, nIDetPolDest NUMBER);

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                        nCod_Asegurado NUMBER, cCodCobert VARCHAR2) RETURN NUMBER;

PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

FUNCTION DEDUCIBLE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                   nCod_Asegurado NUMBER, cCodCobert VARCHAR2) RETURN NUMBER;

PROCEDURE HEREDA_COB_ENDOSO_DECL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                              nCod_Asegurado NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, nIdEndoso NUMBER);

FUNCTION TOTAL_PRIMA_NIVELADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                              nCod_Asegurado NUMBER, nIdEndoso NUMBER) RETURN NUMBER;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

PROCEDURE CARGAR_COBERTURAS_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                            cCodCobert VARCHAR2, nSumaAsegManual NUMBER, nSalarioMensual NUMBER,
                            nVecesSalario NUMBER, nEdad_Minima NUMBER, nEdad_Maxima NUMBER,
                            nEdad_Exclusion NUMBER, nSumaAseg_Minima NUMBER, nSumaAseg_Maxima NUMBER,
                            nPorcExtraPrimaDet NUMBER, nMontoExtraPrimaDet NUMBER, nSumaIngresada NUMBER,
                            nDeducibleIngresado NUMBER, nCuotaPromedio NUMBER, nPrimaPromedio NUMBER,
                            nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER);

END OC_COBERT_ACT_ASEG;

/
create or replace PACKAGE BODY OC_COBERT_ACT_ASEG IS

---- SE INCLUYE IDRAMOREAL A LOS CURSORES E INSERTS           JMMD20220122
-- HOMOLOGACION VIFLEX                                                       2022/03/01  JMMD

PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nTasaCambio NUMBER, nCod_Asegurado NUMBER, cCodCobert VARCHAR2,
                            nSumaAsegManual NUMBER, nSalarioMensual NUMBER, nVecesSalario NUMBER,
                            nEdad_Minima NUMBER, nEdad_Maxima NUMBER, nEdad_Exclusion NUMBER,
                            nSumaAseg_Minima NUMBER, nSumaAseg_Maxima NUMBER, nPorcExtraPrima NUMBER,
                            nMontoExtraPrima NUMBER, nSumaIngresada NUMBER) IS
nCod_Moneda             POLIZAS.Cod_Moneda%TYPE;
nTasaCambioDet          DETALLE_POLIZA.Tasa_Cambio%TYPE;
dFecEmision             POLIZAS.FecEmision%TYPE ;
nSumaAsegMoneda         DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nSumaAsegLocal          DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
dFecIniVig              POLIZAS.FecIniVig%TYPE;
dFecFinVig              POLIZAS.FecFinVig%TYPE;
cSexo                   PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cRiesgo                 ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
cCodActividad           PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
nIdTarifa               TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
nEdad                   NUMBER(5);
nEdadEmision            NUMBER(5);
nExiste                 NUMBER;
nExisteAgen             NUMBER;
nTasa                   NUMBER;
nTasaNivelada           NUMBER;
nValor                  NUMBER;
nValorMoneda            NUMBER;
nPrimaNivLocal          NUMBER := 0;
nPrimaNivMoneda         NUMBER := 0;
cTipoProceso            CONFIG_PLANTILLAS_PLANCOB.TipoProceso%TYPE;
nIdEndoso               ASEGURADO_CERTIFICADO.IdEndoso%TYPE;
cTarifaDinamica         VARCHAR2(1) := 'N';
nPorcDescuento          POLIZAS.PorcDescuento%TYPE;
nPorcGtoAdmin           POLIZAS.PorcGtoAdmin%TYPE;
nPorcGtoAdqui           POLIZAS.PorcGtoAdqui%TYPE;
nPorcUtilidad           POLIZAS.PorcUtilidad%TYPE;
nFactorAjuste           POLIZAS.FactorAjuste%TYPE;
nMontoDeducible         POLIZAS.MontoDeducible%TYPE;
nFactFormulaDeduc       POLIZAS.FactFormulaDeduc%TYPE;
nHorasVig               POLIZAS.HorasVig%TYPE;
nDiasVig                POLIZAS.DiasVig%TYPE;
nEdad_MinimaCob         COBERTURAS_DE_SEGUROS.Edad_Minima%TYPE;
nEdad_MaximaCob         COBERTURAS_DE_SEGUROS.Edad_Maxima%TYPE;
nEdad_ExclusionCob      COBERTURAS_DE_SEGUROS.Edad_Exclusion%TYPE;
nSumaAseg_MinimaCob     COBERTURAS_DE_SEGUROS.SumaAsegMinima%TYPE;
nSumaAseg_MaximaCob     COBERTURAS_DE_SEGUROS.SumaAsegMaxima%TYPE;
cTipoSeg                TIPOS_DE_SEGUROS.TipoSeg%TYPE;
nDeducibleCobLocal      COBERT_ACT_ASEG.Deducible_Local%TYPE;
nDeducibleCobMoneda     COBERT_ACT_ASEG.Deducible_Moneda%TYPE;
nNumRenov               POLIZAS.NumRenov%TYPE;
cStsCobertura           COBERT_ACT.StsCobertura%TYPE;
nIdPolizaEmision        POLIZAS.IdPoliza%TYPE;
dFecIniVigEmision       POLIZAS.FecIniVig%TYPE;
nPorcGtoAdminTar        TARIFA_SEXO_EDAD_RIESGO.PorcGtoAdmin%TYPE;

CURSOR COB_Q IS
   SELECT CodCobert, Porc_Tasa, TipoTasa, Prima_Cobert,
          SumaAsegurada, Cod_Moneda, CodTarifa, Edad_Minima,
          Edad_Maxima, Edad_Exclusion, MontoDeducible, PorcenDeducible,
          SumaAsegMinima, SumaAsegMaxima,
          DECODE(TipoTasa,'C',100,DECODE(TipoTasa,'M',1000,1)) FactorTasa,
          NVL(IDRAMOREAL, OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(CodCia, CODEMPRESA, IdTipoSeg, PlanCob, CodCobert)) IDRAMOREAL
     FROM COBERTURAS_DE_SEGUROS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob
      AND Edad_Minima  <= nEdad
      AND Edad_Maxima  >= nEdad
      AND CodCobert     = NVL(cCodCobert, CodCobert)
      AND StsCobertura  = 'ACT';
BEGIN
   IF NVL(nTasaCambio,0) = 0 THEN
      RAISE_APPLICATION_ERROR(-20225,'No Existe Tasa de Cambio para Generar Coberturas');
   END IF;
   BEGIN
      SELECT 1
        INTO nExiste
        FROM COBERT_ACT_ASEG
       WHERE CodCia            = nCodCia
         AND IdPoliza          = nIdPoliza
         AND IdetPol           = nIDetPol
         AND StsCobertura NOT IN ('SOL','XRE')
         AND Cod_Asegurado     = nCod_Asegurado
         AND CodCobert         = NVL(cCodCobert, CodCobert);
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nExiste := 0;
       WHEN TOO_MANY_ROWS THEN
          nExiste := 1;
   END;

   IF nExiste = 0 THEN
      DELETE COBERT_ACT_ASEG
       WHERE CodCia         = nCodCia
         AND IdPoliza       = nIdPoliza
         AND IdetPol        = nIDetPol
         AND StsCobertura  IN ('SOL','XRE')
         AND Cod_Asegurado  = nCod_Asegurado
         AND CodCobert      = NVL(cCodCobert, CodCobert);

      BEGIN
         SELECT P.Cod_Moneda, TRUNC(P.FecEmision), TRUNC(P.FecIniVig), TRUNC(P.FecFinVig),
                HorasVig, DiasVig, PorcDescuento, PorcGtoAdmin, PorcGtoAdqui,
                PorcUtilidad, FactorAjuste, MontoDeducible, FactFormulaDeduc, NumRenov
           INTO nCod_Moneda, dFecEmision, dFecIniVig, dFecFinVig, nHorasVig, nDiasVig,
                nPorcDescuento, nPorcGtoAdmin, nPorcGtoAdqui, nPorcUtilidad,
                nFactorAjuste, nMontoDeducible, nFactFormulaDeduc, nNumRenov
           FROM POLIZAS P
          WHERE P.CodCia    = nCodCia
            AND P.IdPoliza  = nIdPoliza;
      END;

      nEdad         := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado, dFecIniVig);
      nIdTarifa     := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig);

      IF nNumRenov = 0 THEN
         cStsCobertura     := 'SOL';
         nEdadEmision      := nEdad;
      ELSE
         cStsCobertura     := 'XRE';
         nIdPolizaEmision  := OC_POLIZAS.POLIZA_INICIAL_RENOVACION(nCodCia, nCodEmpresa, nIdPoliza);
         dFecIniVigEmision := OC_POLIZAS.INICIO_VIGENCIA(nCodCia, nCodEmpresa, nIdPolizaEmision);
         nEdadEmision      := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado, dFecIniVigEmision);
      END IF;

      FOR X IN COB_Q  LOOP
         nPrimaNivLocal     := 0;
         nPrimaNivMoneda    := 0;

         BEGIN
            SELECT TipoSeg
              INTO cTipoSeg
              FROM TIPOS_DE_SEGUROS
             WHERE CodCia    = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdTipoSeg = cIdTipoSeg;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cTipoSeg := 'N';
         END;

         IF (nEdad BETWEEN X.Edad_Minima AND X.Edad_Maxima AND nEdad_Minima = X.Edad_Minima AND nEdad_Maxima = X.Edad_Maxima) OR
             NVL(cTipoSeg,'N') != 'P' OR
            (nEdad BETWEEN nEdad_Minima AND nEdad_Maxima AND (nEdad_Minima != X.Edad_Minima OR nEdad_Maxima != X.Edad_Maxima)) THEN
            nEdad_MinimaCob     := NVL(nEdad_Minima,0);
            nEdad_MaximaCob     := NVL(nEdad_Maxima,0);
            nEdad_ExclusionCob  := NVL(nEdad_Exclusion,0);
            nSumaAseg_MinimaCob := NVL(nSumaAseg_Minima,0);
            nSumaAseg_MaximaCob := NVL(nSumaAseg_Maxima,0);

            IF cCodCobert IS NULL THEN
               IF NVL(nEdad_MinimaCob,0) = 0 THEN
                  nEdad_MinimaCob := X.Edad_Minima;
               END IF;
               IF NVL(nEdad_MaximaCob,0) = 0 THEN
                  nEdad_MaximaCob := X.Edad_Maxima;
               END IF;
               IF NVL(nEdad_ExclusionCob,0) = 0 THEN
                  nEdad_ExclusionCob := X.Edad_Exclusion;
               END IF;
               IF NVL(nSumaAseg_MinimaCob,0) = 0 THEN
                  nSumaAseg_MinimaCob := X.SumaAsegMinima;
               END IF;
               IF NVL(nSumaAseg_MaximaCob,0) = 0 THEN
                  nSumaAseg_MaximaCob := X.SumaAsegMaxima;
               END IF;
            END IF;

            IF X.CodTarifa IS NULL THEN
               cTarifaDinamica := 'N'; -- EC - 20/01/2017
               nSumaAsegMoneda := 0;
               nSumaAsegLocal  := 0;
               IF X.TipoTasa = 'C' THEN
                  nTasa := X.Porc_Tasa/ X.FactorTasa;
               ELSIF X.TipoTasa = 'M' THEN
                  nTasa := X.Porc_Tasa/ X.FactorTasa;
               ELSE
                  nTasa := X.Porc_Tasa;
               END IF;
               IF NVL(nTasa,0) =  0 THEN
                  nValorMoneda := X.Prima_Cobert;
                  nValor       := X.Prima_Cobert * nTasaCambio;
                  IF NVL(X.SumaAsegurada,0) != 0 THEN
                     nTasa        := NVL(nValorMoneda,0) / NVL(X.SumaAsegurada,0);
                  END IF;
               ELSE
                  nValorMoneda := NVL(X.SumaAsegurada,0) * NVL(nTasa,0);
                  nValor       := (NVL(X.SumaAsegurada,0) * NVL(nTasa,0)) * nTasaCambio;
               END IF;
               nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
               nSumaAsegLocal  := NVL(X.SumaAsegurada,0) * nTasaCambio;
            ELSE
               IF OC_TARIFA_DINAMICA.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecEmision) = 0 THEN
                  IF nIdTarifa = 0 THEN
                     RAISE_APPLICATION_ERROR(-20225,'NO Existe Tarifa Vigente por Sexo, Edad y Riesgo para el Tipo de Seguro ' || cIdTipoSeg ||
                                             ' Plan de Coberturas ' || cPlanCob || ' y Fecha de Inicio de Vigencia de la Póliza ' ||
                                             TO_CHAR(dFecIniVig,'DD/MM/RRRR'));
                  END IF;

                  IF X.CodTarifa IN ('EDADYSEXO','SEXOEDAD') THEN
                     BEGIN
                        SELECT D.FecIniVig
                          INTO dFecIniVig
                          FROM DETALLE_POLIZA D
                         WHERE D.IdPoliza       = nIdPoliza
                           AND D.IdetPol        = nIDetPol;
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           RAISE_APPLICATION_ERROR(-20225,'No Existe Detalle de Póliza para Generar Coberturas');
                     END;
                     cTarifaDinamica := 'N'; -- EC - 20/01/2017
                     cSexo           := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cCodActividad   := OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cRiesgo         := OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
                     nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
                     nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                               X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        IF NVL(nSumaAsegManual,0) != 0 THEN
                           nSumaAsegMoneda := NVL(nSumaAsegManual,0);
                        ELSE
                           nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
                        END IF;
                     END IF;

                     IF NVL(nSumaAsegManual,0) != 0 THEN
                        nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                   X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa, NULL);
                     ELSE
                        nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                   X.CodCobert, nEdad, cSexo, cRiesgo, nSumaAsegMoneda, nIdTarifa, NULL);
                     END IF;

                     IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                        nValorMoneda := nSumaAsegMoneda * NVL(nTasa,0);
                     END IF;
                     nValor          := NVL(nValorMoneda,0) * nTasaCambio;
                     IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                        nTasa           := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
                     END IF;
                  ELSE
                     cTarifaDinamica   := 'N';
                     cCodActividad     := NULL; --OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cRiesgo           := 'NA'; --OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
                     --nPorcExtraPrima   := OC_PLAN_COBERTURAS.PORCENTAJE_EXTRAPRIMA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);
                     --nMontoExtraPrima  := OC_PLAN_COBERTURAS.MONTO_EXTRAPRIMA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);

                     nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);

                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        IF NVL(nSumaAsegManual,0) != 0 THEN
                           nSumaAsegMoneda := NVL(nSumaAsegManual,0);
                        ELSE
                           nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
                        END IF;
                     END IF;

                     nTasa            := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
                     nTasaNivelada    := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_NIVELADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdadEmision, cSexo, cRiesgo, nIdTarifa, NULL);
                     nPorcGtoAdminTar := OC_TARIFA_SEXO_EDAD_RIESGO.PORCEN_GASTOS_ADMIN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                        X.CodCobert, nEdadEmision, cSexo, cRiesgo, nIdTarifa, NULL);

                     IF NVL(nTasa,0) > 0 THEN
                        nTasa := NVL(nTasa,0) * (1 - (NVL(nPorcDescuento,0) / 100));

                        nTasa := NVL(nTasa,0) * (1 + (NVL(nPorcExtraPrima,0) / 100));

                        nTasa := NVL(nTasa,0) + NVL(nMontoExtraPrima,0);

                        --IF NVL(nFactorAjuste,0) > 0 THEN
                        nTasa := NVL(nTasa,0) * NVL(nFactorAjuste,0);
                        --END IF;

                        -- Factor Deducible ??
                        nTasa := (1-(NVL(nFactFormulaDeduc,0) * NVL(nMontoDeducible,0))) * NVL(nTasa,0);

                        IF NVL(nHorasVig,0) > 0 THEN
                           nTasa := NVL(nTasa,0) * (NVL(nHorasVig,0) / 24);
                        END IF;

                        IF NVL(nDiasVig,0) > 0 THEN
                           nTasa := NVL(nTasa,0) * (NVL(nDiasVig,0) / 365);
                        END IF;

                        --IF cTipoProrrata = 'D365' THEN
                           --nTasa := (NVL(nTasa,0) / 365) * (dFecFinVig - dFecIniVig);
                        --END IF;

                        --IF NVL(nDiasVig,0) > 0 THEN
                           --nTasa := NVL(nTasa,0) * (NVL(nDiasVig,0) / OC_GENERALES.DIAS_ANIO(dFecIniVig, dFecFinVig));
                        --END IF;

                        nTasa := NVL(nTasa,0) / (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) -
                                 (NVL(nPorcGtoAdmin,0) / 100) -  (NVL(nPorcGtoAdminTar,0) / 100));
                     END IF;

                     IF NVL(nTasaNivelada,0) > 0 THEN
                        nTasaNivelada := (NVL(nTasaNivelada,0) + (NVL(nMontoExtraPrima,0) /
                                         (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) - (NVL(nPorcGtoAdmin,0) / 100) -
                                         (NVL(nPorcGtoAdminTar,0) / 100)))) * (1 + (NVL(nPorcExtraPrima,0) / 100));
                     END IF;

                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        nSumaAsegMoneda  := NVL(X.SumaAsegurada,0);
                     END IF;

                     nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa, NULL); --nSumaAsegMoneda);
                     IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                        nValorMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasa,0) / X.FactorTasa;
                     END IF;
                     nValor    := NVL(nValorMoneda,0) * nTasaCambio;
                     IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                        nTasa        := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
                     END IF;

                     nPrimaNivMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasaNivelada,0) / X.FactorTasa;
                     nPrimaNivMoneda := NVL(nPrimaNivMoneda,0) - NVL(nValorMoneda,0);
                     nPrimaNivLocal  := NVL(nPrimaNivMoneda,0) * nTasaCambio;
                  END IF;
               ELSE
                  cTipoProceso := OC_CONFIG_PLANTILLAS_PLANCOB.TIPO_PROCESO(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, 'ASEDET');

                  IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'S' THEN
                     cTarifaDinamica := 'S'; -- EC - 20/01/2017
                     nSumaAsegMoneda := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                               cPlanCob, X.CodCobert, 'S', dFecEmision, nCod_Asegurado,
                                                                               cTipoProceso);
                     nValorMoneda    := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                               cPlanCob, X.CodCobert, 'P', dFecEmision, nCod_Asegurado,
                                                                               cTipoProceso);
                     nTasa           := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                               cPlanCob, X.CodCobert, 'T', dFecEmision, nCod_Asegurado,
                                                                               cTipoProceso);

                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        nSumaAsegMoneda := X.SumaAsegurada;
                     END IF;
                     IF NVL(nValorMoneda,0) = 0 THEN
                        nValorMoneda    := X.Prima_Cobert;
                     END IF;
                     IF NVL(nTasa,0) = 0 THEN
                        IF X.TipoTasa = 'C' THEN
                           nTasa := X.Porc_Tasa/ X.FactorTasa;
                        ELSIF X.TipoTasa = 'M' THEN
                           nTasa := X.Porc_Tasa/ X.FactorTasa;
                        ELSE
                           nTasa := X.Porc_Tasa;
                        END IF;
                     ELSE
                        IF X.TipoTasa = 'C' THEN
                           nTasa := nTasa/ X.FactorTasa;
                        ELSIF X.TipoTasa = 'M' THEN
                           nTasa := nTasa/ X.FactorTasa;
                        END IF;
                     END IF;
                     IF nTasa != 0 AND nValorMoneda = 0 THEN
                        nValorMoneda := nSumaAsegMoneda * nTasa;
                     ELSIF nTasa = 0 AND nSumaAsegMoneda != 0 THEN
                        nTasa  := NVL(nValorMoneda,0) / nSumaAsegMoneda;
                     END IF;
                     nValor    := NVL(nValorMoneda,0) * nTasaCambio;
                  END IF;
               END IF;
            END IF;
            IF X.Cod_Moneda != nCod_Moneda THEN
               nTasaCambioDet  := OC_GENERALES.TASA_DE_CAMBIO(nCod_Moneda, dFecEmision);
               nSumaAsegMoneda := NVL(nSumaAsegMoneda,0) / nTasaCambioDet;
               nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambioDet;
               nValorMoneda    := NVL(nValorMoneda,0) / nTasaCambioDet;
               nValor          := NVL(nValorMoneda,0) * nTasaCambioDet;
            ELSE
               nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambio;
            END IF;

            IF NVL(X.MontoDeducible,0) != 0 THEN
               nDeducibleCobMoneda := NVL(X.MontoDeducible,0);
               nDeducibleCobLocal  := NVL(X.MontoDeducible,0) * nTasaCambio;
            ELSE
               nDeducibleCobMoneda := NVL(nSumaAsegMoneda,0) * NVL(X.PorcenDeducible,0) / 100;
               nDeducibleCobLocal  := NVL(nDeducibleCobMoneda,0) * nTasaCambio;
            END IF;

            BEGIN
               SELECT NVL(MAX(IdEndoso),0)
                 INTO nIdEndoso
                 FROM ASEGURADO_CERTIFICADO
                WHERE CodCia        = nCodCia
                  AND IdPoliza      = nIdPoliza
                  AND IDetPol       = nIDetPol
                  AND Cod_Asegurado = nCod_Asegurado;
            END;
            IF (cTarifaDinamica = 'S' AND NVL(nSumaAsegMoneda,0) != 0 AND NVL(nValorMoneda,0) != 0) OR
               (cTarifaDinamica = 'N' AND NVL(nSumaAsegMoneda,0) != 0) THEN
               BEGIN
                  INSERT INTO COBERT_ACT_ASEG
                        (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                         CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                         Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                         NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                         Cod_Asegurado, PrimaNivMoneda, PrimaNivLocal, SalarioMensual,
                         VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima,
                         Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
                         MontoExtraPrimaDet, SumaIngresada, IDRAMOREAL)
                  VALUES(nIdPoliza, nIDetPol, nCodEmpresa, cIdTipoSeg, nCodCia,
                         X.CodCobert, cStsCobertura, nSumaAsegLocal, nSumaAsegMoneda,
                         nValor, nValorMoneda, nTasa, nIdEndoso, 'POLI',
                         nIdPoliza, cPlanCob, nCod_Moneda, nDeducibleCobLocal, nDeducibleCobMoneda,
                         nCod_Asegurado, nPrimaNivMoneda, nPrimaNivLocal, NVL(nSalarioMensual,0),
                         NVL(nVecesSalario,0), NVL(nSumaAsegManual,0), nEdad_MinimaCob,
                         nEdad_MaximaCob, nEdad_ExclusionCob, nSumaAseg_MinimaCob,
                         nSumaAseg_MaximaCob, nPorcExtraPrima, nMontoExtraPrima, nSumaIngresada, X.IDRAMOREAL);
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas para Detalle de la Póliza: '||
                                            TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol));
               END;
            END IF;
         END IF;
      END LOOP;
   END IF;
END CARGAR_COBERTURAS;

FUNCTION CALCULO_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                           cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                           nCod_Asegurado NUMBER, nTasaCambio NUMBER, cCodCobert VARCHAR2,
                           cTipo VARCHAR2) RETURN NUMBER IS
nCod_Moneda             POLIZAS.Cod_Moneda%TYPE;
nTasaCambioDet          DETALLE_POLIZA.Tasa_Cambio%TYPE;
dFecEmision             POLIZAS.FecEmision%TYPE ;
nSumaAsegMoneda         DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nSumaAsegLocal          DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
nSumaAsegManual         DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
dFecIniVig              POLIZAS.FecIniVig%TYPE;
dFecFinVig              POLIZAS.FecFinVig%TYPE;
cSexo                   PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cRiesgo                 ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
cCodActividad           PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
nIdTarifa               TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
nEdad                   NUMBER(5);
nExiste                 NUMBER;
nExisteAgen             NUMBER;
nTasa                   NUMBER;
nValor                  NUMBER;
nValorMoneda            NUMBER;
nTasaNivelada           NUMBER;
nValorF                 DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
cTipoProceso            CONFIG_PLANTILLAS_PLANCOB.TipoProceso%TYPE;
nPorcDescuento          POLIZAS.PorcDescuento%TYPE;
nPorcGtoAdmin           POLIZAS.PorcGtoAdmin%TYPE;
nPorcGtoAdqui           POLIZAS.PorcGtoAdqui%TYPE;
nPorcUtilidad           POLIZAS.PorcUtilidad%TYPE;
nFactorAjuste           POLIZAS.FactorAjuste%TYPE;
nMontoDeducible         POLIZAS.MontoDeducible%TYPE;
nFactFormulaDeduc       POLIZAS.FactFormulaDeduc%TYPE;
nHorasVig               POLIZAS.HorasVig%TYPE;
nDiasVig                POLIZAS.DiasVig%TYPE;
nPorcExtraPrima         COBERT_ACT_ASEG.PorcExtraPrimaDet%TYPE;
nMontoExtraPrima        COBERT_ACT_ASEG.MontoExtraPrimaDet%TYPE;
nPrimaNivLocal          NUMBER := 0;
nPrimaNivMoneda         NUMBER := 0;
nPorcGtoAdminTar        TARIFA_SEXO_EDAD_RIESGO.PorcGtoAdmin%TYPE;

CURSOR COB_Q IS
   SELECT CodCobert, Porc_Tasa, TipoTasa, Prima_Cobert,
          SumaAsegurada, Cod_Moneda, CodTarifa, Edad_Minima,
          Edad_Maxima, Edad_Exclusion, MontoDeducible, PorcenDeducible,
          SumaAsegMinima, SumaAsegMaxima,
          DECODE(TipoTasa,'C',100,DECODE(TipoTasa,'M',1000,1)) FactorTasa
     FROM COBERTURAS_DE_SEGUROS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg
      AND CodCobert    = cCodCobert
      AND PlanCob      = cPlanCob
      AND StsCobertura = 'ACT';
BEGIN
   BEGIN
      SELECT P.Cod_Moneda, TRUNC(P.FecEmision), TRUNC(P.FecIniVig), TRUNC(P.FecFinVig),
             HorasVig, DiasVig, PorcDescuento, PorcGtoAdmin, PorcGtoAdqui,
             PorcUtilidad, FactorAjuste, MontoDeducible, FactFormulaDeduc
        INTO nCod_Moneda, dFecEmision, dFecIniVig, dFecFinVig, nHorasVig, nDiasVig,
             nPorcDescuento, nPorcGtoAdmin, nPorcGtoAdqui, nPorcUtilidad,
             nFactorAjuste, nMontoDeducible, nFactFormulaDeduc
        FROM POLIZAS P
       WHERE P.CodCia    = nCodCia
         AND P.IdPoliza  = nIdPoliza;
   END;

   BEGIN
      SELECT NVL(PorcExtraPrimaDet,0), NVL(MontoExtraPrimaDet,0), NVL(SumaAsegCalculada,0)
        INTO nPorcExtraPrima, nMontoExtraPrima, nSumaAsegManual
        FROM COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND CodCobert     = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No Existe Cobertura ' || cCodCobert);
   END;

   FOR X IN COB_Q  LOOP
      BEGIN
         SELECT TRUNC(D.FecIniVig), TRUNC(D.FecFinVig)
           INTO dFecIniVig, dFecFinVig
           FROM DETALLE_POLIZA D
          WHERE D.IdPoliza       = nIdPoliza
            AND D.IdetPol        = nIDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No Existe Detalle de Póliza para Generar Coberturas');
      END;

      nEdad         := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado, dFecIniVig);
      nIdTarifa     := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig);

      IF X.CodTarifa IS NULL THEN
         nSumaAsegMoneda := 0;
         nSumaAsegLocal  := 0;
         IF X.TipoTasa = 'C' THEN
            nTasa := X.Porc_Tasa/ X.FactorTasa;
         ELSIF X.TipoTasa = 'M' THEN
            nTasa := X.Porc_Tasa/ X.FactorTasa;
         ELSE
            nTasa := X.Porc_Tasa;
         END IF;
         IF NVL(nTasa,0) =  0 THEN
            nValorMoneda := X.Prima_Cobert;
            nValor       := X.Prima_Cobert * nTasaCambio;
            IF NVL(X.SumaAsegurada,0) != 0 THEN
               nTasa        := NVL(nValorMoneda,0) / X.SumaAsegurada;
            END IF;
         ELSE
            nValorMoneda := X.SumaAsegurada * NVL(nTasa,0);
            nValor       := (X.SumaAsegurada * NVL(nTasa,0)) * nTasaCambio;
         END IF;
         nSumaAsegMoneda := X.SumaAsegurada;
         nSumaAsegLocal  := X.SumaAsegurada * nTasaCambio;
      ELSE
         IF OC_TARIFA_DINAMICA.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecEmision) = 0 THEN
            IF nIdTarifa = 0 THEN
               RAISE_APPLICATION_ERROR(-20225,'NO Existe Tarifa Vigente por Sexo, Edad y Riesgo para el Tipo de Seguro ' || cIdTipoSeg ||
                                       ' Plan de Coberturas ' || cPlanCob || ' y Fecha de Inicio de Vigencia de la Póliza ' ||
                                       TO_CHAR(dFecIniVig,'DD/MM/RRRR'));
            END IF;

            IF X.CodTarifa IN ('EDADYSEXO','SEXOEDAD') THEN
               cSexo           := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado);
               cCodActividad   := OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
               cRiesgo         := OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
               nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                            X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
               nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                         X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  nSumaAsegMoneda  := X.SumaAsegurada;
               END IF;

               nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, nSumaAsegMoneda, nIdTarifa, NULL);
               IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                  nValorMoneda := nSumaAsegMoneda * NVL(nTasa,0);
               END IF;
               nValor    := NVL(nValorMoneda,0) * nTasaCambio;
               IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                  nTasa        := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
               END IF;
            ELSE
               cSexo             := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado);
               cCodActividad     := NULL; --OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
               cRiesgo           := 'NA'; --OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
               --nPorcExtraPrima   := OC_PLAN_COBERTURAS.PORCENTAJE_EXTRAPRIMA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);
               --nMontoExtraPrima  := OC_PLAN_COBERTURAS.MONTO_EXTRAPRIMA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);

               nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                            X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);

               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  IF NVL(nSumaAsegManual,0) != 0 THEN
                     nSumaAsegMoneda := NVL(nSumaAsegManual,0);
                  ELSE
                     nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
                  END IF;
               END IF;

               nTasa            := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
               nTasaNivelada    := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_NIVELADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                            X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);

               nPorcGtoAdminTar := OC_TARIFA_SEXO_EDAD_RIESGO.PORCEN_GASTOS_ADMIN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);

               IF NVL(nTasa,0) > 0 THEN
                  nTasa := NVL(nTasa,0) * (1 - (NVL(nPorcDescuento,0) / 100));

                  nTasa := NVL(nTasa,0) * (1 + (NVL(nPorcExtraPrima,0) / 100));

                  nTasa := NVL(nTasa,0) + NVL(nMontoExtraPrima,0);

                  --IF NVL(nFactorAjuste,0) > 0 THEN
                  nTasa := NVL(nTasa,0) * NVL(nFactorAjuste,0);
                  --END IF;

                  -- Factor Deducible ??
                  nTasa := (1-(NVL(nFactFormulaDeduc,0) * NVL(nMontoDeducible,0))) * NVL(nTasa,0);

                  IF NVL(nHorasVig,0) > 0 THEN
                     nTasa := NVL(nTasa,0) * (NVL(nHorasVig,0) / 24);
                  END IF;

                  --IF cTipoProrrata = 'D365' THEN
                     --nTasa := (NVL(nTasa,0) / 365) * (dFecFinVig - dFecIniVig);
                  --END IF;

                  IF NVL(nDiasVig,0) > 0 THEN
                     nTasa := NVL(nTasa,0) * (NVL(nDiasVig,0) / OC_GENERALES.DIAS_ANIO(dFecIniVig, dFecFinVig));
                  END IF;

                  nTasa := NVL(nTasa,0) / (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) -
                           (NVL(nPorcGtoAdmin,0) / 100) -  (NVL(nPorcGtoAdminTar,0) / 100));
               END IF;

               IF NVL(nTasaNivelada,0) > 0 THEN
                  nTasaNivelada := (NVL(nTasaNivelada,0) + (NVL(nMontoExtraPrima,0) /
                                   (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) - (NVL(nPorcGtoAdmin,0) / 100) -
                                   (NVL(nPorcGtoAdminTar,0) / 100)))) * (1 + (NVL(nPorcExtraPrima,0) / 100));
               END IF;

               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  nSumaAsegMoneda  := NVL(X.SumaAsegurada,0);
               END IF;

               nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa, NULL); --nSumaAsegMoneda);
               IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                  nValorMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasa,0) / X.FactorTasa;
               END IF;
               nValor    := NVL(nValorMoneda,0) * nTasaCambio;
               IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                  nTasa        := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
               END IF;

               nPrimaNivMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasaNivelada,0) / X.FactorTasa;
               nPrimaNivMoneda := NVL(nPrimaNivMoneda,0) - NVL(nValorMoneda,0);
               nPrimaNivLocal  := NVL(nPrimaNivMoneda,0) * nTasaCambio;
            END IF;
         ELSE
            cTipoProceso := OC_CONFIG_PLANTILLAS_PLANCOB.TIPO_PROCESO(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, 'POLDET');
            IF OC_DATOS_PART_EMISION.EXISTE_DATO_PARTICULAR(nCodCia, nIdPoliza, nIDetPol) = 'S' THEN
               nSumaAsegMoneda := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                         cPlanCob, X.CodCobert, 'S', dFecEmision, nCod_Asegurado,
                                                                         cTipoProceso);

               nValorMoneda    := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                         cPlanCob, X.CodCobert, 'P', dFecEmision, nCod_Asegurado,
                                                                         cTipoProceso);

               nTasa           := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                         cPlanCob, X.CodCobert, 'T', dFecEmision, nCod_Asegurado,
                                                                         cTipoProceso);
               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  nSumaAsegMoneda  := X.SumaAsegurada;
               END IF;
               IF NVL(nValorMoneda,0) = 0 THEN
                  nValorMoneda    := X.Prima_Cobert;
               END IF;
               IF NVL(nTasa,0) = 0 THEN
                  IF X.TipoTasa = 'C' THEN
                     nTasa := X.Porc_Tasa/ X.FactorTasa;
                  ELSIF X.TipoTasa = 'M' THEN
                     nTasa := X.Porc_Tasa/ X.FactorTasa;
                  ELSE
                     nTasa := X.Porc_Tasa;
                  END IF;
               ELSE
                  IF X.TipoTasa = 'C' THEN
                     nTasa := nTasa/ X.FactorTasa;
                  ELSIF X.TipoTasa = 'M' THEN
                     nTasa := nTasa/ X.FactorTasa;
                  END IF;
               END IF;
               IF nTasa != 0 AND nValorMoneda = 0 THEN
                  nValorMoneda := nSumaAsegMoneda * nTasa;
               ELSIF nTasa = 0 AND nSumaAsegMoneda != 0 THEN
                  nTasa  := NVL(nValorMoneda,0) / nSumaAsegMoneda;
               END IF;
               nValor  := NVL(nValorMoneda,0) * nTasaCambio;
            END IF;
         END IF;
      END IF;
      IF X.Cod_Moneda != nCod_Moneda THEN
         nTasaCambioDet  := OC_GENERALES.TASA_DE_CAMBIO(X.Cod_Moneda, dFecEmision);
         nSumaAsegLocal  := nSumaAsegMoneda * nTasaCambioDet;
      ELSE
         nSumaAsegLocal  := nSumaAsegMoneda;
      END IF;
      IF cTipo = 'P' THEN
         nValorF := nValorMoneda;
      ELSIF  cTipo = 'S' THEN
         nValorF := nSumaAsegMoneda;
      ELSIF  cTipo = 'PN' THEN
         nValorF := nPrimaNivMoneda;
      ELSE
         nValorF := 0;
      END IF;
   END LOOP;
--  END IF;
   IF cTipo = 'T' THEN
      RETURN(nTasa);
   ELSIF cTipo = 'TN' THEN
      RETURN(nTasaNivelada);
   ELSE
      RETURN(nValorF);
   END IF;
END CALCULO_COBERTURA;

FUNCTION EXISTE_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND idpoliza      = nIdPoliza
         AND IdTipoSeg     = cIdTipoSeg
         AND PlanCob       = cPlanCob
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
 RETURN(cExiste);
END EXISTE_COBERTURA;

PROCEDURE CARGAR_COBERTURAS_SIN_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                       cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                                       nTasaCambio NUMBER, nCod_Asegurado NUMBER, nSuma NUMBER) IS
nCod_Moneda             POLIZAS.Cod_Moneda%TYPE;
nTasaCambioDet          DETALLE_POLIZA.Tasa_Cambio%TYPE;
dFecEmision             POLIZAS.FecEmision%TYPE ;
nSumaAsegMoneda         DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nSumaAsegLocal          DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
--nCod_Asegurado          DETALLE_POLIZA.Cod_Asegurado%TYPE;
dFecIniVig              DETALLE_POLIZA.FecIniVig%TYPE;
cSexo                   PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cRiesgo                 ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
cCodActividad           PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
nIdTarifa               TARIFA_DINAMICA.IdTarifa%TYPE;
nDeducibleCobLocal      COBERT_ACT_ASEG.Deducible_Local%TYPE;
nDeducibleCobMoneda     COBERT_ACT_ASEG.Deducible_Moneda%TYPE;
nEdad                   NUMBER(5);
nExiste                 NUMBER;
nExisteAgen             NUMBER;
nTasa                   NUMBER;
nValor                  NUMBER;
nValorMoneda            NUMBER;
CURSOR COB_Q IS
   SELECT CodCobert, Porc_Tasa, TipoTasa, Prima_Cobert,
          SumaAsegurada, Cod_Moneda, CodTarifa, Edad_Minima,
          Edad_Maxima, Edad_Exclusion, MontoDeducible, PorcenDeducible,
          SumaAsegMinima, SumaAsegMaxima,
          NVL(IDRAMOREAL, OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(CodCia, CODEMPRESA, IdTipoSeg, PlanCob, CodCobert)) IDRAMOREAL
     FROM COBERTURAS_DE_SEGUROS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob
      AND Edad_Minima  <= nEdad
      AND Edad_Maxima  >= nEdad
      AND StsCobertura  = 'ACT';
BEGIN
   BEGIN
      SELECT 1
        INTO nExiste
        FROM COBERT_ACT_ASEG
       WHERE IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol
         AND StsCobertura != 'SOL'
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nExiste := 0;
       WHEN TOO_MANY_ROWS THEN
          nExiste := 1;
   END;

   IF nExiste = 0 THEN
      DELETE COBERT_ACT_ASEG
       WHERE IdPoliza     = nIdPoliza
         AND IdetPol      = nIDetPol
         AND StsCobertura = 'SOL'
         AND Cod_Asegurado = nCod_Asegurado;

      BEGIN
         SELECT P.Cod_Moneda, P.FecEmision
           INTO nCod_Moneda, dFecEmision
           FROM POLIZAS P
          WHERE P.IdPoliza = nIdPoliza;
      END;

      FOR X IN COB_Q  LOOP
         IF X.CodTarifa IS NULL THEN
            nSumaAsegMoneda := nSuma;
            nSumaAsegLocal  := nSuma * nTasaCambio;
            nTasa           := 0;
            nValor          := 0;
            nValorMoneda    := 0;
  /*       IF X.Cod_Moneda != nCod_Moneda THEN
            nTasaCambioDet  := OC_GENERALES.TASA_DE_CAMBIO(X.Cod_Moneda, dFecEmision);
            nSumaAsegMoneda := nSumaAsegLocal * nTasaCambioDet;
         ELSE
            nSumaAsegMoneda := nSumaAsegLocal;
         END IF;*/
         END IF;

         IF NVL(X.MontoDeducible,0) != 0 THEN
            nDeducibleCobMoneda := NVL(X.MontoDeducible,0);
            nDeducibleCobLocal  := NVL(X.MontoDeducible,0) * nTasaCambio;
         ELSE
            nDeducibleCobMoneda := NVL(nSumaAsegMoneda,0) * NVL(X.PorcenDeducible,0) / 100;
            nDeducibleCobLocal  := NVL(nDeducibleCobMoneda,0) * nTasaCambio;
         END IF;

         BEGIN
            INSERT INTO COBERT_ACT_ASEG
                  (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                   CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                   Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                   NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                   Cod_Asegurado, PrimaNivMoneda, PrimaNivLocal, SalarioMensual,
                   VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima,
                   Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
                   MontoExtraPrimaDet, SumaIngresada, IDRAMOREAL)
            VALUES(nIdPoliza, nIDetPol, nCodEmpresa, cIdTipoSeg, nCodCia,
                   X.CodCobert, 'SOL', nSumaAsegMoneda, nSumaAsegLocal,
                   nValor, nValorMoneda, nTasa, 0, 'POLI',
                   nIdPoliza, cPlanCob, X.Cod_Moneda, nDeducibleCobLocal,
                   nDeducibleCobMoneda, nCod_Asegurado, 0, 0, 0, 0, 0,
                   X.Edad_Minima, X.Edad_Maxima, X.Edad_Exclusion, X.SumaAsegMinima,
                   X.SumaAsegMaxima, 0, 0, 0, X.IDRAMOREAL );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas para Detalle de la Póliza: '||
                                      TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol));
         END;
      END LOOP;
   END IF;
END CARGAR_COBERTURAS_SIN_TARIFA;

FUNCTION CAMBIO_POR_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         nCod_Asegurado NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cIndCambioSami  COBERT_ACT_ASEG.IndCambioSami%TYPE;
BEGIN
   BEGIN
      SELECT 'S'
        INTO cIndCambioSami
        FROM COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND IdTipoSeg     = cIdTipoSeg
         AND PlanCob       = cPlanCob
         AND IndCambioSami = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCambioSami := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndCambioSami := 'S';
   END;
 RETURN(cIndCambioSami);
END CAMBIO_POR_SAMI;

PROCEDURE HEREDA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nCod_Asegurado NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
nIdEndoso    ASEGURADO_CERTIFICADO.IdEndoso%TYPE;
CURSOR COB_Q IS
   SELECT TipoRef, NumRef, CodCobert, SumaAseg_Local, SumaAseg_Moneda,
          Tasa, Prima_Moneda, Prima_Local, IdEndoso, Cod_Moneda,
          Deducible_Local, Deducible_Moneda, PrimaNivMoneda, PrimaNivLocal,
          SalarioMensual, VecesSalario, SumaAsegCalculada, Edad_Minima,
          Edad_Maxima, Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima,
          PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada,
          NVL(IDRAMOREAL, OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(CodCia, CODEMPRESA, IdTipoSeg, PlanCob, CodCobert)) IDRAMOREAL
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob;
CURSOR ASEG_Q IS
   SELECT Cod_Asegurado, Estado, IdEndoso
     FROM ASEGURADO_CERTIFICADO
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND IdEndoso       = nIdEndoso
      AND Cod_Asegurado != nCod_Asegurado
      AND Estado        IN ('SOL','XRE');
BEGIN
   OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, nCod_Asegurado);
   BEGIN
      SELECT IdEndoso
        INTO nIdEndoso
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia         = nCodCia
         AND IdPoliza       = nIdPoliza
         AND IDetPol        = nIDetPol
         AND Cod_Asegurado  = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No Existe Asegurado: ' || nCod_Asegurado || ' en Póliza y Detalle No. ' ||
                                TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol));
   END;
   FOR W IN ASEG_Q LOOP
      DELETE COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol
         AND StsCobertura IN ('SOL','XRE')
         AND Cod_Asegurado = W.Cod_Asegurado;

      FOR Z IN COB_Q LOOP
         BEGIN
            INSERT INTO COBERT_ACT_ASEG
                  (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                   CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                   Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                   NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                   Cod_Asegurado, PrimaNivMoneda, PrimaNivLocal, SalarioMensual,
                   VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima,
                   Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
                   MontoExtraPrimaDet, SumaIngresada, IDRAMOREAL)
            VALUES(nIdPoliza, nIDetPol, nCodEmpresa, cIdTipoSeg, nCodCia,
                   Z.CodCobert, W.Estado, Z.SumaAseg_Local, Z.SumaAseg_Moneda,
                   Z.Prima_Local, Z.Prima_Moneda, Z.Tasa, Z.IdEndoso, Z.TipoRef,
                   Z.NumRef, cPlanCob, Z.Cod_Moneda, Z.Deducible_Local, Z.Deducible_Moneda,
                   W.Cod_Asegurado, Z.PrimaNivMoneda, Z.PrimaNivLocal, Z.SalarioMensual,
                   Z.VecesSalario, Z.SumaAsegCalculada, Z.Edad_Minima, Z.Edad_Maxima,
                   Z.Edad_Exclusion, Z.SumaAseg_Minima, Z.SumaAseg_Maxima, Z.PorcExtraPrimaDet,
                   Z.MontoExtraPrimaDet, Z.SumaIngresada, Z.IDRAMOREAL);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas para Detalle de la Póliza: '||
                                      TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol));
         END;
      END LOOP;
      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, W.Cod_Asegurado);
      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, W.Cod_Asegurado);
   END LOOP;

   IF nIdEndoso = 0 THEN
      OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
      OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
   ELSE
      OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
   END IF;
END HEREDA_COBERTURAS;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE COBERTURA_ASEG
      SET StsCobertura = 'ANU'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;

   UPDATE COBERT_ACT_ASEG
      SET StsCobertura    = 'ANU'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END ANULAR;

PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE COBERT_ACT_ASEG
      SET StsCobertura = 'CEX'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END EXCLUIR;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
BEGIN
   UPDATE COBERT_ACT_ASEG
      SET StsCobertura = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND IdEndoso      = nIdEndoso
      AND Cod_Asegurado = nCod_Asegurado;

   BEGIN
      INSERT INTO COBERTURA_ASEG
            (CodCia, CodEmpresa, IdPoliza, IdetPol, IdTipoSeg, CodCobert,
             Suma_Asegurada_Local, Suma_Asegurada_Moneda, Tasa, Prima_Local,
             Prima_Moneda, IdEndoso, StsCobertura, Plancob, Cod_Asegurado,
             Deducible_Local, Deducible_Moneda, PrimaNivMoneda, PrimaNivLocal,
             SalarioMensual, VecesSalario, SumaAsegCalculada, Edad_Minima,
             Edad_Maxima, Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima,
             PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada)
      SELECT CodCia, CodEmpresa, IdPoliza, IdetPol, IdTipoSeg, CodCobert,
             SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Local,
             Prima_Moneda, IdEndoso, StsCobertura, Plancob, Cod_Asegurado,
             Deducible_Local, Deducible_Moneda, PrimaNivMoneda, PrimaNivLocal,
             SalarioMensual, VecesSalario, SumaAsegCalculada, Edad_Minima,
             Edad_Maxima, Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima,
             PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada
        FROM COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIdetPol
         AND IdEndoso      = nIdEndoso
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas en COBERTURA_ASEG para Asegurado No. ' ||
                                 TRIM(TO_CHAR(nCod_Asegurado)) || ' en Detalle de la Póliza: '||
                                 TRIM(TO_CHAR(nIdPoliza)) ||' - '||TO_CHAR(nIDetPol));
   END;
END EMITIR;

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
BEGIN
   DELETE COBERTURA_ASEG
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND IdEndoso      = nIdEndoso
      AND Cod_Asegurado = nCod_Asegurado;

   UPDATE COBERT_ACT_ASEG
      SET StsCobertura = 'SOL'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND IdEndoso      = nIdEndoso
      AND Cod_Asegurado = nCod_Asegurado;
END REVERTIR_EMISION;

PROCEDURE ELIMINAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
BEGIN
   DELETE COBERTURA_ASEG
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND IdEndoso      = nIdEndoso
      AND Cod_Asegurado = nCod_Asegurado;

   DELETE COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND IdEndoso      = nIdEndoso
      AND Cod_Asegurado = nCod_Asegurado;
END ELIMINAR;

PROCEDURE COPIAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPolOrig NUMBER, nIdPolizaDest NUMBER, nIDetPolDest NUMBER) IS
CURSOR COBASEGCERT_Q IS
   SELECT CodCia, IdPoliza, CodEmpresa, IdTipoSeg, TipoRef, NumRef, CodCobert,
          Cod_Asegurado, SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Moneda,
          Prima_Local, IdEndoso, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
          PrimaNivMoneda, PrimaNivLocal, SalarioMensual, VecesSalario, SumaAsegCalculada,
          Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima,
          PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada,
          NVL(IDRAMOREAL, OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(CodCia, CODEMPRESA, IdTipoSeg, PlanCob, CodCobert)) IDRAMOREAL
     FROM COBERT_ACT_ASEG
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;
BEGIN
   FOR D IN COBASEGCERT_Q LOOP
      INSERT INTO COBERT_ACT_ASEG
             (CodCia, IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, TipoRef, NumRef,
              CodCobert, Cod_Asegurado, SumaAseg_Local, SumaAseg_Moneda, Tasa,
              Prima_Moneda, Prima_Local, IdEndoso, PlanCob, Cod_Moneda,
              Deducible_Local, Deducible_Moneda, StsCobertura, PrimaNivMoneda, PrimaNivLocal,
              SalarioMensual, VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima,
              Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima,
              PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada,IDRAMOREAL)
      VALUES (D.CodCia, nIdPolizaDest, nIDetPolDest, D.CodEmpresa, D.IdTipoSeg, D.TipoRef, D.NumRef,
              D.CodCobert, D.Cod_Asegurado, D.SumaAseg_Local, D.SumaAseg_Moneda, D.Tasa,
              D.Prima_Moneda, D.Prima_Local, 0, D.PlanCob, D.Cod_Moneda,
              D.Deducible_Local, D.Deducible_Moneda, 'SOL', D.PrimaNivMoneda, D.PrimaNivLocal,
              D.SalarioMensual, D.VecesSalario, D.SumaAsegCalculada, D.Edad_Minima, D.Edad_Maxima,
              D.Edad_Exclusion, D.SumaAseg_Minima, D.SumaAseg_Maxima,
              D.PorcExtraPrimaDet, D.MontoExtraPrimaDet, D.SumaIngresada,D.IDRAMOREAL);
   END LOOP;
END COPIAR;

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                        nCod_Asegurado NUMBER, cCodCobert VARCHAR2) RETURN NUMBER IS
nSumaAseg_Moneda         COBERT_ACT_ASEG.SumaAseg_Moneda%TYPE;
nSumaAseg_Local          COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SumaAseg_Moneda,0), NVL(SumaAseg_Local,0)
        INTO nSumaAseg_Moneda, nSumaAseg_Local
        FROM COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND CodCobert     = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         BEGIN
            SELECT NVL(SumaAseg_Moneda,0), NVL(SumaAseg_Local,0)
              INTO nSumaAseg_Moneda, nSumaAseg_Local
              FROM COBERT_ACT
             WHERE CodCia        = nCodCia
               AND IdPoliza      = nIdPoliza
               AND IdetPol       = nIdetPol
               AND Cod_Asegurado = nCod_Asegurado
               AND CodCobert     = cCodCobert;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nSumaAseg_Moneda  := 0;
               nSumaAseg_Local   := 0;
            WHEN OTHERS THEN
               nSumaAseg_Moneda  := 0;
               nSumaAseg_Local   := 0;
         END;
   END;
   RETURN(nSumaAseg_Moneda);
END SUMA_ASEGURADA;

PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
/*CURSOR COB_Q IS
   SELECT CodCobert, Suma_Asegurada_Local, Suma_Asegurada_Moneda,
          Prima_Local, Prima_Moneda, Tasa
     FROM COBERTURA_ASEG
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND StsCobertura  = 'ANU';*/
BEGIN
/*   FOR X IN COB_Q LOOP
      UPDATE COBERT_ACT_ASEG
         SET SumaAseg_Moneda = X.Suma_Asegurada_Moneda,
             SumaAseg_Local  = X.Suma_Asegurada_Local,
             Prima_Moneda    = X.Prima_Moneda,
             Prima_Local     = X.Prima_Local,
             Tasa            = X.Tasa,
             StsCobertura    = 'EMI'
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND CodCobert     = X.CodCobert;
   END LOOP;*/

   UPDATE COBERT_ACT_ASEG
      SET StsCobertura    = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;

   UPDATE COBERTURA_ASEG
      SET StsCobertura  = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;

END REHABILITAR;

FUNCTION DEDUCIBLE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                   nCod_Asegurado NUMBER, cCodCobert VARCHAR2) RETURN NUMBER IS
nDeducible_Moneda         COBERT_ACT_ASEG.Deducible_Moneda%TYPE;
nDeducible_Local          COBERT_ACT_ASEG.Deducible_Local%TYPE;
BEGIN
   BEGIN
      SELECT NVL(Deducible_Moneda,0), NVL(Deducible_Local,0)
        INTO nDeducible_Moneda, nDeducible_Local
        FROM COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND CodCobert     = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         BEGIN
            SELECT NVL(SumaAseg_Moneda,0), NVL(SumaAseg_Local,0)
              INTO nDeducible_Moneda, nDeducible_Local
              FROM COBERT_ACT
             WHERE CodCia        = nCodCia
               AND IdPoliza      = nIdPoliza
               AND IdetPol       = nIdetPol
               AND Cod_Asegurado = nCod_Asegurado
               AND CodCobert     = cCodCobert;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nDeducible_Moneda  := 0;
               nDeducible_Local   := 0;
           WHEN OTHERS THEN
               nDeducible_Moneda  := 0;
               nDeducible_Local   := 0;
         END;
   END;
   RETURN(nDeducible_Moneda);
END DEDUCIBLE;

PROCEDURE HEREDA_COB_ENDOSO_DECL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nCod_Asegurado NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, nIdEndoso NUMBER) IS
nCantidadPagos    NUMBER;
nPrimaLocal       COBERT_ACT_ASEG.Prima_Local%TYPE;
nPrimaMoneda      COBERT_ACT_ASEG.Prima_Moneda%TYPE;
cCodPlanPago      PLAN_DE_PAGOS.CodPlanPago%TYPE;
nEdadExclusion    COBERTURAS_DE_SEGUROS.Edad_Exclusion%TYPE;
dFecIniVig        ENDOSOS.FecIniVig%TYPE;
CURSOR COB_Q IS
   SELECT TipoRef, NumRef, CodCobert, SumaAseg_Local, SumaAseg_Moneda,
          Tasa, Prima_Moneda, Prima_Local, IdEndoso, Cod_Moneda,
          Deducible_Local, Deducible_Moneda, PrimaNivMoneda, PrimaNivLocal,
          SalarioMensual, VecesSalario, SumaAsegCalculada, Edad_Minima,
          Edad_Maxima, Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima,
          PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada,
          NVL(IDRAMOREAL, OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(CodCia, CODEMPRESA, IdTipoSeg, PlanCob, CodCobert)) IDRAMOREAL
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob;
CURSOR ASEG_Q IS
   SELECT Cod_Asegurado, Estado, IdEndoso
     FROM ASEGURADO_CERTIFICADO
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND IdEndoso       = nIdEndoso
      AND Cod_Asegurado != nCod_Asegurado
      AND Estado        IN ('SOL','XRE');
BEGIN
   BEGIN
      SELECT FecIniVig
        INTO dFecIniVig
        FROM ENDOSOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza
         AND IdetPol    = nIDetPol
         AND IdEndoso   = nIdEndoso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar la Fecha de Inicio de Vigencia del Endos al Heredar Coberturas '||SQLERRM);
   END;
   FOR W IN ASEG_Q LOOP
      DELETE COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol
         AND StsCobertura IN ('SOL','XRE')
         AND Cod_Asegurado = W.Cod_Asegurado;

      BEGIN
         SELECT CodPlanPago
           INTO cCodPlanPago
           FROM DETALLE_POLIZA
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdPoliza      = nIdPoliza
            AND IdetPol       = nIDetPol;
      END;

      nCantidadPagos := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
      FOR Z IN COB_Q LOOP
         nPrimaLocal    := Z.Prima_Local / nCantidadPagos;
         nPrimaMoneda   := nPrimaLocal * OC_GENERALES.TASA_DE_CAMBIO(Z.Cod_Moneda, TRUNC(SYSDATE));

         BEGIN
            SELECT Edad_Exclusion
              INTO nEdadExclusion
              FROM COBERTURAS_DE_SEGUROS
             WHERE CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdTipoSeg     = cIdTipoSeg
               AND PlanCob       = cPlanCob
               AND CodCobert     = Z.CodCobert;
         END;
         IF OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, W.Cod_Asegurado, dFecIniVig) < NVL(nEdadExclusion,0) THEN
            BEGIN
               INSERT INTO COBERT_ACT_ASEG
                     (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                      CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                      Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                      NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                      Cod_Asegurado, PrimaNivMoneda, PrimaNivLocal, SalarioMensual,
                      VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima,
                      Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
                      MontoExtraPrimaDet, SumaIngresada, IDRAMOREAL)
               VALUES(nIdPoliza, nIDetPol, nCodEmpresa, cIdTipoSeg, nCodCia,
                      Z.CodCobert, W.Estado, Z.SumaAseg_Local, Z.SumaAseg_Moneda,
                      --Z.Prima_Local, Z.Prima_Moneda, Z.Tasa, nIdEndoso, Z.TipoRef,
                      nPrimaLocal, nPrimaMoneda, Z.Tasa, nIdEndoso, Z.TipoRef,
                      Z.NumRef, cPlanCob, Z.Cod_Moneda, Z.Deducible_Local, Z.Deducible_Moneda,
                      W.Cod_Asegurado, Z.PrimaNivMoneda, Z.PrimaNivLocal, Z.SalarioMensual,
                      Z.VecesSalario, Z.SumaAsegCalculada, Z.Edad_Minima, Z.Edad_Maxima,
                      Z.Edad_Exclusion, Z.SumaAseg_Minima, Z.SumaAseg_Maxima, Z.PorcExtraPrimaDet,
                      Z.MontoExtraPrimaDet, Z.SumaIngresada,Z.IDRAMOREAL);
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                  RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas para Detalle de la Póliza: '||
                                         TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol));
            END;
         END IF;
      END LOOP;
      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, W.Cod_Asegurado);
      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, W.Cod_Asegurado);
   END LOOP;

   IF nIdEndoso = 0 THEN
      OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
      OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
   ELSE
      OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
   END IF;
END HEREDA_COB_ENDOSO_DECL;

FUNCTION TOTAL_PRIMA_NIVELADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                              nCod_Asegurado NUMBER, nIdEndoso NUMBER) RETURN NUMBER IS

nPrimaNivMoneda         COBERT_ACT.PrimaNivMoneda%TYPE;
nPrimaNivLocal          COBERT_ACT.PrimaNivLocal%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SUM(PrimaNivMoneda),0), NVL(SUM(PrimaNivLocal),0)
        INTO nPrimaNivMoneda, nPrimaNivLocal
        FROM COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND IdEndoso      = nIdEndoso
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPrimaNivMoneda  := 0;
         nPrimaNivLocal   := 0;
   END;
   RETURN(nPrimaNivMoneda);
END TOTAL_PRIMA_NIVELADA;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE COBERTURA_ASEG
      SET StsCobertura = 'ANU'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;

   UPDATE COBERT_ACT_ASEG
      SET StsCobertura    = 'ANU'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END SUSPENDER;

PROCEDURE CARGAR_COBERTURAS_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                            cCodCobert VARCHAR2, nSumaAsegManual NUMBER, nSalarioMensual NUMBER,
                            nVecesSalario NUMBER, nEdad_Minima NUMBER, nEdad_Maxima NUMBER,
                            nEdad_Exclusion NUMBER, nSumaAseg_Minima NUMBER, nSumaAseg_Maxima NUMBER,
                            nPorcExtraPrimaDet NUMBER, nMontoExtraPrimaDet NUMBER, nSumaIngresada NUMBER,
                            nDeducibleIngresado NUMBER, nCuotaPromedio NUMBER, nPrimaPromedio NUMBER,
                            nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) IS
cCod_Moneda             COTIZACIONES.Cod_Moneda%TYPE;
nTasaCambioDet          TASAS_CAMBIO.Tasa_Cambio%TYPE;
nTasaCambio             TASAS_CAMBIO.Tasa_Cambio%TYPE;
dFecCotizacion          COTIZACIONES.FecCotizacion%TYPE ;
nSumaAsegMoneda         DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nSumaAsegLocal          DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
nCod_Asegurado          DETALLE_POLIZA.Cod_Asegurado%TYPE;
dFecIniVigCot           COTIZACIONES.FecIniVigCot%TYPE;
dFecFinVigCot           COTIZACIONES.FecFinVigCot%TYPE;
cIndAsegModelo          COTIZACIONES.IndAsegModelo%TYPE;
cIndListadoAseg         COTIZACIONES.IndListadoAseg%TYPE;
cIndCensoSubgrupo       COTIZACIONES.IndCensoSubgrupo%TYPE;
cIndExtraPrima          COTIZACIONES.IndExtraPrima%TYPE;
nPorcDescuento          COTIZACIONES.PorcDescuento%TYPE;
nPorcGtoAdmin           COTIZACIONES.PorcGtoAdmin%TYPE;
nPorcGtoAdqui           COTIZACIONES.PorcGtoAdqui%TYPE;
nPorcUtilidad           COTIZACIONES.PorcUtilidad%TYPE;
nFactorAjuste           COTIZACIONES.FactorAjuste%TYPE;
nFactorAjusteSubGrupo   COTIZACIONES.FactorAjuste%TYPE;
nMontoDeducible         COTIZACIONES.MontoDeducible%TYPE;
nFactFormulaDeduc       COTIZACIONES.FactFormulaDeduc%TYPE;
nPorcExtraPrima         COTIZACIONES_DETALLE.PorcExtraPrimaDet%TYPE;
nMontoExtraPrima        COTIZACIONES_DETALLE.MontoExtraPrimaDet%TYPE;
nHorasVig               COTIZACIONES.HorasVig%TYPE;
nDiasVig                COTIZACIONES.DiasVig%TYPE;
cTipoProrrata           COTIZACIONES.TipoProrrata%TYPE;
nDeducibleCobLocal      COTIZACIONES_COBERTURAS.DeducibleCobLocal%TYPE;
nDeducibleCobMoneda     COTIZACIONES_COBERTURAS.DeducibleCobMoneda%TYPE;
cSexo                   PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cRiesgo                 ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
cCodActividad           PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
cTipoSeg                TIPOS_DE_SEGUROS.TipoSeg%TYPE;
cTipoProceso            CONFIG_PLANTILLAS_PLANCOB.TipoProceso%TYPE;
nEdad_MinimaCob         COTIZACIONES_COBERT_MASTER.Edad_Minima%TYPE;
nEdad_MaximaCob         COTIZACIONES_COBERT_MASTER.Edad_Maxima%TYPE;
nEdad_ExclusionCob      COTIZACIONES_COBERT_MASTER.Edad_Exclusion%TYPE;
nSumaAseg_MinimaCob     COTIZACIONES_COBERT_MASTER.SumaAseg_Minima%TYPE;
nSumaAseg_MaximaCob     COTIZACIONES_COBERT_MASTER.SumaAseg_Minima%TYPE;
cCodCotizador           COTIZACIONES.CodCotizador%TYPE;
cRiesgoTarifa           COTIZACIONES_DETALLE.RiesgoTarifa%TYPE;
nIdTarifa               TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
nEdad                   NUMBER(5);
nExiste                 NUMBER;
nExisteAgen             NUMBER;
nTasa                   NUMBER;
nValor                  NUMBER;
nValorMoneda            NUMBER;
nCantAseg               NUMBER;
cTarifaDinamica         VARCHAR2(1) := 'N';
nIdEndoso               COBERT_ACT_ASEG.IdEndoso%TYPE;
nPorcGtoAdminTar        TARIFA_SEXO_EDAD_RIESGO.PorcGtoAdmin%TYPE;

CURSOR COB_Q IS
   SELECT CodCobert, Porc_Tasa, TipoTasa, Prima_Cobert,
          SumaAsegurada, Cod_Moneda, CodTarifa, Edad_Minima,
          Edad_Maxima, Edad_Exclusion, MontoDeducible, PorcenDeducible,
          SumaAsegMinima, SumaAsegMaxima, OrdenImpresion,
          NVL(IDRAMOREAL, OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(CodCia, CODEMPRESA, IdTipoSeg, PlanCob, CodCobert)) IDRAMOREAL
     FROM COBERTURAS_DE_SEGUROS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg
      AND PlanCob      = cPlanCob
      AND CodCobert    = NVL(cCodCobert, CodCobert)
      AND StsCobertura = 'ACT';
BEGIN
   BEGIN
      SELECT Cod_Moneda, FecCotizacion, FecIniVigCot, FecFinVigCot, HorasVig, DiasVig,
             NVL(IndAsegModelo,'N'), NVL(IndListadoAseg,'N'), NVL(IndCensoSubgrupo,'N'),
             PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste,
             MontoDeducible, FactFormulaDeduc, NVL(IndExtraPrima,'N'), TipoProrrata,
             CodCotizador
        INTO cCod_Moneda, dFecCotizacion, dFecIniVigCot, dFecFinVigCot, nHorasVig, nDiasVig,
             cIndAsegModelo, cIndListadoAseg, cIndCensoSubgrupo,
             nPorcDescuento, nPorcGtoAdmin, nPorcGtoAdqui, nPorcUtilidad, nFactorAjuste,
             nMontoDeducible, nFactFormulaDeduc, cIndExtraPrima, cTipoProrrata,
             cCodCotizador
        FROM COTIZACIONES
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Cotización No. : ' || TRIM(TO_CHAR(nIdCotizacion)));
   END;

   IF NVL(nDeducibleIngresado,0) != 0 THEN
      nMontoDeducible := NVL(nDeducibleIngresado,0);
   END IF;

   IF GT_COTIZADOR_CONFIG.TIPO_DE_COTIZADOR(nCodCia, nCodEmpresa, cCodCotizador) IN ('API','APC') THEN
      BEGIN
         SELECT RiesgoTarifa, HorasVig, DiasVig,
                FactorAjuste, FactFormulaDeduc
           INTO cRiesgoTarifa, nHorasVig, nDiasVig,
                nFactorAjusteSubGrupo, nFactFormulaDeduc
           FROM COTIZACIONES_DETALLE
          WHERE CodCia         = nCodCia
            AND CodEmpresa     = nCodEmpresa
            AND IdCotizacion   = nIdCotizacion
            AND IDetCotizacion = nIDetCotizacion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO Existe Detalle No. ' || nIDetCotizacion ||
                                    ' en Cotización No. : ' || TRIM(TO_CHAR(nIdCotizacion)));
      END;
   ELSE
      cRiesgoTarifa := NULL;
   END IF;

   nTasaCambioDet := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, dFecCotizacion);
   nIdTarifa      := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVigCot);


   nEdad            := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado, dFecIniVigCot);--.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIdAsegurado, dFecIniVigCot);
   cSexo            := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado);
   nCantAseg        := 1;
  -- cSexo            := 'U';
   nPorcExtraPrima  := NVL(nPorcExtraPrimaDet,0);
   nMontoExtraPrima := NVL(nMontoExtraPrimaDet,0);

   FOR X IN COB_Q  LOOP
      nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(X.Cod_Moneda, dFecCotizacion);
      BEGIN
         SELECT TipoSeg
           INTO cTipoSeg
           FROM TIPOS_DE_SEGUROS
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdTipoSeg  = cIdTipoSeg;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cTipoSeg := 'N';
      END;

      IF (nEdad BETWEEN X.Edad_Minima AND X.Edad_Maxima AND nEdad_Minima = X.Edad_Minima AND nEdad_Maxima = X.Edad_Maxima) OR
          NVL(cTipoSeg,'N') != 'P' OR
         (nEdad_Minima != X.Edad_Minima OR nEdad_Maxima != X.Edad_Maxima) THEN
         nEdad_MinimaCob     := NVL(nEdad_Minima,0);
         nEdad_MaximaCob     := NVL(nEdad_Maxima,0);
         nEdad_ExclusionCob  := NVL(nEdad_Exclusion,0);
         nSumaAseg_MinimaCob := NVL(nSumaAseg_Minima,0);
         nSumaAseg_MaximaCob := NVL(nSumaAseg_Maxima,0);

         IF cCodCobert IS NULL THEN
            IF NVL(nEdad_MinimaCob,0) = 0 THEN
               nEdad_MinimaCob := X.Edad_Minima;
            END IF;
            IF NVL(nEdad_MaximaCob,0) = 0 THEN
               nEdad_MaximaCob := X.Edad_Maxima;
            END IF;
            IF NVL(nEdad_ExclusionCob,0) = 0 THEN
               nEdad_ExclusionCob := X.Edad_Exclusion;
            END IF;
            IF NVL(nSumaAseg_MinimaCob,0) = 0 THEN
               nSumaAseg_MinimaCob := X.SumaAsegMinima;
            END IF;
            IF NVL(nSumaAseg_MaximaCob,0) = 0 THEN
               nSumaAseg_MaximaCob := X.SumaAsegMaxima;
            END IF;
         END IF;
         IF X.CodTarifa IS NULL THEN
            cTarifaDinamica := 'N'; -- EC - 20/01/2017
            nSumaAsegMoneda := 0;
            nSumaAsegLocal  := 0;

            -- Si viene Suma Asegurada de Cotización se Mantiene Sustituye la Configuración
            IF NVL(nSumaAsegManual,0) = 0 THEN
               nSumaAsegMoneda := X.SumaAsegurada * NVL(nCantAseg,0);
            ELSE
               nSumaAsegMoneda := NVL(nSumaAsegManual,0) * NVL(nCantAseg,0);
            END IF;
            IF X.TipoTasa = 'C' THEN
               nTasa := X.Porc_Tasa/100;
            ELSIF X.TipoTasa = 'M' THEN
               nTasa := X.Porc_Tasa/1000;
            ELSE
               nTasa := X.Porc_Tasa;
            END IF;
            IF NVL(nTasa,0) =  0 THEN
               nValorMoneda := X.Prima_Cobert;
               nValor       := X.Prima_Cobert * nTasaCambio;
               IF NVL(nSumaAsegMoneda,0) != 0 THEN
                  nTasa        := NVL(nValorMoneda,0) / nSumaAsegMoneda;
               END IF;
            ELSE
               nValorMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasa,0);
               nValor       := (NVL(nSumaAsegMoneda,0) * NVL(nTasa,0)) * nTasaCambio;
            END IF;
            nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambio;
         ELSE
            IF OC_TARIFA_DINAMICA.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecCotizacion) = 0 THEN
               cTarifaDinamica := 'N';
               cCodActividad   := NULL; --OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
               IF cRiesgoTarifa IS NULL THEN
                  cRiesgo      := 'NA'; --OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
               ELSE
                  cRiesgo      := cRiesgoTarifa;
               END IF;

               IF NVL(nSumaAsegManual,0) = 0 THEN
                  nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                               X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
               ELSE
                  nSumaAsegMoneda := NVL(nSumaAsegManual,0);
               END IF;
               nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                         X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
               nPorcGtoAdminTar := OC_TARIFA_SEXO_EDAD_RIESGO.PORCEN_GASTOS_ADMIN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
               IF NVL(nTasa,0) > 0 THEN
                  nTasa := NVL(nTasa,0) * (1 - (NVL(nPorcDescuento,0) / 100));

                  nTasa := NVL(nTasa,0) * (1 + (NVL(nPorcExtraPrima,0) / 100));

                  nTasa := NVL(nTasa,0) + NVL(nMontoExtraPrima,0);

                  nTasa := NVL(nTasa,0) * NVL(nFactorAjuste,0);

                  IF NVL(nFactorAjusteSubGrupo,0) > 0 THEN
                     nTasa := NVL(nTasa,0) * NVL(nFactorAjusteSubGrupo,0);
                  END IF;

                  -- Factor Deducible ??
                  nTasa := (1-(NVL(nFactFormulaDeduc,0) * NVL(nMontoDeducible,0))) * NVL(nTasa,0);

                  IF NVL(nHorasVig,0) > 0 THEN
                     nTasa := NVL(nTasa,0) * (NVL(nHorasVig,0) / 24);
                  END IF;

                  IF GT_COTIZADOR_CONFIG.TIPO_DE_COTIZADOR(nCodCia, nCodEmpresa, cCodCotizador) IN ('API','APC') THEN
                     IF NVL(nDiasVig,0) > 0 THEN
                        nTasa := NVL(nTasa,0) * (NVL(nDiasVig,0) / OC_GENERALES.DIAS_ANIO(dFecIniVigCot, dFecFinVigCot));
                     END IF;
                  ELSE
                     IF cTipoProrrata = 'D365' THEN
                        nTasa := (NVL(nTasa,0) / 365) * (dFecFinVigCot - dFecIniVigCot);
                     END IF;
                  END IF;

                  --nTasa := NVL(nTasa,0) / (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) - (NVL(nPorcGtoAdmin,0) / 100));
                  nTasa := NVL(nTasa,0) / (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) -
                           (NVL(nPorcGtoAdmin,0) / 100) -  (NVL(nPorcGtoAdminTar,0) / 100));
               END IF;

               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  nSumaAsegMoneda  := NVL(X.SumaAsegurada,0);
               END IF;

               nSumaAsegMoneda := NVL(nSumaAsegMoneda,0) * NVL(nCantAseg,0);
               nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa, NULL); --nSumaAsegMoneda);
               IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                  nValorMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasa,0) / 1000;
               END IF;
               nValor    := NVL(nValorMoneda,0) * nTasaCambio;
               IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                  nTasa        := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
               END IF;
            END IF;
         END IF;
         IF X.Cod_Moneda != cCod_Moneda THEN
            nTasaCambioDet  := OC_GENERALES.TASA_DE_CAMBIO(X.Cod_Moneda, dFecCotizacion);
            nSumaAsegMoneda := NVL(nSumaAsegMoneda,0) / nTasaCambioDet;
            nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambioDet;
            nValorMoneda    := NVL(nValorMoneda,0) / nTasaCambioDet;
            nValor          := NVL(nValorMoneda,0) * nTasaCambioDet;
            nTasaCambio     := nTasaCambioDet;
         ELSE
            nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambio;
         END IF;

         IF NVL(nDeducibleIngresado,0) != 0 THEN
         --IF NVL(X.MontoDeducible,0) != 0 THEN
            nDeducibleCobMoneda := NVL(nDeducibleIngresado,0);
            nDeducibleCobLocal  := NVL(nDeducibleCobMoneda,0) * nTasaCambio;
         ELSE
            nDeducibleCobMoneda := NVL(nSumaAsegMoneda,0) * NVL(X.PorcenDeducible,0) / 100;
            nDeducibleCobLocal  := NVL(nDeducibleCobMoneda,0) * nTasaCambio;
         END IF;
         BEGIN
            SELECT NVL(MAX(IdEndoso),0)
              INTO nIdEndoso
              FROM ASEGURADO_CERTIFICADO
             WHERE CodCia        = nCodCia
               AND IdPoliza      = nIdPoliza
               AND IDetPol       = nIDetPol
               AND Cod_Asegurado = nCodAsegurado;
         END;
         IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nValorMoneda,0) != 0 THEN
            BEGIN
               INSERT INTO COBERT_ACT_ASEG
                     (Codcia, Codempresa, Idpoliza, Idetpol, Idtiposeg, Tiporef,
                      Numref, Codcobert, Cod_Asegurado, Sumaaseg_Local, Sumaaseg_Moneda,
                      Tasa, Prima_Moneda, Prima_Local, Idendoso, Stscobertura, Plancob,
                      Cod_Moneda, Deducible_Local, Deducible_Moneda, Sumaasegorigen,
                      Salariomensual, Vecessalario, Sumaasegcalculada, Edad_Minima,
                      Edad_Maxima, Edad_Exclusion, Sumaaseg_Minima, Sumaaseg_Maxima,
                      Porcextraprimadet, Montoextraprimadet, Sumaingresada, Primanivmoneda,
                      Primanivlocal,IDRAMOREAL)
               VALUES(nCodCia, nCodEmpresa, nIdpoliza, nIdetpol, cIdTipoSeg, 'POLI',
                      nIdpoliza, X.CodCobert, nCodAsegurado, NVL(nSumaAsegLocal,0), NVL(nSumaAsegMoneda,0),
                      nTasa, NVL(nValorMoneda,0), NVL(nValor,0), nIdEndoso, 'SOL', cPlanCob,
                      X.Cod_Moneda, NVL(nDeducibleCobLocal,0), NVL(nDeducibleCobMoneda,0), 0,
                      NVL(nSalarioMensual,0), NVL(nVecesSalario,0), NVL(nSumaAsegManual,0),
                      nEdad_MinimaCob, nEdad_MaximaCob, nEdad_ExclusionCob, nSumaAseg_MinimaCob, nSumaAseg_MaximaCob,
                      nPorcExtraPrima, nMontoExtraPrima, nSumaIngresada, 0,
                      0,X.IDRAMOREAL);
            END;
         END IF;
      END IF;
   END LOOP;
END CARGAR_COBERTURAS_COTIZACION;

END OC_COBERT_ACT_ASEG;

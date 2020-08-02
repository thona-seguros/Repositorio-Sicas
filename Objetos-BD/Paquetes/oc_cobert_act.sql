--
-- OC_COBERT_ACT  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   PLAN_COBERTURAS (Table)
--   POLIZAS (Table)
--   DETALLE_POLIZA (Table)
--   TARIFA_CONTROL_VIGENCIAS (Table)
--   TARIFA_SEXO_EDAD_RIESGO (Table)
--   GT_TARIFA_CONTROL_VIGENCIAS (Package)
--   OC_DATOS_PART_EMISION (Package)
--   ACTIVIDADES_ECONOMICAS (Table)
--   ASEGURADO (Table)
--   TIPOS_DE_SEGUROS (Table)
--   CONFIG_PLANTILLAS_PLANCOB (Table)
--   COBERTURAS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   OC_TARIFA_DINAMICA (Package)
--   OC_TARIFA_DINAMICA_DET (Package)
--   OC_TARIFA_SEXO_EDAD_RIESGO (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_ACTIVIDADES_ECONOMICAS (Package)
--   OC_ASEGURADO (Package)
--   OC_CONFIG_PLANTILLAS_PLANCOB (Package)
--   OC_GENERALES (Package)
--   OC_POLIZAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_COBERT_ACT IS

PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nTasaCambio NUMBER, cCodCobert VARCHAR2, nSumaAsegManual NUMBER, 
                            nSalarioMensual NUMBER,  nVecesSalario NUMBER, nEdad_Minima NUMBER, 
                            nEdad_Maxima NUMBER,  nEdad_Exclusion NUMBER, nSumaAseg_Minima NUMBER, 
                            nSumaAseg_Maxima NUMBER,  nPorcExtraPrima NUMBER, nMontoExtraPrima NUMBER, 
                            nSumaIngresada NUMBER);
FUNCTION EXISTE_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2;
FUNCTION CALCULO_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nTasaCambio NUMBER,cCodCobert VARCHAR2,cTipo VARCHAR2) RETURN NUMBER;
FUNCTION VALIDA_EDAD_COBERTURA(nCod_Asegurado NUMBER, nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                               cPlanCob VARCHAR2, cCobCobert VARCHAR2) RETURN VARCHAR2;

FUNCTION CAMBIO_POR_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                        cCodCobert VARCHAR2) RETURN NUMBER;

PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

FUNCTION DEDUCIBLE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                   cCodCobert VARCHAR2) RETURN NUMBER;

FUNCTION TOTAL_PRIMA_NIVELADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                              nCod_Asegurado NUMBER, nIdEndoso NUMBER) RETURN NUMBER;

END OC_COBERT_ACT;
/

--
-- OC_COBERT_ACT  (Package Body) 
--
--  Dependencies: 
--   OC_COBERT_ACT (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_COBERT_ACT IS
PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nTasaCambio NUMBER, cCodCobert VARCHAR2, nSumaAsegManual NUMBER,
                            nSalarioMensual NUMBER,  nVecesSalario NUMBER, nEdad_Minima NUMBER, 
                            nEdad_Maxima NUMBER,  nEdad_Exclusion NUMBER, nSumaAseg_Minima NUMBER, 
                            nSumaAseg_Maxima NUMBER,  nPorcExtraPrima NUMBER, nMontoExtraPrima NUMBER, 
                            nSumaIngresada NUMBER) IS
    nCod_Moneda             POLIZAS.Cod_Moneda%TYPE;
    nTasaCambioDet          DETALLE_POLIZA.Tasa_Cambio%TYPE;
    dFecEmision             POLIZAS.FecEmision%TYPE ;
    nSumaAsegMoneda         DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
    nSumaAsegLocal          DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
    nCod_Asegurado          DETALLE_POLIZA.Cod_Asegurado%TYPE;
    cHabitoTarifa           DETALLE_POLIZA.HABITOTARIFA%TYPE;
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
    nDeducibleCobLocal      COBERT_ACT.Deducible_Local%TYPE;
    nDeducibleCobMoneda     COBERT_ACT.Deducible_Moneda%TYPE;
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
              DECODE(TipoTasa,'C',100,DECODE(TipoTasa,'M',1000,1)) FactorTasa
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
        FROM COBERT_ACT
       WHERE IdPoliza          = nIdPoliza
         AND IDetPol           = nIDetPol
         AND StsCobertura NOT IN ('SOL','XRE')
         AND CodCobert         = NVL(cCodCobert, CodCobert);
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nExiste := 0;
       WHEN TOO_MANY_ROWS THEN
          nExiste := 1;
   END;

   IF nExiste = 0 THEN
      DELETE COBERT_ACT
       WHERE IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND StsCobertura IN ('SOL','XRE')
         AND CodCobert     = NVL(cCodCobert, CodCobert);

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

      BEGIN
         SELECT D.Cod_Asegurado, D.FecIniVig, D.FecFinVig, D.HABITOTARIFA
           INTO nCod_Asegurado, dFecIniVig, dFecFinVig, cHABITOTARIFA
           FROM DETALLE_POLIZA D
          WHERE D.CodCia         = nCodCia
            AND D.IdPoliza       = nIdPoliza
            AND D.IDetPol        = nIDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No Existe Detalle de Póliza para Generar Coberturas');
      END;

      nEdad         := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado, dFecIniVig);

      IF nNumRenov = 0 THEN
         cStsCobertura     := 'SOL';
         nEdadEmision      := nEdad;
      ELSE
         cStsCobertura     := 'XRE';
         nIdPolizaEmision  := OC_POLIZAS.POLIZA_INICIAL_RENOVACION(nCodCia, nCodEmpresa, nIdPoliza);
         dFecIniVigEmision := OC_POLIZAS.INICIO_VIGENCIA(nCodCia, nCodEmpresa, nIdPolizaEmision);
         nEdadEmision      := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado, dFecIniVigEmision);
      END IF;


      nIdTarifa     := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig);

      FOR X IN COB_Q  LOOP
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
                  nTasa := X.Porc_Tasa / X.FactorTasa;
               ELSIF X.TipoTasa = 'M' THEN
                  nTasa := X.Porc_Tasa / X.FactorTasa;
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
                     cTarifaDinamica := 'N'; -- EC - 20/01/2017
                     cSexo           := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cCodActividad   := OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cRiesgo         := OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
                     nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);
                     nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                               X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);
                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        IF NVL(nSumaAsegManual,0) != 0 THEN
                           nSumaAsegMoneda := NVL(nSumaAsegManual,0);
                        ELSE
                           nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
                        END IF;
                     END IF;

                     IF NVL(nSumaAsegManual,0) != 0 THEN
                        nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                   X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa,cHabitoTarifa);
                     ELSE
                        nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                   X.CodCobert, nEdad, cSexo, cRiesgo, nSumaAsegMoneda, nIdTarifa,cHabitoTarifa);
                     END IF;

                     IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                        nValorMoneda := nSumaAsegMoneda * NVL(nTasa,0);
                     END IF;
                     nValor    := NVL(nValorMoneda,0) * nTasaCambio;
                     IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                        nTasa        := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
                     END IF;
                  ELSE
                     cTarifaDinamica   := 'N';
                     cSexo             := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cCodActividad     := NULL; --OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cRiesgo           := 'NA'; --OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
                     --nPorcExtraPrima   := OC_PLAN_COBERTURAS.PORCENTAJE_EXTRAPRIMA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);
                     --nMontoExtraPrima  := OC_PLAN_COBERTURAS.MONTO_EXTRAPRIMA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);
                   
                     nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);

                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        IF NVL(nSumaAsegManual,0) != 0 THEN
                           nSumaAsegMoneda := NVL(nSumaAsegManual,0);
                        ELSE
                           nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
                        END IF;
                     END IF;

                     nTasa            := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);

                     nTasaNivelada    := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_NIVELADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdadEmision, cSexo, cRiesgo, nIdTarifa, cHabitoTarifa);

                     nPorcGtoAdminTar := OC_TARIFA_SEXO_EDAD_RIESGO.PORCEN_GASTOS_ADMIN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                        X.CodCobert, nEdadEmision, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);

                     IF NVL(nTasa,0) > 0 THEN
                        nTasa := NVL(nTasa,0) * (1 - (NVL(nPorcDescuento,0) / 100));
    
                        nTasa := NVL(nTasa,0) * (1 + (NVL(nPorcExtraPrima,0) / 100));
                      
                        nTasa := NVL(nTasa,0) + NVL(nMontoExtraPrima,0);
                      
                        IF NVL(nFactorAjuste,0) > 0 THEN  
                            nTasa := NVL(nTasa,0) * NVL(nFactorAjuste,0);
                        END IF;
    
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

                        /*IF NVL(nDiasVig,0) > 0 THEN
                           nTasa := NVL(nTasa,0) * (NVL(nDiasVig,0) / OC_GENERALES.DIAS_ANIO(dFecIniVig, dFecFinVig));
                        END IF;*/
                      
                        nTasa := NVL(nTasa,0) / (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) - 
                                 (NVL(nPorcGtoAdmin,0) / 100)  -  (NVL(nPorcGtoAdminTar,0) / 100));
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
                                                                                X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa,cHabitoTarifa); --nSumaAsegMoneda);
                     IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                        nValorMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasa,0) / X.FactorTasa;
                     END IF;
                     
                     nValor    := NVL(nValorMoneda,0) * nTasaCambio;
                     
                     IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                        nTasa        := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
                     END IF;

                     IF nTasaNivelada > 0 THEN
                         nPrimaNivMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasaNivelada,0) / X.FactorTasa;                         
                         nPrimaNivMoneda := NVL(nPrimaNivMoneda,0) - NVL(nValorMoneda,0);
                         
                     --    IF SIGN(nPrimaNivMoneda) = -1 THEN
                     --       nPrimaNivMoneda := nPrimaNivMoneda * -1;
                     --    END IF;
                         
                         nPrimaNivLocal  := NVL(nPrimaNivMoneda,0) * nTasaCambio;
                     END IF;

                  END IF;
               ELSE
                  cTipoProceso := OC_CONFIG_PLANTILLAS_PLANCOB.TIPO_PROCESO(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, 'POLDET');
                  IF OC_DATOS_PART_EMISION.EXISTE_DATO_PARTICULAR(nCodCia, nIdPoliza, nIDetPol) = 'S' THEN
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
               nSumaAsegMoneda := NVL(nSumaAsegMoneda,0) / nTasaCambioDet;
               nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambioDet;
               nValorMoneda    := NVL(nValorMoneda,0) / nTasaCambioDet;
               nValor          := NVL(nValorMoneda,0) * nTasaCambioDet;
            ELSE
               nSumaAsegLocal  := nSumaAsegMoneda * nTasaCambio;
            END IF;

            IF NVL(X.MontoDeducible,0) != 0 THEN
               nDeducibleCobMoneda := NVL(X.MontoDeducible,0);
               nDeducibleCobLocal  := NVL(X.MontoDeducible,0) * nTasaCambio;
            ELSE
               nDeducibleCobMoneda := NVL(nSumaAsegMoneda,0) * NVL(X.PorcenDeducible,0) / 100;
               nDeducibleCobLocal  := NVL(nDeducibleCobMoneda,0) * nTasaCambio;
            END IF;

            IF (cTarifaDinamica = 'S' AND NVL(nSumaAsegMoneda,0) != 0 AND NVL(nValorMoneda,0) != 0) OR
               (cTarifaDinamica = 'N' AND NVL(nSumaAsegMoneda,0) != 0) THEN
               BEGIN
                  INSERT INTO COBERT_ACT
                        (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                         CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                         Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                         NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                         Cod_Asegurado, PrimaNivMoneda, PrimaNivLocal, SalarioMensual,
                         VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima, 
                         Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
                         MontoExtraPrimaDet, SumaIngresada)
                  VALUES(nIdPoliza, nIDetPol, nCodEmpresa, cIdTipoSeg, nCodCia,
                         X.CodCobert, cStsCobertura, nSumaAsegLocal, nSumaAsegMoneda,
                         nValor, nValorMoneda, nTasa, 0, 'POLI',
                         nIdPoliza, cPlanCob, nCod_Moneda, nDeducibleCobLocal, nDeducibleCobMoneda,
                         nCod_Asegurado, nPrimaNivMoneda, nPrimaNivLocal, NVL(nSalarioMensual,0), 
                         NVL(nVecesSalario,0), NVL(nSumaAsegManual,0), nEdad_MinimaCob, 
                         nEdad_MaximaCob, nEdad_ExclusionCob, nSumaAseg_MinimaCob, 
                         nSumaAseg_MaximaCob, nPorcExtraPrima, nMontoExtraPrima, nSumaIngresada);
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

FUNCTION EXISTE_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                          cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COBERT_ACT
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND idpoliza   = nIdPoliza
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND IDetPol    = nIDetPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_COBERTURA;

FUNCTION CALCULO_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                           cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                           nTasaCambio NUMBER, cCodCobert VARCHAR2, cTipo VARCHAR2) RETURN NUMBER IS
nCod_Moneda             POLIZAS.Cod_Moneda%TYPE;
nTasaCambioDet          DETALLE_POLIZA.Tasa_Cambio%TYPE;
dFecEmision             POLIZAS.FecEmision%TYPE ;
nSumaAsegMoneda         DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nSumaAsegLocal          DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
nSumaAsegManual         DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
nCod_Asegurado          DETALLE_POLIZA.Cod_Asegurado%TYPE;
cHabitoTarifa           DETALLE_POLIZA.HabitoTarifa%TYPE;
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
nPorcExtraPrima         PLAN_COBERTURAS.PorcExtraPrima%TYPE;
nMontoExtraPrima        PLAN_COBERTURAS.MontoExtraPrima%TYPE;
nHorasVig               POLIZAS.HorasVig%TYPE;
nDiasVig                POLIZAS.DiasVig%TYPE;
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
      SELECT NVL(PorcExtraPrimaDet,0), NVL(MontoExtraPrimaDet,0), NVL(SUMAASEG_MONEDA, 0) + NVL(SumaAsegCalculada,0)
        INTO nPorcExtraPrima, nMontoExtraPrima, nSumaAsegManual
        FROM COBERT_ACT
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodCobert     = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No Existe Cobertura ' || cCodCobert);
   END;

   nIdTarifa     := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig);

   FOR X IN COB_Q  LOOP
      BEGIN
         SELECT D.Cod_Asegurado, TRUNC(D.FecIniVig), TRUNC(D.FecFinVig), HabitoTarifa
           INTO nCod_Asegurado, dFecIniVig, dFecFinVig, cHabitoTarifa
           FROM DETALLE_POLIZA D
          WHERE D.IdPoliza       = nIdPoliza
            AND D.IDetPol        = nIDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No Existe Detalle de Póliza para Generar Coberturas');
      END;

      nEdad  := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado, dFecIniVig);

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
                                                                            X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);
               nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                         X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);
               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  nSumaAsegMoneda  := X.SumaAsegurada;
               END IF;

               nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, nSumaAsegMoneda, nIdTarifa,cHabitoTarifa);
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
                                                                            X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);

               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  IF NVL(nSumaAsegManual,0) != 0 THEN
                     nSumaAsegMoneda := NVL(nSumaAsegManual,0);
                  ELSE
                     nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
                  END IF;
               END IF;

               nTasa            := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);
               nTasaNivelada    := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_NIVELADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                            X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);

               nPorcGtoAdminTar := OC_TARIFA_SEXO_EDAD_RIESGO.PORCEN_GASTOS_ADMIN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa,cHabitoTarifa);

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
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa,cHabitoTarifa); --nSumaAsegMoneda);
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

FUNCTION VALIDA_EDAD_COBERTURA(nCod_Asegurado NUMBER,nCodCia NUMBER,nCodEmpresa NUMBER,cIdTipoSeg VARCHAR2,cPlanCob VARCHAR2,cCobCobert VARCHAR2) RETURN VARCHAR2  IS

cExiste    VARCHAR2(1);
nDummy     NUMBER;
nEdad      NUMBER(5);
cValido    VARCHAR2(1);
dFecNacimiento  DATE;
BEGIN
   BEGIN
      SELECT TRUNC(FecNacimiento)
        INTO dFecNacimiento
        FROM PERSONA_NATURAL_JURIDICA  P
       WHERE EXISTS (SELECT 1
                       FROM ASEGURADO A
                      WHERE P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
                        AND  P.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                        AND A.CodCia        = nCodCia
                        AND A.CodEmpresa    = nCodEmpresa
                        AND A.COD_ASEGURADO = nCod_Asegurado);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Debe agregar la Fecha de Nacimiento al Asegurado');

   END;
   nEdad := FLOOR((TRUNC(SYSDATE) - TRUNC(dFecNacimiento)) / 365.25);
   BEGIN
      SELECT 'S'
        INTO cValido
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND CodCobert  = cCobCobert
         AND nEdad BETWEEN Edad_Minima AND Edad_Maxima;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cValido := 'N';
      WHEN TOO_MANY_ROWS THEN
         cValido := 'S';
   END;
   RETURN (cValido);
END VALIDA_EDAD_COBERTURA;

FUNCTION CAMBIO_POR_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cIndCambioSami  COBERT_ACT.IndCambioSami%TYPE;
BEGIN
   BEGIN
      SELECT 'S'
        INTO cIndCambioSami
        FROM COBERT_ACT
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND IdTipoSeg     = cIdTipoSeg
         AND PlanCob       = cPlanCob
         AND IDetPol       = nIDetPol
         AND IndCambioSami = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCambioSami := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndCambioSami := 'S';
   END;
 RETURN(cIndCambioSami);
END CAMBIO_POR_SAMI;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE COBERTURAS
      SET StsCobertura = 'ANU'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol;

   UPDATE COBERT_ACT
      SET StsCobertura    = 'ANU'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol;
END ANULAR;

PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE COBERT_ACT
      SET StsCobertura = 'CEX'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol;
END EXCLUIR;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
/*CURSOR COB IS
 SELECT CodCia, CodEmpresa, IdPoliza, IdetPol, IdTipoSeg, CodCobert,
          SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Local,
          Prima_Moneda, IdEndoso, StsCobertura, Plancob, Deducible_Local,
          Deducible_Moneda
     FROM COBERT_ACT
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdEndoso      = nIdEndoso
      AND IdetPol       = nIDetPol;
*/

BEGIN
   UPDATE COBERT_ACT
      SET StsCobertura = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdEndoso      = nIdEndoso
      AND IDetPol       = nIDetPol;

   INSERT INTO COBERTURAS
         (CodCia, CodEmpresa, IdPoliza, IDetPol, IdTipoSeg, CodCobert, 
          Suma_Asegurada_Local, Suma_Asegurada_Moneda, Tasa, Prima_Local,
          Prima_Moneda, IdEndoso, StsCobertura, Plancob, Deducible_Local,
          Deducible_Moneda, PrimaNivMoneda, PrimaNivLocal, SalarioMensual, 
          VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima, 
          Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
          MontoExtraPrimaDet, SumaIngresada)
   SELECT CodCia, CodEmpresa, IdPoliza, IDetPol, IdTipoSeg, CodCobert,
          SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Local,
          Prima_Moneda, IdEndoso, StsCobertura, Plancob, Deducible_Local,
          Deducible_Moneda, PrimaNivMoneda, PrimaNivLocal, SalarioMensual, 
          VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima, 
          Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
          MontoExtraPrimaDet, SumaIngresada
     FROM COBERT_ACT
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdEndoso      = nIdEndoso
      AND IDetPol       = nIDetPol;
END EMITIR;

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
BEGIN
   DELETE COBERTURAS
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdEndoso      = nIdEndoso
      AND IDetPol       = nIDetPol;

   UPDATE COBERT_ACT
      SET StsCobertura = 'SOL'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdEndoso      = nIdEndoso
      AND IDetPol       = nIDetPol;
END REVERTIR_EMISION;

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                        cCodCobert VARCHAR2) RETURN NUMBER IS
nSumaAseg_Moneda         COBERT_ACT_ASEG.SumaAseg_Moneda%TYPE;
nSumaAseg_Local          COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SumaAseg_Moneda,0), NVL(SumaAseg_Local,0)
        INTO nSumaAseg_Moneda, nSumaAseg_Local
        FROM COBERT_ACT
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodCobert     = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nSumaAseg_Moneda  := 0;
         nSumaAseg_Local   := 0;
   END;
   RETURN(nSumaAseg_Moneda);
END SUMA_ASEGURADA;

PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE COBERT_ACT
      SET StsCobertura    = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND StsCobertura  = 'ANU';

   UPDATE COBERTURAS
      SET StsCobertura  = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND StsCobertura  = 'ANU';
END REHABILITAR;

FUNCTION DEDUCIBLE(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                        cCodCobert VARCHAR2) RETURN NUMBER IS
nDeducible_Moneda         COBERT_ACT.Deducible_Moneda%TYPE;
nDeducible_Local          COBERT_ACT.Deducible_Local%TYPE;
BEGIN
   BEGIN
      SELECT NVL(Deducible_Moneda,0), NVL(Deducible_Local,0)
        INTO nDeducible_Moneda, nDeducible_Local
        FROM COBERT_ACT
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodCobert     = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDeducible_Moneda  := 0;
         nDeducible_Local   := 0;
   END;
   RETURN(nDeducible_Moneda);
END DEDUCIBLE;

FUNCTION TOTAL_PRIMA_NIVELADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                              nCod_Asegurado NUMBER, nIdEndoso NUMBER) RETURN NUMBER IS

nPrimaNivMoneda         COBERT_ACT.PrimaNivMoneda%TYPE;
nPrimaNivLocal          COBERT_ACT.PrimaNivLocal%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SUM(PrimaNivMoneda),0), NVL(SUM(PrimaNivLocal),0)
        INTO nPrimaNivMoneda, nPrimaNivLocal
        FROM COBERT_ACT
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND IdEndoso      = nIdEndoso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPrimaNivMoneda  := 0;
         nPrimaNivLocal   := 0;
   END;
   RETURN(nPrimaNivMoneda);
END TOTAL_PRIMA_NIVELADA;

END OC_COBERT_ACT;
/

--
-- GT_COTIZACIONES_COBERT_MASTER  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_POLIZA (Table)
--   TARIFA_CONTROL_VIGENCIAS (Table)
--   TASAS_CAMBIO (Table)
--   GT_TARIFA_CONTROL_VIGENCIAS (Package)
--   ACTIVIDADES_ECONOMICAS (Table)
--   TIPOS_DE_SEGUROS (Table)
--   CONFIG_PLANTILLAS_PLANCOB (Table)
--   COTIZACIONES (Table)
--   COTIZACIONES_COBERTURAS (Table)
--   COTIZACIONES_COBERT_MASTER (Table)
--   COTIZACIONES_DETALLE (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   OC_TARIFA_DINAMICA (Package)
--   OC_TARIFA_SEXO_EDAD_RIESGO (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   GT_COTIZADOR_CONFIG (Package)
--   OC_GENERALES (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_COTIZACIONES_COBERT_MASTER IS

  FUNCTION EXISTEN_COBERTURAS_MASTER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN VARCHAR2;
  PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                              cPlanCob VARCHAR2, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                              nIdAsegurado NUMBER, cCodCobert VARCHAR2, nSumaAsegManual NUMBER,
                              nSalarioMensual NUMBER, nVecesSalario NUMBER, nEdad_Minima NUMBER,
                              nEdad_Maxima NUMBER, nEdad_Exclusion NUMBER, nSumaAseg_Minima NUMBER,
                              nSumaAseg_Maxima NUMBER, nPorcExtraPrimaDet NUMBER, nMontoExtraPrimaDet NUMBER,
                              nSumaIngresada NUMBER, nDeducibleIngresado NUMBER, nCuotaPromedio NUMBER,
                              nPrimaPromedio NUMBER);
  PROCEDURE RECOTIZACION_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER);
  PROCEDURE COPIAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER);
  FUNCTION PRIMA_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, cCodCobert VARCHAR2) RETURN NUMBER; 
  PROCEDURE CREAR_COBERTURAS_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                                    nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, cIndPolCol VARCHAR2, nSumaAsegManual NUMBER); 

END GT_COTIZACIONES_COBERT_MASTER;
/

--
-- GT_COTIZACIONES_COBERT_MASTER  (Package Body) 
--
--  Dependencies: 
--   GT_COTIZACIONES_COBERT_MASTER (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_COTIZACIONES_COBERT_MASTER IS

FUNCTION EXISTEN_COBERTURAS_MASTER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN VARCHAR2 IS
cExisteCob      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteCob
        FROM COTIZACIONES_COBERT_MASTER
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteCob := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteCob := 'S';
   END;
   RETURN(cExisteCob);
END EXISTEN_COBERTURAS_MASTER;

PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                            nIdAsegurado NUMBER, cCodCobert VARCHAR2, nSumaAsegManual NUMBER,
                            nSalarioMensual NUMBER, nVecesSalario NUMBER, nEdad_Minima NUMBER,
                            nEdad_Maxima NUMBER, nEdad_Exclusion NUMBER, nSumaAseg_Minima NUMBER,
                            nSumaAseg_Maxima NUMBER, nPorcExtraPrimaDet NUMBER, nMontoExtraPrimaDet NUMBER,
                            nSumaIngresada NUMBER, nDeducibleIngresado NUMBER, nCuotaPromedio NUMBER,
                            nPrimaPromedio NUMBER) IS
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

CURSOR COB_Q IS
   SELECT CodCobert, Porc_Tasa, TipoTasa, Prima_Cobert,
          SumaAsegurada, Cod_Moneda, CodTarifa, Edad_Minima, 
          Edad_Maxima, Edad_Exclusion, MontoDeducible, PorcenDeducible,
          SumaAsegMinima, SumaAsegMaxima, OrdenImpresion
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
                nFactorAjuste, nFactFormulaDeduc
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

   nEdad            := nEdad_Minima;
   nCantAseg        := 1;
   cSexo            := 'U';
   nPorcExtraPrima  := NVL(nPorcExtraPrimaDet,0);
   nMontoExtraPrima := NVL(nMontoExtraPrimaDet,0);
   
   FOR X IN COB_Q  LOOP
      nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(X.Cod_Moneda, dFecCotizacion);
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
                                                                               X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
               ELSE
                  nSumaAsegMoneda := NVL(nSumaAsegManual,0);
               END IF;
               nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                         X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
               IF NVL(nTasa,0) > 0 THEN
                  nTasa := NVL(nTasa,0) * (1 - (NVL(nPorcDescuento,0) / 100));

                  nTasa := NVL(nTasa,0) * (1 + (NVL(nPorcExtraPrima,0) / 100));
                  
                  nTasa := NVL(nTasa,0) + NVL(nMontoExtraPrima,0);
                  
                  nTasa := NVL(nTasa,0) * NVL(nFactorAjuste,0);

                  IF NVL(nFactorAjusteSubGrupo,0) > 0 THEN
                     nTasa := NVL(nTasa,0) * NVL(nFactorAjuste,0);
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

                  nTasa := NVL(nTasa,0) / (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) - (NVL(nPorcGtoAdmin,0) / 100));
               END IF;
               
               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  nSumaAsegMoneda  := NVL(X.SumaAsegurada,0);
               END IF;

               nSumaAsegMoneda := NVL(nSumaAsegMoneda,0) * NVL(nCantAseg,0);
               nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa); --nSumaAsegMoneda);
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

         IF NVL(X.MontoDeducible,0) != 0 THEN
            nDeducibleCobMoneda := NVL(X.MontoDeducible,0);
            nDeducibleCobLocal  := NVL(X.MontoDeducible,0) * nTasaCambio;
         ELSE
            nDeducibleCobMoneda := NVL(nSumaAsegMoneda,0) * NVL(X.PorcenDeducible,0) / 100;
            nDeducibleCobLocal  := NVL(nDeducibleCobMoneda,0) * nTasaCambio;
         END IF;

         --IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nValorMoneda,0) != 0 THEN
            BEGIN
               INSERT INTO COTIZACIONES_COBERT_MASTER
                     (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion,
                      CodCobert, SumaAsegCobLocal, SumaAsegCobMoneda,
                      Tasa, PrimaCobLocal, PrimaCobMoneda, DeducibleCobLocal,
                      DeducibleCobMoneda, SalarioMensual, VecesSalario,
                      SumaAsegCalculada, Edad_Minima, Edad_Maxima, Edad_Exclusion,
                      SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
                      MontoExtraPrimaDet, SumaIngresada, OrdenImpresion,
                      DeducibleIngresado, CuotaPromedio, PrimaPromedio)
               VALUES(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, 
                      X.CodCobert, NVL(nSumaAsegLocal,0), NVL(nSumaAsegMoneda,0),
                      nTasa, NVL(nValor,0), NVL(nValorMoneda,0), NVL(nDeducibleCobLocal,0),
                      NVL(nDeducibleCobMoneda,0), NVL(nSalarioMensual,0), NVL(nVecesSalario,0),
                      NVL(nSumaAsegManual,0), nEdad_MinimaCob, nEdad_MaximaCob, nEdad_ExclusionCob,
                      nSumaAseg_MinimaCob, nSumaAseg_MaximaCob, nPorcExtraPrima,
                      nMontoExtraPrima, nSumaIngresada, X.OrdenImpresion, NVL(nDeducibleIngresado,0),
                      NVL(nCuotaPromedio,0), NVL(nPrimaPromedio,0));
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                  UPDATE COTIZACIONES_COBERT_MASTER
                     SET SumaAsegCobLocal      = NVL(nSumaAsegLocal,0),
                         SumaAsegCobMoneda     = NVL(nSumaAsegMoneda,0),
                         Tasa                  = nTasa,
                         PrimaCobLocal         = NVL(nValor,0),
                         PrimaCobMoneda        = NVL(nValorMoneda,0),
                         DeducibleCobLocal     = NVL(nDeducibleCobLocal,0),
                         DeducibleCobMoneda    = NVL(nDeducibleCobMoneda,0),
                         SalarioMensual        = NVL(nSalarioMensual,0),
                         VecesSalario          = NVL(nVecesSalario,0),
                         SumaAsegCalculada     = NVL(nSumaAsegManual,0),
                         Edad_Minima           = nEdad_MinimaCob,
                         Edad_Maxima           = nEdad_MaximaCob,
                         Edad_Exclusion        = nEdad_ExclusionCob,
                         SumaAseg_Minima       = nSumaAseg_MinimaCob,
                         SumaAseg_Maxima       = nSumaAseg_MaximaCob,
                         PorcExtraPrimaDet     = nPorcExtraPrima,
                         MontoExtraPrimaDet    = nMontoExtraPrima,
                         SumaIngresada         = nSumaIngresada,
                         OrdenImpresion        = X.OrdenImpresion,
                         DeducibleIngresado    = NVL(nDeducibleIngresado,0),
                         CuotaPromedio         = NVL(nCuotaPromedio,0),
                         PrimaPromedio         = NVL(nPrimaPromedio,0)
                   WHERE CodCia         = nCodCia
                     AND CodEmpresa     = nCodEmpresa
                     AND IdCotizacion   = nIdCotizacion
                     AND IDetCotizacion = nIDetCotizacion
                     AND CodCobert      = X.CodCobert;
            END;
         --END IF;
      END IF;
   END LOOP;
END CARGAR_COBERTURAS;

PROCEDURE RECOTIZACION_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER) IS
CURSOR COB_Q IS
   SELECT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, CodCobert,
          SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal, 
          PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,
          SalarioMensual, VecesSalario, SumaAsegCalculada,
          Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima,
          SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, 
          OrdenImpresion, SumaIngresada, DeducibleIngresado, 
          CuotaPromedio, PrimaPromedio
     FROM COTIZACIONES_COBERT_MASTER
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   FOR W IN COB_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_COBERT_MASTER
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, CodCobert,
                 SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal,
                 PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,
                 SalarioMensual, VecesSalario, SumaAsegCalculada,
                 Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima,
                 SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, 
                 OrdenImpresion, SumaIngresada, DeducibleIngresado, 
                 CuotaPromedio, PrimaPromedio)
         VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, W.IDetCotizacion, W.CodCobert,
                 W.SumaAsegCobLocal, W.SumaAsegCobMoneda, W.Tasa, W.PrimaCobLocal,
                 W.PrimaCobMoneda, W.DeducibleCobLocal, W.DeducibleCobMoneda,
                 W.SalarioMensual, W.VecesSalario, W.SumaAsegCalculada,
                 W.Edad_Minima, W.Edad_Maxima, W.Edad_Exclusion, W.SumaAseg_Minima,
                 W.SumaAseg_Maxima, W.PorcExtraPrimaDet, W.MontoExtraPrimaDet, 
                 W.OrdenImpresion, W.SumaIngresada, W.DeducibleIngresado, 
                 W.CuotaPromedio, W.PrimaPromedio);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Cobertura Master de Detalle Cotización No. ' || nIdReCotizacion || ' y Cobertura ' ||W.CodCobert);
      END;
   END LOOP;
END RECOTIZACION_COBERTURAS;

PROCEDURE COPIAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER) IS
CURSOR COB_Q IS
   SELECT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, CodCobert,
          SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal, 
          PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,
          SalarioMensual, VecesSalario, SumaAsegCalculada,
          Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima,
          SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, 
          SumaIngresada, OrdenImpresion, DeducibleIngresado, 
          CuotaPromedio, PrimaPromedio
     FROM COTIZACIONES_COBERT_MASTER
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
BEGIN
   FOR W IN COB_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_COBERT_MASTER
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, CodCobert,
                 SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal,
                 PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,
                 SalarioMensual, VecesSalario, SumaAsegCalculada,
                 Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima,
                 SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet,
                 SumaIngresada, OrdenImpresion, DeducibleIngresado,
                 CuotaPromedio, PrimaPromedio)
         VALUES (nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionDest, W.CodCobert,
                 W.SumaAsegCobLocal, W.SumaAsegCobMoneda, W.Tasa, W.PrimaCobLocal,
                 W.PrimaCobMoneda, W.DeducibleCobLocal, W.DeducibleCobMoneda,
                 W.SalarioMensual, W.VecesSalario, W.SumaAsegCalculada,
                 W.Edad_Minima, W.Edad_Maxima, W.Edad_Exclusion, W.SumaAseg_Minima,
                 W.SumaAseg_Maxima, W.PorcExtraPrimaDet, W.MontoExtraPrimaDet,
                 W.SumaIngresada, W.OrdenImpresion, W.DeducibleIngresado, 
                 W.CuotaPromedio, W.PrimaPromedio);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Cobertura de Detalle Cotización No. ' || nIDetCotizacion || 
                                    ' Detalle No. ' || nIDetCotizacionDest || ' y Cobertura ' ||W.CodCobert);
      END;
   END LOOP;
END COPIAR_COBERTURAS;

FUNCTION PRIMA_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, cCodCobert VARCHAR2) RETURN NUMBER IS
nPrimaCobLocal    COTIZACIONES_COBERT_MASTER.PrimaCobLocal%TYPE;
nCuotaPromedio    COTIZACIONES_COBERT_MASTER.CuotaPromedio%TYPE;
nPrimaPromedio    COTIZACIONES_COBERT_MASTER.PrimaPromedio%TYPE;
cIndEdadPromedio  COTIZACIONES_DETALLE.IndEdadPromedio%TYPE;
cIndCuotaPromedio COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE;
cIndPrimaPromedio COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE;
nPorcGtoAdmin     COTIZACIONES.PorcGtoAdmin%TYPE;
nPorcGtoAdqui     COTIZACIONES.PorcGtoAdqui%TYPE;
nPorcUtilidad     COTIZACIONES.PorcUtilidad%TYPE;
BEGIN
   BEGIN
      SELECT NVL(D.CuotaPromedio,0), NVL(D.PrimaPromedio,0)
        INTO nCuotaPromedio, nPrimaPromedio
        FROM COTIZACIONES_COBERT_MASTER D
       WHERE D.CodCia            = nCodCia
         AND D.CodEmpresa        = nCodEmpresa
         AND D.IdCotizacion      = nIdCotizacion
         AND D.IDetCotizacion    = nIDetCotizacion
         AND D.CodCobert         = cCodCobert;
   EXCEPTION 
      WHEN NO_dATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO es Posible Determinar Cuota de la Cotización: '||nIdCotizacion);         
   END;
   BEGIN 
      SELECT NVL(D.IndEdadPromedio,'N'), NVL(D.IndCuotaPromedio,'N'), NVL(D.IndPrimaPromedio,'N'),
             NVL(C.PorcGtoAdmin,0), NVL(C.PorcGtoAdqui,0), NVL(C.PorcUtilidad,0)
        INTO cIndEdadPromedio, cIndCuotaPromedio, cIndPrimaPromedio,
             nPorcGtoAdmin, nPorcGtoAdqui, nPorcUtilidad
        FROM COTIZACIONES C,COTIZACIONES_DETALLE D
       WHERE D.CodCia            = nCodCia
         AND D.CodEmpresa        = nCodEmpresa
         AND D.IdCotizacion      = nIdCotizacion
         AND D.IDetCotizacion    = nIDetCotizacion
         AND C.CodCia            = D.CodCia
         AND C.CodEmpresa        = D.CodEmpresa
         AND C.IdCotizacion      = D.IdCotizacion;
   EXCEPTION 
      WHEN NO_dATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO es Posible Determinar la Cotización: '||nIdCotizacion);
   END;
   IF NVL(cIndEdadPromedio,'N') = 'S' AND NVL(nCuotaPromedio,0) != 0 THEN
      NULL;
   ELSIF NVL(cIndCuotaPromedio,'N') = 'S' AND NVL(nCuotaPromedio,0) != 0 THEN
      nPrimaCobLocal := nCuotaPromedio / (1 - (nPorcGtoAdqui/100) - ((nPorcGtoAdmin/100) + (nPorcUtilidad/100)));
   ELSIF NVL(cIndPrimaPromedio,'N') = 'S' AND NVL(nPrimaPromedio,0) != 0 THEN
      nPrimaCobLocal := nPrimaPromedio;
   END IF;
   RETURN nPrimaCobLocal;
END PRIMA_COBERTURA;

PROCEDURE CREAR_COBERTURAS_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                                    nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, cIndPolCol VARCHAR2, nSumaAsegManual NUMBER) IS
cIndCambioSAMI   COBERT_ACT.IndCambioSAMI%TYPE;
nSumaAsegLocal   ASEGURADO_CERTIFICADO.SumaAseg%TYPE         := 0;
nSumaAsegMoneda  ASEGURADO_CERTIFICADO.SumaAseg_Moneda%TYPE  := 0;
nPrimaNeta       ASEGURADO_CERTIFICADO.PrimaNeta%TYPE        := 0;
nPrimaNeta_Mon   ASEGURADO_CERTIFICADO.PrimaNeta_Moneda%TYPE := 0;
   
CURSOR COTCOB_Q IS
   SELECT C.IdTipoSeg, M.CodCobert, M.SumaAsegCobLocal, M.SumaAsegCobMoneda, M.Tasa,
          M.PrimaCobLocal, M.PrimaCobMoneda, M.DeducibleCobLocal, M.DeducibleCobMoneda,
          C.SAMIAutorizado, C.PlanCob, C.Cod_Moneda, M.SalarioMensual, M.VecesSalario,
          M.SumaAsegCalculada, M.Edad_Minima, M.Edad_Maxima, M.Edad_Exclusion, M.SumaAseg_Minima,
          M.SumaAseg_Maxima, M.PorcExtraPrimaDet, M.MontoExtraPrimaDet, 
          M.SumaIngresada, C.IndAsegModelo, C.IndCensoSubGrupo,
          M.CuotaPromedio, M.PrimaPromedio, M.DeducibleIngresado
     FROM COTIZACIONES_COBERT_MASTER M, COTIZACIONES C
    WHERE M.CodCia         = C.CodCia
      AND M.CodEmpresa     = C.CodEmpresa
      AND M.IdCotizacion   = C.IdCotizacion
      AND C.CodCia         = nCodCia
      AND C.CodEmpresa     = nCodEmpresa
      AND C.IdCotizacion   = nIdCotizacion
      AND M.IDetCotizacion = nIDetCotizacion;
BEGIN
   IF NVL(cIndPolCol,'N') = 'S' THEN
      IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdpoliza, nIDetPol, nCodAsegurado) = 'N' THEN
         INSERT INTO ASEGURADO_CERTIFICADO
               (CodCia, IdPoliza, IDetPol, Cod_Asegurado, Estado, SumaAseg, 
                PrimaNeta, IdEndoso, SumaAseg_Moneda, PrimaNeta_Moneda)
         VALUES(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado, 'SOL', nSumaAsegLocal, 
                nPrimaNeta, 0, nSumaAsegMoneda, nPrimaNeta_Mon);
      END IF;

      FOR X IN COTCOB_Q LOOP
         IF X.SAMIAutorizado > 0 THEN
            cIndCambioSAMI     := 'S';
         END IF;

         OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS_COTIZACION(nCodCia, nCodEmpresa, X.IdTipoSeg,
                                                          X.PlanCob, nIdCotizacion, nIDetCotizacion,
                                                          X.CodCobert, NVL(nSumaAsegManual,0), X.SalarioMensual, 
                                                          X.VecesSalario, X.Edad_Minima, X.Edad_Maxima, 
                                                          X.Edad_Exclusion, X.SumaAseg_Minima, X.SumaAseg_Maxima,
                                                          X.PorcExtraPrimaDet, X.MontoExtraPrimaDet, X.SumaIngresada, 
                                                          X.DeducibleIngresado, X.CuotaPromedio, X.PrimaPromedio, 
                                                          nIdPoliza, nIDetPol, nCodAsegurado);

         nSumaAsegLocal    := nSumaAsegLocal  + X.SumaAsegCobLocal;
         nSumaAsegMoneda   := nSumaAsegMoneda + X.SumaAsegCobMoneda;
         nPrimaNeta        := nPrimaNeta      + X.PrimaCobLocal;
         nPrimaNeta_Mon    := nPrimaNeta_Mon  + X.PrimaCobMoneda;
      END LOOP;

      UPDATE ASEGURADO_CERTIFICADO
         SET SumaAseg          = nSumaAsegLocal,
             SumaAseg_Moneda   = nSumaAsegMoneda,
             PrimaNeta         = nPrimaNeta,
             PrimaNeta_Moneda  = nPrimaNeta_Mon
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCodAsegurado;
   ELSE
      FOR X IN COTCOB_Q LOOP
         IF X.SAMIAutorizado > 0 THEN
            cIndCambioSAMI     := 'S';
         END IF;

         INSERT INTO COBERT_ACT
               (CodEmpresa, CodCia, IdPoliza, IDetPol, IdTipoSeg, TipoRef, NumRef, CodCobert, 
                SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Local, Prima_Moneda, IdEndoso, 
                StsCobertura, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                Cod_Asegurado, IndCambioSAMI, SumaAsegOrigen, SalarioMensual, VecesSalario, 
                SumaAsegCalculada, Edad_Minima, Edad_Maxima,  Edad_Exclusion, SumaAseg_Minima, 
                SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada, 
                PrimaNivMoneda, PrimaNivLocal)
         VALUES(nCodEmpresa, nCodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, 'POLI', nIdPoliza, X.CodCobert, 
                X.SumaAsegCobLocal, X.SumaAsegCobMoneda, X.Tasa, X.PrimaCobLocal, X.PrimaCobMoneda, 0, 
                'SOL', X.PlanCob, X.Cod_Moneda, X.DeducibleCobLocal, X.DeducibleCobMoneda, 
                nCodAsegurado, cIndCambioSAMI, NULL, X.SalarioMensual, X.VecesSalario,
                X.SumaAsegCalculada, X.Edad_Minima, X.Edad_Maxima, X.Edad_Exclusion, X.SumaAseg_Minima,
                X.SumaAseg_Maxima, X.PorcExtraPrimaDet, X.MontoExtraPrimaDet, X.SumaIngresada,
                0, 0);
      END LOOP;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Crear las Coberturas desde Cotización '||SQLERRM);
END CREAR_COBERTURAS_POLIZA;   

END GT_COTIZACIONES_COBERT_MASTER;
/

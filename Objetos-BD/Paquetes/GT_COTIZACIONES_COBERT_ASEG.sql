CREATE OR REPLACE PACKAGE          GT_COTIZACIONES_COBERT_ASEG IS

  FUNCTION EXISTEN_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, 
                              nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN VARCHAR2;
  PROCEDURE RECOTIZACION_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER);
  PROCEDURE COPIAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER);
  PROCEDURE CREAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                             nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, cIndPolCol VARCHAR2);                           

END GT_COTIZACIONES_COBERT_ASEG;
/

CREATE OR REPLACE PACKAGE BODY          GT_COTIZACIONES_COBERT_ASEG IS

FUNCTION EXISTEN_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER,
                            nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN VARCHAR2 IS
cExisteCob      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteCob
        FROM COTIZACIONES_COBERT_ASEG
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion
         AND IdAsegurado    = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteCob := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteCob := 'S';
   END;
   RETURN(cExisteCob);
END EXISTEN_COBERTURAS;

PROCEDURE RECOTIZACION_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER) IS
CURSOR COB_Q IS
   SELECT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado, 
          CodCobert, SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal,
          PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,
          SalarioMensual, VecesSalario, SumaAsegCalculada,
          Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima,
          SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada,
          DeducibleIngresado, CuotaPromedio, PrimaPromedio, FranquiciaIngresado, MontoDiario, Dias_Cal  ---ARH 28/02/2024
     FROM COTIZACIONES_COBERT_ASEG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   FOR W IN COB_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_COBERT_ASEG
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado,
                 CodCobert, SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal,
                 PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,
                 SalarioMensual, VecesSalario, SumaAsegCalculada,
                 Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima,
                 SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet,
                 SumaIngresada, DeducibleIngresado, CuotaPromedio, PrimaPromedio, FranquiciaIngresado, MontoDiario, Dias_Cal)
         VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, W.IDetCotizacion, W.IdAsegurado,
                 W.CodCobert, W.SumaAsegCobLocal, W.SumaAsegCobMoneda, W.Tasa, W.PrimaCobLocal,
                 W.PrimaCobMoneda, W.DeducibleCobLocal, W.DeducibleCobMoneda,
                 W.SalarioMensual, W.VecesSalario, W.SumaAsegCalculada,
                 W.Edad_Minima, W.Edad_Maxima, W.Edad_Exclusion, W.SumaAseg_Minima,
                 W.SumaAseg_Maxima, W.PorcExtraPrimaDet, W.MontoExtraPrimaDet,
                 W.SumaIngresada, W.DeducibleIngresado, W.CuotaPromedio, W.PrimaPromedio, W.FranquiciaIngresado, W.MontoDiario, W.Dias_Cal); ---ARH 28/02/2024
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Cobertura de Censo o Asegurado en Cotización No. ' || nIdReCotizacion || ' y Cobertura ' ||W.CodCobert);
      END;
   END LOOP;
END RECOTIZACION_COBERTURAS;

PROCEDURE COPIAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER) IS
CURSOR COB_Q IS
   SELECT CodCia, CodEmpresa, IdAsegurado,  CodCobert, SumaAsegCobLocal, 
          SumaAsegCobMoneda, Tasa, PrimaCobLocal, PrimaCobMoneda, 
          DeducibleCobLocal, DeducibleCobMoneda, SalarioMensual, 
          VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima, 
          Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, 
          PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada,
          DeducibleIngresado, CuotaPromedio, PrimaPromedio, FranquiciaIngresado, MontoDiario, Dias_Cal --ARH 28/02/2024
     FROM COTIZACIONES_COBERT_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
BEGIN
   FOR W IN COB_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_COBERT_ASEG
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado,
                 CodCobert, SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal,
                 PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,
                 SalarioMensual, VecesSalario, SumaAsegCalculada,
                 Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima,
                 SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet,
                 SumaIngresada, DeducibleIngresado, CuotaPromedio, PrimaPromedio, FranquiciaIngresado, MontoDiario, Dias_Cal)--- ARH 21/03/2024
         VALUES (nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionDest, W.IdAsegurado,
                 W.CodCobert, W.SumaAsegCobLocal, W.SumaAsegCobMoneda, W.Tasa, W.PrimaCobLocal,
                 W.PrimaCobMoneda, W.DeducibleCobLocal, W.DeducibleCobMoneda,
                 W.SalarioMensual, W.VecesSalario, W.SumaAsegCalculada,
                 W.Edad_Minima, W.Edad_Maxima, W.Edad_Exclusion, W.SumaAseg_Minima,
                 W.SumaAseg_Maxima, W.PorcExtraPrimaDet, W.MontoExtraPrimaDet,
                 W.SumaIngresada, W.DeducibleIngresado, W.CuotaPromedio, W.PrimaPromedio, W.FranquiciaIngresado, W.MontoDiario, W.Dias_Cal); ---ARH 28/02/2024
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Cobertura de Censo o Asegurado en Cotización No. ' ||  nIdCotizacion || 
                                    ' Detalle No. ' || nIDetCotizacionDest || ' y Cobertura ' ||W.CodCobert);
      END;
   END LOOP;
END COPIAR_COBERTURAS;

PROCEDURE CREAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                           nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, cIndPolCol VARCHAR2) IS

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
          M.SumaIngresada, C.IndAsegModelo, C.IndCensoSubGrupo, M.FranquiciaIngresado, M.MontoDiario, M.Dias_Cal  ----28022024 ARH
     FROM COTIZACIONES_COBERT_ASEG M, COTIZACIONES C
    WHERE M.CodCia         = C.CodCia
      AND M.CodEmpresa     = C.CodEmpresa
      AND M.IdCotizacion   = C.IdCotizacion
      AND C.CodCia         = nCodCia
      AND C.CodEmpresa     = nCodEmpresa
      AND C.IdCotizacion   = nIdCotizacion
      AND M.IDetCotizacion = nIDetCotizacion;
BEGIN
   IF NVL(cIndPolCol,'N') = 'S' THEN
      INSERT INTO ASEGURADO_CERTIFICADO
            (CodCia, IdPoliza, IDetPol, Cod_Asegurado, Estado, SumaAseg, 
             PrimaNeta, IdEndoso, SumaAseg_Moneda, PrimaNeta_Moneda)
      VALUES(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado, 'SOL', nSumaAsegLocal, 
             nPrimaNeta, 0, nSumaAsegMoneda, nPrimaNeta_Mon);

      FOR X IN COTCOB_Q LOOP
         IF X.SAMIAutorizado > 0 THEN
            cIndCambioSAMI     := 'S';
         END IF;

         INSERT INTO COBERT_ACT_ASEG
               (CodEmpresa, CodCia, IdPoliza, IDetPol, IdTipoSeg, TipoRef, NumRef, CodCobert, 
                SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Local, Prima_Moneda, IdEndoso, 
                StsCobertura, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                Cod_Asegurado, IndCambioSAMI, SumaAsegOrigen, SalarioMensual, VecesSalario, 
                SumaAsegCalculada, Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima, 
                SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada, 
                PrimaNivMoneda, PrimaNivLocal, FranquiciaIngresado, MontoDiario, Dias_Cal)
         VALUES(nCodEmpresa, nCodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, 'POLI', nIdPoliza, X.CodCobert,
                X.SumaAsegCobLocal, X.SumaAsegCobMoneda, X.Tasa, X.PrimaCobLocal, X.PrimaCobMoneda, 0, 
                'SOL', X.PlanCob, X.Cod_Moneda, X.DeducibleCobLocal, X.DeducibleCobMoneda, 
                nCodAsegurado, cIndCambioSAMI, NULL, X.SalarioMensual, X.VecesSalario, 
                X.SumaAsegCalculada, X.Edad_Minima, X.Edad_Maxima, X.Edad_Exclusion, X.SumaAseg_Minima,
                X.SumaAseg_Maxima, X.PorcExtraPrimaDet, X.MontoExtraPrimaDet, X.SumaIngresada,
                0, 0,X.FranquiciaIngresado, X.MontoDiario, X.Dias_Cal);

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
                PrimaNivMoneda, PrimaNivLocal, FranquiciaIngresado, MontoDiario, Dias_Cal)
         VALUES(nCodEmpresa, nCodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, 'POLI', nIdPoliza, X.CodCobert, 
                X.SumaAsegCobLocal, X.SumaAsegCobMoneda, X.Tasa, X.PrimaCobLocal, X.PrimaCobMoneda, 0, 
                'SOL', X.PlanCob, X.Cod_Moneda, X.DeducibleCobLocal, X.DeducibleCobMoneda, 
                nCodAsegurado, cIndCambioSAMI, NULL, X.SalarioMensual, X.VecesSalario,
                X.SumaAsegCalculada, X.Edad_Minima, X.Edad_Maxima, X.Edad_Exclusion, X.SumaAseg_Minima,
                X.SumaAseg_Maxima, X.PorcExtraPrimaDet, X.MontoExtraPrimaDet, X.SumaIngresada,
                0, 0, X.FranquiciaIngresado, X.MontoDiario, X.Dias_Cal);
      END LOOP;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Crear las Coberturas desde Cotización '||SQLERRM);
END CREAR_COBERTURAS;

END GT_COTIZACIONES_COBERT_ASEG;

--
-- OC_RESERVAS_TECNICAS_ACCYENF  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   PLAN_DE_PAGOS (Table)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_POLIZA (Table)
--   OC_CONFIG_RESERVAS_FACTORSUF (Package)
--   OC_CONFIG_RESERVAS_PLANCOB_GTO (Package)
--   OC_RESERVAS_TECNICAS_RES (Package)
--   RESERVAS_TECNICAS_ACCYENF (Table)
--   CONFIG_RESERVAS_PLANCOB (Table)
--   CONFIG_RESERVAS_PLANCOB_GTO (Table)
--   CONFIG_RESERVAS_TARIFAS (Table)
--   CONFIG_RESERVAS_TIPOSEG (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   COBERTURAS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   OC_FACTURAS (Package)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_ASEGURADO (Package)
--   OC_PLAN_DE_PAGOS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_RESERVAS_TECNICAS_ACCYENF AS 
PROCEDURE GENERAR_RESERVA(nIdReserva NUMBER, nCodCia NUMBER, cCodReserva VARCHAR2, dFecIniRva DATE, 
                          dFecFinRva DATE, dFecValuacion DATE, cParamFactorRva VARCHAR2); 
END OC_RESERVAS_TECNICAS_ACCYENF;
/

--
-- OC_RESERVAS_TECNICAS_ACCYENF  (Package Body) 
--
--  Dependencies: 
--   OC_RESERVAS_TECNICAS_ACCYENF (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_RESERVAS_TECNICAS_ACCYENF AS 

PROCEDURE GENERAR_RESERVA(nIdReserva NUMBER, nCodCia NUMBER, cCodReserva VARCHAR2, dFecIniRva DATE, 
                          dFecFinRva DATE, dFecValuacion DATE, cParamFactorRva VARCHAR2) IS 

cIdTipoSeg              CONFIG_RESERVAS_TIPOSEG.IdTipoSeg%TYPE; 
cPlanCob                CONFIG_RESERVAS_PLANCOB.PlanCob%TYPE; 
nCodEmpresa             CONFIG_RESERVAS_TIPOSEG.CodEmpresa%TYPE; 
nIdPoliza               POLIZAS.IdPoliza%TYPE; 
nIDetPol                DETALLE_POLIZA.IDetPol%TYPE; 
nSumaAsegurada          COBERTURAS.Suma_Asegurada_Local%TYPE; 
nEdad                   NUMBER(5); 
nPrimaTarifa            RESERVAS_TECNICAS_ACCYENF.PrimaTarifa%TYPE; 
nPrimaRiesgo            RESERVAS_TECNICAS_ACCYENF.PrimaRiesgo%TYPE; 
nPrimaSinComis          RESERVAS_TECNICAS_ACCYENF.PrimaSinComis%TYPE; 
nRvaMatTotal            RESERVAS_TECNICAS_ACCYENF.RvaMatTotal%TYPE; 
nRvaGtosTotal           RESERVAS_TECNICAS_ACCYENF.RvaGtosTotal%TYPE; 
nRvaGtosAdic            RESERVAS_TECNICAS_ACCYENF.RvaGtosTotal%TYPE; 
nRvaTotal               RESERVAS_TECNICAS_ACCYENF.RvaTotal%TYPE; 
nGastoAdmin             RESERVAS_TECNICAS_ACCYENF.GastoAdmin%TYPE; 
nFactorNoDev            RESERVAS_TECNICAS_ACCYENF.FactorNoDev%TYPE; 
nGtoAdmin               CONFIG_RESERVAS_PLANCOB_GTO.PorcGtoAdmin%TYPE; 
nGtoAdqui               CONFIG_RESERVAS_PLANCOB_GTO.PorcGtoAdqui%TYPE; 
nPorcUtilidad           CONFIG_RESERVAS_PLANCOB_GTO.PorcUtilidad%TYPE; 
nFactPriTarifaBas       CONFIG_RESERVAS_TARIFAS.PrimaTarifaBasica%TYPE; 
nFactPriTarifaAdic      CONFIG_RESERVAS_TARIFAS.PrimaTarifaAdic%TYPE; 
nFactPriRiesgoBas       CONFIG_RESERVAS_TARIFAS.PrimaRiesgoBasica%TYPE; 
nFactPriRiesgoAdic      CONFIG_RESERVAS_TARIFAS.PrimaRiesgoAdic%TYPE; 
nPrimaBasica            COBERTURAS.Prima_Local%TYPE; 
nPrimaAdicional         COBERTURAS.Prima_Local%TYPE; 
nRvaMatCp               RESERVAS_TECNICAS_ACCYENF.RvaMatTotal%TYPE; 
nRvaMatLp               RESERVAS_TECNICAS_ACCYENF.RvaMatTotal%TYPE; 
nAjuInsufCpBa           RESERVAS_TECNICAS_ACCYENF.AjusteInsufBasica%TYPE; 
nAjuInsufLpBa           RESERVAS_TECNICAS_ACCYENF.AjusteInsufBasica%TYPE; 
nRvaGtosCp              RESERVAS_TECNICAS_ACCYENF.RvaGtosTotal%TYPE; 
nRvaGtosLp              RESERVAS_TECNICAS_ACCYENF.RvaGtosTotal%TYPE; 
nRvaMatAdCp             RESERVAS_TECNICAS_ACCYENF.RvaMatTotal%TYPE; 
nRvaMatAdLp             RESERVAS_TECNICAS_ACCYENF.RvaMatTotal%TYPE; 
nAjuInsufCpAd           RESERVAS_TECNICAS_ACCYENF.AjusteInsufBasica%TYPE; 
nAjuInsufLpAd           RESERVAS_TECNICAS_ACCYENF.AjusteInsufBasica%TYPE; 
nRvaGtosAdCp            RESERVAS_TECNICAS_ACCYENF.RvaGtosTotal%TYPE; 
nRvaGtosAdLp            RESERVAS_TECNICAS_ACCYENF.RvaGtosTotal%TYPE; 
nFactSuficiencia        RESERVAS_TECNICAS_ACCYENF.FactSuficiencia%TYPE; 
nFactInSuficiencia      RESERVAS_TECNICAS_ACCYENF.FactInSuficiencia%TYPE; 
nAjusteInsufBasica      RESERVAS_TECNICAS_ACCYENF.AjusteInsufBasica%TYPE; 
nAjusteInsufAdic        RESERVAS_TECNICAS_ACCYENF.AjusteInsufAdic%TYPE; 
nCostoAdquiBasica       RESERVAS_TECNICAS_ACCYENF.CostoAdquiBasica%TYPE; 
nCostoAdquiAdic         RESERVAS_TECNICAS_ACCYENF.CostoAdquiAdic%TYPE; 
nMargenUtilBasica       RESERVAS_TECNICAS_ACCYENF.MargenUtilBasica%TYPE; 
nMargenUtilAdic         RESERVAS_TECNICAS_ACCYENF.MargenUtilAdic%TYPE; 
nDevolucionBasica       RESERVAS_TECNICAS_ACCYENF.DevolucionBasica%TYPE; 
nDevolucionAdic         RESERVAS_TECNICAS_ACCYENF.DevolucionAdic%TYPE; 
nRvaSufBasica           RESERVAS_TECNICAS_ACCYENF.RvaSufBasica%TYPE; 
nRvaSufAdic             RESERVAS_TECNICAS_ACCYENF.RvaSufAdic%TYPE; 
nRvaInSufBasica         RESERVAS_TECNICAS_ACCYENF.RvaInSufBasica%TYPE; 
nRvaInSufAdic           RESERVAS_TECNICAS_ACCYENF.RvaInSufAdic%TYPE; 
nFactUtilidad           RESERVAS_TECNICAS_ACCYENF.FactUtilidad%TYPE; 
nPorcDevolucion         RESERVAS_TECNICAS_ACCYENF.PorcDevolucion%TYPE; 
nFactGtoAdqui           RESERVAS_TECNICAS_ACCYENF.FactGtoAdqui%TYPE; 
nCostoAdminBasica       RESERVAS_TECNICAS_ACCYENF.CostoAdminBasica%TYPE; 
nCostoAdminAdic         RESERVAS_TECNICAS_ACCYENF.CostoAdminAdic%TYPE; 
nPrimaRiesgoAdic        RESERVAS_TECNICAS_ACCYENF.PrimaRiesgoAdic%TYPE; 
nRvaMatAdicional        RESERVAS_TECNICAS_ACCYENF.RvaMatAdicional%TYPE; 
nCostoAdminDevBas       RESERVAS_TECNICAS_ACCYENF.CostoAdminDevBas%TYPE; 
nCostoAdminDevAdic      RESERVAS_TECNICAS_ACCYENF.CostoAdminDevAdic%TYPE; 
nPrimaTarifaAdic        RESERVAS_TECNICAS_ACCYENF.PrimaTarifaAdic%TYPE; 
nRvaPrimaBasica         RESERVAS_TECNICAS_ACCYENF.RvaPrimaBasica%TYPE; 
nRvaPrimaAdic           RESERVAS_TECNICAS_ACCYENF.RvaPrimaAdic%TYPE;
nProvGtosAsist          RESERVAS_TECNICAS_ACCYENF.ProvGtosAsist%TYPE;
nProvGtosAsistDev       RESERVAS_TECNICAS_ACCYENF.ProvGtosAsistDev%TYPE;
nRvaRiesgoCurso1        RESERVAS_TECNICAS_ACCYENF.RvaRiesgoCurso1%TYPE;
nRvaRiesgoCurso2        RESERVAS_TECNICAS_ACCYENF.RvaRiesgoCurso2%TYPE;
nRvaGtoAdminBasica      RESERVAS_TECNICAS_ACCYENF.RvaGtoAdminBasica%TYPE;
nRvaGtoAdminAdic        RESERVAS_TECNICAS_ACCYENF.RvaGtoAdminAdic%TYPE;
nRvaMinBasica           RESERVAS_TECNICAS_ACCYENF.RvaMinBasica%TYPE;
nRvaMinAdic             RESERVAS_TECNICAS_ACCYENF.RvaMinAdic%TYPE;
cCodPlanPagos           PLAN_DE_PAGOS.CodPlanPago%TYPE;
nFrecPagos              PLAN_DE_PAGOS.FrecPagos%TYPE;
dFecIniVig              DATE;
dFecFinVig              DATE;
cGeneroRva              VARCHAR2(1); 
nAltura                 NUMBER(5); 

CURSOR TIPOSEG_Q IS 
   SELECT TS.IdTipoSeg, TS.CodEmpresa, PC.PlanCob
     FROM CONFIG_RESERVAS_TIPOSEG TS, CONFIG_RESERVAS_PLANCOB PC 
    WHERE PC.StsPlanRva    = 'ACT' 
      AND PC.CodEmpresa    = TS.CodEmpresa 
      AND PC.IdTipoSeg     = TS.IdTipoSeg 
      AND PC.CodReserva    = TS.CodReserva 
      AND PC.CodCia        = TS.CodCia 
      AND TS.CodReserva    = cCodReserva 
      AND TS.StsTipoSegRva = 'ACT'; 
CURSOR CERTIF_Q IS 
   SELECT D.IdPoliza, D.IDetPol, D.IdTipoSeg, D.PlanCob, 
          D.Cod_Asegurado, D.CodCia, D.CodEmpresa, 
          D.FecIniVig, D.FecFinVig, D.PorcComis
     FROM DETALLE_POLIZA D
    WHERE StsDetalle  = 'EMI'
      /*AND FecIniVig  <= dFecFinRva
      AND (FecFinVig >= dFecFinRva
       OR FecFinVig   >  dFecIniRva)*/
      AND PlanCob     = cPlanCob
      AND IdTipoSeg   = cIdTipoSeg
      AND CodEmpresa  = nCodEmpresa
      AND CodCia      = nCodCia
      AND EXISTS (SELECT 'S'
                    FROM FACTURAS
                   WHERE CodCia                   = D.CodCia
                     AND IdPoliza                 = D.IdPoliza
                     AND IDetPol                  = D.IDetPol
                     AND IndContabilizada         = 'S'
                     AND TRUNC(FecContabilizada) <= dFecValuacion)
    UNION 
   SELECT IdPoliza, IDetPol, IdTipoSeg, PlanCob, 
          Cod_Asegurado, CodCia, CodEmpresa, 
          FecIniVig, FecFinVig, PorcComis 
     FROM DETALLE_POLIZA D
    WHERE StsDetalle  IN ('ANU','EXC') 
      AND FecAnul     > dFecValuacion --dFecIniRva 
      AND FecAnul    != FecIniVig 
      AND FecIniVig  <= dFecValuacion
      AND PlanCob     = cPlanCob
      AND IdTipoSeg   = cIdTipoSeg 
      AND CodEmpresa  = nCodEmpresa 
      AND CodCia      = nCodCia
      AND EXISTS (SELECT 'S'
                    FROM FACTURAS
                   WHERE CodCia                   = D.CodCia
                     AND IdPoliza                 = D.IdPoliza
                     AND IDetPol                  = D.IDetPol
                     AND IndContabilizada         = 'S'
                     AND TRUNC(FecContabilizada) <= dFecValuacion);

CURSOR COB_Q IS 
   SELECT C.SumaAseg_Moneda, C.Prima_Moneda, CS.Cobertura_Basica 
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS 
    WHERE CS.CodCobert    = C.CodCobert 
      AND CS.PlanCob      = C.PlanCob 
      AND CS.IdTipoSeg    = C.IdTipoSeg 
      AND CS.CodEmpresa   = C.CodEmpresa 
      AND CS.CodCia       = C.CodCia 
      AND C.StsCobertura IN ('EMI','ANU','REN') 
      AND C.Prima_Moneda != 0 
      AND C.PlanCob       = cPlanCob 
      AND C.IdTipoSeg     = cIdTipoSeg 
      AND C.CodEmpresa    = nCodEmpresa 
      AND C.IDetPol       = nIDetPol 
      AND C.IdPoliza      = nIdPoliza 
      AND C.CodCia        = nCodCia
   UNION
   SELECT C.SumaAseg_Moneda, C.Prima_Moneda, CS.Cobertura_Basica 
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS 
    WHERE CS.CodCobert    = C.CodCobert 
      AND CS.PlanCob      = C.PlanCob
      AND CS.IdTipoSeg    = C.IdTipoSeg
      AND CS.CodEmpresa   = C.CodEmpresa
      AND CS.CodCia       = C.CodCia
      AND C.StsCobertura IN ('EMI','ANU','REN') 
      AND C.Prima_Moneda != 0
      AND C.PlanCob       = cPlanCob
      AND C.IdTipoSeg     = cIdTipoSeg
      AND C.CodEmpresa    = nCodEmpresa
      AND C.IDetPol       = nIDetPol
      AND C.IdPoliza      = nIdPoliza 
      AND C.CodCia        = nCodCia;
CURSOR DET_Q IS
   SELECT F.IdFactura, F.FecVenc, D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE (D.IndCptoPrima   = 'S'
       OR C.IndCptoServicio = 'S')
      AND C.CodConcepto     = D.CodCpto
      AND C.CodCia          = F.CodCia
      AND D.IdFactura       = F.IdFactura
      AND F.IdFactura      IN (SELECT IdFactura
                                 FROM FACTURAS
                                WHERE CodCia                   = nCodCia
                                  AND IdPoliza                 = nIdPoliza
                                  AND IDetPol                  = nIDetPol
                                  AND IndContabilizada         = 'S'
                                  AND TRUNC(FecContabilizada) <= dFecValuacion)
    ORDER BY D.IdFactura;
BEGIN
   cGeneroRva    := 'N'; 
   nRvaMatCp     := 0; 
   nRvaMatLp     := 0; 
   nRvaGtosCp    := 0; 
   nRvaGtosLp    := 0; 
   nAjuInsufCpBa := 0; 
   nAjuInsufLpBa := 0; 
   nRvaMatAdCp   := 0; 
   nRvaMatAdLp   := 0; 
   nAjuInsufCpAd := 0; 
   nAjuInsufLpAd := 0; 
   nRvaGtosAdCp  := 0; 
   nRvaGtosAdLp  := 0; 
   FOR W IN TIPOSEG_Q LOOP 
      cGeneroRva   := 'S'; 
      nCodEmpresa := W.CodEmpresa; 
      cIdTipoSeg  := W.IdTipoSeg; 
      cPlanCob    := W.PlanCob; 
      FOR Z IN CERTIF_Q LOOP 
         nIdPoliza        := Z.IdPoliza; 
         nIDetPol         := Z.IDetPol; 
         nEdad            := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, Z.Cod_Asegurado, Z.FecIniVig); 

         SELECT CEIL(MONTHS_BETWEEN(Z.FecFinVig, Z.FecIniVig)/12) 
           INTO nAltura 
           FROM DUAL; 

         nPrimaTarifa       := 0; 
         nPrimaRiesgo       := 0; 
         nPrimaSinComis     := 0; 
         nRvaMatTotal       := 0; 
         nRvaGtosTotal      := 0; 
         nRvaGtosAdic       := 0; 
         nRvaTotal          := 0; 
         nGastoAdmin        := 0; 
         nPrimaBasica       := 0; 
         nPrimaAdicional    := 0; 
         nFactSuficiencia   := 0;
         nFactInSuficiencia := 0;
         nAjusteInsufBasica := 0; 
         nAjusteInsufAdic   := 0; 
         nCostoAdquiBasica  := 0; 
         nCostoAdquiAdic    := 0; 
         nMargenUtilBasica  := 0; 
         nMargenUtilAdic    := 0; 
         nDevolucionBasica  := 0; 
         nDevolucionAdic    := 0; 
         nRvaSufBasica      := 0; 
         nRvaSufAdic        := 0; 
         nRvaInSufBasica    := 0; 
         nRvaInSufAdic      := 0; 
         nCostoAdminBasica  := 0; 
         nCostoAdminAdic    := 0; 
         nPrimaRiesgoAdic   := 0; 
         nRvaMatAdicional   := 0; 
         nCostoAdminDevBas  := 0; 
         nCostoAdminDevAdic := 0; 
         nPrimaTarifaAdic   := 0; 
         nRvaPrimaBasica    := 0; 
         nRvaPrimaAdic      := 0;
         nProvGtosAsist     := 0;
         nProvGtosAsistDev  := 0;
         nRvaRiesgoCurso1   := 0;
         nRvaRiesgoCurso2   := 0;
         nRvaGtoAdminBasica := 0;
         nRvaGtoAdminAdic   := 0;
         nRvaMinBasica      := 0;
         nRvaMinAdic        := 0;

         FOR Y IN COB_Q LOOP 
            IF Y.Cobertura_Basica = 'S' THEN 
               nSumaAsegurada  := Y.SumaAseg_Moneda;
            END IF;
         END LOOP;

         FOR Y IN DET_Q LOOP
            IF dFecIniVig IS NULL THEN
               dFecIniVig := Y.FecVenc;
            ELSE
               cCodPlanPagos   := OC_FACTURAS.CODIGO_PLAN_PAGOS(Z.CodCia, Y.IdFactura);
               nFrecPagos      := OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(Z.CodCia, Z.CodEmpresa, cCodPlanPagos);
               IF nFrecPagos NOT IN (15,7) THEN
                  dFecFinVig   := ADD_MONTHS(Y.FecVenc, nFrecPagos);
               ELSE
                  dFecFinVig   := Y.FecVenc + nFrecPagos;
               END IF;
               IF dFecFinVig > Z.FecFinVig THEN
                  dFecFinVig := Z.FecFinVig;
               END IF;
            END IF;

            IF Y.CodCpto = 'PRIBAS' THEN
               nPrimaBasica    := NVL(nPrimaBasica,0) + NVL(Y.Monto_Det_Moneda,0); 
            ELSE 
               nPrimaAdicional := NVL(nPrimaAdicional,0) + NVL(Y.Monto_Det_Moneda,0);
            END IF;
         END LOOP;

         IF OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(nCodCia, Z.CodEmpresa, W.IdTipoSeg) != '010' THEN
            dFecIniVig  := Z.FecIniVig;
            dFecFinVig  := Z.FecFinVig;
         END IF;

         -- Factor NO Devengado 
         IF TRUNC(dFecFinVig) < TRUNC(dFecValuacion) THEN 
            nFactorNoDev := 0; 
         ELSIF TRUNC(dFecIniVig) > TRUNC(dFecValuacion) THEN 
            nFactorNoDev := 1; 
         ELSE 
            nFactorNoDev := ROUND(ABS(1 -(TRUNC(dFecValuacion) - TRUNC(dFecIniVig)) / (TRUNC(dFecFinVig) - TRUNC(dFecIniVig))),6);
         END IF;

         -- Lee y Calcula Factores para Reserva 
         nGtoAdmin          := OC_CONFIG_RESERVAS_PLANCOB_GTO.DEVUELVE_GASTO(nCodCia, cCodReserva, nCodEmpresa, cIdTipoSeg, 
                                                                             cPlanCob, 'PGA'); 
         nGtoAdqui          := Z.PorcComis / 100;
         nPorcUtilidad      := OC_CONFIG_RESERVAS_PLANCOB_GTO.DEVUELVE_GASTO(nCodCia, cCodReserva, nCodEmpresa, cIdTipoSeg, 
                                                                             cPlanCob, 'PUT'); 
         -- Cálculo de Reservas y Gastos 
         nPrimaTarifa       := nPrimaBasica;
         nPrimaTarifaAdic   := nPrimaAdicional; 

         nFactSuficiencia   := OC_CONFIG_RESERVAS_FACTORSUF.FACTOR_SUFICIENCIA(nCodCia, cCodReserva, nCodEmpresa, 
                                                                               cIdTipoSeg, dFecValuacion); 
         nCostoAdminBasica  := ROUND(nPrimaTarifa * nGtoAdmin,6);
         nCostoAdminAdic    := ROUND(nPrimaTarifaAdic * nGtoAdmin,6);
         nCostoAdquiBasica  := ROUND(nPrimaTarifa * nGtoAdqui,6);
         nCostoAdquiAdic    := ROUND(nPrimaTarifaAdic * nGtoAdqui,6);
         nMargenUtilBasica  := ROUND(nPrimaTarifa * nPorcUtilidad,6);
         nMargenUtilAdic    := ROUND(nPrimaTarifaAdic * nPorcUtilidad,6);
         nRvaGtoAdminBasica := ROUND((NVL(nPrimaTarifa,0) * NVL(nGtoAdmin,0)) * nFactorNoDev,6);
         nRvaGtoAdminAdic   := ROUND((NVL(nPrimaTarifaAdic,0) * NVL(nGtoAdmin,0)) * nFactorNoDev,6);
         nPrimaRiesgo       := ROUND(NVL(nPrimaTarifa,0) - NVL(nCostoAdminBasica,0) - 
                                     NVL(nCostoAdquiBasica,0) - NVL(nMargenUtilBasica,0),6);
         nPrimaRiesgoAdic   := ROUND(NVL(nPrimaTarifaAdic,0) - NVL(nCostoAdminAdic,0) - 
                                     NVL(nCostoAdquiAdic,0) - NVL(nMargenUtilAdic,0),6);

         nRvaMatTotal       := ROUND(NVL(nPrimaRiesgo,0) * nFactorNoDev,6);
         nRvaMatAdicional   := ROUND(NVL(nPrimaRiesgoAdic,0) * nFactorNoDev,6);
         nCostoAdminDevBas  := ROUND(nFactorNoDev * nPrimaTarifa * nGtoAdmin,6);
         nCostoAdminDevAdic := ROUND(nFactorNoDev * nPrimaTarifaAdic * nGtoAdmin,6);
         nAjusteInsufBasica := 0;
         nAjusteInsufAdic   := 0;
         nRvaSufBasica      := ROUND(((NVL(nFactSuficiencia,0) * nFactorNoDev * NVL(nPrimaRiesgo,0)) + NVL(nCostoAdminDevBas,0)),6);
         nRvaSufAdic        := ROUND(((NVL(nFactSuficiencia,0) * nFactorNoDev * NVL(nPrimaRiesgoAdic,0)) + NVL(nCostoAdminDevAdic,0)),6);
         nRvaPrimaBasica    := ROUND(GREATEST(NVL(nRvaMatTotal,0), NVL(nRvaSufBasica,0)),6);
         nRvaPrimaAdic      := ROUND(GREATEST(NVL(nRvaMatAdicional,0), NVL(nRvaSufAdic,0)),6);
         nRvaMinBasica      := (nPrimaTarifa - nCostoAdquiBasica) * nFactorNoDev;
         nRvaMinAdic        := (nPrimaTarifaAdic - nCostoAdquiAdic) * nFactorNoDev;
         IF nRvaMinBasica > nRvaSufBasica THEN
            nRvaPrimaBasica    := nRvaMinBasica - (nCostoAdminBasica * nFactorNoDev);
            nRvaPrimaAdic      := nRvaMinAdic - (nCostoAdminAdic * nFactorNoDev);
            nAjusteInsufBasica := 0;
            nAjusteInsufAdic   := 0;
         ELSE
            nRvaPrimaBasica    := nRvaMatTotal;
            nRvaPrimaAdic      := nRvaMatAdicional;
            nAjusteInsufBasica := nRvaMatTotal * (nFactSuficiencia - 1);
            nAjusteInsufAdic   := nRvaMatAdicional * (nFactSuficiencia - 1);
         END IF;

         IF NVL(nAltura,0) <= 1 THEN 
            nRvaMatCp       := ROUND(NVL(nRvaMatCp,0) + NVL(nRvaPrimaBasica,0),2);
            nRvaMatAdCp     := ROUND(NVL(nRvaMatAdCp,0) + NVL(nRvaPrimaAdic,0),2); 
            nRvaGtosCp      := ROUND(NVL(nRvaGtosCp,0) + NVL(nRvaGtosTotal,0),2);
            nRvaGtosAdCp    := ROUND(NVL(nRvaGtosAdCp,0) + NVL(nRvaGtosAdic,0),2);
            nAjuInsufCpBa   := ROUND(NVL(nAjuInsufCpBa,0) + NVL(nAjusteInsufBasica,0),2);
            nAjuInsufCpAd   := ROUND(NVL(nAjuInsufCpAd,0) + NVL(nAjusteInsufAdic,0),2);
         ELSE 
            nRvaMatLp       := ROUND(NVL(nRvaMatLp,0) + NVL(nRvaPrimaBasica,0),2);
            nRvaMatAdLp     := ROUND(NVL(nRvaMatAdLp,0) + NVL(nRvaPrimaAdic,0),2);
            nRvaGtosLp      := ROUND(NVL(nRvaGtosLp,0) + NVL(nRvaGtosTotal,0),2);
            nRvaGtosAdLp    := ROUND(NVL(nRvaGtosAdLp,0) + NVL(nRvaGtosAdic,0),2);
            nAjuInsufLpBa   := ROUND(NVL(nAjuInsufLpBa,0) + NVL(nAjusteInsufBasica,0),2);
            nAjuInsufLpAd   := ROUND(NVL(nAjuInsufLpAd,0) + NVL(nAjusteInsufAdic,0),2);
         END IF;

         --IF NVL(nRvaMatTotal,0) != 0 OR NVL(nRvaMatAdicional,0) != 0 THEN 
         BEGIN 
            INSERT INTO RESERVAS_TECNICAS_ACCYENF 
                   (IdReserva, IdPoliza, IdetPol, SumaAsegurada, PrimaTarifa, 
                    PrimaRiesgo, PrimaSinComis, RvaMatTotal, RvaGtosTotal, 
                    RvaTotal, GastoAdmin, FactorNoDev, FactSuficiencia, 
                    CostoAdminBasica, CostoAdminAdic, PorcGastosAdqui, PorcUtilidad, 
                    CostoAdquiBasica, CostoAdquiAdic, MargenUtilBasica, MargenUtilAdic, 
                    PrimaRiesgoAdic, RvaMatAdicional, CostoAdminDevBas, CostoAdminDevAdic, 
                    AjusteInsufBasica, AjusteInsufAdic, DevolucionBasica, DevolucionAdic, 
                    RvaSufBasica, RvaSufAdic, FactUtilidad, PorcDevolucion, 
                    PrimaTarifaAdic, FactGtoAdqui, RvaPrimaBasica, RvaPrimaAdic,
                    FactInSuficiencia, RvaInSufBasica, RvaInSufAdic, ProvGtosAsist,
                    RvaRiesgoCurso1, ProvGtosAsistDev, RvaRiesgoCurso2, RvaGtoAdminBasica,
                    RvaGtoAdminAdic, RvaMinBasica, RvaMinAdic) 
            VALUES (nIdReserva, nIdPoliza, nIDetPol, nSumaAsegurada, nPrimaTarifa, 
                    nPrimaRiesgo, nPrimaSinComis, nRvaMatTotal, nRvaGtosTotal, 
                    nRvaTotal, nGtoAdmin * 100, nFactorNoDev, nFactSuficiencia, 
                    nCostoAdminBasica, nCostoAdminAdic, nGtoAdqui * 100, nPorcUtilidad * 100, 
                    nCostoAdquiBasica, nCostoAdquiAdic, nMargenUtilBasica, nMargenUtilAdic, 
                    nPrimaRiesgoAdic, nRvaMatAdicional, nCostoAdminDevBas, nCostoAdminDevAdic, 
                    nAjusteInsufBasica, nAjusteInsufAdic, nDevolucionBasica, nDevolucionAdic, 
                    nRvaSufBasica, nRvaSufAdic, nFactUtilidad, nPorcDevolucion * 100, 
                    nPrimaTarifaAdic, nFactGtoAdqui, nRvaPrimaBasica, nRvaPrimaAdic,
                    nFactInSuficiencia, nRvaInSufBasica, nRvaInSufAdic, nProvGtosAsist,
                    nRvaRiesgoCurso1, nProvGtosAsistDev, nRvaRiesgoCurso2, nRvaGtoAdminBasica,
                    nRvaGtoAdminAdic, nRvaMinBasica, nRvaMinAdic); 
         EXCEPTION 
            WHEN DUP_VAL_ON_INDEX THEN 
               RAISE_APPLICATION_ERROR(-20100,'Certificado Duplicado en Reserva para Póliza-Detalle: '|| nIdPoliza ||'-'||nIDetPol); 
         END; 
         --END IF; 
      END LOOP; 
   END LOOP; 
   -- Resumen de Reservas para Corto y Largo Plazo 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVAPTC', 'S', nRvaMatCp); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVAPTC', 'N', nRvaMatAdCp); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVAPTL', 'S', nRvaMatLp); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVAPTL', 'N', nRvaMatAdLp); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'INSUFC', 'S', nAjuInsufCpBa); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'INSUFC', 'N', nAjuInsufCpAd); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'INSUFL', 'S', nAjuInsufLpBa); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'INSUFL', 'N', nAjuInsufLpAd); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVAGAC', 'S', nRvaGtosCp); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVAGAC', 'N', nRvaGtosAdCp); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVAGAL', 'S', nRvaGtosLp); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVAGAL', 'N', nRvaGtosAdLp); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVATOC', 'S', nRvaMatCp + nRvaGtosCp + nAjuInsufCpBa); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVATOC', 'N', nRvaMatAdCp + nRvaGtosAdCp + nAjuInsufCpAd); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVATOL', 'S', nRvaMatLp + nRvaGtosLp + nAjuInsufLpBa); 
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVATOL', 'N', nRvaMatAdLp + nRvaGtosAdLp + nAjuInsufLpAd); 

   IF NVL(cGeneroRva,'N') = 'N' THEN 
      RAISE_APPLICATION_ERROR(-20100,'NO Generó Reserva de Accidentes y Enfermedades: '|| cCodReserva||'. Revise si la Configuración está Activa.'); 
   END IF; 
EXCEPTION 
   WHEN OTHERS THEN 
      RAISE_APPLICATION_ERROR(-20100,'Error en Generación de Reserva Accidentes y Enfermedades: '|| cCodReserva||'-'||nIdPoliza ||'-'||nIDetPol||SQLERRM); 
END GENERAR_RESERVA; 

END OC_RESERVAS_TECNICAS_ACCYENF;
/

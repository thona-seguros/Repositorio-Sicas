--
-- OC_RESERVAS_TECNICAS_REC  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   PLAN_DE_PAGOS (Table)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   DETALLE_POLIZA (Table)
--   OC_CONFIG_RESERVAS_FACTORSUF (Package)
--   OC_CONFIG_RESERVAS_PLANCOB_GTO (Package)
--   TIPOS_DE_SEGUROS (Table)
--   OC_RESERVAS_TECNICAS_RES (Package)
--   RESERVAS_TECNICAS_REC (Table)
--   CONFIG_RESERVAS_PLANCOB (Table)
--   CONFIG_RESERVAS_PLANCOB_GTO (Table)
--   CONFIG_RESERVAS_TIPOSEG (Table)
--   COBERTURAS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   OC_TABLAS_MORTALIDAD (Package)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_ASEGURADO (Package)
--   OC_PLAN_DE_PAGOS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_RESERVAS_TECNICAS_REC AS 
PROCEDURE GENERAR_RESERVA(nIdReserva NUMBER, nCodCia NUMBER, cCodReserva VARCHAR2, dFecIniRva DATE, 
                          dFecFinRva DATE, dFecValuacion DATE, cParamFactorRva VARCHAR2); 
END OC_RESERVAS_TECNICAS_REC;
/

--
-- OC_RESERVAS_TECNICAS_REC  (Package Body) 
--
--  Dependencies: 
--   OC_RESERVAS_TECNICAS_REC (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_RESERVAS_TECNICAS_REC AS 

PROCEDURE GENERAR_RESERVA(nIdReserva NUMBER, nCodCia NUMBER, cCodReserva VARCHAR2, dFecIniRva DATE, 
                          dFecFinRva DATE, dFecValuacion DATE, cParamFactorRva VARCHAR2) IS 

cIdTipoSeg              CONFIG_RESERVAS_TIPOSEG.IdTipoSeg%TYPE; 
cPlanCob                CONFIG_RESERVAS_PLANCOB.PlanCob%TYPE; 
nCodEmpresa             CONFIG_RESERVAS_TIPOSEG.CodEmpresa%TYPE; 
nIdPoliza               POLIZAS.IdPoliza%TYPE; 
nIDetPol                DETALLE_POLIZA.IDetPol%TYPE; 
nSumaAsegurada          COBERTURAS.Suma_Asegurada_Local%TYPE; 
nEdad                   NUMBER(5); 
nPrimaEmitida           RESERVAS_TECNICAS_REC.PrimaEmitida%TYPE;
nNumPagosPend           RESERVAS_TECNICAS_REC.NumPagosPend%TYPE;
nPrimaRiesgo            RESERVAS_TECNICAS_REC.PrimaRiesgo%TYPE;
nPrimaDiferida          RESERVAS_TECNICAS_REC.PrimaDiferida%TYPE;
nFactorNoDev            RESERVAS_TECNICAS_REC.FactorNoDev%TYPE;
nFactorSuficiencia      RESERVAS_TECNICAS_REC.FactorSuficiencia%TYPE;
nPrimaNoDevengada       RESERVAS_TECNICAS_REC.PrimaNoDevengada%TYPE;
nTotalRRC               RESERVAS_TECNICAS_REC.TotalRRC%TYPE;
nRvaGastos              RESERVAS_TECNICAS_REC.RvaGastos%TYPE;
nPrimaDevolver          RESERVAS_TECNICAS_REC.PrimaDevolver%TYPE;
nTotalRRCFinal          RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nGtoAdmin               CONFIG_RESERVAS_PLANCOB_GTO.PorcGtoAdmin%TYPE; 
nGtoAdqui               CONFIG_RESERVAS_PLANCOB_GTO.PorcGtoAdqui%TYPE; 
nInteresTecnico         CONFIG_RESERVAS_PLANCOB_GTO.InteresTecnico%TYPE;
cCodRamo                TIPOS_DE_SEGUROS.CodTipoPlan%TYPE;
nNumPagos               PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos              PLAN_DE_PAGOS.FrecPagos%TYPE;
dFecFinRec              FACTURAS.FecVenc%TYPE;
dFecVenc                FACTURAS.FecVenc%TYPE;
nRvaMatCp               RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nRvaMatLp               RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nAjuInsufCpBa           RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nAjuInsufLpBa           RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nRvaGtosCp              RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nRvaGtosLp              RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nRvaMatAdCp             RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nRvaMatAdLp             RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nAjuInsufCpAd           RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nAjuInsufLpAd           RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nRvaGtosAdCp            RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nRvaGtosAdLp            RESERVAS_TECNICAS_REC.TotalRRCFinal%TYPE;
nIdFactura              FACTURAS.IdFactura%TYPE;
dFecIniVig              DATE;
dFecFinVig              DATE;
cGeneroRva              VARCHAR2(1); 
nAltura                 NUMBER(5); 

CURSOR CERTIF_Q IS 
   SELECT D.IdPoliza, D.IDetPol, D.IdTipoSeg, D.PlanCob, D.Cod_Asegurado, 
          D.CodCia, D.CodEmpresa, D.FecIniVig, D.FecFinVig, D.PorcComis,
          D.CodPlanPago
     FROM DETALLE_POLIZA D, CONFIG_RESERVAS_TIPOSEG TS, CONFIG_RESERVAS_PLANCOB PC
    WHERE PC.StsPlanRva    = 'ACT' 
      AND PC.CodEmpresa    = TS.CodEmpresa 
      AND PC.IdTipoSeg     = TS.IdTipoSeg 
      AND PC.CodReserva    = TS.CodReserva 
      AND PC.CodCia        = TS.CodCia 
      AND TS.CodReserva    = cCodReserva 
      AND TS.StsTipoSegRva = 'ACT'
      AND TS.IdTipoSeg     = D.IdTipoSeg
      AND D.StsDetalle     = 'EMI'
      AND D.FecIniVig     <= dFecValuacion
      AND D.FecFinVig      > dFecValuacion
      AND EXISTS (SELECT 'S'
                    FROM FACTURAS
                   WHERE CodCia                   = D.CodCia
                     AND IdPoliza                 = D.IdPoliza
                     AND IDetPol                  = D.IDetPol
                     AND IndContabilizada         = 'S'
                     AND TRUNC(FecContabilizada) <= dFecValuacion)
    UNION 
   SELECT D.IdPoliza, D.IDetPol, D.IdTipoSeg, D.PlanCob, D.Cod_Asegurado,
          D.CodCia, D.CodEmpresa, D.FecIniVig, D.FecFinVig, D.PorcComis,
          D.CodPlanPago
     FROM DETALLE_POLIZA D, CONFIG_RESERVAS_TIPOSEG TS, CONFIG_RESERVAS_PLANCOB PC
    WHERE PC.StsPlanRva    = 'ACT' 
      AND PC.CodEmpresa    = TS.CodEmpresa 
      AND PC.IdTipoSeg     = TS.IdTipoSeg 
      AND PC.CodReserva    = TS.CodReserva 
      AND PC.CodCia        = TS.CodCia 
      AND TS.CodReserva    = cCodReserva 
      AND TS.StsTipoSegRva = 'ACT'
      AND TS.IdTipoSeg     = D.IdTipoSeg
      AND D.StsDetalle    IN ('ANU','EXC') 
      AND D.FecAnul        > dFecValuacion
      AND D.FecAnul       != FecIniVig 
      AND D.FecIniVig     <= dFecValuacion
      AND EXISTS (SELECT 'S'
                    FROM FACTURAS
                   WHERE CodCia                   = D.CodCia
                     AND IdPoliza                 = D.IdPoliza
                     AND IDetPol                  = D.IDetPol
                     AND IndContabilizada         = 'S'
                     AND TRUNC(FecContabilizada) <= dFecValuacion);

CURSOR COB_Q IS 
   SELECT C.SumaAseg_Moneda, C.Prima_Moneda, CS.Cobertura_Basica,
          CS.TabMortalidad, C.Cod_Asegurado, C.CodCobert,
          CS.Devuelve_Prima
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
   SELECT C.SumaAseg_Moneda, C.Prima_Moneda, CS.Cobertura_Basica,
          CS.TabMortalidad, C.Cod_Asegurado, C.CodCobert,
          CS.Devuelve_Prima
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
   SELECT IdFactura, FecVenc
     FROM FACTURAS
    WHERE IdPoliza  = nIdPoliza
      AND IdEndoso  = 0
      AND IdFactura IN (SELECT MAX(IdFactura)
                          FROM FACTURAS
                         WHERE IdPoliza  = nIdPoliza
                           AND IdEndoso  = 0
                           AND StsFact  IN ('EMI','PAG','ABO')
                           AND FecVenc  <= dFecValuacion);
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
   FOR Z IN CERTIF_Q LOOP 
      cGeneroRva          := 'S'; 
      nIdPoliza           := Z.IdPoliza; 
      nIDetPol            := Z.IDetPol; 
      nCodEmpresa         := Z.CodEmpresa;
      cIdTipoSeg          := Z.IdTipoSeg; 
      cPlanCob            := Z.PlanCob;
      cCodRamo            := OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(Z.CodCia, nCodEmpresa, Z.IdTipoSeg);
      nNumPagos           := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(Z.CodCia, nCodEmpresa, Z.CodPlanPago);
      nFactorNoDev        := ROUND((TRUNC(Z.FecFinVig) - TRUNC(dFecValuacion)) / (TRUNC(Z.FecFinVig) - TRUNC(Z.FecIniVig)),6);
      nPrimaEmitida       := 0;
      nNumPagosPend       := 0;
      nPrimaRiesgo        := 0;
      nPrimaDiferida      := 0;
      nFactorSuficiencia  := 0;
      nPrimaNoDevengada   := 0;
      nTotalRRC           := 0;
      nRvaGastos          := 0;
      nPrimaDevolver      := 0;
      nTotalRRCFinal      := 0;

      SELECT CEIL(MONTHS_BETWEEN(Z.FecFinVig, Z.FecIniVig)/12) 
        INTO nAltura 
        FROM DUAL; 

      -- No. de Pagos Pendientes
      SELECT COUNT(*)
        INTO nNumPagosPend
        FROM FACTURAS
       WHERE IdPoliza = nIdPoliza
         AND IDetPol  = nIDetPol
         AND IdEndoso = 0
         AND StsFact  = 'EMI';

      FOR Y IN DET_Q LOOP
         nFrecPagos      := OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(Z.CodCia, nCodEmpresa, Z.CodPlanPago);
         dFecVenc        := Y.FecVenc;
         nIdFactura      := Y.IdFactura;
         IF nFrecPagos NOT IN (15,7) THEN
            dFecFinRec   := ADD_MONTHS(Y.FecVenc, nFrecPagos);
         ELSE
            dFecFinRec   := Y.FecVenc + nFrecPagos;
         END IF;
         IF dFecFinRec > Z.FecFinVig THEN
            dFecFinRec := Z.FecFinVig;
         END IF;
      END LOOP;

      FOR Y IN COB_Q LOOP 
         nEdad               := OC_ASEGURADO.EDAD_ASEGURADO(Z.CodCia, nCodEmpresa, Y.Cod_Asegurado, Z.FecIniVig);
         nSumaAsegurada      := Y.SumaAseg_Moneda;
         nPrimaEmitida       := Y.Prima_Moneda;
         nGtoAdmin           := OC_CONFIG_RESERVAS_PLANCOB_GTO.DEVUELVE_GASTO(Z.CodCia, cCodReserva, nCodEmpresa, Z.IdTipoSeg, 
                                                                              Z.PlanCob, 'PGA');
         nGtoAdqui           := Z.PorcComis / 100;
         nFactorSuficiencia  := OC_CONFIG_RESERVAS_FACTORSUF.FACTOR_SUFICIENCIA(Z.CodCia, cCodReserva, nCodEmpresa, 
                                                                                Z.IdTipoSeg, dFecValuacion);
         nInteresTecnico     := OC_CONFIG_RESERVAS_PLANCOB_GTO.DEVUELVE_GASTO(Z.CodCia, cCodReserva, nCodEmpresa, Z.IdTipoSeg, 
                                                                              Z.PlanCob, 'INT');
         nPrimaRiesgo        := nSumaAsegurada * (nInteresTecnico / LN(1 + nInteresTecnico)) * 
                                POWER((1 + nInteresTecnico),-1) * 
                                OC_TABLAS_MORTALIDAD.VALOR_QX(Z.CodCia, Y.TabMortalidad, 'U', 'U', nEdad);
         IF cCodRamo != '010' THEN
            nPrimaDiferida := 0;
         ELSE
            nPrimaDiferida := (nNumPagosPend * nPrimaRiesgo) / nNumPagos;
         END IF;

         nPrimaNoDevengada := (nPrimaRiesgo * nFactorNoDev) - nPrimaDiferida;
         nTotalRRC         := nPrimaNoDevengada * GREATEST(1, nFactorSuficiencia);
         IF cCodRamo != '010' THEN
            nRvaGastos     := nPrimaEmitida * nGtoAdmin * ((dFecFinRec - dFecValuacion) /  (dFecFinRec - dFecVenc));
         ELSE
            nRvaGastos     := nPrimaEmitida * nNumPagos * nGtoAdmin * ((dFecFinRec - dFecValuacion) /  (dFecFinRec - dFecVenc));
         END IF;
         IF Y.Devuelve_Prima = 'N' THEN
            nPrimaDevolver := 0;
         ELSE
            nPrimaDevolver := nPrimaEmitida * (1 - nGtoAdqui) * ((dFecFinRec - dFecValuacion) /  (dFecFinRec - dFecVenc));
         END IF;
         nTotalRRCFinal := GREATEST(NVL(nTotalRRC+nRvaGastos,0), NVL(nPrimaDevolver,0));
         BEGIN
            INSERT INTO RESERVAS_TECNICAS_REC
                   (IdReserva, IdPoliza, IdetPol, CodAsegurado, CodCobert, SumaAsegurada,
                    PrimaEmitida, NumPagosPend, IdFacturaVig, FecIniFact, FecFinFact,
                    PrimaRiesgo, PrimaDiferida, FactorNoDev, FactorSuficiencia,
                    PrimaNoDevengada, TotalRRC, RvaGastos, PrimaDevolver, TotalRRCFinal) 
            VALUES (nIdReserva, nIdPoliza, nIdetPol, Y.Cod_Asegurado, Y.CodCobert, nSumaAsegurada,
                    nPrimaEmitida, nNumPagosPend, nIdFactura, dFecVenc, dFecFinRec,
                    nPrimaRiesgo, nPrimaDiferida, nFactorNoDev, nFactorSuficiencia,
                    nPrimaNoDevengada, nTotalRRC, nRvaGastos, nPrimaDevolver, nTotalRRCFinal);
         EXCEPTION 
            WHEN DUP_VAL_ON_INDEX THEN 
               RAISE_APPLICATION_ERROR(-20100,'Cobertura Duplicado en Reserva para Póliza-Detalle-CodAsegurado-CodCobert: '|| 
                                       nIdPoliza ||'-'|| nIDetPol || '-' || Y.Cod_Asegurado || '-' || Y.CodCobert); 
         END; 

         IF NVL(nAltura,0) <= 1 THEN 
            IF NVL(Y.Cobertura_Basica,'N') = 'S' THEN
               nRvaMatCp       := ROUND(NVL(nRvaMatCp,0) + NVL(nTotalRRCFinal,0),2);
               nRvaGtosCp      := ROUND(NVL(nRvaGtosCp,0) + NVL(nRvaGastos,0),2);
            ELSE
               nRvaMatAdCp     := ROUND(NVL(nRvaMatAdCp,0) + NVL(nTotalRRCFinal,0),2); 
               nRvaGtosAdCp    := ROUND(NVL(nRvaGtosAdCp,0) + NVL(nRvaGastos,0),2);
            END IF;
         ELSE 
            IF NVL(Y.Cobertura_Basica,'N') = 'S' THEN
               nRvaMatLp       := ROUND(NVL(nRvaMatLp,0) + NVL(nTotalRRCFinal,0),2);
               nRvaGtosLp      := ROUND(NVL(nRvaGtosLp,0) + NVL(nRvaGastos,0),2);
            ELSE
               nRvaMatAdLp     := ROUND(NVL(nRvaMatAdLp,0) + NVL(nTotalRRCFinal,0),2);
               nRvaGtosAdLp    := ROUND(NVL(nRvaGtosAdLp,0) + NVL(nRvaGastos,0),2);
            END IF;
         END IF;
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
      RAISE_APPLICATION_ERROR(-20100,'NO Generó Reserva de Riesgos en Curso: '|| cCodReserva||'. Revise si la Configuración está Activa.'); 
   END IF; 
EXCEPTION 
   WHEN OTHERS THEN 
      RAISE_APPLICATION_ERROR(-20100,'Error en Generación de Reserva de Riesgos en Curso: '|| cCodReserva||'-'||nIdPoliza ||'-'||nIDetPol||SQLERRM); 
END GENERAR_RESERVA;

END OC_RESERVAS_TECNICAS_REC;
/

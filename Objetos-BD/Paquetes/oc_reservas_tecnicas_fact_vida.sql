--
-- OC_RESERVAS_TECNICAS_FACT_VIDA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   RESERVAS_TECNICAS_ACCYENF (Table)
--   RESERVAS_TECNICAS_FACT_VIDA (Table)
--   POLIZAS (Table)
--   CONFIG_RESERVAS_PLANCOB (Table)
--   CONFIG_RESERVAS_PLANCOB_GTO (Table)
--   CONFIG_RESERVAS_TIPOSEG (Table)
--   OC_CONFIG_RESERVAS_FACTORSUF (Package)
--   OC_CONFIG_RESERVAS_FACTOR_EDAD (Package)
--   OC_CONFIG_RESERVAS_PLANCOB_GTO (Package)
--   COBERTURAS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   OC_ASEGURADO (Package)
--   DETALLE_POLIZA (Table)
--   OC_RESERVAS_TECNICAS_RES (Package)
--   OC_SINIESTRO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_RESERVAS_TECNICAS_FACT_VIDA AS
PROCEDURE generar_reserva(nidreserva NUMBER, ncodcia NUMBER, ccodreserva VARCHAR2, dfecinirva DATE,
                          dfecfinrva DATE, dfecvaluacion DATE, cparamfactorrva VARCHAR2);
END OC_RESERVAS_TECNICAS_FACT_VIDA;
/

--
-- OC_RESERVAS_TECNICAS_FACT_VIDA  (Package Body) 
--
--  Dependencies: 
--   OC_RESERVAS_TECNICAS_FACT_VIDA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_RESERVAS_TECNICAS_FACT_VIDA AS

PROCEDURE generar_reserva(nidreserva NUMBER, ncodcia NUMBER, ccodreserva VARCHAR2, dfecinirva DATE,
                          dfecfinrva DATE, dfecvaluacion DATE, cparamfactorrva VARCHAR2) IS

cidtiposeg              CONFIG_RESERVAS_TIPOSEG.idtiposeg%TYPE;
cplancob                CONFIG_RESERVAS_PLANCOB.plancob%TYPE;
ncodempresa             CONFIG_RESERVAS_TIPOSEG.codempresa%TYPE;
nidpoliza               POLIZAS.idpoliza%TYPE;
nidetpol                DETALLE_POLIZA.idetpol%TYPE;
nsumaasegurada          COBERTURAS.suma_asegurada_local%TYPE;
nedad                   NUMBER(5);
nprimabasica            RESERVAS_TECNICAS_FACT_VIDA.primabasica%TYPE;
nprimaadic              RESERVAS_TECNICAS_FACT_VIDA.primaadic%TYPE;
nprimariesgobasica      RESERVAS_TECNICAS_FACT_VIDA.primariesgobasica%TYPE;
nprimariesgoadic        RESERVAS_TECNICAS_FACT_VIDA.primariesgoadic%TYPE;
nfactornodev            RESERVAS_TECNICAS_FACT_VIDA.factornodev%TYPE;
nfactorprbasica         RESERVAS_TECNICAS_FACT_VIDA.factorprbasica%TYPE;
nfactorpradic           RESERVAS_TECNICAS_FACT_VIDA.factorpradic%TYPE;
nrvatotalbasica         RESERVAS_TECNICAS_FACT_VIDA.rvatotalbasica%TYPE;
nrvatotaladic           RESERVAS_TECNICAS_FACT_VIDA.rvatotaladic%TYPE;
ngastoadminbasica       RESERVAS_TECNICAS_FACT_VIDA.gastoadminbasica%TYPE;
ngastoadminadic         RESERVAS_TECNICAS_FACT_VIDA.gastoadminadic%TYPE;
ngtoadmin               CONFIG_RESERVAS_PLANCOB_GTO.porcgtoadmin%TYPE;
ngtoadqui               CONFIG_RESERVAS_PLANCOB_GTO.porcgtoadqui%TYPE;
nporcutilidad           CONFIG_RESERVAS_PLANCOB_GTO.porcutilidad%TYPE;
ntotalgastos            CONFIG_RESERVAS_PLANCOB_GTO.porcgtoadmin%TYPE;
nfactorptbasica         RESERVAS_TECNICAS_FACT_VIDA.factorptbasica%TYPE;
nfactorptadic           RESERVAS_TECNICAS_FACT_VIDA.factorptadic%TYPE;
nfactutilidad           RESERVAS_TECNICAS_FACT_VIDA.factutilidad%TYPE;
nporcdevolucion         RESERVAS_TECNICAS_FACT_VIDA.porcdevolucion%TYPE;
nfactgtoadqui           RESERVAS_TECNICAS_FACT_VIDA.factgtoadqui%TYPE;
nrvamatcpba             RESERVAS_TECNICAS_FACT_VIDA.rvatotalbasica%TYPE;
nrvamatcpad             RESERVAS_TECNICAS_FACT_VIDA.rvatotaladic%TYPE;
najuinsufcpba           RESERVAS_TECNICAS_FACT_VIDA.ajusteinsufbasica%TYPE;
najuinsufcpad           RESERVAS_TECNICAS_FACT_VIDA.ajusteinsufadic%TYPE;
nrvamatlpba             RESERVAS_TECNICAS_FACT_VIDA.rvatotalbasica%TYPE;
nrvamatlpad             RESERVAS_TECNICAS_FACT_VIDA.rvatotalbasica%TYPE;
najuinsuflpba           RESERVAS_TECNICAS_FACT_VIDA.ajusteinsufadic%TYPE;
najuinsuflpad           RESERVAS_TECNICAS_FACT_VIDA.rvasufadic%TYPE;
nrvagtoscpba            RESERVAS_TECNICAS_FACT_VIDA.gastoadminbasica%TYPE;
nrvagtoscpad            RESERVAS_TECNICAS_FACT_VIDA.gastoadminbasica%TYPE;
nrvagtoslpba            RESERVAS_TECNICAS_FACT_VIDA.gastoadminbasica%TYPE;
nrvagtoslpad            RESERVAS_TECNICAS_FACT_VIDA.gastoadminbasica%TYPE;
nfactsuficiencia        RESERVAS_TECNICAS_FACT_VIDA.factsuficiencia%TYPE;
najusteinsufbasica      RESERVAS_TECNICAS_FACT_VIDA.ajusteinsufbasica%TYPE;
najusteinsufadic        RESERVAS_TECNICAS_FACT_VIDA.ajusteinsufadic%TYPE;
ncostoadquibasica       RESERVAS_TECNICAS_FACT_VIDA.costoadquibasica%TYPE;
ncostoadquiadic         RESERVAS_TECNICAS_FACT_VIDA.costoadquiadic%TYPE;
nmargenutilbasica       RESERVAS_TECNICAS_FACT_VIDA.margenutilbasica%TYPE;
nmargenutiladic         RESERVAS_TECNICAS_FACT_VIDA.margenutiladic%TYPE;
ndevolucionbasica       RESERVAS_TECNICAS_FACT_VIDA.devolucionbasica%TYPE;
ndevolucionadic         RESERVAS_TECNICAS_FACT_VIDA.devolucionadic%TYPE;
ndevoluciontotal        RESERVAS_TECNICAS_FACT_VIDA.devoluciontotal%TYPE;
nrvasufbasica           RESERVAS_TECNICAS_FACT_VIDA.rvasufbasica%TYPE;
nrvasufadic             RESERVAS_TECNICAS_FACT_VIDA.rvasufadic%TYPE;
nrvaprimabasica         RESERVAS_TECNICAS_ACCYENF.rvaprimabasica%TYPE;
nrvaprimaadic           RESERVAS_TECNICAS_ACCYENF.rvaprimaadic%TYPE;
cgenerorva              VARCHAR2(1);
naltura                 NUMBER(5);

CURSOR tiposeg_q IS
   SELECT ts.idtiposeg, ts.codempresa, pc.plancob
     FROM CONFIG_RESERVAS_TIPOSEG ts, CONFIG_RESERVAS_PLANCOB pc
    WHERE pc.stsplanrva    = 'ACT'
      AND pc.codempresa    = ts.codempresa
      AND pc.idtiposeg     = ts.idtiposeg
      AND pc.codreserva    = ts.codreserva
      AND pc.codcia        = ts.codcia
      AND ts.codreserva    = ccodreserva
      AND ts.ststiposegrva = 'ACT';
CURSOR certif_q IS
   SELECT idpoliza, idetpol, idtiposeg, plancob,
          cod_asegurado, codcia, codempresa,
          fecinivig, fecfinvig
     FROM DETALLE_POLIZA
    WHERE stsdetalle  = 'EMI'
      AND fecinivig  <= dfecfinrva
      AND (fecfinvig >= dfecfinrva
       OR fecfinvig   >  dfecinirva)
      AND plancob     = cplancob
      AND idtiposeg   = cidtiposeg
      AND codempresa  = ncodempresa
      AND codcia      = ncodcia
    UNION
   SELECT idpoliza, idetpol, idtiposeg, plancob,
          cod_asegurado, codcia, codempresa,
          fecinivig, fecfinvig
     FROM DETALLE_POLIZA
    WHERE stsdetalle  IN ('ANU','EXC')
      AND fecanul     > dfecvaluacion --dFecIniRva
      AND fecanul    != fecinivig
--> MGC 19/JUN/2012 
      AND fecinivig   <= dfecvaluacion
--> MGC 19/JUN/2012 
      AND plancob     = cplancob
      AND idtiposeg   = cidtiposeg
      AND codempresa  = ncodempresa
      AND codcia      = ncodcia;

CURSOR cob_q IS
   SELECT c.suma_asegurada_local, c.prima_local, cs.cobertura_basica
     FROM COBERTURAS c, COBERTURAS_DE_SEGUROS cs
    WHERE cs.codcobert    = c.codcobert
      AND cs.plancob      = c.plancob
      AND cs.idtiposeg    = c.idtiposeg
      AND cs.codempresa   = c.codempresa
      AND cs.codcia       = c.codcia
      AND c.stscobertura IN ('EMI','ANU')
      AND c.prima_local  != 0
      AND c.plancob       = cplancob
      AND c.idtiposeg     = cidtiposeg
      AND c.codempresa    = ncodempresa
      AND c.idetpol       = nidetpol
      AND c.idpoliza      = nidpoliza
      AND c.codcia        = ncodcia;
BEGIN
   cgenerorva := 'N';
   nrvamatcpba   := 0;
   nrvamatcpad   := 0;
   najuinsufcpba := 0;
   najuinsufcpad := 0;
   nrvamatlpba   := 0;
   nrvamatlpad   := 0;
   najuinsuflpba := 0;
   najuinsuflpad := 0;
   nrvagtoscpba  := 0;
   nrvagtoscpad  := 0;
   nrvagtoslpba  := 0;
   nrvagtoslpad  := 0;
   FOR w IN tiposeg_q LOOP
      cgenerorva   := 'S';
      ncodempresa := w.codempresa;
      cidtiposeg  := w.idtiposeg;
      cplancob    := w.plancob;
      FOR z IN certif_q LOOP
         IF OC_SINIESTRO.tiene_siniestro(ncodcia, z.idpoliza, z.idetpol, dfecvaluacion) = 'N' THEN
            nidpoliza        := z.idpoliza;
            nidetpol         := z.idetpol;
            nedad            := OC_ASEGURADO.edad_asegurado(ncodcia, ncodempresa, z.cod_asegurado, z.fecinivig);

            SELECT CEIL(MONTHS_BETWEEN(z.fecfinvig, z.fecinivig)/12)
              INTO naltura
              FROM dual;

            nprimabasica       := 0;
            nprimaadic         := 0;
            nprimariesgobasica := 0;
            nprimariesgoadic   := 0;
            nrvatotalbasica    := 0;
            nrvatotaladic      := 0;
            ngastoadminbasica  := 0;
            ngastoadminadic    := 0;
            nfactsuficiencia   := 0;
            najusteinsufbasica := 0;
            najusteinsufadic   := 0;
            ncostoadquibasica  := 0;
            ncostoadquiadic    := 0;
            nmargenutilbasica  := 0;
            nmargenutiladic    := 0;
            ndevolucionbasica  := 0;
            ndevolucionadic    := 0;
            ndevoluciontotal   := 0;
            nrvasufbasica      := 0;
            nrvasufadic        := 0;
            nrvaprimabasica    := 0;
            nrvaprimaadic      := 0;

            -- Factor NO Devengado
            IF TRUNC(z.fecfinvig) < TRUNC(dfecvaluacion) THEN
               nfactornodev := 0;
            ELSIF TRUNC(z.fecinivig) > TRUNC(dfecvaluacion) THEN
               nfactornodev := 1;
            ELSE
               nfactornodev := ROUND(ABS((TRUNC(z.fecfinvig) - TRUNC(dfecvaluacion)) / (TRUNC(z.fecfinvig) - TRUNC(z.fecinivig))),3);
            END IF;

            FOR y IN cob_q LOOP
               IF y.cobertura_basica = 'S' THEN
                  nsumaasegurada := y.suma_asegurada_local;
                  nprimabasica   := NVL(nprimabasica,0) + y.prima_local;
               ELSE
                  nprimaadic     := NVL(nprimaadic,0) + y.prima_local;
               END IF;
            END LOOP;

            -- Lee y Calcula Factores para Reserva
            nfactorprbasica    := OC_CONFIG_RESERVAS_FACTOR_EDAD.factor(ncodcia, ccodreserva, nedad, 'BA');
            nfactorpradic      := OC_CONFIG_RESERVAS_FACTOR_EDAD.factor(ncodcia, ccodreserva, nedad, 'AD');

            ngtoadmin          := OC_CONFIG_RESERVAS_PLANCOB_GTO.devuelve_gasto(ncodcia, ccodreserva, ncodempresa, cidtiposeg,
                                                                                cplancob, 'PGA');
            ngtoadqui          := OC_CONFIG_RESERVAS_PLANCOB_GTO.devuelve_gasto(ncodcia, ccodreserva, ncodempresa, cidtiposeg,
                                                                                cplancob, 'PAD');
            nporcutilidad      := OC_CONFIG_RESERVAS_PLANCOB_GTO.devuelve_gasto(ncodcia, ccodreserva, ncodempresa, cidtiposeg,
                                                                                cplancob, 'PUT');
            -- Calculo de Reservas y Gastos
            ntotalgastos       := NVL(ngtoadmin,0) + NVL(ngtoadqui,0) + NVL(nporcutilidad,0);
            nfactorptbasica    := ROUND(NVL(nfactorprbasica,0) / (1 - NVL(ntotalgastos,0)),3);
            nfactorptadic      := ROUND(NVL(nfactorpradic,0) / (1 - NVL(ntotalgastos,0)),3);
            nprimariesgobasica := ROUND(NVL(nfactorprbasica,0) * nsumaasegurada / 1000,0);
            nprimariesgoadic   := ROUND(NVL(nfactorpradic,0) * nsumaasegurada / 1000,0);
            nrvatotalbasica    := ROUND(NVL(nprimariesgobasica,0) * nfactornodev,0);
            nrvatotaladic      := ROUND(NVL(nprimariesgoadic,0) * nfactornodev,0);
            ngastoadminbasica  := ROUND(NVL(nprimabasica,0) * nfactornodev * NVL(ngtoadmin,0),0);
            ngastoadminadic    := ROUND(NVL(nprimaadic,0) * nfactornodev * NVL(ngtoadmin,0),0);
            nfactsuficiencia   := OC_CONFIG_RESERVAS_FACTORSUF.factor_suficiencia(ncodcia, ccodreserva, ncodempresa,
                                                                                  cidtiposeg, dfecvaluacion);

            nfactutilidad      := OC_CONFIG_RESERVAS_FACTORSUF.factor_utilidad(ncodcia, ccodreserva, ncodempresa,
                                                                               cidtiposeg, dfecvaluacion);
            nporcdevolucion    := OC_CONFIG_RESERVAS_FACTORSUF.porcentaje_devolucion(ncodcia, ccodreserva, ncodempresa,
                                                                                     cidtiposeg, dfecvaluacion);
            nfactgtoadqui      := OC_CONFIG_RESERVAS_FACTORSUF.factor_gtosadq(ncodcia, ccodreserva, ncodempresa,
                                                                              cidtiposeg, dfecvaluacion);

            najusteinsufbasica := ROUND(nrvatotalbasica * (nfactsuficiencia - 1),0);
            najusteinsufadic   := ROUND(nrvatotaladic * (nfactsuficiencia - 1),0);
            ncostoadquibasica  := ROUND(nprimabasica * ngtoadqui,0);
            ncostoadquiadic    := ROUND(nprimaadic * ngtoadqui,0);
            nmargenutilbasica  := ROUND(nprimabasica * nporcutilidad,0);
            nmargenutiladic    := ROUND(nprimaadic * nporcutilidad,0);
            ndevolucionbasica  := ROUND((nporcdevolucion * (nprimabasica - (nfactgtoadqui * ncostoadquibasica) - (nmargenutilbasica * nfactutilidad)) * nfactornodev),0);
            ndevolucionadic    := ROUND((nporcdevolucion * (nprimaadic - (nfactgtoadqui * ncostoadquiadic) - (nmargenutiladic * nfactutilidad)) * nfactornodev),0);
            ndevoluciontotal   := ROUND(ndevolucionbasica + ndevolucionadic,0);
            nrvasufbasica      := ROUND(GREATEST((nrvatotalbasica + ngastoadminbasica + najusteinsufbasica),ndevolucionbasica),0);
            nrvasufadic        := ROUND(GREATEST((nrvatotaladic + ngastoadminadic + najusteinsufadic),ndevolucionadic),0);
            nrvaprimabasica    := nrvasufbasica - najusteinsufbasica - ngastoadminbasica;
            nrvaprimaadic      := nrvasufadic - najusteinsufadic - ngastoadminadic;

            IF NVL(naltura,0) <= 1 THEN
               nrvamatcpba     := NVL(nrvamatcpba,0) + NVL(nrvaprimabasica,0);
               nrvamatcpad     := NVL(nrvamatcpad,0) + NVL(nrvaprimaadic,0);
               nrvagtoscpba    := NVL(nrvagtoscpba,0) + NVL(ngastoadminbasica,0);
               nrvagtoscpad    := NVL(nrvagtoscpad,0) + NVL(ngastoadminadic,0);
               najuinsufcpba   := NVL(najuinsufcpba,0) + NVL(najusteinsufbasica,0);
               najuinsufcpad   := NVL(najuinsufcpad,0) + NVL(najusteinsufadic,0);
            ELSE
               nrvamatlpba     := NVL(nrvamatlpba,0) + NVL(nrvaprimabasica,0);
               nrvamatlpad     := NVL(nrvamatlpad,0) + NVL(nrvaprimaadic,0);
               nrvagtoslpba    := NVL(nrvagtoslpba,0) + NVL(ngastoadminbasica,0);
               nrvagtoslpad    := NVL(nrvagtoslpad,0)+ NVL(ngastoadminadic,0);
               najuinsuflpba   := NVL(najuinsuflpba,0) + NVL(najusteinsufbasica,0);
               najuinsuflpad   := NVL(najuinsuflpad,0) + NVL(najusteinsufadic,0);
            END IF;

            IF NVL(nrvatotalbasica,0) + NVL(nrvatotaladic,0) != 0 THEN
               BEGIN
                  INSERT INTO RESERVAS_TECNICAS_FACT_VIDA
                         (idreserva, idpoliza, idetpol, sumaasegurada, primabasica,
                          primaadic, primariesgobasica, primariesgoadic, factornodev,
                          factorprbasica, factorpradic, factorptbasica, factorptadic,
              rvatotalbasica, rvatotaladic, gastoadminbasica, gastoadminadic,
                          factsuficiencia, ajusteinsufbasica, ajusteinsufadic,
                          porcgastosadqui, porcutilidad, costoadquibasica, costoadquiadic,
                          margenutilbasica, margenutiladic, devolucionbasica, devolucionadic,
                          devoluciontotal, rvasufbasica, rvasufadic, factutilidad,
                          porcdevolucion, factgtoadqui, rvaprimabasica, rvaprimaadic)
                  VALUES (nidreserva, nidpoliza, nidetpol, nsumaasegurada, nprimabasica,
                          nprimaadic, nprimariesgobasica, nprimariesgoadic, nfactornodev,
                          nfactorprbasica, nfactorpradic, nfactorptbasica, nfactorptadic,
                          nrvatotalbasica, nrvatotaladic, ngastoadminbasica, ngastoadminadic,
                          nfactsuficiencia, najusteinsufbasica, najusteinsufadic,
                          ngtoadqui * 100, nporcutilidad * 100, ncostoadquibasica, ncostoadquiadic,
                          nmargenutilbasica, nmargenutiladic, ndevolucionbasica, ndevolucionadic,
                          ndevoluciontotal, nrvasufbasica, nrvasufadic, nfactutilidad,
                          nporcdevolucion * 100, nfactgtoadqui, nrvaprimabasica, nrvaprimaadic);
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     RAISE_APPLICATION_ERROR(-20100,'Certificado Duplicado en Reserva para Poliza-Detalle: '|| nidpoliza ||'-'||nidetpol);
               END;
            END IF;
         END IF;
      END LOOP;
   END LOOP;
   -- Resumen de Reservas para Corto y Largo Plazo
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVAPTC', 'S', nrvamatcpba);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVAPTC', 'N', nrvamatcpad);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVAPTL', 'S', nrvamatlpba);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVAPTL', 'N', nrvamatlpad);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'INSUFC', 'S', najuinsufcpba);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'INSUFC', 'N', najuinsufcpad);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'INSUFL', 'S', najuinsuflpba);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'INSUFL', 'N', najuinsuflpad);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVAGAC', 'S', nrvagtoscpba);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVAGAC', 'N', nrvagtoscpad);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVAGAL', 'S', nrvagtoslpba);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVAGAL', 'N', nrvagtoslpad);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVATOC', 'S', nrvamatcpba + nrvagtoscpba + najuinsufcpba);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVATOC', 'N', nrvamatcpad + nrvagtoscpad + najuinsufcpad);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVATOL', 'S', nrvamatlpba + nrvagtoslpba + najuinsuflpba);
   OC_RESERVAS_TECNICAS_RES.inserta_resumen(nidreserva, 'RVATOL', 'N', nrvamatlpad + nrvagtoslpad + najuinsuflpad);

   IF NVL(cgenerorva,'N') = 'N' THEN
      RAISE_APPLICATION_ERROR(-20100,'NO Genero Reservas de Vida Individual: '|| ccodreserva||'. Revise si la Configuracion esta Activa.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error en Generacion de Reserva de Vida Individual: '|| ccodreserva||'-'||nidpoliza ||'-'||nidetpol||SQLERRM);
END generar_reserva;

END OC_RESERVAS_TECNICAS_FACT_VIDA;
/

--
-- OC_RESERVAS_TECNICAS_FACT_VIDA  (Synonym) 
--
--  Dependencies: 
--   OC_RESERVAS_TECNICAS_FACT_VIDA (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_RESERVAS_TECNICAS_FACT_VIDA FOR SICAS_OC.OC_RESERVAS_TECNICAS_FACT_VIDA
/


GRANT EXECUTE ON SICAS_OC.OC_RESERVAS_TECNICAS_FACT_VIDA TO PUBLIC
/

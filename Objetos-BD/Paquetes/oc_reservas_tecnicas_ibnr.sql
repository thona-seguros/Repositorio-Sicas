--
-- OC_RESERVAS_TECNICAS_IBNR  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FACTURAS (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_POLIZA (Table)
--   OC_CONFIG_RESERVAS (Package)
--   OC_CONFIG_RESERVAS_PLAN_IBNR (Package)
--   TRANSACCION (Table)
--   OC_RESERVAS_TECNICAS_GAAS (Package)
--   OC_RESERVAS_TECNICAS_RES (Package)
--   RESERVAS_TECNICAS (Table)
--   RESERVAS_TECNICAS_GAAS (Table)
--   RESERVAS_TECNICAS_IBNR (Table)
--   CONFIG_RESERVAS_PLANCOB (Table)
--   CONFIG_RESERVAS_TIPOSEG (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_RESERVAS_TECNICAS_IBNR AS
PROCEDURE GENERAR_RESERVA(nIdReserva NUMBER, nCodCia NUMBER, cCodReserva VARCHAR2, dFecIniRva DATE, 
                          dFecFinRva DATE, dFecValuacion DATE, cParamFactorRva VARCHAR2);
PROCEDURE INSERTAR_TRIMESTRE(nIdReserva NUMBER, nIdTrimestre NUMBER, nPrimaNetaTrim NUMBER);
PROCEDURE RESERVA_TRIMESTRE_ANTERIOR(nIdReservaAnt NUMBER, nIdReserva NUMBER);
END OC_RESERVAS_TECNICAS_IBNR;
/

--
-- OC_RESERVAS_TECNICAS_IBNR  (Package Body) 
--
--  Dependencies: 
--   OC_RESERVAS_TECNICAS_IBNR (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_RESERVAS_TECNICAS_IBNR AS

PROCEDURE GENERAR_RESERVA(nIdReserva NUMBER, nCodCia NUMBER, cCodReserva VARCHAR2, dFecIniRva DATE,
                          dFecFinRva DATE, dFecValuacion DATE, cParamFactorRva VARCHAR2) IS

nIdReservaAnt           RESERVAS_TECNICAS.IdReserva%TYPE;
nIdTrimestre            RESERVAS_TECNICAS_IBNR.IdTrimestre%TYPE;
nIdTrimestreAnt         RESERVAS_TECNICAS_IBNR.IdTrimestre%TYPE;
nPrimaNetaTrim          RESERVAS_TECNICAS_IBNR.PrimaNetaTrim%TYPE;
nPrimaNetaTrimTot       RESERVAS_TECNICAS_IBNR.PrimaNetaTrim%TYPE;
nPrimaNetaAcumIBNR      RESERVAS_TECNICAS_IBNR.PrimaNetaTrim%TYPE;
nPrimaNetaAcumGAAS      RESERVAS_TECNICAS_IBNR.PrimaNetaTrim%TYPE;
nConstReservaIBNR       RESERVAS_TECNICAS_IBNR.ConstReserva%TYPE;
nRRCVidaIndIBNR         RESERVAS_TECNICAS_IBNR.RRCVidaInd%TYPE;
nRRCVidaIndIBNRTemp     RESERVAS_TECNICAS_IBNR.RvaAcumTrim%TYPE;
nRvaAcumTrimIBNR        RESERVAS_TECNICAS_IBNR.RvaAcumTrim%TYPE;
nLimSupReservaIBNR      RESERVAS_TECNICAS_IBNR.LimSupReserva%TYPE;
nRvaTotTrimestreIBNR    RESERVAS_TECNICAS_IBNR.RvaTotTrimestre%TYPE;
nPrimaCedidaIBNR        RESERVAS_TECNICAS_IBNR.PrimaCedida%TYPE;
nFactorCedidaIBNR       RESERVAS_TECNICAS_IBNR.FactorCedida%TYPE;
nRvaReasegCedidoIBNR    RESERVAS_TECNICAS_IBNR.RvaReasegCedido%TYPE;
nConstReservaGAAS       RESERVAS_TECNICAS_GAAS.ConstReserva%TYPE;
nRRCVidaIndGAAS         RESERVAS_TECNICAS_GAAS.RRCVidaInd%TYPE;
nRRCVidaIndGAASTemp     RESERVAS_TECNICAS_GAAS.RRCVidaInd%TYPE;
nRvaAcumTrimGAAS        RESERVAS_TECNICAS_GAAS.RvaAcumTrim%TYPE;
nLimSupReservaGAAS      RESERVAS_TECNICAS_GAAS.LimSupReserva%TYPE;
nRvaTotTrimestreGAAS    RESERVAS_TECNICAS_GAAS.RvaTotTrimestre%TYPE;
nPrimaCedidaGAAS        RESERVAS_TECNICAS_GAAS.PrimaCedida%TYPE;
nFactorCedidaGAAS       RESERVAS_TECNICAS_GAAS.FactorCedida%TYPE;
nRvaReasegCedidoGAAS    RESERVAS_TECNICAS_GAAS.RvaReasegCedido%TYPE;
cGeneroRva              VARCHAR2(1);
nTrimTotal              NUMBER(5) := OC_CONFIG_RESERVAS.TRIMESTRES(nCodCia, cCodReserva);
dFecIniTrim             DATE;
dFecFinTrim             DATE;
nContador               NUMBER(5);

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
CURSOR TRIM_IBNR_Q IS
   SELECT IdTrimestre
     FROM RESERVAS_TECNICAS_IBNR
    WHERE IdReserva   = nIdReserva
      AND IdTrimestre > nIdTrimestre;
CURSOR TRIM_GAAS_Q IS
   SELECT IdTrimestre
     FROM RESERVAS_TECNICAS_GAAS
    WHERE IdReserva   = nIdReserva
      AND IdTrimestre > nIdTrimestre;
BEGIN
   cGeneroRva := 'N';

   SELECT NVL(MAX(IdReserva),0)
     INTO nIdReservaAnt
     FROM RESERVAS_TECNICAS
    WHERE CodReserva = cCodReserva
      AND IdReserva  < nIdReserva;

   IF nIdReservaAnt != 0 THEN
      OC_RESERVAS_TECNICAS_IBNR.RESERVA_TRIMESTRE_ANTERIOR(nIdReservaAnt, nIdReserva);
      OC_RESERVAS_TECNICAS_GAAS.RESERVA_TRIMESTRE_ANTERIOR(nIdReservaAnt, nIdReserva);
   ELSE
      dFecIniTrim := TO_DATE('01/01/2009','DD/MM/YYYY');
      dFecFinTrim := ADD_MONTHS(dFecIniTrim,3);
      FOR X IN 1..nTrimTotal LOOP
         nIdTrimestre := TO_CHAR(dFecIniTrim,'YYYY') || LPAD(CEIL(TO_NUMBER(TO_CHAR(dFecIniTrim,'MM')) / 3),2,'0');
         -- Realizar Sumatoria de Pólizas y Primas 
         OC_RESERVAS_TECNICAS_IBNR.INSERTAR_TRIMESTRE(nIdReserva, nIdTrimestre, 0);
         OC_RESERVAS_TECNICAS_GAAS.INSERTAR_TRIMESTRE(nIdReserva, nIdTrimestre, 0);
         dFecIniTrim     := dFecFinTrim;
         dFecFinTrim     := ADD_MONTHS(dFecIniTrim,3);
      END LOOP;
   END IF;
   -- Determina Trimestre de Reserva
   nIdTrimestre          := TO_CHAR(dFecFinRva,'YYYY') || LPAD(CEIL(TO_NUMBER(TO_CHAR(dFecFinRva,'MM')) / 3),2,'0');
   nIdTrimestreAnt       := TO_CHAR(ADD_MONTHS(dFecFinRva,-9),'YYYY') || LPAD(CEIL(TO_NUMBER(TO_CHAR(ADD_MONTHS(dFecFinRva,-9),'MM')) / 3),2,'0');
   nPrimaNetaTrim        := 0;
   nPrimaNetaTrimTot     := 0;
        nConstReservaIBNR     := 0;
        nRRCVidaIndIBNR       := 0;
        nRRCVidaIndIBNRTemp   := 0;
        nRvaAcumTrimIBNR      := 0;
        nLimSupReservaIBNR    := 0;
        nRvaTotTrimestreIBNR  := 0;
        nPrimaCedidaIBNR      := 0;
        nFactorCedidaIBNR     := 0;
        nRvaReasegCedidoIBNR  := 0;
        nConstReservaGAAS     := 0;
        nRRCVidaIndGAAS       := 0;
        nRRCVidaIndGAASTemp   := 0;
        nRvaAcumTrimGAAS      := 0;
        nLimSupReservaGAAS    := 0;
        nRvaTotTrimestreGAAS  := 0;
        nPrimaCedidaGAAS      := 0;
        nFactorCedidaGAAS     := 0;
        nRvaReasegCedidoGAAS  := 0;

   -- Prima Emitida IBNR
   SELECT NVL(SUM(PrimaNetaTrim),0)
     INTO nPrimaNetaAcumIBNR
     FROM RESERVAS_TECNICAS_IBNR
    WHERE IdReserva    = nIdReserva
           AND IdTrimestre >= nIdTrimestreAnt
           AND IdTrimestre <= nIdTrimestre;

   -- Prima Emitida GAAS
   SELECT NVL(SUM(PrimaNetaTrim),0)
     INTO nPrimaNetaAcumGAAS
     FROM RESERVAS_TECNICAS_GAAS
    WHERE IdReserva    = nIdReserva
           AND IdTrimestre >= nIdTrimestreAnt
           AND IdTrimestre <= nIdTrimestre;

   FOR W IN TIPOSEG_Q LOOP
      cGeneroRva  := 'S';
                SELECT NVL(SUM(DF.Monto_Det_Local),0)
                  INTO nPrimaNetaTrim
                  FROM TRANSACCION T, FACTURAS F, DETALLE_FACTURAS DF, DETALLE_POLIZA D, CATALOGO_DE_CONCEPTOS C
                 WHERE T.FechaTransaccion >= dFecIniRva
                   AND T.FechaTransaccion <= dFecFinRva
                   AND F.IdTransaccion     = T.IdTransaccion
                   AND DF.IdFactura        = F.IdFactura
                   AND D.IdPoliza          = F.IdPoliza
                   AND D.IDetPol           = F.IDetPol
                   AND D.PlanCob           = W.PlanCob
                   AND D.IdTipoSeg         = W.IdTipoSeg
                   AND D.CodEmpresa        = W.CodEmpresa
                   AND D.CodCia            = nCodCia
         AND C.CodCia            = F.CodCia
         AND C.CodConcepto       = DF.CodCpto
         AND (C.IndCptoServicio  = 'S'
          OR  C.IndCptoPrimas    = 'S');

      nPrimaNetaTrimTot   := NVL(nPrimaNetaTrimTot,0) + NVL(nPrimaNetaTrim,0);
      nConstReservaIBNR   := NVL(nConstReservaIBNR,0) + 
                                       (OC_CONFIG_RESERVAS_PLAN_IBNR.FACTOR_RVA_IBNR(nCodCia, cCodReserva, W.CodEmpresa, W.IdTipoSeg, 
                                                                           W.PlanCob, dFecFinRva) * NVL(nPrimaNetaTrim,0));
      nConstReservaGAAS   := NVL(nConstReservaGAAS,0) + 
                                       (OC_CONFIG_RESERVAS_PLAN_IBNR.FACTOR_RVA_GAAS(nCodCia, cCodReserva, W.CodEmpresa, W.IdTipoSeg, 
                                                                           W.PlanCob, dFecFinRva) * NVL(nPrimaNetaTrim,0));
      nRRCVidaIndIBNRTemp := NVL(nRRCVidaIndIBNRTemp,0) *
                             OC_CONFIG_RESERVAS_PLAN_IBNR.FACTOR_RVA_IBNR(nCodCia, cCodReserva, W.CodEmpresa, W.IdTipoSeg, 
                                                                          W.PlanCob, dFecFinRva);
      nRRCVidaIndIBNR     := NVL(nRRCVidaIndIBNR,0) + NVL(nRRCVidaIndIBNRTemp,0);

      nRRCVidaIndGAASTemp := NVL(nRRCVidaIndGAASTemp,0) *
                             OC_CONFIG_RESERVAS_PLAN_IBNR.FACTOR_RVA_GAAS(nCodCia, cCodReserva, W.CodEmpresa, W.IdTipoSeg, 
                                                                          W.PlanCob, dFecFinRva);
      nRRCVidaIndGAAS     := NVL(nRRCVidaIndGAAS,0) + NVL(nRRCVidaIndGAASTemp,0);
      
      nLimSupReservaIBNR  := nLimSupReservaIBNR + 
                                       (OC_CONFIG_RESERVAS_PLAN_IBNR.FACTOR_LIMITE_IBNR(nCodCia, cCodReserva, W.CodEmpresa, W.IdTipoSeg, 
                                                                              W.PlanCob, dFecFinRva) *
                                                                           (NVL(nPrimaNetaAcumIBNR,0) + NVL(nPrimaNetaTrimTot,0)));
      nLimSupReservaGAAS  := nLimSupReservaGAAS + 
                                       (OC_CONFIG_RESERVAS_PLAN_IBNR.FACTOR_LIMITE_GAAS(nCodCia, cCodReserva, W.CodEmpresa, W.IdTipoSeg, 
                                                                              W.PlanCob, dFecFinRva) * 
                                                                          (NVL(nPrimaNetaAcumIBNR,0) + NVL(nPrimaNetaTrimTot,0)));
   END LOOP;

   -- Acumulado IBNR
   SELECT NVL(SUM(ConstReserva),0) + NVL(nConstReservaIBNR,0)
     INTO nRvaAcumTrimIBNR
     FROM RESERVAS_TECNICAS_IBNR
    WHERE IdReserva    = nIdReserva
           AND IdTrimestre <= nIdTrimestre;

   -- Acumulado GAAS
   SELECT NVL(SUM(ConstReserva),0) + NVL(nConstReservaGAAS,0)
     INTO nRvaAcumTrimGAAS
     FROM RESERVAS_TECNICAS_GAAS
    WHERE IdReserva    = nIdReserva
           AND IdTrimestre <= nIdTrimestre;

   -- Solo para Reservas de VIDA se Aplica el Máximo
   IF OC_CONFIG_RESERVAS.INDICADORES(nCodCia, cCodReserva, 'VI') = 'S' THEN
      nRvaAcumTrimIBNR := GREATEST(nRvaAcumTrimIBNR, nRRCVidaIndIBNR);
      nRvaAcumTrimGAAS := GREATEST(nRvaAcumTrimGAAS, nRRCVidaIndGAAS);
   END IF;

   nRvaTotTrimestreIBNR  := LEAST(nRvaAcumTrimIBNR, nLimSupReservaIBNR);
   nRvaTotTrimestreGAAS  := LEAST(nRvaAcumTrimGAAS, nLimSupReservaGAAS);

   -- Actualiza Valores del Trimestre IBNR
   UPDATE RESERVAS_TECNICAS_IBNR
      SET PrimaNetaTrim    = nPrimaNetaTrimTot,
                    ConstReserva     = nConstReservaIBNR,
          RRCVidaInd       = nRRCVidaIndIBNR,
          RvaAcumTrim      = nRvaAcumTrimIBNR,
          LimSupReserva    = nLimSupReservaIBNR,
          RvaTotTrimestre  = nRvaTotTrimestreIBNR,
          PrimaCedida      = nPrimaCedidaIBNR,
          FactorCedida     = nFactorCedidaIBNR,
          RvaReasegCedido  = nRvaReasegCedidoIBNR
    WHERE IdReserva   = nIdReserva
      AND IdTrimestre = nIdTrimestre;
 
   -- Actualiza Valores del Trimestre GAAS
   UPDATE RESERVAS_TECNICAS_GAAS
      SET PrimaNetaTrim    = nPrimaNetaTrimTot,
                    ConstReserva     = nConstReservaGAAS,
          RRCVidaInd       = nRRCVidaIndGAAS,
          RvaAcumTrim      = nRvaAcumTrimGAAS,
          LimSupReserva    = nLimSupReservaGAAS,
          RvaTotTrimestre  = nRvaTotTrimestreGAAS,
          PrimaCedida      = nPrimaCedidaGAAS,
          FactorCedida     = nFactorCedidaGAAS,
          RvaReasegCedido  = nRvaReasegCedidoGAAS
    WHERE IdReserva   = nIdReserva
      AND IdTrimestre = nIdTrimestre;
 
   -- Actualiza Reserva Acumulada para el Resto de Trimestres IBNR
   UPDATE RESERVAS_TECNICAS_IBNR
      SET RvaAcumTrim = nRvaAcumTrimIBNR
    WHERE IdReserva   = nIdReserva
      AND IdTrimestre > nIdTrimestre;
 
   -- Actualiza Reserva Acumulada para el Resto de Trimestres GAAS
   UPDATE RESERVAS_TECNICAS_GAAS
      SET RvaAcumTrim = nRvaAcumTrimGAAS
    WHERE IdReserva   = nIdReserva
      AND IdTrimestre > nIdTrimestre;
 
   -- Registra Acumulado y Reserva IBNR 3 Trimestres Siguientes
   nContador := 1;
   FOR X IN TRIM_IBNR_Q LOOP
      UPDATE RESERVAS_TECNICAS_IBNR
         SET LimSupReserva    = nLimSupReservaIBNR,
             RvaTotTrimestre  = nRvaTotTrimestreIBNR
       WHERE IdReserva   = nIdReserva
         AND IdTrimestre = X.IdTrimestre;
      nContador := nContador + 1;
      IF nContador > 3 THEN
         EXIT;
      END IF;
   END LOOP;

   -- Registra Acumulado y Reserva GAAS 3 Trimestres Siguientes
   nContador := 1;
   FOR X IN TRIM_GAAS_Q LOOP
      UPDATE RESERVAS_TECNICAS_GAAS
         SET LimSupReserva    = nLimSupReservaGAAS,
             RvaTotTrimestre  = nRvaTotTrimestreGAAS
       WHERE IdReserva   = nIdReserva
         AND IdTrimestre = X.IdTrimestre;
      nContador := nContador + 1;
      IF nContador > 3 THEN
         EXIT;
      END IF;
   END LOOP;

   -- Resumen de Reservas para Corto y Largo Plazo
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'PEIBNR', 'S', nPrimaNetaTrimTot);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'PEIBNR', 'N', 0);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVIBNR', 'S', nRvaTotTrimestreIBNR);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVIBNR', 'N', 0);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVGAAS', 'S', nRvaTotTrimestreGAAS);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'RVGAAS', 'N', 0);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'IBNRCE', 'S', nRvaReasegCedidoIBNR);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'IBNRCE', 'N', 0);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'GAASCE', 'S', nRvaReasegCedidoGAAS);
   OC_RESERVAS_TECNICAS_RES.INSERTA_RESUMEN(nIdReserva, 'GAASCE', 'N', 0);
   IF NVL(cGeneroRva,'N') = 'N' THEN
      RAISE_APPLICATION_ERROR(-20100,'NO Generó Reservas de IBNR y GAAS : '|| cCodReserva||'. Revise si la Configuración está Activa.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error en Generación de Reserva del IBNR: '|| cCodReserva||' ' ||SQLERRM);
END GENERAR_RESERVA;

PROCEDURE INSERTAR_TRIMESTRE(nIdReserva NUMBER, nIdTrimestre NUMBER, nPrimaNetaTrim NUMBER) IS
BEGIN
   INSERT INTO RESERVAS_TECNICAS_IBNR
          (IdReserva, IdTrimestre, PrimaNetaTrim, ConstReserva,
           RRCVidaInd, RvaAcumTrim, LimSupReserva, RvaTotTrimestre, 
           PrimaCedida, FactorCedida, RvaReasegCedido)
   VALUES (nIdReserva, nIdTrimestre, nPrimaNetaTrim, 0,
           0, 0, 0, 0, 0, 0, 0);
END INSERTAR_TRIMESTRE;

PROCEDURE RESERVA_TRIMESTRE_ANTERIOR(nIdReservaAnt NUMBER, nIdReserva NUMBER) IS
CURSOR RVA_Q IS
   SELECT IdTrimestre, PrimaNetaTrim, ConstReserva,
          RRCVidaInd, RvaAcumTrim, LimSupReserva, RvaTotTrimestre, 
          PrimaCedida, FactorCedida, RvaReasegCedido
     FROM RESERVAS_TECNICAS_IBNR
    WHERE IdReserva = nIdReservaAnt
         ORDER BY IdTrimestre;
BEGIN
   FOR X IN RVA_Q LOOP
      INSERT INTO RESERVAS_TECNICAS_IBNR
             (IdReserva, IdTrimestre, PrimaNetaTrim, ConstReserva,
              RRCVidaInd, RvaAcumTrim, LimSupReserva, RvaTotTrimestre, 
              PrimaCedida, FactorCedida, RvaReasegCedido)
      VALUES (nIdReserva, X.IdTrimestre, X.PrimaNetaTrim, X.ConstReserva,
              X.RRCVidaInd, X.RvaAcumTrim, X.LimSupReserva, X.RvaTotTrimestre, 
              X.PrimaCedida, X.FactorCedida, X.RvaReasegCedido);
   END LOOP;
END RESERVA_TRIMESTRE_ANTERIOR;

END OC_RESERVAS_TECNICAS_IBNR;
/

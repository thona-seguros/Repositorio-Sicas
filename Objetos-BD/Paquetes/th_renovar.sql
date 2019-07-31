--
-- TH_RENOVAR  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   POLIZAS (Table)
--   DATOS_PART_EMISION (Table)
--   DETALLE_POLIZA (Table)
--   OC_DETALLE_POLIZA (Package)
--   AGENTES_DETALLES_POLIZAS (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   AGENTES_DISTRIBUCION_POLIZA (Table)
--   AGENTE_POLIZA (Table)
--   COBERTURAS (Table)
--   COBERT_ACT (Table)
--   OC_TAREA (Package)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_AGENTES (Package)
--   OC_AGENTES_DETALLES_POLIZAS (Package)
--   OC_AGENTES_DISTRIBUCION_POLIZA (Package)
--   OC_ASISTENCIAS_DETALLE_POLIZA (Package)
--   OC_BENEFICIARIO (Package)
--   OC_COBERT_ACT (Package)
--   OC_COMISIONES (Package)
--   OC_CONFIG_COMISIONES (Package)
--   OC_GENERALES (Package)
--   OC_PLAN_COBERTURAS (Package)
--   OC_POLIZAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.TH_RENOVAR IS
  
PROCEDURE RENOVAR_MEXCAL(P_CODCIA            NUMBER, 
                         P_POLIZA_ORI        NUMBER,
                         P_POLIZA_REN    OUT NUMBER,
                         P_MENSAJE_ERROR OUT VARCHAR2);
--
PROCEDURE RENOVAR_MEXCAL_CAMBIO(P_CODCIA            NUMBER, 
                                P_POLIZA_ORI        NUMBER,
                                P_TIPOSEG           VARCHAR2,
                                P_PLANCOB           VARCHAR2,
                                P_POLIZA_REN    OUT NUMBER,
                                P_MENSAJE_ERROR OUT VARCHAR2);
END TH_RENOVAR;
/

--
-- TH_RENOVAR  (Package Body) 
--
--  Dependencies: 
--   TH_RENOVAR (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.TH_RENOVAR IS
--
-- Creadoo 2016/12/05

PROCEDURE RENOVAR_MEXCAL(P_CODCIA            NUMBER,  
                         P_POLIZA_ORI        NUMBER, 
                         P_POLIZA_REN    OUT NUMBER,
                         P_MENSAJE_ERROR OUT VARCHAR2) IS
dFecHoy       DATE;
nIdPoliza     POLIZAS.IdPoliza%TYPE;
nIDetPol      DETALLE_POLIZA.IDetPol%TYPE;
cNumPolUnico  POLIZAS.NumPolUnico%TYPE;
p_msg_regreso varchar2(50);
nTasaCambio   DETALLE_POLIZA.Tasa_Cambio%TYPE;
W_CONTINUA           BOOLEAN;
W_MENSAJE_ERROR      VARCHAR2(2000);
--
CURSOR POL_Q IS
   SELECT CodEmpresa, TipoPol, NumPolRef, SumaAseg_Local, SumaAseg_Moneda,
          PrimaNeta_Local, PrimaNeta_Moneda, DescPoliza, PorcComis, IndExaInsp,
          Cod_Moneda, Num_Cotizacion, CodCliente, Cod_Agente, CodPlanPago,
          Medio_Pago, NumPolUnico, IndPolCol, IndProcFact, Caracteristica,
          IndFactPeriodo, FormaVenta, TipoRiesgo, IndConcentrada, TipoDividendo,
          CodGrupoEc, IndAplicoSami, SamiPoliza, TipoAdministracion, NumRenov,
          HoraVigIni, HoraVigFin, CodAgrupador, IndFacturaPol,
          IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional,
          P.FECINIVIG, P.FECFINVIG, P.FECSOLICITUD
     FROM POLIZAS P
    WHERE IdPoliza = P_POLIZA_ORI
      AND CodCia   = P_CODCIA;

CURSOR DET_Q IS
   SELECT IDetPol, Cod_Asegurado, CodEmpresa, CodPlanPago, Suma_Aseg_Local,
          Suma_Aseg_Moneda, Prima_Local, Prima_Moneda, IdTipoSeg, Tasa_Cambio,
          PorcComis,  NULL CodContrato, NULL CodProyecto, NULL Cod_Moneda,
          PlanCob, MontoComis, NumDetRef, FecAnul, Motivanul, CodPromotor,
          IndDeclara, IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
          IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH,
          DP.FECINIVIG,  DP.FECFINVIG
     FROM DETALLE_POLIZA DP
    WHERE IdPoliza = P_POLIZA_ORI
      AND CodCia   = P_CODCIA;

CURSOR COB_Q IS
  SELECT CA.IDetPol, CA.CodEmpresa, CA.CodCia, DP.IdTipoSeg, CA.CodCobert,
         CA.SumaAseg_Moneda, CA.Prima_Moneda, TipoRef, CA.NumRef, CA.IdEndoso,
         CA.PlanCob, CA.Cod_Moneda, CA.Deducible_Local, CA.Deducible_Moneda,
         CA.Cod_Asegurado
    FROM COBERT_ACT CA, DETALLE_POLIZA DP
   WHERE DP.IDetPol  = CA.IDetPol
     AND DP.IdPoliza = CA.IdPoliza
     AND CA.IdPoliza = P_POLIZA_ORI
     AND CA.CodCia   = P_CODCIA;

CURSOR COBER_Q IS
  SELECT C.IDPOLIZA,               C.IDETPOL,        C.CODEMPRESA,
         C.IDTIPOSEG,              C.CODCIA,         C.CODCOBERT,
         C.IDENDOSO,               C.STSCOBERTURA,   C.SUMA_ASEGURADA_LOCAL,
         C.SUMA_ASEGURADA_MONEDA,  C.PRIMA_LOCAL,    C.PRIMA_MONEDA,
         C.TASA,                   C.PLANCOB,        C.MODIFICACION,
         C.DEDUCIBLE_LOCAL,        C.DEDUCIBLE_MONEDA
    FROM DETALLE_POLIZA DP,
         COBERTURAS     C
   WHERE DP.IDPOLIZA = P_POLIZA_ORI
     AND DP.CODCIA   = P_CODCIA
     --
     AND C.CODCIA   = DP.CODCIA
     AND C.IDPOLIZA = DP.IDPOLIZA
     AND C.IDETPOL  = DP.IDETPOL;

CURSOR AGTE_POL_Q IS
   SELECT Cod_Agente, Porc_Comision, Ind_Principal, Origen
     FROM AGENTE_POLIZA
    WHERE CodCia   = P_CODCIA
      AND IdPoliza = P_POLIZA_ORI;

CURSOR AGTE_DIST_POL_Q IS
   SELECT Cod_Agente, CodNivel, Cod_Agente_Distr, Porc_Comision_Agente,
          Porc_Com_Distribuida, Porc_Comision_Plan, Porc_Com_Proporcional,
          Cod_Agente_Jefe, Porc_Com_Poliza, Origen
     FROM AGENTES_DISTRIBUCION_POLIZA
    WHERE CodCia   = P_CODCIA
      AND IdPoliza = P_POLIZA_ORI;

CURSOR AGENTES_Q IS
   SELECT A.Cod_Agente, A.Ind_Principal, A.Porc_Comision, A.Origen
     FROM AGENTES_DETALLES_POLIZAS A
    WHERE IDetPol  = nIDetPol
      AND CodCia   = P_CODCIA
      AND IdPoliza = P_POLIZA_ORI;

CURSOR AGTE_DIST_DET_Q IS
   SELECT CodNivel, Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan,
          Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Com_Proporcional,
          Cod_Agente_Jefe, Origen
     FROM AGENTES_DISTRIBUCION_COMISION
    WHERE IDetPol  = nIDetPol
      AND CodCia   = P_CODCIA
      AND IdPoliza = P_POLIZA_ORI;   
      
/*
CURSOR PER_Q IS
   SELECT IDetPol, Estatura, Peso, Cavidad_Toraxica_Min, Cavidad_Toraxica_Max,
          Capacidad_Abdominal, Presion_Arterial_Min, Presion_Arterial_Max,
          Pulso, Mortalidad, Suma_Aseg_Moneda, Suma_Aseg_Local,
          Extra_Prima_Moneda, Extra_Prima_Local, Id_Fumador,
          Observaciones, Porc_SubNormal, Prima_Local, Prima_Moneda
     FROM DATOS_PARTICULARES_PERSONAS
    WHERE IdPoliza = P_POLIZA_ORI
      AND CodCia   = P_CODCIA;

CURSOR BIEN_Q IS
   SELECT Num_Bien, IDetPol, CodPais, CodEstado, CodCiudad, CodMunicipio,
          Ubicacion_Bien, Tipo_Bien, Suma_Aseg_Local_Bien, Suma_Aseg_Moneda_Bien,
          Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien
     FROM DATOS_PARTICULARES_BIENES
    WHERE IdPoliza = P_POLIZA_ORI
      AND CodCia   = P_CODCIA;

CURSOR AUTO_Q IS
   SELECT IDetPol, Num_Vehi, Cod_Marca, Cod_Version, Cod_Modelo, Anio_Vehiculo,
          Placa, Cantidad_Pasajeros, Tarjeta_Circulacion, Color, Numero_Chasis,
          Numero_Motor, SumaAseg_Local, SumaAseg_Moneda, PrimaNeta_Local,
          PrimaNeta_Moneda
     FROM DATOS_PARTICULARES_VEHICULO
    WHERE IdPoliza = P_POLIZA_ORI
      AND CodCia   = P_CODCIA;

CURSOR ASEG_CERT_Q IS
   SELECT CodCia, IdPoliza, Cod_Asegurado, FechaAlta, FechaBaja, CodEmpresa,
          SumaAseg, Primaneta
     FROM ASEGURADO_CERT
    WHERE IDetPol  = nIDetPol
      AND IdPoliza = P_POLIZA_ORI
      AND CodCia   = P_CODCIA;
*/
BEGIN
  SELECT TRUNC(SYSDATE)
    INTO dFecHoy
    FROM DUAL;
  --
  W_CONTINUA       := TRUE; 
  --
  FOR X IN POL_Q LOOP
      --
      nIdPoliza    := OC_POLIZAS.F_GET_NUMPOL(p_msg_regreso);
      P_POLIZA_REN := nIdPoliza;
      nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(X.Cod_Moneda, TRUNC(SYSDATE));
      --
      IF INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),1) != 0 THEN
         cNumPolUnico := SUBSTR(X.NumPolUnico,1,INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),1)-1) ||
                         '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
      ELSIF X.NumPolUnico IS NOT NULL THEN
         cNumPolUnico := TRIM(X.NumPolUnico) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
      ELSE
         cNumPolUnico := TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
      END IF;
      --  
      INSERT INTO POLIZAS
               (IdPoliza,           CodEmpresa,        CodCia,             TipoPol, 
                NumPolRef,          FecIniVig,         FecFinVig,          FecSolicitud, 
                FecEmision,         FecRenovacion,     StsPoliza,          FecSts, 
                FecAnul,            MotivAnul,         SumaAseg_Local,     SumaAseg_Moneda,
                PrimaNeta_Local,    PrimaNeta_Moneda,  DescPoliza,         PorcComis, 
                --
                NumRenov,           IndExaInsp,        Cod_Moneda,         Num_Cotizacion, 
                CodCliente,         Cod_Agente,        CodPlanPago,        Medio_Pago, 
                NumPolUnico,        IndPolCol,         IndProcFact,        Caracteristica, 
                IndFactPeriodo,     FormaVenta,        TipoRiesgo,         IndConcentrada, 
                TipoDividendo,      CodGrupoEc,        IndAplicoSami,      SamiPoliza, 
                --
                TipoAdministracion, HoraVigIni,        HoraVigFin,         CodAgrupador,
                IndFacturaPol,      IndFactElectronica,IndCalcDerechoEmis, CodDirecRegional)
        VALUES (nIdPoliza,          X.CodEmpresa,      P_CODCIA,           X.TipoPol, 
                P_POLIZA_ORI,       ADD_MONTHS(X.FECINIVIG,12),   ADD_MONTHS(X.FECFINVIG,12), X.FECSOLICITUD, 
                dFecHoy   ,         ADD_MONTHS(X.FECINIVIG,12), 'SOL',        dFecHoy, 
                NULL,              NULL,               X.SumaAseg_Local,   X.SumaAseg_Moneda,
                X.PrimaNeta_Local, X.PrimaNeta_Moneda, X.DescPoliza,       X.PorcComis,
                --
                NVL(X.NumRenov,0) + 1, X.IndExaInsp,  X.Cod_Moneda,       X.Num_Cotizacion, 
                X.CodCliente,      X.Cod_Agente,       X.CodPlanPago,      X.Medio_Pago,
                cNumPolUnico,      X.IndPolCol,        X.IndProcFact,      X.Caracteristica, 
                X.IndFactPeriodo,  X.FormaVenta,       X.TipoRiesgo,       X.IndConcentrada, 
                X.TipoDividendo,   X.CodGrupoEc,       'N',                0, 
                --
                X.TipoAdministracion, X.HoraVigIni,    X.HoraVigFin,       X.CodAgrupador,
                X.IndFacturaPol,   X.IndFactElectronica, X.IndCalcDerechoEmis, X.CodDirecRegional);
      --
      IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE POLIZAS'; END IF;     
      --
      IF W_CONTINUA THEN
         --
         FOR G IN AGTE_POL_Q LOOP
             INSERT INTO AGENTE_POLIZA
                 (IdPoliza,             CodCia,                  Cod_Agente, 
                  Porc_Comision,        Ind_Principal,           Origen)
             VALUES (nIdPoliza,            P_CODCIA,                G.Cod_Agente, 
                  G.Porc_Comision,      G.Ind_Principal,         G.Origen);
             --
             IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE AGENTE_POLIZA'; END IF;     
             --
         END LOOP;
         --
      END IF;   
      --   
      IF W_CONTINUA THEN
         --
         FOR D IN AGTE_DIST_POL_Q LOOP
             INSERT INTO AGENTES_DISTRIBUCION_POLIZA
                  (IdPoliza,               CodCia,                Cod_Agente,    
                   CodNivel,               Cod_Agente_Distr,      Porc_Comision_Agente, 
                   Porc_Com_Distribuida,   Porc_Comision_Plan,    Porc_Com_Proporcional, 
                   Cod_Agente_Jefe,        Porc_Com_Poliza,       Origen)
             VALUES (nIdPoliza,              P_CODCIA,              D.Cod_Agente, 
                   D.CodNivel,             D.Cod_Agente_Distr,    D.Porc_Comision_Agente,
                   D.Porc_Com_Distribuida, D.Porc_Comision_Plan,  D.Porc_Com_Proporcional,
                   D.Cod_Agente_Jefe,      D.Porc_Com_Poliza,     D.Origen);
             --
             IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE AGENTES_DISTRIBUCION_POLIZA'; END IF;     
             --
         END LOOP;
         --
      END IF;
      --   
      IF W_CONTINUA THEN
         --
         FOR Y IN DET_Q LOOP
             nIDetPol := Y.IDetPol;
             INSERT INTO DETALLE_POLIZA
                  (IdPoliza,                   IDetPol,                  CodCia, 
                   Cod_Asegurado,              CodEmpresa,               CodPlanPago,
                   Suma_Aseg_Local,            Suma_Aseg_Moneda,         Prima_Local, 
                   Prima_Moneda,               FecIniVig,                FecFinVig, 
                   IdTipoSeg,                  Tasa_Cambio,              PorcComis, 
                   --
                   StsDetalle,                 PlanCob,                  MontoComis, 
                   NumDetRef,                  FecAnul,                  Motivanul, 
                   CodPromotor,                IndDeclara,               IndSinAseg, 
                   CodFilial,                  CodCategoria,             IndFactElectronica,
                   IndAsegModelo,              CantAsegModelo,           MontoComisH,
                   PorcComisH)
             VALUES(nIdPoliza,                  Y.IDetPol,                P_CODCIA, 
                   Y.Cod_Asegurado,            Y.CodEmpresa,             Y.CodPlanPago,
                   Y.Suma_Aseg_Local,          Y.Suma_Aseg_Moneda,       Y.Prima_Local, 
                   Y.Prima_Moneda,             ADD_MONTHS(Y.FECINIVIG,12), ADD_MONTHS(Y.FECFINVIG,12), 
                   Y.IdTipoSeg,                nTasaCambio,              Y.PorcComis, 
                   --
                   'SOL',                      Y.PlanCob,                Y.MontoComis, 
                   Y.NumDetRef,                '',                       '', 
                   Y.CodPromotor,              Y.IndDeclara,             Y.IndSinAseg, 
                   Y.CodFilial,                Y.CodCategoria,           Y.IndFactElectronica,
                   Y.IndAsegModelo,            Y.CantAsegModelo,         Y.MontoComisH, 
                   Y.PorcComisH);
             --
             IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE DETALLE_POLIZA'; END IF;     
             --
             IF W_CONTINUA THEN
             --
                FOR J IN AGENTES_Q LOOP
                    INSERT INTO AGENTES_DETALLES_POLIZAS
                       (IdPoliza,              IdetPol,          IdTiposeg, 
                        Cod_Agente,            Porc_Comision,    Ind_Principal, 
                        CodCia,                Origen)
                    VALUES (nIdPoliza,             nIDetPol,         Y.IdTiposeg,
                        J.Cod_Agente,          J.Porc_Comision,  J.Ind_Principal,
                        P_CODCIA,              J.Origen);
                END LOOP;
                --
                IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE AGENTES_DETALLES_POLIZAS'; END IF;     
                --
             END IF;      
             --
             IF W_CONTINUA THEN
             --
                FOR H IN AGTE_DIST_DET_Q LOOP
                    INSERT INTO AGENTES_DISTRIBUCION_COMISION
                       (CodCia,                   IdPoliza,                IdetPol, 
                        CodNivel,                 Cod_Agente,              Cod_Agente_Distr,
                        Porc_Comision_Plan,       Porc_Comision_Agente,    Porc_Com_Distribuida,
                        Porc_Com_Proporcional,    Cod_Agente_Jefe,         Origen)
                    VALUES (P_CODCIA,                 nIdPoliza,               nIDetPol, 
                        H.CodNivel,               H.Cod_Agente,            H.Cod_Agente_Distr,
                        H.Porc_Comision_Plan,     H.Porc_Comision_Agente,  H.Porc_Com_Distribuida,
                        H.Porc_Com_Proporcional,  H.Cod_Agente_Jefe,       H.Origen);
                    --
                    IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE AGENTES_DISTRIBUCION_COMISION'; END IF;     
                    --
                END LOOP;
             END IF;
             --
             OC_BENEFICIARIO.COPIAR(P_POLIZA_ORI, nIDetPol, Y.Cod_Asegurado, nIdPoliza, nIDetPol, Y.Cod_Asegurado);
             --
         END LOOP;
         --
      END IF;
      --
      IF W_CONTINUA THEN
         --
         FOR Z IN COB_Q LOOP
             INSERT INTO COBERT_ACT
                  (IdPoliza,  IDetPol, CodEmpresa, CodCia, CodCobert, StsCobertura,
                  SumaAseg_Local, SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa,
                  IdEndoso, IdTipoSeg, TipoRef, NumRef, PlanCob, Cod_Moneda, 
                  Deducible_Local, Deducible_Moneda, Cod_Asegurado)
             VALUES (nIdPoliza, Z.IDetPol, Z.CodEmpresa, Z.CodCia, Z.CodCobert, 'SOL',
                  Z.SumaAseg_Moneda, Z.SumaAseg_Moneda, Z.Prima_Moneda, Z.Prima_Moneda, NULL,
                  0, Z.IdTipoSeg, Z.TipoRef, Z.NumRef, Z.PlanCob, Z.Cod_Moneda, 
                  Z.Deducible_Local, Z.Deducible_Moneda, Z.Cod_Asegurado);
             --
             IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE AGENTES_DISTRIBUCION_COMISION'; END IF;     
             --
         END LOOP;
      END IF;
      --
      IF W_CONTINUA THEN
         --
         FOR T IN COBER_Q LOOP
             INSERT INTO COBERTURAS
                 (IDPOLIZA,                 IDETPOL,           CODEMPRESA,
                  IDTIPOSEG,                CODCIA,            CODCOBERT,
                  IDENDOSO,                 STSCOBERTURA,      SUMA_ASEGURADA_LOCAL,
                  SUMA_ASEGURADA_MONEDA,    PRIMA_LOCAL,       PRIMA_MONEDA,
                  TASA,                     PLANCOB,           MODIFICACION,
                  DEDUCIBLE_LOCAL,          DEDUCIBLE_MONEDA)
             VALUES (nIdPoliza,                T.IDETPOL,         T.CODEMPRESA,
                  T.IDTIPOSEG,              T.CODCIA,          T.CODCOBERT,
                  T.IDENDOSO,               'SOL',             T.SUMA_ASEGURADA_LOCAL,
                  T.SUMA_ASEGURADA_MONEDA,  T.PRIMA_LOCAL,     T.PRIMA_MONEDA,
                  T.TASA,                   T.PLANCOB,         T.MODIFICACION,
                  T.DEDUCIBLE_LOCAL,        T.DEDUCIBLE_MONEDA);
             --
             IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE AGENTES_DISTRIBUCION_COMISION'; END IF;     
             --
         END LOOP;
      END IF;
      --
   END LOOP;
   --
   IF W_CONTINUA THEN
      UPDATE POLIZAS P
         SET P.STSPOLIZA = 'REN',
             P.FECSTS    = TRUNC(SYSDATE)
       WHERE P.IDPOLIZA  = P_POLIZA_ORI;
  ELSE
      ROLLBACK;
      P_MENSAJE_ERROR := sqlcode||' - '||W_MENSAJE_ERROR;
      P_POLIZA_REN    := '';
      --
  END IF;
END RENOVAR_MEXCAL;

PROCEDURE RENOVAR_MEXCAL_CAMBIO(P_CODCIA            NUMBER,   
                                P_POLIZA_ORI        NUMBER,  
                                P_TIPOSEG           VARCHAR2,
                                P_PLANCOB           VARCHAR2,
                                P_POLIZA_REN    OUT NUMBER,
                                P_MENSAJE_ERROR OUT VARCHAR2) IS
dFecHoy            DATE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
cNumPolUnico       POLIZAS.NumPolUnico%TYPE;
p_msg_regreso      VARCHAR2(50);
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
W_CONTINUA         BOOLEAN;
W_MENSAJE_ERROR    VARCHAR2(2000);
cCodmoneda         POLIZAS.Cod_Moneda%TYPE;
nPorcComis         POLIZAS.PorcComis%TYPE;
nCod_Agente        POLIZAS.Cod_agente%TYPE;
cOrigen            AGENTE_POLIZA.Origen%TYPE;
W_EXISTE_DAT_PAR_EMI NUMBER;
--
CURSOR POL_Q IS
   SELECT CodEmpresa, TipoPol, NumPolRef, SumaAseg_Local, SumaAseg_Moneda,
          PrimaNeta_Local, PrimaNeta_Moneda, DescPoliza, PorcComis, IndExaInsp,
          Cod_Moneda, Num_Cotizacion, CodCliente, AP.COD_AGENTE, CodPlanPago,
          Medio_Pago, NumPolUnico, IndPolCol, IndProcFact, Caracteristica,
          IndFactPeriodo, FormaVenta, TipoRiesgo, IndConcentrada, TipoDividendo,
          CodGrupoEc, IndAplicoSami, SamiPoliza, TipoAdministracion, NumRenov,
          HoraVigIni, HoraVigFin, CodAgrupador, IndFacturaPol,
          IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional,
          P.FECINIVIG, P.FECFINVIG, P.FECSOLICITUD
     FROM POLIZAS P,
          AGENTE_POLIZA AP
    WHERE P.IdPoliza = P_POLIZA_ORI
      AND P.CodCia   = P_CODCIA
      --
      AND AP.IDPOLIZA = P.IDPOLIZA
      AND AP.CODCIA   = P.CODCIA;
     
CURSOR DET_Q IS
   SELECT IDetPol, Cod_Asegurado, CodEmpresa, CodPlanPago, Suma_Aseg_Local,
          Suma_Aseg_Moneda, Prima_Local, Prima_Moneda, IdTipoSeg, Tasa_Cambio,
          PorcComis,  NULL CodContrato, NULL CodProyecto, NULL Cod_Moneda,
          PlanCob, MontoComis, NumDetRef, FecAnul, Motivanul, CodPromotor,
          IndDeclara, IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
          IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH,
          DP.FECINIVIG,  DP.FECFINVIG
     FROM DETALLE_POLIZA DP
    WHERE IdPoliza = P_POLIZA_ORI
      AND CodCia   = P_CODCIA;

BEGIN
  SELECT TRUNC(SYSDATE)
    INTO dFecHoy
    FROM DUAL;
  --
  W_CONTINUA           := TRUE; 
  --
  FOR X IN POL_Q LOOP
      --
      nIdPoliza    := OC_POLIZAS.F_GET_NUMPOL(p_msg_regreso);
      P_POLIZA_REN := nIdPoliza;
      nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(X.Cod_Moneda, TRUNC(SYSDATE));
      --
      IF X.NumPolUnico IS NULL THEN
         cNumPolUnico := TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
      ELSIF INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),-1) != 0 THEN
         cNumPolUnico := SUBSTR(X.NumPolUnico,1,INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),-1)-1) ||
                         '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
      ELSIF INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),-1) = 0 THEN
         cNumPolUnico := TRIM(X.NumPolUnico) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
      END IF;
      --  
      INSERT INTO POLIZAS
               (IdPoliza,           CodEmpresa,        CodCia,             TipoPol, 
                NumPolRef,          FecIniVig,         FecFinVig,          FecSolicitud, 
                FecEmision,         FecRenovacion,     StsPoliza,          FecSts, 
                FecAnul,            MotivAnul,         SumaAseg_Local,     SumaAseg_Moneda,
                PrimaNeta_Local,    PrimaNeta_Moneda,  DescPoliza,         PorcComis, 
                --
                NumRenov,           IndExaInsp,        Cod_Moneda,         Num_Cotizacion, 
                CodCliente,         Cod_Agente,        CodPlanPago,        Medio_Pago, 
                NumPolUnico,        IndPolCol,         IndProcFact,        Caracteristica, 
                IndFactPeriodo,     FormaVenta,        TipoRiesgo,         IndConcentrada, 
                TipoDividendo,      CodGrupoEc,        IndAplicoSami,      SamiPoliza, 
                --
                TipoAdministracion, HoraVigIni,        HoraVigFin,         CodAgrupador,
                IndFacturaPol,      IndFactElectronica,IndCalcDerechoEmis, CodDirecRegional)
        VALUES (nIdPoliza,          X.CodEmpresa,      P_CODCIA,           X.TipoPol, 
                P_POLIZA_ORI,       ADD_MONTHS(X.FECINIVIG,12),   ADD_MONTHS(X.FECFINVIG,12), X.FECSOLICITUD, 
                dFecHoy   ,         ADD_MONTHS(X.FECINIVIG,12), 'SOL',        dFecHoy, 
                NULL,              NULL,               X.SumaAseg_Local,   X.SumaAseg_Moneda,
                X.PrimaNeta_Local, X.PrimaNeta_Moneda, X.DescPoliza,       X.PorcComis,
                --
                NVL(X.NumRenov,0) + 1, X.IndExaInsp,  X.Cod_Moneda,       X.Num_Cotizacion, 
                X.CodCliente,      X.Cod_Agente,       X.CodPlanPago,      X.Medio_Pago,
                cNumPolUnico,      X.IndPolCol,        X.IndProcFact,      X.Caracteristica, 
                X.IndFactPeriodo,  X.FormaVenta,       X.TipoRiesgo,       X.IndConcentrada, 
                X.TipoDividendo,   X.CodGrupoEc,       'N',                0, 
                --
                X.TipoAdministracion, X.HoraVigIni,    X.HoraVigFin,       X.CodAgrupador,
                X.IndFacturaPol,   X.IndFactElectronica, X.IndCalcDerechoEmis, X.CodDirecRegional);
      --
      IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE POLIZAS'; END IF;     
      --
      IF W_CONTINUA THEN
         IF OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(P_CODCIA, X.CodEmpresa, P_TIPOSEG) = 'S' THEN
            --
            cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(P_CODCIA, X.CodEmpresa, P_TIPOSEG, P_PLANCOB);
            nPorcComis  := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(P_CODCIA, X.CodEmpresa, P_TIPOSEG);
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            nCod_Agente := X.Cod_Agente;
            IF nCod_Agente = 0 THEN
               W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE POLIZAS';
            END IF;           
            --
            -- Inserta Tarea de Seguimiento
            --
            IF W_CONTINUA THEN
               IF OC_TAREA.EXISTE_TAREA(P_CODCIA,nIdPoliza) = 'N' THEN
                  OC_TAREA.INSERTA_TAREA(P_CODCIA, 7, 'SOL', 'EMI', nIdPoliza, X.CodCliente, 'A','SOL', 'SOLICITUD DE RENOVACION');
               END IF;
               -- Genera Detalle de Poliza
               FOR Y IN DET_Q LOOP
                   W_EXISTE_DAT_PAR_EMI := 0;
                   nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(P_CODCIA,        X.CodEmpresa,      P_TIPOSEG,     
                                                                     P_PLANCOB,       nIdPoliza,         nTasaCambio,  
                                                                     nPorcComis,      Y.COD_ASEGURADO,   Y.CODPLANPAGO,
                                                                     cNumPolUnico,    Y.CODPROMOTOR,     ADD_MONTHS(Y.FECINIVIG,12));
                   --
                   UPDATE DETALLE_POLIZA
                      SET FecFinVig = ADD_MONTHS(Y.FECFINVIG,12)
                    WHERE CodCia     = P_CODCIA
                      AND CodEmpresa = X.CodEmpresa
                      AND IdPoliza   = nIdPoliza
                      AND IDetPol    = nIDetPol;
                   --
                   IF OC_COBERT_ACT.EXISTE_COBERTURA(P_CODCIA, X.CodEmpresa, P_TIPOSEG, P_PLANCOB, nIdPoliza, nIDetPol) = 'N' THEN
                      OC_COBERT_ACT.CARGAR_COBERTURAS(P_CODCIA, X.CodEmpresa, P_TIPOSEG, P_PLANCOB, nIdPoliza, nIDetPol, nTasaCambio,NULL,0,0,0,0,0,0,0,0,0,0,0);
                   END IF;
                   --
                   OC_ASISTENCIAS_DETALLE_POLIZA.CARGAR_ASISTENCIAS(P_CODCIA, X.CodEmpresa, P_TIPOSEG, P_PLANCOB, nIdPoliza,
                                                                    nIDetPol, nTasaCambio, cCodMoneda, ADD_MONTHS(Y.FECINIVIG,12), ADD_MONTHS(Y.FECFINVIG,12));
                   --
                   IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE (P_CODCIA, nIdPoliza, nIDetPol, P_TIPOSEG, nCod_Agente) = 'N' THEN
                      IF nCod_Agente IS NOT NULL THEN
                         IF OC_AGENTES.NIVEL_AGENTE(P_CODCIA, nCod_Agente) = 5 THEN
                            cOrigen  := 'U';
                         ELSIF OC_AGENTES.NIVEL_AGENTE(P_CODCIA, nCod_Agente) = 4 THEN
                            cOrigen  := 'H';
                         ELSE
                            cOrigen  := 'C';
                         END IF;
                         --
                         BEGIN
                           INSERT INTO AGENTE_POLIZA
                                  (IdPoliza,  CodCia,   Cod_Agente,  Porc_Comision, Ind_Principal, Origen)
                           VALUES (nIdPoliza, P_CODCIA, nCod_Agente,  100,          'S',           cOrigen);
                           --
                           IF P_TIPOSEG != 'ESTVIG' THEN
                              OC_COMISIONES.DISTRIBUCION(P_CODCIA, nIdPoliza, nCod_Agente, 100);
                              OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(P_CODCIA, nIdPoliza);
                           END IF;
                          EXCEPTION
                            WHEN DUP_VAL_ON_INDEX THEN
                               IF P_TIPOSEG != 'ESTVIG' THEN
                                 OC_COMISIONES.DISTRIBUCION(P_CODCIA, nIdPoliza, nCod_Agente, 100);
                                 OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(P_CODCIA, nIdPoliza);
                              END IF;
                           WHEN OTHERS THEN
                              IF sqlcode <> 0 THEN  W_CONTINUA := FALSE; W_MENSAJE_ERROR := 'RENUEVA MEXCAL - ERROR EN INSERT DE AGENTE'; END IF;    
                          END;
                      END IF;
                   END IF;
                   --
                   OC_BENEFICIARIO.COPIAR(P_POLIZA_ORI, nIDetPol, Y.Cod_Asegurado, nIdPoliza, nIDetPol, Y.Cod_Asegurado);
                   --
                   SELECT COUNT(*)
                     INTO W_EXISTE_DAT_PAR_EMI
                     FROM DATOS_PART_EMISION DP
                     WHERE DP.CODCIA   = P_CODCIA
                       AND DP.IDPOLIZA = P_POLIZA_ORI
                       AND DP.IDETPOL  = nIDetPol;
                   --     
                       
                   IF W_EXISTE_DAT_PAR_EMI = 0 THEN
                      INSERT INTO DATOS_PART_EMISION
                       SELECT P_CODCIA,       --CODCIA,
                              nIdPoliza,      --IDPOLIZA,
                              nIDetPol,       --IDETPOL,
                              'SOL',          --STSDATPART,
                              TRUNC(SYSDATE), --FECSTS,
                              CAMPO1, CAMPO2, CAMPO3, CAMPO4, CAMPO5, CAMPO6, CAMPO7, CAMPO8, CAMPO9, CAMPO10,
                              CAMPO11,CAMPO12,CAMPO13,CAMPO14,CAMPO15,CAMPO16,CAMPO17,CAMPO18,CAMPO19,CAMPO20,
                              CAMPO21,CAMPO22,CAMPO23,CAMPO24,CAMPO25,CAMPO26,CAMPO27,CAMPO28,CAMPO29,CAMPO30,
                              CAMPO31,CAMPO32,CAMPO33,CAMPO34,CAMPO35,CAMPO36,CAMPO37,CAMPO38,CAMPO39,CAMPO40,
                              CAMPO41,CAMPO42,CAMPO43,CAMPO44,CAMPO45,CAMPO46,CAMPO47,CAMPO48,CAMPO49,CAMPO50,
                              CAMPO51,CAMPO52,CAMPO53,CAMPO54,CAMPO55,CAMPO56,CAMPO57,CAMPO58,CAMPO59,CAMPO60,
                              CAMPO61,CAMPO62,CAMPO63,CAMPO64,CAMPO65,CAMPO66,CAMPO67,CAMPO68,CAMPO69,CAMPO70,
                              CAMPO71,CAMPO72,CAMPO73,CAMPO74,CAMPO75,CAMPO76,CAMPO77,CAMPO78,CAMPO79,CAMPO80,
                              CAMPO81,CAMPO82,CAMPO83,CAMPO84,CAMPO85,CAMPO86,CAMPO87,CAMPO88,CAMPO89,CAMPO90,
                              CAMPO91,CAMPO92,CAMPO93,CAMPO94,CAMPO95,CAMPO96,CAMPO97,CAMPO98,CAMPO99,CAMPO100
                         FROM DATOS_PART_EMISION
                        WHERE IdPoliza = P_POLIZA_ORI
                          AND CodCia   = P_CODCIA;
                   END IF;    
               END LOOP;
               --
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(P_CODCIA, nIdPoliza, nIDetPol, 0);
               OC_POLIZAS.ACTUALIZA_VALORES(P_CODCIA, nIdPoliza, 0);
            END IF;
            --
         END IF;
      END IF;
   END LOOP;
   --
   IF W_CONTINUA THEN
      UPDATE POLIZAS P
         SET P.STSPOLIZA = 'REN',
             P.FECSTS    = TRUNC(SYSDATE)
       WHERE P.IDPOLIZA  = P_POLIZA_ORI;
   ELSE
      ROLLBACK;
      P_MENSAJE_ERROR := sqlcode||' - '||W_MENSAJE_ERROR;
      P_POLIZA_REN    := '';
   END IF;
END RENOVAR_MEXCAL_CAMBIO;


END TH_RENOVAR;
/

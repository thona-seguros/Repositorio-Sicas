--
-- OC_TARJETAS_PREPAGO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_AGENTES_DISTRIBUCION_POLIZA (Package)
--   PLAN_COBERTURAS (Table)
--   POLIZAS (Table)
--   PRIMAS_DEPOSITO (Table)
--   CONFIG_COMISIONES (Table)
--   OC_TAREA (Package)
--   OC_TIPOS_DE_SEGUROS (Package)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_POLIZA (Table)
--   AGENTE_POLIZA (Table)
--   ASEGURADO (Table)
--   OC_CONFIG_COMISIONES (Package)
--   OC_DETALLE_POLIZA (Package)
--   CLIENTES (Table)
--   CLIENTE_ASEG (Table)
--   TARJETAS_PREPAGO (Table)
--   TARJETAS_PREPAGO_ACTIV (Table)
--   OC_GENERALES (Package)
--   OC_PLAN_COBERTURAS (Package)
--   OC_POLIZAS (Package)
--   OC_ASEGURADO (Package)
--   OC_CLIENTES (Package)
--   OC_COBERT_ACT (Package)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--   OC_PRIMAS_DEPOSITO (Package)
--   TIPOS_DE_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_tarjetas_prepago IS

FUNCTION FOLIO_VENTA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                     cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, cCodPromotor VARCHAR2) RETURN NUMBER;

FUNCTION FOLIO_ACTIVACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                          cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, cCodPromotor VARCHAR2) RETURN NUMBER;

PROCEDURE VENTA_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                        cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                        cCodPromotor VARCHAR2, dFecVenta DATE);

PROCEDURE ACTIVACION_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                             cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                             cCodPromotor VARCHAR2, cCodUsrCallCenter VARCHAR2, dFecActiv DATE);

PROCEDURE PAGO_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                       cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                       cCodPromotor VARCHAR2, dFecPago DATE, nCodCliente NUMBER,
                       nMontoTarjeta NUMBER, cCodMoneda VARCHAR2, cNumDepBancario VARCHAR2,
                       cNumReciboPago VARCHAR2);

PROCEDURE ANULAR_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                         cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                         cCodPromotor VARCHAR2, dFecAnul DATE);

PROCEDURE EMISION_POLIZA_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                 cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                                 cCodPromotor VARCHAR2, cNumReciboPago VARCHAR2, cIdGrupoTarj VARCHAR2,dFecIniVig DATE);

FUNCTION NUMERO_PRIMA_DEPOSITO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                               cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                               cCodPromotor VARCHAR2) RETURN NUMBER;

FUNCTION POSEE_PROMOTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                        cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER) RETURN VARCHAR2;

PROCEDURE ASIGNA_PROMOTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                          cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                          cCodPromotor VARCHAR2);
PROCEDURE CAMBIA_PROMOTOR(nCodCia NUMBER, cCodPromotorBaja VARCHAR2, cCodPromotorNuevo VARCHAR2);

FUNCTION FOLIOS_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2, cStsFolio VARCHAR2) RETURN NUMBER;

PROCEDURE CAMBIA_LIBERA_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                                cCodPromotor VARCHAR2, cCodPromotorNuevo VARCHAR2);

END OC_TARJETAS_PREPAGO;
/

--
-- OC_TARJETAS_PREPAGO  (Package Body) 
--
--  Dependencies: 
--   OC_TARJETAS_PREPAGO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_tarjetas_prepago IS

FUNCTION FOLIO_VENTA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                     cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, cCodPromotor VARCHAR2) RETURN NUMBER IS
nNumFolioVenta    TARJETAS_PREPAGO.NumFolioVenta%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(NumFolioVenta),0) + 1
        INTO nNumFolioVenta
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND CodPromotor = cCodPromotor;
   END;
   IF nNumFolioVenta = 1 THEN
      nNumFolioVenta := TO_NUMBER(TRIM(cCodPromotor) || '000001');
   END IF;
   RETURN(nNumFolioVenta);
END FOLIO_VENTA;

FUNCTION FOLIO_ACTIVACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                          cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, cCodPromotor VARCHAR2) RETURN NUMBER IS
nNumFolioActiv    TARJETAS_PREPAGO.NumFolioActiv%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(NumFolioActiv),0) + 1
        INTO nNumFolioActiv
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND CodPromotor = cCodPromotor;
   END;
   IF nNumFolioActiv = 1 THEN
      nNumFolioActiv := TO_NUMBER(TRIM(cCodPromotor) || '000001');
   END IF;
   RETURN(nNumFolioActiv);
END FOLIO_ACTIVACION;

PROCEDURE VENTA_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                        cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                        cCodPromotor VARCHAR2, dFecVenta DATE) IS
cVendida          VARCHAR2(1);
nNumFolioVenta    TARJETAS_PREPAGO.NumFolioVenta%TYPE;
cStsTarjeta       TARJETAS_PREPAGO.StsTarjeta%TYPE;
BEGIN
   BEGIN
      SELECT 'N', StsTarjeta
        INTO cVendida, cStsTarjeta
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta IN ('ASIG','ACTR','ACTP');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cVendida := 'S';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros para la Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' ¡Verificar Registros!');
   END;

   IF cVendida = 'N' THEN
      nNumFolioVenta := OC_TARJETAS_PREPAGO.FOLIO_VENTA(nCodCia, nCodEmpresa, cIdTipoSeg,
                                                        cPlanCob, cTipoTarjeta, cCodPromotor);
      UPDATE TARJETAS_PREPAGO
         SET StsTarjeta    = DECODE(cStsTarjeta,'ASIG','VEND',DECODE(cStsTarjeta,'ACTR','ACTR','ACTP')),
             FecSts        = TRUNC(SYSDATE),
             NumFolioVenta = nNumFolioVenta,
             FecVenta      = dFecVenta
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta IN ('ASIG','ACTR','ACTP');
   ELSE
      RAISE_APPLICATION_ERROR(-20225,'Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' YA fue Vendida Previamente o No ha Sido Asignada');
   END IF;
END VENTA_TARJETA;

PROCEDURE ACTIVACION_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                             cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                             cCodPromotor VARCHAR2, cCodUsrCallCenter VARCHAR2, dFecActiv DATE) IS
cActivada         VARCHAR2(1);
nNumFolioActiv    TARJETAS_PREPAGO.NumFolioActiv%TYPE;
BEGIN
   BEGIN
      SELECT 'S'
        INTO cActivada
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta  IN ('ACTR','ACTP');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cActivada := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros para la Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' ¡Verificar Registros!');
   END;
   IF cActivada = 'N' THEN
      nNumFolioActiv := OC_TARJETAS_PREPAGO.FOLIO_ACTIVACION(nCodCia, nCodEmpresa, cIdTipoSeg,
                                                             cPlanCob, cTipoTarjeta, cCodPromotor);
      UPDATE TARJETAS_PREPAGO
         SET StsTarjeta       = 'ACTR',
             FecSts           = TRUNC(SYSDATE),
             NumFolioActiv    = nNumFolioActiv,
             FecActiv         = dFecActiv,
             CodUsrCallCenter = cCodUsrCallCenter
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta IN ('ASIG','VEND');
   ELSE
      RAISE_APPLICATION_ERROR(-20225,'Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' YA fue Activada Previamente');
   END IF;
END ACTIVACION_TARJETA;

PROCEDURE PAGO_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                       cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                       cCodPromotor VARCHAR2, dFecPago DATE, nCodCliente NUMBER,
                       nMontoTarjeta NUMBER, cCodMoneda VARCHAR2, cNumDepBancario VARCHAR2,
                       cNumReciboPago VARCHAR2) IS
nIdPrimaDeposito  PRIMAS_DEPOSITO.IdPrimaDeposito%TYPE;
cObservaciones    PRIMAS_DEPOSITO.Observaciones%TYPE;
cStsTarjeta       TARJETAS_PREPAGO.StsTarjeta%TYPE;
nIdPoliza         DETALLE_POLIZA.IdPoliza%TYPE;
nIDetPol          DETALLE_POLIZA.IDetPol%TYPE;
cPagada           VARCHAR2(1);
CURSOR FACT_Q IS
   SELECT IdFactura
     FROM FACTURAS
    WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPoliza
      AND IDetPol   = nIDetPol
      AND StsFact   = 'EMI';
BEGIN
   BEGIN
      SELECT 'N', StsTarjeta
        INTO cPagada, cStsTarjeta
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta != 'CANP'
         AND FecPago    IS NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cPagada     := 'S';
         cStsTarjeta := 'VEND';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros para la Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' ¡Verificar Registros!');
   END;

   IF cPagada = 'N' THEN
      cObservaciones   := 'Pago de Tarjeta No. ' ||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta));
      nIdPrimaDeposito := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nMontoTarjeta, cCodMoneda, cObservaciones, NULL, NULL);

      UPDATE TARJETAS_PREPAGO
         SET FecPago         = dFecPago,
             IdPrimaDeposito = nIdPrimaDeposito,
             NumDepBancario  = cNumDepBancario
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta != 'CANP';

      OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, SYSDATE,cNumDepBancario);

      IF cStsTarjeta = 'ACTR' THEN
         BEGIN
            SELECT TP.IdPoliza, DP.IDetPol
              INTO nIdPoliza, nIDetPol
              FROM TARJETAS_PREPAGO_ACTIV TP, DETALLE_POLIZA DP
             WHERE DP.IdPoliza     = TP.IdPoliza
               AND TP.CodCia       = nCodCia
               AND TP.CodEmpresa   = nCodEmpresa
               AND TP.IdTipoSeg    = cIdTipoSeg
               AND TP.PlanCob      = cPlanCob
               AND TP.TipoTarjeta  = cTipoTarjeta
               AND TP.NumTarjeta   = nNumTarjeta;
             -- Realizar Pago de Facturas con Prima en Depósito
             FOR W IN FACT_Q LOOP
                --OC_FACTURAS.PAGAR_CON_PRIMA_DEPOSITO(W.IdFactura, nIdPrimaDeposito, cNumReciboPago, TRUNC(SYSDATE),cNumDepBancario, 1);
                NULL;
             END LOOP;

             UPDATE TARJETAS_PREPAGO
                SET StsTarjeta    = 'ACTP',
                    FecSts        = TRUNC(SYSDATE)
              WHERE CodCia      = nCodCia
                AND CodEmpresa  = nCodEmpresa
                AND IdTipoSeg   = cIdTipoSeg
                AND PlanCob     = cPlanCob
                AND TipoTarjeta = cTipoTarjeta
                AND NumTarjeta  = nNumTarjeta
                AND CodPromotor = cCodPromotor
                AND StsTarjeta != 'CANP';

             UPDATE TARJETAS_PREPAGO_ACTIV
                SET StsProcActiv  = 'ACTP',
                    FecProcActiv  = TRUNC(SYSDATE)
              WHERE CodCia      = nCodCia
                AND CodEmpresa  = nCodEmpresa
                AND IdTipoSeg   = cIdTipoSeg
                AND PlanCob     = cPlanCob
                AND TipoTarjeta = cTipoTarjeta
                AND NumTarjeta  = nNumTarjeta;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' NO Ha Sido Emitida');
         END;
      END IF;

   ELSE
      RAISE_APPLICATION_ERROR(-20225,'Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' YA fue Pagada Previamente');
   END IF;
END PAGO_TARJETA;

PROCEDURE ANULAR_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                         cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                         cCodPromotor VARCHAR2, dFecAnul DATE) IS
cPendiente        VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cPendiente
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta  IN ('PEND','ASIG');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cPendiente := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros para la Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' ¡Verificar Registros!');
   END;

   IF cPendiente = 'S' THEN
      UPDATE TARJETAS_PREPAGO
         SET StsTarjeta       = 'CANP',
             FecSts           = dFecAnul
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta  IN ('PEND','ASIG');
   ELSE
      RAISE_APPLICATION_ERROR(-20225,'Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))|| ' NO se puede Anular porque ya Fue Vendida');
   END IF;
END ANULAR_TARJETA;

PROCEDURE EMISION_POLIZA_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                 cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                                 cCodPromotor VARCHAR2, cNumReciboPago VARCHAR2, cIdGrupoTarj VARCHAR2,dFecIniVig DATE ) IS
nCodCliente        CLIENTES.CodCliente%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
cDescPoliza        POLIZAS.DescPoliza%TYPE;
cCodMoneda         PLAN_COBERTURAS.CodMoneda%TYPE;
nPorcComis         CONFIG_COMISIONES.PorcComision%TYPE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
nIdPrimaDeposito   TARJETAS_PREPAGO.IdPrimaDeposito%TYPE;
cCodPlanPago       TIPOS_DE_SEGUROS.CodPlanPago%TYPE;
nCod_Agente        AGENTES.Cod_Agente%TYPE;
cStsProcActiv      TARJETAS_PREPAGO.StsTarjeta%TYPE;
cNumDepBancario    TARJETAS_PREPAGO.NumDepBancario%TYPE;

CURSOR DATOS_Q IS
   SELECT TipoDocIdentAseg, NumDocIdentAseg, ApePaternoAseg, ApeMaternoAseg,
          NombresAseg, SexoAseg, DirecAseg, CodPaisAseg, CodEstadoAseg,
          CodCiudadAseg, CodMunicipAseg, CodPostalAseg, CodColoniaAseg, TelefonoAseg
     FROM TARJETAS_PREPAGO_ACTIV
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg
      AND PlanCob      = cPlanCob
      AND TipoTarjeta  = cTipoTarjeta
      AND NumTarjeta   = nNumTarjeta
      AND IdPoliza    IS NULL;
CURSOR FACT_Q IS
   SELECT IdFactura
     FROM FACTURAS
    WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPoliza
      AND IDetPol   = nIDetPol
      AND StsFact   = 'EMI';
BEGIN
   cCodPlanPago := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(nCodCia, nCodEmpresa, cIdTipoSeg);
   BEGIN
      SELECT Cod_Agente
        INTO nCod_Agente
        FROM AGENTES
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND Est_Agente  != 'SUS'
         AND Tipo_Agente  = 'DIREC';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO ha Configurado un Agente Directo para Compañía '||TRIM(TO_CHAR(nCodCia))||
                                 ' y la Empresa '||TRIM(TO_CHAR(nCodEmpresa)));
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Configurados varios Agente Directo para Compañía '||TRIM(TO_CHAR(nCodCia))||
                                 ' y la Empresa '||TRIM(TO_CHAR(nCodEmpresa)));
   END;
   FOR X IN DATOS_Q LOOP
      nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(X.TipoDocIdentAseg, X.NumDocIdentAseg);
      IF nCodCliente = 0 THEN
         nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(X.TipoDocIdentAseg, X.NumDocIdentAseg);
      END IF;
      nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, X.TipoDocIdentAseg, X.NumDocIdentAseg);
      IF nCod_Asegurado = 0 THEN
         nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa,
                                                           X.TipoDocIdentAseg, X.NumDocIdentAseg);
      END IF;

      -- Registra Relación Cliente-Asegurado
      BEGIN
         INSERT INTO CLIENTE_ASEG
                (CodCliente, Cod_Asegurado)
         VALUES(nCodCliente, nCod_Asegurado);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;

      -- Se Inserta Póliza de Tarjeta
      cDescPoliza := 'Activación y Emisión de Tarjeta Pre-Pago No. ' || cTipoTarjeta ||'-'||TRIM(TO_CHAR(nNumTarjeta));
      cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);
      nPorcComis  := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(nCodCia, nCodEmpresa, cIdTipoSeg);
      BEGIN
         SELECT IdPoliza
           INTO nIdpoliza
           FROM Polizas
          WHERE NumPolUnico = TRIM(TO_CHAR(nNumTarjeta))
            AND CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          nIdPoliza := 0;
      END;
      IF  OC_POLIZAS.EXISTE_POLIZA(nCodCia, nCodEmpresa, nIdpoliza) = 'N' THEN
          nIdPoliza   := OC_POLIZAS.INSERTAR_POLIZA(nCodCia, nCodEmpresa, cDescPoliza, cCodMoneda, nPorcComis,
                                                nCodCliente, nCod_Agente, cCodPlanPago, TRIM(TO_CHAR(nNumTarjeta)),
                                                cIdGrupoTarj,dFecIniVig);

      END IF;
      -- Inserta Tarea de Seguimiento
      OC_TAREA.INSERTA_TAREA(nCodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A',
                             'SOL', 'SOLICITUD DE EMISION');

      -- Genera Detalle de Póliza
      nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
      IF OC_DETALLE_POLIZA.EXISTE_POLIZA_DETALLE(nCodCia, nCodEmpresa, nIdPoliza, TRIM(TO_CHAR(nNumTarjeta))) = 'N' then
         nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                        nIdPoliza, nTasaCambio, nPorcComis,
                                                        nCod_Asegurado, cCodPlanPago, TRIM(TO_CHAR(nNumTarjeta)),
                                                        cCodPromotor,dFecIniVig);
      ELSE
         BEGIN
            SELECT IDetPol
              INTO nIDetPol
              FROM DETALLE_POLIZA
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdPoliza    = nIdpoliza
               AND NumDetRef   = TRIM(TO_CHAR(nNumTarjeta))
               AND IdTipoSeg   = cIdTipoSeg
               AND PlanCob    = cPlanCob;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| TRIM(TO_CHAR(nNumTarjeta))||nIdpoliza);
         END;
      END IF;
         -- Genera Coberturas de la Tarjeta Pre-Pago
      OC_COBERT_ACT.CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                      nIdPoliza, nIDetPol, nTasaCambio, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);

      -- Inserta Agentes a Detalle de Póliza
      INSERT INTO AGENTE_POLIZA
            (IdPoliza, CodCia, Cod_Agente, Porc_Comision, Ind_Principal, Origen)
      VALUES(nIdPoliza, nCodCia, nCod_Agente, 100, 'S', 'C');

      INSERT INTO AGENTES_DISTRIBUCION_POLIZA
             (CodCia, IdPoliza, CodNivel, Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan, Porc_Comision_Agente,
              Porc_com_distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
      VALUES (nCodCia, nIdPoliza, 3, nCod_Agente, nCod_Agente, 50, 50, 50, 100, NULL, 'C');
      OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(nCodCia, nIdPoliza);

      --OC_AGENTES_DETALLES_POLIZAS.INSERTA_AGENTE(nCodCia, nIdPoliza, nIDetPol, cIdTipoSeg, nCod_Agente);

      -- Inserta Requisitos Obligatorios
      OC_POLIZAS.INSERTA_REQUISITOS(nCodCia, nIdPoliza);

      -- Actualiza Valores de Póliza y Detalle
      OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
      OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);

      -- Emitir Póliza
      BEGIN
      OC_POLIZAS.EMITIR_POLIZA(nCodCia, nIdPoliza, nCodEmpresa);
      EXCEPTION
           WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'Error en Emision de Poliza'||nIdPoliza||'Codcia'||nCodCia||SQLERRM);
      END;
      -- Realizar Pago de Facturas con Prima en Depósito
      nIdPrimaDeposito := OC_TARJETAS_PREPAGO.NUMERO_PRIMA_DEPOSITO(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                    cTipoTarjeta, nNumTarjeta, cCodPromotor);
      IF NVL(nIdPrimaDeposito,0) != 0 THEN
         BEGIN
            SELECT NumDepBancario
              INTO cNumDepBancario
              FROM TARJETAS_PREPAGO
             WHERE CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
               AND IdTipoSeg    = cIdTipoSeg
               AND PlanCob      = cPlanCob
               AND TipoTarjeta  = cTipoTarjeta
               AND NumTarjeta   = nNumTarjeta;

         END;

         FOR W IN FACT_Q LOOP
            --OC_FACTURAS.PAGAR_CON_PRIMA_DEPOSITO(W.IdFactura, nIdPrimaDeposito, cNumReciboPago, TRUNC(SYSDATE),cNumDepBancario);
            NULL;
         END LOOP;
         cStsProcActiv := 'ACTP';
      ELSE
         cStsProcActiv := 'ACTR';
      END IF;
      -- Actualiza No. de Póliza en Tarjeta Pre-Pago
      UPDATE TARJETAS_PREPAGO_ACTIV
         SET StsProcActiv = cStsProcActiv,
             FecProcActiv = TRUNC(SYSDATE),
                 IdPoliza     = nIdPoliza
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdTipoSeg    = cIdTipoSeg
         AND PlanCob      = cPlanCob
         AND TipoTarjeta  = cTipoTarjeta
         AND NumTarjeta   = nNumTarjeta
         AND IdPoliza    IS NULL;

      -- Actualiza Status de Tarjeta Pre-Pago
      UPDATE TARJETAS_PREPAGO
         SET StsTarjeta   = cStsProcActiv,
             FecSts       = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdTipoSeg    = cIdTipoSeg
         AND PlanCob      = cPlanCob
         AND TipoTarjeta  = cTipoTarjeta
         AND NumTarjeta   = nNumTarjeta;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,SQLERRM);
END EMISION_POLIZA_TARJETA;

FUNCTION NUMERO_PRIMA_DEPOSITO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                               cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                               cCodPromotor VARCHAR2) RETURN NUMBER IS

nIdPrimaDeposito   TARJETAS_PREPAGO.IdPrimaDeposito%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IdPrimaDeposito,0)
        INTO nIdPrimaDeposito
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdPrimaDeposito := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros para la Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))||
                                 ' NO se Puede Obtener el No. de Prima en Depósito');
   END;
   RETURN(nIdPrimaDeposito);
END NUMERO_PRIMA_DEPOSITO;

FUNCTION POSEE_PROMOTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                        cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER) RETURN VARCHAR2 IS
cCodPromotor   TARJETAS_PREPAGO.CodPromotor%TYPE;
BEGIN
   BEGIN
      SELECT CodPromotor
        INTO cCodPromotor
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodPromotor := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varias Tarjetas: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta)));
   END;
   IF cCodPromotor IS NULL THEN
      RETURN('N');
   ELSE
      RETURN('S');
   END IF;
END POSEE_PROMOTOR;

PROCEDURE ASIGNA_PROMOTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                          cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                          cCodPromotor VARCHAR2) IS
cExiste   VARCHAR2(1) := 'N';
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM TARJETAS_PREPAGO
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor IS NULL
         AND StsTarjeta  = 'PEND';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No Existe Tarjeta: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))||
                                 ' para Actualizarle el Código de Promotor ' || cCodPromotor);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen varias Tarjetas: '||TRIM(cTipoTarjeta)||'-'||TRIM(TO_CHAR(nNumTarjeta))||
                                 ' para Actualizarle el Código de Promotor ' || cCodPromotor);
   END;
   IF cExiste = 'S' THEN
      UPDATE TARJETAS_PREPAGO
         SET CodPromotor = cCodPromotor,
             StsTarjeta  = 'ASIG',
             FecSts      = SYSDATE
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor IS NULL
         AND StsTarjeta  = 'PEND';
   END IF;
END ASIGNA_PROMOTOR;

PROCEDURE CAMBIA_PROMOTOR(nCodCia NUMBER, cCodPromotorBaja VARCHAR2, cCodPromotorNuevo VARCHAR2) IS
BEGIN
   UPDATE TARJETAS_PREPAGO
      SET CodPromotor = cCodPromotorNuevo
    WHERE CodCia      = nCodCia
      AND StsTarjeta  = 'ASIG'
      AND CodPromotor = cCodPromotorBaja;
END CAMBIA_PROMOTOR;

FUNCTION FOLIOS_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2, cStsFolio VARCHAR2) RETURN NUMBER IS
nCantFolios   NUMBER(20);
BEGIN
   SELECT NVL(COUNT(*),0)
     INTO nCantFolios
     FROM TARJETAS_PREPAGO
    WHERE CodCia      = nCodCia
      AND StsTarjeta  = cStsFolio
      AND CodPromotor = cCodPromotor;
   RETURN(nCantFolios);
END FOLIOS_PROMOTOR;

PROCEDURE CAMBIA_LIBERA_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,
                                cCodPromotor VARCHAR2, cCodPromotorNuevo VARCHAR2) IS
BEGIN
   IF cCodPromotorNuevo IS NULL THEN
      UPDATE TARJETAS_PREPAGO
         SET CodPromotor = NULL,
             StsTarjeta  = 'PEND',
             FecSts      = SYSDATE
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta  = 'ASIG';
   ELSE
      UPDATE TARJETAS_PREPAGO
         SET CodPromotor = cCodPromotorNuevo,
             FecSts      = SYSDATE
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND TipoTarjeta = cTipoTarjeta
         AND NumTarjeta  = nNumTarjeta
         AND CodPromotor = cCodPromotor
         AND StsTarjeta  = 'ASIG';
   END IF;
END CAMBIA_LIBERA_TARJETA;

END OC_TARJETAS_PREPAGO;
/

--
-- OC_TARJETAS_PREPAGO  (Synonym) 
--
--  Dependencies: 
--   OC_TARJETAS_PREPAGO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_TARJETAS_PREPAGO FOR SICAS_OC.OC_TARJETAS_PREPAGO
/


GRANT EXECUTE ON SICAS_OC.OC_TARJETAS_PREPAGO TO PUBLIC
/

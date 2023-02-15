CREATE OR REPLACE PACKAGE GT_FAI_TIPOS_DE_FONDOS AS

cTipoFondo       FAI_TIPOS_DE_FONDOS.TipoFondo%TYPE;
cStatus          FAI_TIPOS_DE_FONDOS.StsFondo%TYPE;
nCodCia          FAI_TIPOS_DE_FONDOS.CodCia%TYPE;
nCodEmpresa      FAI_TIPOS_DE_FONDOS.CodEmpresa%TYPE;

CURSOR MOV_Q IS
   SELECT CodCptoMov
     FROM FAI_MOVIMIENTOS_FONDOS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND StsMovFondo  = cStatus;

CURSOR CARGO_Q IS
   SELECT CodCargo
     FROM FAI_CARGOS_FONDOS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND StsCargo     = cStatus;

CURSOR BONO_Q IS
   SELECT CodBono
     FROM FAI_BONOS_FONDOS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND StsBono      = cStatus;

CURSOR PLAN_RET_Q IS
   SELECT CodPlanRet
     FROM FAI_PLAN_RETIRO_FALLEC
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND StsPlanRet   = cStatus;

CURSOR INCENTIVOS_Q IS
   SELECT CodIncentivo
     FROM FAI_CONF_TIPO_INCENTIVO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
	   AND StsIncentivo = cStatus;

CURSOR EMAILS_Q IS
   SELECT CodCptoMov, FecIniEmail, FecFinEmail
     FROM FAI_EMAIL_MOVIMIENTO_FONDO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
	   AND StsEmail     = cStatus;

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2);

FUNCTION DESCRIPCION (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

FUNCTION MONEDA_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

FUNCTION INDICADORES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoIndic VARCHAR2) RETURN VARCHAR2;

FUNCTION MONTOS_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoMonto VARCHAR2) RETURN NUMBER;

FUNCTION MONTOS_FONDO_AGRUPA_PARAM(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoMonto VARCHAR2,
                                   cCodRutinaTopes VARCHAR2, cCodRutinaMinimos VARCHAR2) RETURN NUMBER;
                                   
FUNCTION DEFINE_MONTOS_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cParam1 VARCHAR2, cParam2 VARCHAR2 ) RETURN NUMBER;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, cNomFondoDest VARCHAR2);

FUNCTION EDADES_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoEdad VARCHAR2) RETURN NUMBER;

FUNCTION ARTICULO_FONDO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

FUNCTION STATUS_FONDO (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

FUNCTION CODIGO_APORTE_INICIAL(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

FUNCTION CLASE_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

FUNCTION TIPO_INTERES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

FUNCTION TASA_CAMBIO_TOPES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN NUMBER;

FUNCTION PERIODO_LIQUIDEZ(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

END GT_FAI_TIPOS_DE_FONDOS;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_TIPOS_DE_FONDOS AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) IS
BEGIN
   GT_FAI_TIPOS_DE_FONDOS.cTipoFondo  := cTipoFondo;
   GT_FAI_TIPOS_DE_FONDOS.cStatus     := 'CONFIG';
   GT_FAI_TIPOS_DE_FONDOS.nCodCia     := nCodCia;
   GT_FAI_TIPOS_DE_FONDOS.nCodEmpresa := nCodEmpresa;

   UPDATE FAI_TIPOS_DE_FONDOS
      SET StsFondo   = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo;

-- Activa Movimientos del Fondo
   FOR X IN MOV_Q LOOP
      GT_FAI_MOVIMIENTOS_FONDOS.ACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, X.CodCptoMov);
   END LOOP;

-- Activa Cargos al Fondo
   FOR Y IN CARGO_Q LOOP
      GT_FAI_CARGOS_FONDOS.ACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, Y.CodCargo);
   END LOOP;

-- Activa Bonos al Fondo
   FOR Z IN BONO_Q LOOP
      GT_FAI_BONOS_FONDOS.ACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, Z.CodBono);
   END LOOP;

-- Activa Planes de Retiro y Fallecimiento
   FOR W IN PLAN_RET_Q LOOP
      GT_FAI_PLAN_RETIRO_FALLEC.ACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, W.CodPlanRet);
   END LOOP;

-- Activa Incentivos del Fondo
   FOR T IN INCENTIVOS_Q LOOP
      GT_FAI_CONF_TIPO_INCENTIVO.ACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, T.CodIncentivo);
   END LOOP;

-- Activa emails de movimientos del Fondo
   FOR R IN EMAILS_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.ACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, R.CodCptoMov, R.FecIniEmail, R.FecFinEmail);
   END LOOP;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) IS
BEGIN
   GT_FAI_TIPOS_DE_FONDOS.cTipoFondo  := cTipoFondo;
   GT_FAI_TIPOS_DE_FONDOS.cStatus     := 'ACTIVO';
   GT_FAI_TIPOS_DE_FONDOS.nCodCia     := nCodCia;
   GT_FAI_TIPOS_DE_FONDOS.nCodEmpresa := nCodEmpresa;

   UPDATE FAI_TIPOS_DE_FONDOS
      SET StsFondo   = 'CONFIG',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo;

-- Configura Movimientos del Fondo
   FOR X IN MOV_Q LOOP
      GT_FAI_MOVIMIENTOS_FONDOS.CONFIGURAR(nCodCia, nCodEmpresa, cTipoFondo, X.CodCptoMov);
   END LOOP;

-- Configura Cargos al Fondo
   FOR Y IN CARGO_Q LOOP
      GT_FAI_CARGOS_FONDOS.CONFIGURAR(nCodCia, nCodEmpresa, cTipoFondo, Y.CodCargo);
   END LOOP;

-- Configura Bonos al Fondo
   FOR Z IN BONO_Q LOOP
      GT_FAI_BONOS_FONDOS.CONFIGURAR(nCodCia, nCodEmpresa, cTipoFondo, Z.CodBono);
   END LOOP;

-- Configura Planes de Retiro y Fallecimiento
   FOR W IN PLAN_RET_Q LOOP
      GT_FAI_PLAN_RETIRO_FALLEC.CONFIGURAR(nCodCia, nCodEmpresa, cTipoFondo, W.CodPlanRet);
   END LOOP;

-- Configura Incentivos del Fondo
   FOR T IN INCENTIVOS_Q LOOP
      GT_FAI_CONF_TIPO_INCENTIVO.CONFIGURAR(nCodCia, nCodEmpresa, cTipoFondo, T.CodIncentivo);
   END LOOP;

-- Configura emails de movimientos del Fondo
   FOR R IN EMAILS_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.CONFIGURAR(nCodCia, nCodEmpresa, cTipoFondo, R.CodCptoMov, R.FecIniEmail, R.FecFinEmail);
   END LOOP;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) IS
BEGIN
   GT_FAI_TIPOS_DE_FONDOS.cTipoFondo  := cTipoFondo;
   GT_FAI_TIPOS_DE_FONDOS.cStatus     := 'SUSPEN';
   GT_FAI_TIPOS_DE_FONDOS.nCodCia     := nCodCia;
   GT_FAI_TIPOS_DE_FONDOS.nCodEmpresa := nCodEmpresa;

   UPDATE FAI_TIPOS_DE_FONDOS
      SET StsFondo   = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo;

-- Reactiva Movimientos del Fondo
   FOR X IN MOV_Q LOOP
      GT_FAI_MOVIMIENTOS_FONDOS.REACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, X.CodCptoMov);
   END LOOP;

-- Reactiva Cargos al Fondo
   FOR Y IN CARGO_Q LOOP
      GT_FAI_CARGOS_FONDOS.REACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, Y.CodCargo);
   END LOOP;

-- Reactiva Bonos al Fondo
   FOR Z IN BONO_Q LOOP
      GT_FAI_BONOS_FONDOS.REACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, Z.CodBono);
   END LOOP;

-- Reactiva Planes de Retiro y Fallecimiento
   FOR W IN PLAN_RET_Q LOOP
      GT_FAI_PLAN_RETIRO_FALLEC.REACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, W.CodPlanRet);
   END LOOP;

-- Reactiva Incentivos del Fondo
   FOR T IN INCENTIVOS_Q LOOP
      GT_FAI_CONF_TIPO_INCENTIVO.REACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, T.CodIncentivo);
   END LOOP;

-- Reactiva emails de movimientos del Fondo
   FOR R IN EMAILS_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.REACTIVAR(nCodCia, nCodEmpresa, cTipoFondo, R.CodCptoMov, R.FecIniEmail, R.FecFinEmail);
   END LOOP;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) IS
BEGIN
   GT_FAI_TIPOS_DE_FONDOS.cTipoFondo  := cTipoFondo;
   GT_FAI_TIPOS_DE_FONDOS.cStatus     := 'ACTIVO';
   GT_FAI_TIPOS_DE_FONDOS.nCodCia     := nCodCia;
   GT_FAI_TIPOS_DE_FONDOS.nCodEmpresa := nCodEmpresa;

   UPDATE FAI_TIPOS_DE_FONDOS
      SET StsFondo   = 'SUSPEN',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo;


-- Suspende Movimientos del Fondo
   FOR X IN MOV_Q LOOP
      GT_FAI_MOVIMIENTOS_FONDOS.SUSPENDER(nCodCia, nCodEmpresa, cTipoFondo, X.CodCptoMov);
   END LOOP;

-- Suspende Cargos al Fondo
   FOR Y IN CARGO_Q LOOP
      GT_FAI_CARGOS_FONDOS.SUSPENDER(nCodCia, nCodEmpresa, cTipoFondo, Y.CodCargo);
   END LOOP;

-- Suspende Bonos al Fondo
   FOR Z IN BONO_Q LOOP
      GT_FAI_BONOS_FONDOS.SUSPENDER(nCodCia, nCodEmpresa, cTipoFondo, Z.CodBono);
   END LOOP;

-- Suspende Planes de Retiro y Fallecimiento
   FOR W IN PLAN_RET_Q LOOP
      GT_FAI_PLAN_RETIRO_FALLEC.SUSPENDER(nCodCia, nCodEmpresa, cTipoFondo, W.CodPlanRet);
   END LOOP;

-- Suspende Incentivos del Fondo
   FOR T IN INCENTIVOS_Q LOOP
      GT_FAI_CONF_TIPO_INCENTIVO.SUSPENDER(nCodCia, nCodEmpresa, cTipoFondo, T.CodIncentivo);
   END LOOP;

-- Suspende emails de movimientos del Fondo
   FOR R IN EMAILS_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.SUSPENDER(nCodCia, nCodEmpresa, cTipoFondo, R.CodCptoMov, R.FecIniEmail, R.FecFinEmail);
   END LOOP;
END SUSPENDER;

FUNCTION DESCRIPCION (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cDescFondo   FAI_TIPOS_DE_FONDOS.DescFondo%TYPE;
BEGIN
   BEGIN
      SELECT DescFondo
        INTO cDescFondo
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescFondo := 'NO EXISTE';
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'ERROR en Función DESCRIPCION del Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
   END;
   RETURN(cDescFondo);
END DESCRIPCION;

FUNCTION MONEDA_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cCodMoneda   FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
BEGIN
   BEGIN
      SELECT CodMoneda
        INTO cCodMoneda
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodMoneda := NULL;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'ERROR en Función MONEDA del Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
   END;
   RETURN(cCodMoneda);
END MONEDA_FONDO;

FUNCTION INDICADORES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoIndic VARCHAR2) RETURN VARCHAR2 IS
cIndRetorno    VARCHAR2(1);
CURSOR IND_Q IS
   SELECT IndGenAporteIni, IndAportes, IndRetParciales, IndRetTotales,
          IndAjustes, IndTraspaso, IndPrestamos, IndDescIntFondo,
          IndDescPtmoFondo, IndComision, IndIncentivos, IndAVM, IndRetAnioIni,
          IndRescateAutomatico, IndManejoMonedaLoc, IndGenIntereses,
          IndPlazoOblgComp, IndBeneficiarios, IndDctoCobFondo, IndUnidades,
          IndConfAportes, IndAplicaIR, IndInteresesDiarios, IndConsultaWEB,
          IndExclusivoPagoPrima, IndFondoColectivos
     FROM FAI_TIPOS_DE_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo;
BEGIN
   FOR X IN IND_Q LOOP
      IF cTipoIndic = 'AI' THEN -- Aporte Inicial
         cIndRetorno := X.IndGenAporteIni;
      ELSIF cTipoIndic = 'AA' THEN -- Aportes Adicionales
         cIndRetorno := X.IndAportes;
      ELSIF cTipoIndic = 'RP' THEN -- Retiros Parciales
         cIndRetorno := X.IndRetParciales;
      ELSIF cTipoIndic = 'RT' THEN -- Retiros Totales
         cIndRetorno := X.IndRetTotales;
      ELSIF cTipoIndic = 'AJ' THEN -- Ajustes
         cIndRetorno := X.IndAjustes;
      ELSIF cTipoIndic = 'TR' THEN -- Traspasos
         cIndRetorno := X.IndTraspaso;
      ELSIF cTipoIndic = 'PT' THEN -- Préstamos
         cIndRetorno := X.IndPrestamos;
      ELSIF cTipoIndic = 'DI' THEN -- Descuenta Intereses del Fondo
         cIndRetorno := X.IndDescIntFondo;
      ELSIF cTipoIndic = 'DP' THEN -- Descuenta Préstamos del Fondo
         cIndRetorno := X.IndDescPtmoFondo;
      ELSIF cTipoIndic = 'CO' THEN -- Genera Comisiones
         cIndRetorno := X.IndComision;
      ELSIF cTipoIndic = 'IN' THEN -- Incentivos
         cIndRetorno := X.IndIncentivos;
      ELSIF cTipoIndic = 'AV' THEN -- Ajuste Valor de Mercado
         cIndRetorno := X.IndAVM;
      ELSIF cTipoIndic = 'R1' THEN -- Permite Retiros el 1er. Año
         cIndRetorno := X.IndRetAnioIni;
      ELSIF CTipoIndic = 'RA ' THEN -- Rescate Automático si Baja del Mínimo
         cIndRetorno := X.IndRescateAutomatico;
      ELSIF cTipoIndic = 'ML' THEN -- Manejo por Moneda Local
         cIndRetorno := X.IndManejoMonedaLoc;
      ELSIF cTipoIndic = 'GI' THEN -- Generar Intereses
         cIndRetorno := X.IndGenIntereses;
      ELSIF cTipoIndic = 'PC' THEN -- Maneja Plazo Comprometido y Obligado
         cIndRetorno := X.IndPlazoOblgComp;
      ELSIF cTipoIndic = 'BF' THEN -- Beneficiarios del Fondo
         cIndRetorno := X.IndBeneficiarios;
      ELSIF cTipoIndic = 'DC' THEN -- Permite Descuento de Cobertura en Fondo
         cIndRetorno := X.IndDctoCobFondo;
      ELSIF cTipoIndic = 'UN' THEN -- Maneja Unidades
         cIndRetorno := X.IndUnidades;
      ELSIF cTipoIndic = 'CA' THEN -- Configura Aportes Subsecuentes
         cIndRetorno := X.IndConfAportes;
      ELSIF cTipoIndic = 'IR' THEN -- Aplica Interes Real
         cIndRetorno := X.IndAplicaIR;
      ELSIF cTipoIndic = 'ID' THEN -- Aplica Intereses Diarios
         cIndRetorno := X.IndInteresesDiarios;
      ELSIF cTipoIndic = 'WEB' THEN -- Consulta en WEB Portal de Asegurados
         cIndRetorno := X.IndConsultaWEB;
      ELSIF cTipoIndic = 'EPP' THEN -- Exclusivo para Pago de Primas
         cIndRetorno := X.IndExclusivoPagoPrima;
      ELSIF cTipoIndic = 'FCOL' THEN -- Fondo Para Colectividad de Asegurados
         cIndRetorno := X.IndFondoColectivos;
      END IF;
   END LOOP;
   RETURN(NVL(cIndRetorno,'N'));
END INDICADORES;

FUNCTION MONTOS_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoMonto VARCHAR2) RETURN NUMBER IS
nMtoAporteMin       FAI_TIPOS_DE_FONDOS.MtoAporteMin%TYPE;
nMtoAporteMax       FAI_TIPOS_DE_FONDOS.MtoAporteMax%TYPE;
nMtoAporteIni       FAI_TIPOS_DE_FONDOS.MtoAporteIni%TYPE;
BEGIN
   SELECT MtoAporteMin, MtoAporteMax, MtoAporteIni
     INTO nMtoAporteMin, nMtoAporteMax, nMtoAporteIni
     FROM FAI_TIPOS_DE_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo;
   IF cTipoMonto = 'MI' THEN
      RETURN(nMtoAporteMin);
   ELSIF cTipoMonto = 'MA' THEN
      RETURN(nMtoAporteMax);
   ELSIF cTipoMonto = 'IN' THEN
      RETURN(nMtoAporteIni);
   ELSE
      RETURN(0);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
END MONTOS_FONDO;

FUNCTION MONTOS_FONDO_AGRUPA_PARAM(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoMonto VARCHAR2,
                                   cCodRutinaTopes VARCHAR2, cCodRutinaMinimos VARCHAR2) RETURN NUMBER IS

nMtoAporteMin    FAI_TIPOS_DE_FONDOS.MtoAporteMin%TYPE;
nMtoAporteMax    FAI_TIPOS_DE_FONDOS.MtoAporteMax%TYPE;
nMtoAporteIni    FAI_TIPOS_DE_FONDOS.MtoAporteIni%TYPE;
BEGIN
   IF cCodRutinaTopes IS NOT NULL THEN
      SELECT MAX(MtoAporteMin * NVL(TasaCambioTopes, 1)),
             MAX(MtoAporteMax * NVL(TasaCambioTopes, 1)),
             MAX(MtoAporteIni * NVL(TasaCambioTopes, 1))
        INTO nMtoAporteMin, nMtoAporteMax, nMtoAporteIni
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND TipoFondo      = cTipoFondo
         AND CodRutinaTopes = cCodRutinaTopes;
   ELSIF cCodRutinaMinimos IS NOT NULL THEN
      SELECT MAX(MtoAporteMin * NVL(TasaCambioTopes, 1)), 0, 0
        INTO nMtoAporteMin, nMtoAporteMax, nMtoAporteIni
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND TipoFondo        = cTipoFondo
         AND CodRutinaMinimos = cCodRutinaMinimos;
   END IF;
   IF cTipoMonto = 'MI' THEN
      RETURN(nMtoAporteMin);
   ELSIF cTipoMonto = 'MA' THEN
      RETURN(nMtoAporteMax);
   ELSIF cTipoMonto = 'IN' THEN
      RETURN(nMtoAporteIni);
   ELSE
      RETURN(0);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
END MONTOS_FONDO_AGRUPA_PARAM;

FUNCTION DEFINE_MONTOS_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cParam1 VARCHAR2, cParam2 VARCHAR2 ) RETURN NUMBER IS
nMonto   FAI_TIPOS_DE_FONDOS.MtoAporteMin%TYPE;
BEGIN
   IF cParam2 IS NULL THEN
      nMonto := GT_FAI_TIPOS_DE_FONDOS.MONTOS_FONDO(nCodCia, nCodEmpresa, cTipoFondo, cParam1);
   -- Se agrega rutina para Optimaxx Patrimonial - EC - 27/05/2009
   ELSIF cParam2 IN ('MAXIMOPORART176', 'MAXIMOPORART218','TOPESPATRIMONIAL') THEN
      nMonto := GT_FAI_TIPOS_DE_FONDOS.MONTOS_FONDO_AGRUPA_PARAM(nCodCia, nCodEmpresa, cTipoFondo, cParam1, cParam2, NULL);
   ELSIF cParam2 IS NOT NULL THEN
      nMonto := GT_FAI_TIPOS_DE_FONDOS.MONTOS_FONDO_AGRUPA_PARAM(nCodCia, nCodEmpresa, cTipoFondo, cParam1, NULL, cParam2);
   END IF;
   RETURN(nMonto);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
END DEFINE_MONTOS_FONDO;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, cNomFondoDest VARCHAR2) IS

cTipoInteres   FAI_TIPOS_DE_FONDOS.TipoInteres%TYPE;

CURSOR TIPOS_Q IS
   SELECT DescFondo, CodMoneda, PorcFondo, StsFondo, FecStatus,
          EdadMin, EdadMax, EdadRetiro, MtoAporteMin,
          MtoAporteMax, MtoAporteIni, IndAportes, IndGenAporteIni,
          CodAportIni, IndRetParciales, IndRetTotales, IndAjustes,
          IndTraspaso, IndPrestamos, PorcPrestamos, CalcIntPrestamos,
          TipoIntPrestamos, IndDescIntFondo, InddescPtmoFondo,
          IndComision, IndIncentivos, TipoInteres, TiempoMinimo,
          NumDiasAnul, AnoIndisput, IndAvm, NomRepEstCta, NomRepCertif,
          NomRepFiniquito, TipoInteresGar, IndRetAnioIni, TipoInflacion,
          MtoMinConcentradora, IndRescateAutomatico, NomRepRescAutomatico,
          NomRepCartBien, NomRepTabVal, IndManejoMonedaLoc, IndGenIntereses, 
          CodRutinaCalcInt, IndPlazoOblgComp, ClaseFondo, TipoFondoAsoc,
          CodTipoInversion, IndBeneficiarios, IndDctoCobFondo, CodRutinaMinimos, 
          IndUnidades, CodCptoResAutom, TipoRangoAportes, CodArticulo, CodRutinaTopes,
          TasaCambioTopes, NomRepRecibo, CodCobertPaf, MesesPreferencial, 
          IndConfAportes, PeriodoLiquidez, IndCobCobertOpcDif, AnioPeriodoRetiro, 
          IndComFondoPol, IndConsultaWEB, IndExclusivoPagoPrima, IndFondoColectivos
     FROM FAI_TIPOS_DE_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig;

CURSOR MOV_Q IS
   SELECT CodCptoMov
     FROM FAI_MOVIMIENTOS_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig;

CURSOR CARGO_Q IS
   SELECT CodCargo, DescCargo
     FROM FAI_CARGOS_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig;

CURSOR BONO_Q IS
   SELECT CodBono, DescBono
     FROM FAI_BONOS_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig;

CURSOR PLAN_RET_Q IS
   SELECT CodPlanRet, DescPlanRet
     FROM FAI_PLAN_RETIRO_FALLEC
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo = cTipoFondoOrig;

CURSOR COMI_Q IS
   SELECT DISTINCT NivelComision, PlanComision
     FROM FAI_CONF_COMISIONES_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig;

CURSOR INCEN_Q IS
   SELECT CodIncentivo, DescIncentivo
     FROM FAI_CONF_TIPO_INCENTIVO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig;

CURSOR  CONFIG_Q IS
   SELECT DISTINCT TipoInteres
     FROM FAI_CONFIG_TASAS_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig
	   AND TipoInteres = cTipoInteres;
   
-- Se agrega copia de email -  OC Tecnologías - 20/09/2009
CURSOR EMAIL_Q IS
   SELECT CodCptoMov, FecIniEmail, FecFinEmail, TextoEmail
     FROM FAI_EMAIL_MOVIMIENTO_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo    = cTipoFondoOrig
	   AND FecIniEmail <= TRUNC(SYSDATE)
		AND FecFinEmail >= TRUNC(SYSDATE);
BEGIN
   -- Inserta Tipos de Fondos
   FOR X IN TIPOS_Q LOOP
      cTipoInteres := X.TipoInteres;
      INSERT INTO FAI_TIPOS_DE_FONDOS
             (CodCia, CodEmpresa, TipoFondo, DescFondo, CodMoneda, PorcFondo, StsFondo, FecStatus,
              EdadMin, EdadMax, EdadRetiro, MtoAporteMin,
              MtoAporteMax, MtoAporteIni, IndAportes, IndGenAporteIni,
              CodAportIni, IndRetParciales, IndRetTotales, IndAjustes,
              IndTraspaso, IndPrestamos, PorcPrestamos, CalcIntPrestamos,
              TipoIntPrestamos, IndDescIntFondo, IndDescPtmoFondo,
              IndComision, IndIncentivos, TipoInteres, TiempoMinimo,
              NumDiasAnul, AnoIndisput, IndAvm, NomRepEstCta, NomRepCertif,
              NomRepFiniquito, TipoInteresGar, IndRetAnioIni, TipoInflacion,
              MtoMinConcentradora, IndRescateAutomatico, NomRepRescAutomatico,
              NomRepCartBien, NomRepTabVal, IndManejoMonedaLoc, IndGenIntereses, 
              CodRutinaCalcInt, IndPlazoOblgComp, ClaseFondo, TipoFondoAsoc,
              CodTipoInversion, IndBeneficiarios, IndDctoCobFondo, CodRutinaMinimos, 
              IndUnidades, CodCptoResAutom, TipoRangoAportes, CodArticulo, CodRutinaTopes,
              TasaCambioTopes, NomRepRecibo, CodCobertPaf, MesesPreferencial, 
              IndConfAportes, PeriodoLiquidez, IndCobCobertOpcDif, AnioPeriodoRetiro, 
              IndComFondoPol, IndConsultaWEB, IndExclusivoPagoPrima, IndFondoColectivos)
      VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cNomFondoDest, X.CodMoneda, X.PorcFondo, 'CONFIG', TRUNC(SYSDATE),
              X.EdadMin, X.EdadMax, X.EdadRetiro, X.MtoAporteMin,
              X.MtoAporteMax, X.MtoAporteIni, X.IndAportes, X.IndGenAporteIni,
              X.CodAportIni, X.IndRetParciales, X.IndRetTotales, X.IndAjustes,
              X.IndTraspaso, X.IndPrestamos, X.PorcPrestamos, X.CalcIntPrestamos,
              X.TipoIntPrestamos, X.IndDescIntFondo, X.InddescPtmoFondo,
              X.IndComision, X.IndIncentivos, X.TipoInteres, X.TiempoMinimo,
              X.NumDiasAnul, X.AnoIndisput, X.IndAvm, X.NomRepEstCta, X.NomRepCertif,
              X.NomRepFiniquito, X.TipoInteresGar, X.IndRetAnioIni, X.TipoInflacion,
              X.MtoMinConcentradora, X.IndRescateAutomatico, X.NomRepRescAutomatico,
              X.NomRepCartBien, X.NomRepTabVal, X.IndManejoMonedaLoc, X.IndGenIntereses, 
              X.CodRutinaCalcInt, X.IndPlazoOblgComp, X.ClaseFondo, X.TipoFondoAsoc,
              X.CodTipoInversion, X.IndBeneficiarios, X.IndDctoCobFondo, X.CodRutinaMinimos, 
              X.IndUnidades, X.CodCptoResAutom, X.TipoRangoAportes, X.CodArticulo, X.CodRutinaTopes,
              X.TasaCambioTopes, X.NomRepRecibo, X.CodCobertPaf, X.MesesPreferencial, 
              X.IndConfAportes, X.PeriodoLiquidez, X.IndCobCobertOpcDif, X.AnioPeriodoRetiro, 
              X.IndComFondoPol, X.IndConsultaWEB, X.IndExclusivoPagoPrima, X.IndFondoColectivos);
   END LOOP;

   FOR X IN MOV_Q LOOP
      GT_FAI_MOVIMIENTOS_FONDOS.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, X.CodCPtoMov, X.CodCPtoMov);
   END LOOP;

   -- Inserta Cargos del Fondo
   FOR X IN CARGO_Q LOOP
      GT_FAI_CARGOS_FONDOS.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, X.CodCargo, X.CodCargo, X.DescCargo);
   END LOOP;

   -- Inserta Bonos del Fondo
   FOR X IN BONO_Q LOOP
      GT_FAI_BONOS_FONDOS.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, X.CodBono, X.CodBono, X.DescBono);
   END LOOP;

   -- Inserta Planes de Retiro y Fallecimiento del Fondo
   FOR X IN PLAN_RET_Q LOOP
      GT_FAI_PLAN_RETIRO_FALLEC.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, X.CodPlanRet, X.CodPlanRet, X.DescPlanRet);
   END LOOP;

   -- Inserta Comisiones del Fondo
   FOR X IN COMI_Q LOOP
      GT_FAI_CONF_COMISIONES_FONDO.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest,
                                          X.NivelComision, X.PlanComision, X.NivelComision, X.PlanComision);
   END LOOP;

   -- Inserta Incentivos del Fondo
   FOR X IN INCEN_Q LOOP
      GT_FAI_CONF_TIPO_INCENTIVO.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest,
                                        X.CodIncentivo, X.CodIncentivo, X.DescIncentivo);
   END LOOP;
  -- Inserta Config_Tasas_Fondos
   FOR X IN CONFIG_Q LOOP
      GT_FAI_CONFIG_TASAS_FONDOS.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, X.TipoInteres, X.TipoInteres);
   END LOOP;
   
   -- Se agrega copia de email
   FOR X IN EMAIL_Q LOOP
      GT_FAI_EMAIL_MOVIMIENTO_FONDO.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, X.CodCptoMov,
                                           X.FecIniEmail, X.FecFinEmail, cTipoFondoDest, X.CodCptoMov);
   END LOOP;
END COPIAR;

FUNCTION EDADES_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cTipoEdad VARCHAR2) RETURN NUMBER IS
nEdadMin     FAI_TIPOS_DE_FONDOS.EdadMin%TYPE;
nEdadMax     FAI_TIPOS_DE_FONDOS.EdadMax%TYPE;
nEdadRetiro  FAI_TIPOS_DE_FONDOS.EdadRetiro%TYPE;
BEGIN
   SELECT EdadMin, EdadMax, EdadRetiro
     INTO nEdadMin, nEdadMax, nEdadRetiro
     FROM FAI_TIPOS_DE_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo = cTipoFondo;

   IF cTipoEdad = 'MI' THEN
      RETURN(nEdadMin);
   ELSIF cTipoEdad = 'MA' THEN
      RETURN(nEdadMax);
   ELSIF cTipoEdad = 'RE' THEN
      RETURN(nEdadRetiro);
   ELSE
      RETURN(0);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
END EDADES_FONDO;

FUNCTION ARTICULO_FONDO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
cCodArticulo      FAI_TIPOS_DE_FONDOS.CodArticulo%TYPE;
BEGIN
   SELECT NVL(MAX(TF.CodArticulo),'NO EXISTE') 
     INTO cCodArticulo
     FROM FAI_TIPOS_DE_FONDOS TF, FAI_FONDOS_DETALLE_POLIZA FD
    WHERE TF.CodEmpresa = FD.CodEmpresa
      AND TF.CodCia     = FD.CodCia
      AND TF.TipoFondo  = FD.TipoFondo
      AND FD.IdPoliza   = nIdPoliza
      AND FD.CodEmpresa = nCodEmpresa
      AND FD.CodCia     = nCodCia;
   RETURN(cCodArticulo);
END ARTICULO_FONDO;

FUNCTION STATUS_FONDO (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cStsFondo   FAI_TIPOS_DE_FONDOS.StsFondo%TYPE;
BEGIN
   BEGIN
      SELECT StsFondo
        INTO cStsFondo
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cStsFondo := 'NO EXISTE';
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'ERROR en Función STATUS del Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
   END;
   RETURN(cStsFondo);
END STATUS_FONDO;

FUNCTION CODIGO_APORTE_INICIAL(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cCodAportIni   FAI_TIPOS_DE_FONDOS.CodAportIni%TYPE;
BEGIN
   BEGIN
      SELECT CodAportIni
        INTO cCodAportIni
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100, 'NO Existe Tipo de Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'ERROR en Función CODIGO_APORTE_INICIAL del Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
   END;
   RETURN(cCodAportIni);
END CODIGO_APORTE_INICIAL;

FUNCTION CLASE_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cClaseFondo   FAI_TIPOS_DE_FONDOS.ClaseFondo%TYPE;
BEGIN
   BEGIN
      SELECT ClaseFondo
        INTO cClaseFondo
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100, 'NO Existe Tipo de Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'ERROR en Función CLASE_FONDO del Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
   END;
   RETURN(cClaseFondo);
END CLASE_FONDO;

FUNCTION TIPO_INTERES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cTipoInteres   FAI_TIPOS_DE_FONDOS.TipoInteres%TYPE;
BEGIN
   BEGIN
      SELECT TipoInteres
        INTO cTipoInteres
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100, 'NO Existe Tipo de Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'ERROR en Función TIPO_INTERES del Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
   END;
   RETURN(cTipoInteres);
END TIPO_INTERES;

FUNCTION TASA_CAMBIO_TOPES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN NUMBER IS
nTasaCambioTopes   FAI_TIPOS_DE_FONDOS.TasaCambioTopes%TYPE;
BEGIN
   BEGIN
      SELECT NVL(TasaCambioTopes,1)
        INTO nTasaCambioTopes
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100, 'NO Existe Tipo de Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'ERROR en Función TASA_CAMBIO_TOPES del Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
   END;
   RETURN(nTasaCambioTopes);
END TASA_CAMBIO_TOPES;

FUNCTION PERIODO_LIQUIDEZ(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cPeriodoLiquidez   FAI_TIPOS_DE_FONDOS.PeriodoLiquidez%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PeriodoLiquidez,'D')
        INTO cPeriodoLiquidez
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoFondo   = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100, 'NO Existe Tipo de Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'ERROR en Función PERIODO_LIQUIDEZ del Fondo: ' || cTipoFondo || ' - ' || SQLERRM);
   END;
   RETURN(cPeriodoLiquidez);
END PERIODO_LIQUIDEZ;

END GT_FAI_TIPOS_DE_FONDOS;

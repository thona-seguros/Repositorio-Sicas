--
-- OC_SOLICITUD_COBERTURAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_POLIZA (Table)
--   TARIFA_CONTROL_VIGENCIAS (Table)
--   GT_TARIFA_CONTROL_VIGENCIAS (Package)
--   ACTIVIDADES_ECONOMICAS (Table)
--   OC_SOLICITUD_ASISTENCIAS (Package)
--   OC_SOLICITUD_DETALLE (Package)
--   OC_SOLICITUD_EMISION (Package)
--   SOLICITUD_ASISTENCIAS (Table)
--   SOLICITUD_COBERTURAS (Table)
--   SOLICITUD_DETALLE (Table)
--   SOLICITUD_EMISION (Table)
--   CONFIG_PLANTILLAS_PLANCOB (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT_ASEG (Table)
--   OC_TARIFA_DINAMICA (Package)
--   OC_TARIFA_SEXO_EDAD_RIESGO (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_GENERALES (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SOLICITUD_COBERTURAS IS

PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdSolicitud NUMBER, nIDetSol NUMBER,
                            nTasaCambio NUMBER, nEdad NUMBER, nCod_Moneda VARCHAR2);

PROCEDURE ACTUALIZA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER,
                               nTasaCambio NUMBER, nPrimaAsegurado NUMBER);

FUNCTION EXISTEN_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2;

FUNCTION TIENE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2;

FUNCTION COBERTURAS_NEGATIVAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2;

PROCEDURE TRASLADA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, 
                              nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

FUNCTION TOTAL_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN NUMBER;

PROCEDURE ELIMINAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER);

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER);

END OC_SOLICITUD_COBERTURAS;
/

--
-- OC_SOLICITUD_COBERTURAS  (Package Body) 
--
--  Dependencies: 
--   OC_SOLICITUD_COBERTURAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SOLICITUD_COBERTURAS IS
PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdSolicitud NUMBER, nIDetSol NUMBER,
                            nTasaCambio NUMBER, nEdad NUMBER, nCod_Moneda VARCHAR2) IS
nTasaCambioDet          DETALLE_POLIZA.Tasa_Cambio%TYPE;
nSumaAsegMoneda         DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nSumaAsegLocal          DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
dFecIniVig              DETALLE_POLIZA.FecIniVig%TYPE;
cSexo                   PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cRiesgo                 ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
cCodActividad           PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
nCantAsegModelo         SOLICITUD_DETALLE.CantAsegModelo%TYPE;
nExiste                 NUMBER;
nExisteAgen             NUMBER;
nTasa                   NUMBER;
nValor                  NUMBER;
nValorMoneda            NUMBER;
cTipoProceso            CONFIG_PLANTILLAS_PLANCOB.TipoProceso%TYPE;
nIdTarifa               TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;

CURSOR COB_Q IS
   SELECT CodCobert, Porc_Tasa, TipoTasa, Prima_Cobert,
          SumaAsegurada, Cod_Moneda, CodTarifa, MontoDeducible
     FROM COBERTURAS_DE_SEGUROS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob
      AND Edad_Minima  <= nEdad
      AND Edad_Maxima  >= nEdad
      AND StsCobertura  = 'ACT';
BEGIN
   IF NVL(nTasaCambio,0) = 0 THEN
      RAISE_APPLICATION_ERROR(-20225,'No Existe Tasa de Cambio para Generar Coberturas');
   END IF;
   BEGIN
      SELECT 1
        INTO nExiste
        FROM SOLICITUD_COBERTURAS
       WHERE CodCia        = nCodCia
         AND IdSolicitud   = nIdSolicitud
         AND IdetSol       = nIDetSol;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nExiste := 0;
       WHEN TOO_MANY_ROWS THEN
          nExiste := 1;
   END;

   IF nExiste = 0 THEN
      IF OC_SOLICITUD_EMISION.ASEGURADO_MODELO(nCodCia, nCodEmpresa, nIdSolicitud) = 'S' THEN
         nCantAsegModelo := OC_SOLICITUD_DETALLE.CANTIDAD_ASEGURADOS(nCodCia, nCodEmpresa, nIdSolicitud, nIDetSol);
      ELSE
         nCantAsegModelo := 1;
      END IF;

      nIdTarifa      := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig);

      FOR X IN COB_Q  LOOP
         IF X.CodTarifa IS NULL THEN
            nSumaAsegMoneda := 0;
            nSumaAsegLocal  := 0;
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
               IF NVL(X.SumaAsegurada,0) != 0 THEN
                  nTasa        := NVL(nValorMoneda,0) / NVL(X.SumaAsegurada,0);
               END IF;
            ELSE
               nValorMoneda := NVL(X.SumaAsegurada,0) * NVL(nTasa,0);
               nValor       := (NVL(X.SumaAsegurada,0) * NVL(nTasa,0)) * nTasaCambio;
            END IF;
            nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
            nSumaAsegLocal  := NVL(X.SumaAsegurada,0) * nTasaCambio;
         ELSE
            IF OC_TARIFA_DINAMICA.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, TRUNC(SYSDATE)) = 0 THEN
               cSexo           := 'U';
               cCodActividad   := NULL;
               cRiesgo         := NULL;
               nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                            X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
               nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                         X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
               IF NVL(nSumaAsegMoneda,0) = 0 THEN
                  nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
               END IF;

               nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                          X.CodCobert, nEdad, cSexo, cRiesgo, nSumaAsegMoneda, nIdTarifa);
               IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                  nValorMoneda := nSumaAsegMoneda * NVL(nTasa,0);
               END IF;
               nValor          := NVL(nValorMoneda,0) * nTasaCambio;
               IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                  nTasa           := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
               END IF;
            END IF;
         END IF;
         IF X.Cod_Moneda != nCod_Moneda THEN
            nTasaCambioDet  := OC_GENERALES.TASA_DE_CAMBIO(nCod_Moneda, TRUNC(SYSDATE));
            nSumaAsegMoneda := NVL(nSumaAsegMoneda,0) / nTasaCambioDet;
            nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambioDet;
            nValorMoneda    := NVL(nValorMoneda,0) / nTasaCambioDet;
            nValor          := NVL(nValorMoneda,0) * nTasaCambioDet;
         ELSE
            nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambio;
         END IF;

         BEGIN
            IF nCantAsegModelo > 1 THEN
               nTasa := (nValorMoneda * nCantAsegModelo) / NVL(nSumaAsegMoneda,0);
            END IF;
            INSERT INTO SOLICITUD_COBERTURAS
                  (CodCia, CodEmpresa, IdSolicitud, IDetSol, CodCobert,
                   SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Moneda,
                   Prima_Local, Deducible_Local, Deducible_Moneda)
            VALUES(nCodCia, nCodEmpresa, nIdSolicitud, nIDetSol, X.CodCobert,
                   nSumaAsegLocal, nSumaAsegMoneda, nTasa, nValorMoneda * nCantAsegModelo,
                   nValor * nCantAsegModelo, NVL(X.MontoDeducible,0) * nTasaCambio, NVL(X.MontoDeducible,0));
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas para Detalle de Solicitud: '||
                                      TRIM(TO_CHAR(nIdSolicitud))||' - '||TO_CHAR(nIDetSol));
         END;
      END LOOP;
   END IF;
END CARGAR_COBERTURAS;

PROCEDURE ACTUALIZA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER,
                               nTasaCambio NUMBER, nPrimaAsegurado NUMBER) IS
nTotCobert        SOLICITUD_COBERTURAS.Prima_Moneda%TYPE;
nTotAsist         SOLICITUD_ASISTENCIAS.MontoAsistMoneda%TYPE;
nDifPrimaAseg     SOLICITUD_COBERTURAS.Prima_Moneda%TYPE;
nCantAsegModelo   SOLICITUD_DETALLE.CantAsegModelo%TYPE;

CURSOR COB_Q IS
   SELECT *
     FROM SOLICITUD_COBERTURAS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud
      AND IDetSol       = nIDetSol;
BEGIN
   SELECT NVL(SUM(Prima_Moneda),0)
     INTO nTotCobert
     FROM SOLICITUD_COBERTURAS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud
      AND IDetSol       = nIDetSol
      AND CodCobert    != 'GMXA';

   nTotAsist := OC_SOLICITUD_ASISTENCIAS.TOTAL_ASISTENCIAS(nCodCia, nCodEmpresa, nIdSolicitud, nIDetSol);

   IF OC_SOLICITUD_EMISION.ASEGURADO_MODELO(nCodCia, nCodEmpresa, nIdSolicitud) = 'S' THEN
      nCantAsegModelo := OC_SOLICITUD_DETALLE.CANTIDAD_ASEGURADOS(nCodCia, nCodEmpresa, nIdSolicitud, nIDetSol);
   ELSE
      nCantAsegModelo := 1;
   END IF;

   nDifPrimaAseg := (NVL(nPrimaAsegurado,0) * nCantAsegModelo) - NVL(nTotCobert,0) - NVL(nTotAsist,0);

   UPDATE SOLICITUD_COBERTURAS
      SET Prima_Moneda  = nDifPrimaAseg,
          Prima_Local   = nDifPrimaAseg * nTasaCambio,
          Tasa          = nDifPrimaAseg / SumaAseg_Moneda
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud
      AND IDetSol       = nIDetSol
      AND CodCobert     = 'GMXA';

END ACTUALIZA_COBERTURAS;

FUNCTION EXISTEN_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUD_COBERTURAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud
         AND IDetSol       = nIDetSol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_COBERTURAS;

FUNCTION TIENE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUD_COBERTURAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud
         AND IDetSol       = nIDetSol;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
       WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
    END;
    RETURN(cExiste);
END TIENE_COBERTURAS;

PROCEDURE TRASLADA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, 
                              nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
CURSOR COB_Q IS
   SELECT SC.CodCobert, SC.SumaAseg_Local, SC.SumaAseg_Moneda, SC.Tasa, 
          SC.Prima_Moneda, SC.Prima_Local, SC.Deducible_Local,
          SC.Deducible_Moneda, SE.IdTipoSeg, SE.PlanCob, SE.Cod_Moneda
     FROM SOLICITUD_COBERTURAS SC, SOLICITUD_EMISION SE
    WHERE SC.CodCia        = SE.CodCia
      AND SC.CodEmpresa    = SE.CodEmpresa
      AND SC.IDetSol       = nIDetPol
      AND SC.IdSolicitud   = SE.IdSolicitud
      AND SE.CodCia        = nCodCia
      AND SE.CodEmpresa    = nCodEmpresa
      AND SE.IdSolicitud   = nIdSolicitud;
BEGIN
   FOR W IN COB_Q LOOP
      BEGIN
         INSERT INTO COBERT_ACT_ASEG
               (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                NumRef, PlanCob, Cod_Moneda, Deducible_Local,
                Deducible_Moneda, Cod_Asegurado)
         VALUES(nIdPoliza, nIDetPol, nCodEmpresa, W.IdTipoSeg, nCodCia,
                W.CodCobert, 'SOL', W.SumaAseg_Local, W.SumaAseg_Moneda,
                W.Prima_Local, W.Prima_Moneda, W.Tasa, 0, 'POLI',
                nIdPoliza, W.PlanCob, W.Cod_Moneda, W.Deducible_Local,
                W.Deducible_Moneda, nCod_Asegurado);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas para Detalle de la Póliza: '||
                                   TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol));
      END;
   END LOOP;
END TRASLADA_COBERTURAS;

FUNCTION COBERTURAS_NEGATIVAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUD_COBERTURAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud
         AND IDetSol       = nIDetSol
         AND Prima_Moneda  < 0;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
       WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
    END;
    RETURN(cExiste);
END COBERTURAS_NEGATIVAS;

FUNCTION TOTAL_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN NUMBER IS
nPrima_Moneda    SOLICITUD_COBERTURAS.Prima_Moneda%TYPE;
BEGIN
   SELECT NVL(SUM(Prima_Moneda),0)
     INTO nPrima_Moneda
     FROM SOLICITUD_COBERTURAS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud
      AND IDetSol       = nIDetSol;

   RETURN(nPrima_Moneda);
END TOTAL_COBERTURAS;

PROCEDURE ELIMINAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) IS
BEGIN
   DELETE SOLICITUD_COBERTURAS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud
      AND IDetSol       = nIDetSol;
END ELIMINAR_COBERTURAS;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER) IS
BEGIN
   INSERT INTO SOLICITUD_COBERTURAS
         (CodCia, CodEmpresa, IdSolicitud, IDetSol, CodCobert, SumaAseg_Local, 
          SumaAseg_Moneda, Tasa, Prima_Moneda, Prima_Local, Deducible_Local, Deducible_Moneda)
   SELECT CodCia, CodEmpresa, nIdSolicitudDest, IDetSol, CodCobert, SumaAseg_Local, 
          SumaAseg_Moneda, Tasa, Prima_Moneda, Prima_Local, Deducible_Local, Deducible_Moneda
     FROM SOLICITUD_COBERTURAS
    WHERE CodCia      = nCodCia 
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitudOrig;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Coberturas en Solicitud No. ' || nIdSolicitudDest);
END COPIAR;

END OC_SOLICITUD_COBERTURAS;
/

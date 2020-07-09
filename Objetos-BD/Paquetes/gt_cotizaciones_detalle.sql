--
-- GT_COTIZACIONES_DETALLE  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   GT_COTIZACIONES_ASEG (Package)
--   GT_COTIZACIONES_CENSO_ASEG (Package)
--   GT_COTIZACIONES_COBERTURAS (Package)
--   GT_COTIZACIONES_COBERT_ASEG (Package)
--   GT_COTIZACIONES_COBERT_MASTER (Package)
--   GT_DETALLE_POLIZA_COTIZ (Package)
--   COTIZACIONES (Table)
--   COTIZACIONES_ASEG (Table)
--   COTIZACIONES_CENSO_ASEG (Table)
--   COTIZACIONES_COBERTURAS (Table)
--   COTIZACIONES_COBERT_ASEG (Table)
--   COTIZACIONES_DETALLE (Table)
--   OC_DETALLE_POLIZA (Package)
--   OC_GENERALES (Package)
--   DETALLE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_COTIZACIONES_DETALLE IS

   FUNCTION EXISTE_DETALLE_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   PROCEDURE RECOTIZACION_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER);
   FUNCTION EDAD_LIMITE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   FUNCTION CANTIDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   FUNCTION PORCENTAJE_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   FUNCTION MONTO_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   PROCEDURE ACTUALIZAR_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER);
   FUNCTION TIENE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN VARCHAR2;
   PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER);
   PROCEDURE ELIMINAR_CERTIFICADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   FUNCTION VECES_SALARIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   FUNCTION CANTIDAD_TOTAL_ASEG_DET(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   FUNCTION MANEJA_EDAD_PROMEDIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   FUNCTION MANEJA_CUOTA_PROMEDIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   FUNCTION MANEJA_PRIMA_PROMEDIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER;
   FUNCTION CREAR_CERTIFICADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER, 
                              nCodAsegurado NUMBER, cIndPolCol VARCHAR2) RETURN NUMBER;

END GT_COTIZACIONES_DETALLE;
/

--
-- GT_COTIZACIONES_DETALLE  (Package Body) 
--
--  Dependencies: 
--   GT_COTIZACIONES_DETALLE (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_COTIZACIONES_DETALLE IS

FUNCTION EXISTE_DETALLE_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cExisteDet      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteDet
        FROM COTIZACIONES_DETALLE
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteDet := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteDet := 'S';
   END;
   RETURN(cExisteDet);
END EXISTE_DETALLE_COTIZACION;

PROCEDURE RECOTIZACION_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER) IS
CURSOR DET_Q IS
   SELECT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, CodSubgrupo,
          DescSubgrupo, EdadLimite, CantAsegurados, SalarioMensual, 
          VecesSalario, PorcExtraPrimaDet, MontoExtraPrimaDet,
          PrimaAsegurado, SumaAsegDetLocal, SumaAsegDetMoneda, 
          PrimaDetLocal, PrimaDetMoneda, RiesgoTarifa, HorasVig,
          DiasVig, FactorAjuste, FactFormulaDeduc, IndEdadPromedio,
          IndCuotaPromedio, IndPrimaPromedio
     FROM COTIZACIONES_DETALLE
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   FOR W IN DET_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_DETALLE
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, CodSubgrupo,
                 DescSubgrupo, EdadLimite, CantAsegurados, SalarioMensual, 
                 VecesSalario, PorcExtraPrimaDet, MontoExtraPrimaDet, 
                 PrimaAsegurado, SumaAsegDetLocal, SumaAsegDetMoneda, 
                 PrimaDetLocal, PrimaDetMoneda, RiesgoTarifa, HorasVig,
                 DiasVig, FactorAjuste, FactFormulaDeduc, IndEdadPromedio,
                 IndCuotaPromedio, IndPrimaPromedio)
         VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, W.IDetCotizacion, W.CodSubgrupo,
                 W.DescSubgrupo, W.EdadLimite, W.CantAsegurados, W.SalarioMensual, 
                 W.VecesSalario, W.PorcExtraPrimaDet, W.MontoExtraPrimaDet, 
                 W.PrimaAsegurado, W.SumaAsegDetLocal, W.SumaAsegDetMoneda, 
                 W.PrimaDetLocal, W.PrimaDetMoneda, W.RiesgoTarifa, W.HorasVig,
                 W.DiasVig, W.FactorAjuste, W.FactFormulaDeduc, W.IndEdadPromedio,
                 W.IndCuotaPromedio, W.IndPrimaPromedio);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Detalle de Cotización No. ' || nIdReCotizacion || ' y Detalle No. ' ||W.IDetCotizacion);
      END;
   END LOOP;
   
   GT_COTIZACIONES_COBERTURAS.RECOTIZACION_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdRecotizacion);
END RECOTIZACION_DETALLE;

FUNCTION EDAD_LIMITE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
nEdadLimite        COTIZACIONES_DETALLE.EdadLimite%TYPE;
BEGIN
   BEGIN
      SELECT NVL(EdadLimite,0)
        INTO nEdadLimite
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nEdadLimite := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Edades Limite de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(nEdadLimite);
END EDAD_LIMITE;

FUNCTION CANTIDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
nCantAsegurados        COTIZACIONES_DETALLE.CantAsegurados%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CantAsegurados,0)
        INTO nCantAsegurados
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCantAsegurados := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Cantidad de Asegurados de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(nCantAsegurados);
END CANTIDAD_ASEGURADOS;

FUNCTION PORCENTAJE_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
nPorcExtraPrimaDet        COTIZACIONES_DETALLE.PorcExtraPrimaDet%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcExtraPrimaDet,0)
        INTO nPorcExtraPrimaDet
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcExtraPrimaDet := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar % de ExtraPrima de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(nPorcExtraPrimaDet);
END PORCENTAJE_EXTRAPRIMA;

FUNCTION MONTO_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
nMontoExtraPrimaDet        COTIZACIONES_DETALLE.MontoExtraPrimaDet%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoExtraPrimaDet,0)
        INTO nMontoExtraPrimaDet
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoExtraPrimaDet := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Monto de ExtraPrima de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(nMontoExtraPrimaDet);
END MONTO_EXTRAPRIMA;

PROCEDURE ACTUALIZAR_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) IS
nSumaAsegCobLocal        COTIZACIONES_COBERTURAS.SumaAsegCobLocal%TYPE;
nSumaAsegCobMoneda       COTIZACIONES_COBERTURAS.SumaAsegCobMoneda%TYPE;
nPrimaCobLocal           COTIZACIONES_COBERTURAS.PrimaCobLocal%TYPE;
nPrimaCobMoneda          COTIZACIONES_COBERTURAS.PrimaCobMoneda%TYPE;
nPrimaAsegurado          COTIZACIONES_DETALLE.PrimaAsegurado%TYPE;
nSumaAsegurado           COTIZACIONES_DETALLE.SumaAsegurado%TYPE;
nCantAsegurados          COTIZACIONES_DETALLE.CantAsegurados%TYPE;
BEGIN
   SELECT NVL(SUM(SumaAsegCobLocal),0), NVL(SUM(SumaAsegCobMoneda),0),
          NVL(SUM(PrimaCobLocal),0), NVL(SUM(PrimaCobMoneda),0)
     INTO nSumaAsegCobLocal, nSumaAsegCobMoneda,
          nPrimaCobLocal, nPrimaCobMoneda
     FROM COTIZACIONES_COBERTURAS
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   SELECT NVL(SUM(SumaAsegCobLocal),0) + NVL(nSumaAsegCobLocal,0),
          NVL(SUM(SumaAsegCobMoneda),0) + NVL(nSumaAsegCobMoneda,0),
          NVL(SUM(PrimaCobLocal),0) + NVL(nPrimaCobLocal,0),
          NVL(SUM(PrimaCobMoneda),0) + NVL(nPrimaCobMoneda,0)
     INTO nSumaAsegCobLocal, nSumaAsegCobMoneda,
          nPrimaCobLocal, nPrimaCobMoneda
     FROM COTIZACIONES_COBERT_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   nCantAsegurados := GT_COTIZACIONES_DETALLE.CANTIDAD_ASEGURADOS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion);
   IF NVL(nCantAsegurados,0) = 0 THEN
      BEGIN
         SELECT NVL(SUM(CantAsegurados),0)
           INTO nCantAsegurados
           FROM COTIZACIONES_CENSO_ASEG
          WHERE CodCia         = nCodCia
            AND CodEmpresa     = nCodEmpresa
            AND IdCotizacion   = nIdCotizacion
            AND IDetCotizacion = nIDetCotizacion;
      END;
      IF NVL(nCantAsegurados,0) = 0 THEN
         BEGIN
            SELECT NVL(SUM(CantAsegurados),0)
              INTO nCantAsegurados
              FROM COTIZACIONES_CENSO_ASEG
             WHERE CodCia         = nCodCia
               AND CodEmpresa     = nCodEmpresa
               AND IdCotizacion   = nIdCotizacion
               AND IDetCotizacion = nIDetCotizacion;
         END;
      END IF;
   END IF;
   
   IF NVL(nCantAsegurados,0) > 0 THEN
      nPrimaAsegurado := NVL(nPrimaCobMoneda,0) / NVL(nCantAsegurados,0);
      nSumaAsegurado  := NVL(nSumaAsegCobMoneda,0) / NVL(nCantAsegurados,0);
   ELSE
      nPrimaAsegurado := 0;
      nSumaAsegurado  := 0;
   END IF;

   UPDATE COTIZACIONES_DETALLE
      SET SumaAsegDetLocal  = nSumaAsegCobLocal,
          SumaAsegDetMoneda = nSumaAsegCobMoneda,
          PrimaDetLocal     = nPrimaCobLocal,
          PrimaDetMoneda    = nPrimaCobMoneda,
          PrimaAsegurado    = nPrimaAsegurado,
          SumaAsegurado     = nSumaAsegurado
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   UPDATE COTIZACIONES
      SET SumaAsegCotLocal  = nSumaAsegCobLocal,
          SumaAsegCotMoneda = nSumaAsegCobMoneda,
          PrimaCotLocal     = nPrimaCobLocal,
          PrimaCotMoneda    = nPrimaCobMoneda
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;
END ACTUALIZAR_VALORES;

FUNCTION TIENE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN VARCHAR2 IS
cExisteDet      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteDet
        FROM COTIZACIONES_COBERTURAS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteDet := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteDet := 'S';
   END;
   RETURN(cExisteDet);
END TIENE_COBERTURAS;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER) IS
CURSOR DET_Q IS
   SELECT CodCia, CodEmpresa, CodSubgrupo, DescSubgrupo, EdadLimite, 
          CantAsegurados, SalarioMensual,  VecesSalario, PorcExtraPrimaDet, 
          MontoExtraPrimaDet, PrimaAsegurado, SumaAsegDetLocal, SumaAsegDetMoneda, 
          PrimaDetLocal, PrimaDetMoneda, RiesgoTarifa, HorasVig,
          DiasVig, FactorAjuste, FactFormulaDeduc, IndEdadPromedio,
          IndCuotaPromedio, IndPrimaPromedio
     FROM COTIZACIONES_DETALLE
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
BEGIN
   FOR W IN DET_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_DETALLE
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, CodSubgrupo,
                 DescSubgrupo, EdadLimite, CantAsegurados, SalarioMensual, 
                 VecesSalario, PorcExtraPrimaDet, MontoExtraPrimaDet, 
                 PrimaAsegurado, SumaAsegDetLocal, SumaAsegDetMoneda, 
                 PrimaDetLocal, PrimaDetMoneda, RiesgoTarifa, HorasVig,
                 DiasVig, FactorAjuste, FactFormulaDeduc, IndEdadPromedio,
                 IndCuotaPromedio, IndPrimaPromedio)
         VALUES (nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionDest, W.CodSubgrupo,
                 W.DescSubgrupo, W.EdadLimite, W.CantAsegurados, W.SalarioMensual, 
                 W.VecesSalario, W.PorcExtraPrimaDet, W.MontoExtraPrimaDet, 
                 W.PrimaAsegurado, W.SumaAsegDetLocal, W.SumaAsegDetMoneda, 
                 W.PrimaDetLocal, W.PrimaDetMoneda, W.RiesgoTarifa, W.HorasVig,
                 W.DiasVig, W.FactorAjuste, W.FactFormulaDeduc, W.IndEdadPromedio,
                 W.IndCuotaPromedio, W.IndPrimaPromedio);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Detalle de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' ||nIDetCotizacionDest);
      END;
      GT_COTIZACIONES_COBERTURAS.COPIAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIDetCotizacionDest);
      GT_COTIZACIONES_COBERT_MASTER.COPIAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIDetCotizacionDest);
      GT_COTIZACIONES_CENSO_ASEG.COPIAR_CENSOS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIDetCotizacionDest);
      GT_COTIZACIONES_ASEG.COPIAR_ASEGURADOS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIDetCotizacionDest);
      GT_COTIZACIONES_COBERT_ASEG.COPIAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIDetCotizacionDest);
   END LOOP;
END COPIAR;

PROCEDURE ELIMINAR_CERTIFICADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
BEGIN
   DELETE COTIZACIONES_COBERT_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   DELETE COTIZACIONES_COBERTURAS
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   DELETE COTIZACIONES_CENSO_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   DELETE COTIZACIONES_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   DELETE COTIZACIONES_DETALLE
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

END ELIMINAR_CERTIFICADOS;

FUNCTION VECES_SALARIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
nVecesSalario        COTIZACIONES_DETALLE.VecesSalario%TYPE;
BEGIN
   BEGIN
      SELECT NVL(VecesSalario,0)
        INTO nVecesSalario
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nVecesSalario := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Monto de ExtraPrima de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(nVecesSalario);
END VECES_SALARIO;

FUNCTION CANTIDAD_TOTAL_ASEG_DET(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
nCantAsegurados        COTIZACIONES_DETALLE.CantAsegurados%TYPE;
BEGIN
   SELECT NVL(SUM(CantAsegurados),0)
     INTO nCantAsegurados
     FROM COTIZACIONES_DETALLE
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   SELECT NVL(SUM(CantAsegurados),0) + NVL(nCantAsegurados,0)
     INTO nCantAsegurados
     FROM COTIZACIONES_CENSO_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   SELECT COUNT(*) + NVL(nCantAsegurados,0)
     INTO nCantAsegurados
     FROM COTIZACIONES_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   RETURN(nCantAsegurados);
END CANTIDAD_TOTAL_ASEG_DET;

FUNCTION MANEJA_EDAD_PROMEDIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
cIndEdadPromedio        COTIZACIONES_DETALLE.IndEdadPromedio%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndEdadPromedio,'N')
        INTO cIndEdadPromedio
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndEdadPromedio := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Indicador de Edad Promedio de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(cIndEdadPromedio);
END MANEJA_EDAD_PROMEDIO;

FUNCTION MANEJA_CUOTA_PROMEDIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
cIndCuotaPromedio        COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndCuotaPromedio,'N')
        INTO cIndCuotaPromedio
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCuotaPromedio := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Indicador de Cuota Promedio de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(cIndCuotaPromedio);
END MANEJA_CUOTA_PROMEDIO;

FUNCTION MANEJA_PRIMA_PROMEDIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) RETURN NUMBER IS
cIndPrimaPromedio        COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndPrimaPromedio,'N')
        INTO cIndPrimaPromedio
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndPrimaPromedio := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Indicador de Prima Promedio de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(cIndPrimaPromedio);
END MANEJA_PRIMA_PROMEDIO;

FUNCTION CREAR_CERTIFICADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER, 
                           nCodAsegurado NUMBER, cIndPolCol VARCHAR2) RETURN NUMBER IS
   nIDetPol         DETALLE_POLIZA.IDetPol%TYPE;
   cIndAsegMod      DETALLE_POLIZA.IndAsegModelo%TYPE;
   nCantAsegurados  DETALLE_POLIZA.CantAsegModelo%TYPE;
   
CURSOR COTDET_Q IS
   SELECT C.IdTipoSeg, C.PlanCob, C.Cod_Moneda, OC_GENERALES.FUN_TASA_CAMBIO(C.Cod_Moneda,TRUNC(SYSDATE)) TipoCambio,
          C.PorcComisAgte, C.CodPlanPago, C.FecIniVigCot, C.FecFinVigCot, C.IndAsegModelo, C.IndCensoSubGrupo,
          C.IndListadoAseg, C.CantAsegurados, D.IDetCotizacion, D.CodSubGrupo, D.SumaAsegDetLocal, D.SumaAsegDetMoneda,
          D.PrimaDetLocal, D.PrimaDetMoneda, D.DescSubGrupo
     FROM COTIZACIONES C, COTIZACIONES_DETALLE D
    WHERE D.CodCia       = C.CodCia      
      AND D.CodEmpresa   = C.CodEmpresa  
      AND D.IdCotizacion = C.IdCotizacion
      AND C.CodCia       = nCodCia
      AND C.CodEmpresa   = nCodEmpresa
      AND C.IdCotizacion = nIdCotizacion;
BEGIN
   FOR X IN COTDET_Q LOOP
      IF NVL(X.IndAsegModelo,'N') = 'S' OR  NVL(X.IndCensoSubGrupo,'N') = 'S' THEN
         cIndAsegMod     := 'S';
         nCantAsegurados := X.CantAsegurados;
      ELSE
         cIndAsegMod     := 'N';
         nCantAsegurados := NULL;
      END IF;

      nIDetPol := OC_DETALLE_POLIZA.INSERTAR_DETALLE(nCodCia, nCodEmpresa, X.IdTipoSeg,
                                                     X.PlanCob, nIdPoliza, X.TipoCambio,
                                                     X.PorcComisAgte, nCodAsegurado, X.CodPlanPago,
                                                     X.IDetCotizacion, NULL, X.FecIniVigCot);

      UPDATE DETALLE_POLIZA
         SET FecFinVig            = X.FecFinVigCot,
             Suma_Aseg_Local      = X.SumaAsegDetLocal,
             Suma_Aseg_Moneda     = X.SumaAsegDetMoneda,
             Prima_Local          = X.PrimaDetLocal,
             Prima_Moneda         = X.PrimaDetMoneda,
             IndDeclara           = 'N',
             IndSinAseg           = 'N',
             CodCategoria         = X.DescSubGrupo,
             IndAsegModelo        = X.IndAsegModelo,
             CantAsegModelo       = nCantAsegurados,
             CodFilial            = X.CodSubGrupo
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;

      GT_DETALLE_POLIZA_COTIZ.INSERTA(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion,
                                      nIdPoliza, nIDetPol);

      IF X.IndAsegModelo = 'S' THEN
         GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion,
                                                     nIdPoliza, nIDetPol, nCodAsegurado, cIndPolCol);
      ELSIF X.IndListadoAseg = 'S' AND X.IndCensoSubGrupo = 'S' THEN
         GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion,
                                                      nIdPoliza, nIDetPol, nCodAsegurado, cIndPolCol);
      END IF;

      -- Censo
      IF X.IndCensoSubGrupo = 'S' THEN
         GT_COTIZACIONES_CENSO_ASEG.ACTUALIZA_CERTIFICADO(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion,
                                                          nIdPoliza, nIDetPol);
      END IF;
   END LOOP;
   RETURN(nIDetPol);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Crear el SubGrupo/Certificado '||SQLERRM);
END CREAR_CERTIFICADO;

END GT_COTIZACIONES_DETALLE;
/

--
-- GT_COTIZACIONES_DETALLE  (Synonym) 
--
--  Dependencies: 
--   GT_COTIZACIONES_DETALLE (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_COTIZACIONES_DETALLE FOR SICAS_OC.GT_COTIZACIONES_DETALLE
/


GRANT EXECUTE ON SICAS_OC.GT_COTIZACIONES_DETALLE TO PUBLIC
/

CREATE OR REPLACE PACKAGE          GT_COTIZACIONES_DETALLE IS

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
   --
   PROCEDURE RECALCULA_FACTORAJUSTE( nCodCia         COTIZACIONES_DETALLE.CodCia%TYPE
                                   , nCodEmpresa     COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                   , nIdCotizacion   COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                   , nIDetCotizacion COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                   , cCodSubGrupo    COTIZACIONES_DETALLE.CodSubGrupo%TYPE );

   PROCEDURE RESTAURA_FACTORAJUSTE( nCodCia         COTIZACIONES_DETALLE.CodCia%TYPE
                                   , nCodEmpresa     COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                   , nIdCotizacion   COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                   , nIDetCotizacion COTIZACIONES_DETALLE.IDetCotizacion%TYPE);                                   
END GT_COTIZACIONES_DETALLE;

/
create or replace PACKAGE BODY          GT_COTIZACIONES_DETALLE IS

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
          IndCuotaPromedio, IndPrimaPromedio, PrimaNetaPor
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
                 IndCuotaPromedio, IndPrimaPromedio, PrimaNetaPor)
         VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, W.IDetCotizacion, W.CodSubgrupo,
                 W.DescSubgrupo, W.EdadLimite, W.CantAsegurados, W.SalarioMensual, 
                 W.VecesSalario, W.PorcExtraPrimaDet, W.MontoExtraPrimaDet, 
                 W.PrimaAsegurado, W.SumaAsegDetLocal, W.SumaAsegDetMoneda, 
                 W.PrimaDetLocal, W.PrimaDetMoneda, W.RiesgoTarifa, W.HorasVig,
                 W.DiasVig, W.FactorAjuste, W.FactFormulaDeduc, W.IndEdadPromedio,
                 W.IndCuotaPromedio, W.IndPrimaPromedio, W.PrimaNetaPor);
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
   cMenor12Anios    VARCHAR2(1);
   --
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
         IF NVL(X.IndAsegModelo,'N') = 'S' AND (NVL(X.CantAsegurados, 0) > 0) THEN
            nCantAsegurados := X.CantAsegurados - 1;
         ELSE
            nCantAsegurados := X.CantAsegurados;
         END IF;
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
             --CodCategoria         = X.DescSubGrupo,
             IndAsegModelo        = X.IndAsegModelo,
             CantAsegModelo       = nCantAsegurados--,
             --CodFilial            = X.CodSubGrupo
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza
         AND IDetPol    = nIDetPol;

      GT_DETALLE_POLIZA_COTIZ.INSERTA(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion,
                                      nIdPoliza, nIDetPol);

      IF X.IndAsegModelo = 'S' THEN
         IF NVL(cIndPolCol, 'N') = 'S' THEN
            BEGIN
               SELECT 'S'
               INTO   cMenor12Anios
               FROM   COTIZACIONES_COBERTURAS M
                  ,   COTIZACIONES C
               WHERE  M.CodCia       = C.CodCia
                 AND  M.CodEmpresa   = C.CodEmpresa
                 AND  M.IdCotizacion = C.IdCotizacion
                 AND  C.CodCia       = nCodCia
                 AND  C.CodEmpresa   = nCodEmpresa
                 AND  C.IdCotizacion = nIdCotizacion
                 AND  M.Edad_Maxima  = 12;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 cMenor12Anios := 'N';
            WHEN TOO_MANY_ROWS THEN
                 cMenor12Anios := 'S';
            END;
            --
            IF cMenor12Anios = 'S' THEN
               --Se utiliza el Asegurado Modelo menor para menores de 12 años  Codigo Asegurado 256656
               GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion, nIdPoliza, nIDetPol, 256656, cIndPolCol);
            ELSE
               --Se utiliza el Asegurado Modelo menor para mayores de 12 años  Codigo Asegurado 256655
               GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion, nIdPoliza, nIDetPol, 256655, cIndPolCol);
            END IF;
         ELSE
            GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion, nIdPoliza, nIDetPol, nCodAsegurado, cIndPolCol);
         END IF;
      ELSIF X.IndListadoAseg = 'S' OR X.IndCensoSubGrupo = 'S' THEN
         GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion, nIdPoliza, nIDetPol, nCodAsegurado, cIndPolCol);
      END IF;

      -- Censo
      IF X.IndCensoSubGrupo = 'S' THEN
         GT_COTIZACIONES_CENSO_ASEG.ACTUALIZA_CERTIFICADO(nCodCia, nCodEmpresa, nIdCotizacion, X.IDetCotizacion,
                                                          nIdPoliza, nIDetPol);
      END IF;
   END LOOP;
   --
   OC_DETALLE_POLIZA.ACTUALIZA_VALORES( nCodCia, nIdPoliza, nIDetPol, NULL );
   --
   RETURN(nIDetPol);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Crear el SubGrupo/Certificado '||SQLERRM);
END CREAR_CERTIFICADO;

PROCEDURE RECALCULA_FACTORAJUSTE( nCodCia         COTIZACIONES_DETALLE.CodCia%TYPE
                                , nCodEmpresa     COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                , nIdCotizacion   COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                , nIDetCotizacion COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                , cCodSubGrupo    COTIZACIONES_DETALLE.CodSubGrupo%TYPE ) IS
   --
   nFactorAjusteNuevo   COTIZACIONES_DETALLE.FactorAjuste%TYPE;
   nFactorAjusteInicial COTIZACIONES_DETALLE.FactorAjusteInicial%TYPE;
   --
   CURSOR Factores IS
      SELECT Factor
      FROM   COTIZACIONES_DETALLE_FACTOR
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = nIDetCotizacion;
BEGIN
   --Actualizo el FactorAjuste en COTIZACIONES_DETALLE 
   nFactorAjusteNuevo := 1;
   --
   SELECT FactorAjuste
   INTO   nFactorAjusteInicial
      FROM   COTIZACIONES_DETALLE
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = nIDetCotizacion
        AND  CodSubgrupo    = cCodSubGrupo;
      --
      FOR x IN Factores LOOP 
          nFactorAjusteNuevo := nFactorAjusteNuevo * x.Factor;
      END LOOP;
      --
      UPDATE COTIZACIONES_DETALLE
      SET    FactorAjuste        = nFactorAjusteNuevo
        ,    FactorAjusteInicial = nFactorAjusteInicial
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = nIDetCotizacion
        AND  CodSubgrupo    = cCodSubGrupo;
EXCEPTION
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20200,'Error al Recalcular el Factor Ajuste '||SQLERRM);
END RECALCULA_FACTORAJUSTE;

PROCEDURE RESTAURA_FACTORAJUSTE(  nCodCia         COTIZACIONES_DETALLE.CodCia%TYPE
                                , nCodEmpresa     COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                , nIdCotizacion   COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                , nIDetCotizacion COTIZACIONES_DETALLE.IDetCotizacion%TYPE) IS
nIdCotizacionOriginal      COTIZACIONES.IdCotizacion%TYPE;    
nFactorAjusteOriginal      COTIZACIONES_DETALLE.FactorAjuste%TYPE;
nFactorAjusteInicialOrig   COTIZACIONES_DETALLE.FactorAjusteInicial%TYPE;
nFactorAjusteCotOrig       COTIZACIONES.FactorAjuste%TYPE;
cCodSubGrupo               COTIZACIONES_DETALLE.CodSubGrupo%TYPE;

nPorcComisAgte             COTIZACIONES.PorcComisAgte%TYPE;
nPorcComisProm             COTIZACIONES.PorcComisProm%TYPE;
nPorcComisDir              COTIZACIONES.PorcComisDir%TYPE;
nPorcGtoAdqui              COTIZACIONES.PorcGtoAdqui%TYPE;
cCodTipoBono               COTIZACIONES.CodTipoBono%TYPE;
nPorcConvenciones          COTIZACIONES.PorcConvenciones%TYPE;

CURSOR CLAU_Q IS
   SELECT CodClausula, TextoClausula
     FROM COTIZACIONES_CLAUSULAS
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacionOriginal;
BEGIN
   BEGIN
      SELECT NumCotizacionAnt
        INTO nIdCotizacionOriginal
        FROM COTIZACIONES
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20200,'No es posible determinar la cotización origen para la cotización '||nIdCotizacion);
   END;

   BEGIN
      SELECT FactorAjuste, PorcComisAgte, PorcComisProm, 
             PorcComisDir, PorcGtoAdqui, CodTipoBono,
             PorcConvenciones
        INTO nFactorAjusteCotOrig,nPorcComisAgte, nPorcComisProm, 
             nPorcComisDir, nPorcGtoAdqui, cCodTipoBono,
             nPorcConvenciones
        FROM COTIZACIONES
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacionOriginal;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20200,'No es posible determinar el factor de ajuste original para la cotización '||nIdCotizacion);
   END;

   BEGIN
      SELECT CodSubGrupo
        INTO cCodSubGrupo 
        FROM COTIZACIONES_DETALLE
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND IdCotizacion     = nIdCotizacion
         AND IdetCotizacion   = nIdetCotizacion;
   END;

   BEGIN
      SELECT FactorAjuste, FactorAjusteInicial
        INTO nFactorAjusteOriginal, nFactorAjusteInicialOrig
        FROM COTIZACIONES_DETALLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacionOriginal
         AND IDetCotizacion = nIDetCotizacion
         AND CodSubgrupo    = cCodSubGrupo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20200,'No es posible determinar Factores de Ajuste iniciales de la cotización '||nIdCotizacion);
   END;

   DELETE COTIZACIONES_CLAUSULAS
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   --RESTAURA CLAUSULAS
   FOR W IN CLAU_Q LOOP
      INSERT INTO COTIZACIONES_CLAUSULAS (CodCia, CodEmpresa, IdCotizacion, CodClausula, TextoClausula)
           VALUES (nCodCia, nCodEmpresa, nIdCotizacion, W.CodClausula, W.TextoClausula);
   END LOOP;

   DELETE COTIZACIONES_DETALLE_FACTOR
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   UPDATE COTIZACIONES_DETALLE
      SET FactorAjuste        = nFactorAjusteOriginal,    
          FactorAjusteInicial = nFactorAjusteInicialOrig
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion
      AND CodSubgrupo    = cCodSubGrupo; 

   UPDATE COTIZACIONES
      SET FactorAjuste     = nFactorAjusteCotOrig,
          PorcComisAgte    = nPorcComisAgte, 
          PorcComisProm    = nPorcComisProm, 
          PorcComisDir     = nPorcComisDir, 
          PorcGtoAdqui     = nPorcGtoAdqui, 
          CodTipoBono      = cCodTipoBono,
          PorcConvenciones = nPorcConvenciones
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

END RESTAURA_FACTORAJUSTE;

END GT_COTIZACIONES_DETALLE;
--
-- GT_COTIZACIONES_ASEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   COTIZACIONES_ASEG (Table)
--   COTIZACIONES_COBERT_ASEG (Table)
--   GT_COTIZACIONES_COBERT_ASEG (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_COTIZACIONES_ASEG IS

  FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
  FUNCTION EXISTEN_ASEGURADOS_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
  PROCEDURE RECOTIZACION_ASEG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER);
  FUNCTION EDAD_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                          nIdAsegurado NUMBER, dFecCotizacion DATE) RETURN NUMBER;
  FUNCTION SEXO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER,
                          nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN VARCHAR2;
  FUNCTION PORCENTAJE_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, 
                                 nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN NUMBER;
  FUNCTION MONTO_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, 
                            nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN NUMBER;
  PROCEDURE ACTUALIZAR_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER);
  FUNCTION TIENE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN VARCHAR2;
  PROCEDURE COPIAR_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER);
  PROCEDURE ELIMINAR_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER);

END GT_COTIZACIONES_ASEG;
/

--
-- GT_COTIZACIONES_ASEG  (Package Body) 
--
--  Dependencies: 
--   GT_COTIZACIONES_ASEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_COTIZACIONES_ASEG IS

FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
nIdAsegurado     COTIZACIONES_ASEG.IdAsegurado%TYPE;
BEGIN
   SELECT NVL(MAX(IdAsegurado),0) + 1
     INTO nIdAsegurado
     FROM COTIZACIONES_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;
    RETURN(nIdAsegurado);
END CORRELATIVO_ASEGURADO;

FUNCTION EXISTEN_ASEGURADOS_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cExisteAseg      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteAseg
        FROM COTIZACIONES_ASEG
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteAseg := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteAseg := 'S';
   END;
   RETURN(cExisteAseg);
END EXISTEN_ASEGURADOS_COTIZACION;

PROCEDURE RECOTIZACION_ASEG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER) IS
CURSOR ASEG_Q IS
   SELECT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado, 
          TipoDocIdentificacion, NumDocIdentificacion, NombreAseg, 
          ApellidoPaternoAseg, ApellidoMaternoAseg, FechaNacAseg,
          SexoAsegurado, EdadContratacion, SalarioMensual, VecesSalario,
          PorcExtraPrimaAseg, MontoExtraPrimaAseg, SumaAsegLocalAseg, 
          SumaAsegMonedaAseg, PrimaLocalAseg, PrimaMonedaAseg 
     FROM COTIZACIONES_ASEG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   FOR W IN ASEG_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_ASEG
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado, 
                 TipoDocIdentificacion, NumDocIdentificacion, NombreAseg, 
                 ApellidoPaternoAseg, ApellidoMaternoAseg, FechaNacAseg,
                 SexoAsegurado, EdadContratacion, SalarioMensual, VecesSalario,
                 PorcExtraPrimaAseg, MontoExtraPrimaAseg, SumaAsegLocalAseg, 
                 SumaAsegMonedaAseg, PrimaLocalAseg, PrimaMonedaAseg)
         VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, W.IDetCotizacion, W.IdAsegurado,
                 W.TipoDocIdentificacion, W.NumDocIdentificacion, W.NombreAseg, 
                 W.ApellidoPaternoAseg, W.ApellidoMaternoAseg, W.FechaNacAseg,
                 W.SexoAsegurado, W.EdadContratacion, W.SalarioMensual, W.VecesSalario, 
                 W.PorcExtraPrimaAseg, W.MontoExtraPrimaAseg, W.SumaAsegLocalAseg, 
                 W.SumaAsegMonedaAseg, W.PrimaLocalAseg, W.PrimaMonedaAseg);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Asegurado de Cotización No. ' || nIdReCotizacion || ' e IdAsegurado No. ' || W.IdAsegurado);
      END;
   END LOOP;
   
   GT_COTIZACIONES_COBERT_ASEG.RECOTIZACION_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdRecotizacion);
END RECOTIZACION_ASEG;

FUNCTION EDAD_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                        nIdAsegurado NUMBER, dFecCotizacion DATE) RETURN NUMBER IS
nEdadContratacion        COTIZACIONES_ASEG.EdadContratacion%TYPE;
dFechaNacAseg            COTIZACIONES_ASEG.FechaNacAseg%TYPE;
nEdadAsegurado           COTIZACIONES_ASEG.EdadContratacion%TYPE;
BEGIN
   BEGIN
      SELECT EdadContratacion, FechaNacAseg
        INTO nEdadContratacion, dFechaNacAseg
        FROM COTIZACIONES_ASEG
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion
         AND IdAsegurado    = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nEdadContratacion := 0;
         dFechaNacAseg     := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Edad de Asegurado de Cotización No. ' || nIdCotizacion || ' y Asegurado No. ' || nIdAsegurado);
   END;
   
   IF NVL(nEdadContratacion,0) > 0 THEN
      nEdadAsegurado := NVL(nEdadContratacion,0);
   ELSE
      nEdadAsegurado := FLOOR((TRUNC(dFecCotizacion) - TRUNC(dFechaNacAseg)) / 365.25);
   END IF;
   RETURN(nEdadAsegurado);
END EDAD_ASEGURADO;

FUNCTION SEXO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN VARCHAR2 IS
cSexoAsegurado          COTIZACIONES_ASEG.SexoAsegurado%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SexoAsegurado,'U')
        INTO cSexoAsegurado
        FROM COTIZACIONES_ASEG
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion
         AND IdAsegurado    = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cSexoAsegurado := 'U';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Sexo de Asegurado de Cotización No. ' || nIdCotizacion || ' y Asegurado No. ' || nIdAsegurado);
   END;
   
   RETURN(cSexoAsegurado);
END SEXO_ASEGURADO;

FUNCTION PORCENTAJE_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER,
                               nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN NUMBER IS
nPorcExtraPrimaAseg        COTIZACIONES_ASEG.PorcExtraPrimaAseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcExtraPrimaAseg,0)
        INTO nPorcExtraPrimaAseg
        FROM COTIZACIONES_ASEG
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion
         AND IdAsegurado    = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcExtraPrimaAseg := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar % de ExtraPrima de Cotización No. ' || nIdCotizacion || ' y Asegurado No. ' || nIdAsegurado);
   END;
   RETURN(nPorcExtraPrimaAseg);
END PORCENTAJE_EXTRAPRIMA;

FUNCTION MONTO_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER,
                          nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN NUMBER IS
nMontoExtraPrimaAseg        COTIZACIONES_ASEG.MontoExtraPrimaAseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoExtraPrimaAseg,0)
        INTO nMontoExtraPrimaAseg
        FROM COTIZACIONES_ASEG
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion
         AND IdAsegurado    = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoExtraPrimaAseg := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Monto de ExtraPrima de Cotización No. ' || nIdCotizacion || ' y Asegurado No. ' || nIdAsegurado);
   END;
   RETURN(nMontoExtraPrimaAseg);
END MONTO_EXTRAPRIMA;

PROCEDURE ACTUALIZAR_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) IS
nSumaAsegCobLocal        COTIZACIONES_COBERT_ASEG.SumaAsegCobLocal%TYPE;
nSumaAsegCobMoneda       COTIZACIONES_COBERT_ASEG.SumaAsegCobMoneda%TYPE;
nPrimaCobLocal           COTIZACIONES_COBERT_ASEG.PrimaCobLocal%TYPE;
nPrimaCobMoneda          COTIZACIONES_COBERT_ASEG.PrimaCobMoneda%TYPE;
BEGIN
   SELECT NVL(SUM(SumaAsegCobLocal),0), NVL(SUM(SumaAsegCobMoneda),0),
          NVL(SUM(PrimaCobLocal),0), NVL(SUM(PrimaCobMoneda),0)
     INTO nSumaAsegCobLocal, nSumaAsegCobMoneda,
          nPrimaCobLocal, nPrimaCobMoneda
     FROM COTIZACIONES_COBERT_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion
      AND IdAsegurado    = nIdAsegurado;

   UPDATE COTIZACIONES_ASEG
      SET SumaAsegLocalAseg  = nSumaAsegCobLocal,
          SumaAsegMonedaAseg = nSumaAsegCobMoneda,
          PrimaLocalAseg     = nPrimaCobLocal,
          PrimaMonedaAseg    = nPrimaCobMoneda
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion
      AND IdAsegurado    = nIdAsegurado;
END ACTUALIZAR_VALORES;

FUNCTION TIENE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN VARCHAR2 IS
cExisteDet      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteDet
        FROM COTIZACIONES_COBERT_ASEG
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion
         AND IdAsegurado    = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteDet := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteDet := 'S';
   END;
   RETURN(cExisteDet);
END TIENE_COBERTURAS;

PROCEDURE COPIAR_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER) IS
CURSOR ASEG_Q IS
   SELECT CodCia, CodEmpresa, IdAsegurado, TipoDocIdentificacion, NumDocIdentificacion, 
          NombreAseg, ApellidoPaternoAseg,  ApellidoMaternoAseg, FechaNacAseg, 
          SexoAsegurado, EdadContratacion,  SalarioMensual, VecesSalario, 
          PorcExtraPrimaAseg, MontoExtraPrimaAseg,  SumaAsegLocalAseg,  
          SumaAsegMonedaAseg, PrimaLocalAseg, PrimaMonedaAseg 
     FROM COTIZACIONES_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
BEGIN
   FOR W IN ASEG_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_ASEG
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado, 
                 TipoDocIdentificacion, NumDocIdentificacion, NombreAseg, 
                 ApellidoPaternoAseg, ApellidoMaternoAseg, FechaNacAseg,
                 SexoAsegurado, EdadContratacion, SalarioMensual, VecesSalario,
                 PorcExtraPrimaAseg, MontoExtraPrimaAseg, SumaAsegLocalAseg, 
                 SumaAsegMonedaAseg, PrimaLocalAseg, PrimaMonedaAseg)
         VALUES (nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionDest, W.IdAsegurado,
                 W.TipoDocIdentificacion, W.NumDocIdentificacion, W.NombreAseg, 
                 W.ApellidoPaternoAseg, W.ApellidoMaternoAseg, W.FechaNacAseg,
                 W.SexoAsegurado, W.EdadContratacion, W.SalarioMensual, W.VecesSalario, 
                 W.PorcExtraPrimaAseg, W.MontoExtraPrimaAseg, W.SumaAsegLocalAseg, 
                 W.SumaAsegMonedaAseg, W.PrimaLocalAseg, W.PrimaMonedaAseg);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Asegurado de Cotización No. ' || nIdCotizacion || 
                                    ' Detalle No. ' || nIDetCotizacionDest || ' en IdAsegurado No. ' || W.IdAsegurado);
      END;
   END LOOP;
END COPIAR_ASEGURADOS;

PROCEDURE ELIMINAR_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER) IS
BEGIN
   DELETE COTIZACIONES_COBERT_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   DELETE COTIZACIONES_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
END ELIMINAR_ASEGURADOS;

END GT_COTIZACIONES_ASEG;
/

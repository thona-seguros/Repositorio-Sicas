--
-- GT_COTIZACIONES_CENSO_ASEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   GT_COTIZACIONES_COBERT_ASEG (Package)
--   COTIZACIONES_CENSO_ASEG (Table)
--   COTIZACIONES_COBERT_ASEG (Table)
--   COBERT_ACT (Table)
--   DETALLE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_COTIZACIONES_CENSO_ASEG IS

  FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
  FUNCTION EXISTE_CENSO_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
  PROCEDURE RECOTIZACION_CENSO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER);
  FUNCTION EDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN NUMBER;
  FUNCTION CANTIDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN NUMBER;
  PROCEDURE ACTUALIZAR_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER);
  FUNCTION TIENE_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN VARCHAR2;
  PROCEDURE COPIAR_CENSOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER);
  PROCEDURE ELIMINAR_CENSOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdetCotizacion NUMBER);
  PROCEDURE ACTUALIZA_CERTIFICADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                                  nIdPoliza NUMBER, nIDetPol NUMBER);

END GT_COTIZACIONES_CENSO_ASEG;
/

--
-- GT_COTIZACIONES_CENSO_ASEG  (Package Body) 
--
--  Dependencies: 
--   GT_COTIZACIONES_CENSO_ASEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_COTIZACIONES_CENSO_ASEG IS
FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
nIdAsegurado     COTIZACIONES_CENSO_ASEG.IdAsegurado%TYPE;
BEGIN
   SELECT NVL(MAX(IdAsegurado),0) + 1
     INTO nIdAsegurado
     FROM COTIZACIONES_CENSO_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdCotizacion  = nIdCotizacion;
    RETURN(nIdAsegurado);
END CORRELATIVO_ASEGURADO;

FUNCTION EXISTE_CENSO_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cExisteCenso      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteCenso
        FROM COTIZACIONES_CENSO_ASEG
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteCenso := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteCenso := 'S';
   END;
   RETURN(cExisteCenso);
END EXISTE_CENSO_COTIZACION;

PROCEDURE RECOTIZACION_CENSO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER) IS
CURSOR CENSO_Q IS
   SELECT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion,
          IdAsegurado, EdadAsegurados, CantAsegurados, 
          SalarioMensual, VecesSalario, SumaAsegLocalCenso,
          SumaAsegMonedaCenso, PrimaLocalCenso, PrimaMonedaCenso
     FROM COTIZACIONES_CENSO_ASEG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   FOR W IN CENSO_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_CENSO_ASEG
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado,
                 EdadAsegurados, CantAsegurados, SalarioMensual, VecesSalario, 
                 SumaAsegLocalCenso, SumaAsegMonedaCenso, PrimaLocalCenso, 
                 PrimaMonedaCenso)
         VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, W.IDetCotizacion, W.IdAsegurado,
                 W.EdadAsegurados, W.CantAsegurados, W.SalarioMensual, W.VecesSalario, 
                 W.SumaAsegLocalCenso, W.SumaAsegMonedaCenso, W.PrimaLocalCenso, 
                 W.PrimaMonedaCenso);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Censo de Cotización No. ' || nIdReCotizacion || ' en IdAsegurado No. ' || W.IdAsegurado);
      END;
   END LOOP;
   GT_COTIZACIONES_COBERT_ASEG.RECOTIZACION_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdRecotizacion);

END RECOTIZACION_CENSO;

FUNCTION EDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN NUMBER IS
nEdadAsegurados        COTIZACIONES_CENSO_ASEG.EdadAsegurados%TYPE;
BEGIN
   BEGIN
      SELECT NVL(EdadAsegurados,0)
        INTO nEdadAsegurados
        FROM COTIZACIONES_CENSO_ASEG
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion
         AND IdAsegurado    = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nEdadAsegurados := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Edades Limite de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(nEdadAsegurados);
END EDAD_ASEGURADOS;

FUNCTION CANTIDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIdAsegurado NUMBER) RETURN NUMBER IS
nCantAsegurados        COTIZACIONES_CENSO_ASEG.CantAsegurados%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CantAsegurados,0)
        INTO nCantAsegurados
        FROM COTIZACIONES_CENSO_ASEG
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdCotizacion   = nIdCotizacion
         AND IDetCotizacion = nIDetCotizacion
         AND IdAsegurado    = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCantAsegurados := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Buscar Cantidad de Asegurados de Cotización No. ' || nIdCotizacion || ' y Detalle No. ' || nIDetCotizacion);
   END;
   RETURN(nCantAsegurados);
END CANTIDAD_ASEGURADOS;

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

   UPDATE COTIZACIONES_CENSO_ASEG
      SET SumaAsegLocalCenso  = nSumaAsegCobLocal,
          SumaAsegMonedaCenso = nSumaAsegCobMoneda,
          PrimaLocalCenso     = nPrimaCobLocal,
          PrimaMonedaCenso    = nPrimaCobMoneda
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

PROCEDURE COPIAR_CENSOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, nIDetCotizacionDest NUMBER) IS
CURSOR CENSO_Q IS
   SELECT CodCia, CodEmpresa, IdAsegurado, EdadAsegurados, CantAsegurados, 
          SalarioMensual, VecesSalario, SumaAsegLocalCenso,
          SumaAsegMonedaCenso, PrimaLocalCenso, PrimaMonedaCenso
     FROM COTIZACIONES_CENSO_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
BEGIN
   FOR W IN CENSO_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES_CENSO_ASEG
                (CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado,
                 EdadAsegurados, CantAsegurados, SalarioMensual, VecesSalario, 
                 SumaAsegLocalCenso, SumaAsegMonedaCenso, PrimaLocalCenso, 
                 PrimaMonedaCenso)
         VALUES (nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionDest, W.IdAsegurado,
                 W.EdadAsegurados, W.CantAsegurados, W.SalarioMensual, W.VecesSalario, 
                 W.SumaAsegLocalCenso, W.SumaAsegMonedaCenso, W.PrimaLocalCenso, 
                 W.PrimaMonedaCenso);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicado Censo de Cotización No. ' || nIdCotizacion || 
                                    ' Detalle No. ' || nIDetCotizacionDest || ' en IdAsegurado No. ' || W.IdAsegurado);
      END;
   END LOOP;
END COPIAR_CENSOS;

PROCEDURE ELIMINAR_CENSOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdetCotizacion NUMBER) IS
BEGIN
   DELETE COTIZACIONES_COBERT_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

   DELETE COTIZACIONES_CENSO_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
END ELIMINAR_CENSOS;

PROCEDURE ACTUALIZA_CERTIFICADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                                nIdPoliza NUMBER, nIDetPol NUMBER) IS

cIndCambioSAMI   COBERT_ACT.IndCambioSAMI%TYPE;

CURSOR COTCEN_Q IS
   SELECT EdadAsegurados, CantAsegurados, SalarioMensual, VecesSalario,
          SumaAsegLocalCenso, SumaAsegMonedaCenso, PrimaLocalCenso, PrimaMonedaCenso
     FROM COTIZACIONES_CENSO_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
BEGIN
   FOR X IN COTCEN_Q LOOP
      BEGIN
	       UPDATE DETALLE_POLIZA
		        SET Suma_Aseg_Local  = X.SumaAsegLocalCenso,
                Suma_Aseg_Moneda = X.SumaAsegMonedaCenso,
                Prima_Local      = X.PrimaLocalCenso,
                Prima_Moneda     = X.PrimaMonedaCenso
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol;
      END;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Actualizar Censo '||SQLERRM);
END ACTUALIZA_CERTIFICADO;

END GT_COTIZACIONES_CENSO_ASEG;
/

--
-- GT_COTIZACIONES_CENSO_ASEG  (Synonym) 
--
--  Dependencies: 
--   GT_COTIZACIONES_CENSO_ASEG (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_COTIZACIONES_CENSO_ASEG FOR SICAS_OC.GT_COTIZACIONES_CENSO_ASEG
/


GRANT EXECUTE ON SICAS_OC.GT_COTIZACIONES_CENSO_ASEG TO PUBLIC
/

--
-- GT_DETALLE_POLIZA_COTIZ  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_POLIZA_COTIZ (Table)
--   COTIZACIONES_DETALLE (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_DETALLE_POLIZA_COTIZ IS

  PROCEDURE INSERTA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, 
                    nIDetCotizacion NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

END GT_DETALLE_POLIZA_COTIZ;
/

--
-- GT_DETALLE_POLIZA_COTIZ  (Package Body) 
--
--  Dependencies: 
--   GT_DETALLE_POLIZA_COTIZ (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_DETALLE_POLIZA_COTIZ IS

PROCEDURE INSERTA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, 
                  nIDetCotizacion NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
CURSOR COTIZ_Q IS
   SELECT CodSubgrupo, DescSubgrupo, EdadLimite, CantAsegurados, SalarioMensual, VecesSalario,
          PorcExtraPrimaDet, MontoExtraPrimaDet, PrimaAsegurado, SumaAsegurado, SumaAsegDetLocal,
          SumaAsegDetMoneda, PrimaDetLocal, PrimaDetMoneda, IndModifReglas, IndEdadPromedio,
          IndCuotaPromedio, IndPrimaPromedio
     FROM COTIZACIONES_DETALLE
    WHERE CodEmpresa     = nCodEmpresa
      AND CodCia         = nCodCia
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
BEGIN
   FOR X IN COTIZ_Q LOOP
      BEGIN
         INSERT INTO DETALLE_POLIZA_COTIZ
               (IdPoliza, IDetPol, CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, 
                CodSubgrupo, DescSubgrupo, EdadLimite, CantAsegurados, SalarioMensual, 
                VecesSalario, PorcExtraPrimaDet, MontoExtraPrimaDet, PrimaAsegurado, 
                SumaAsegurado, SumaAsegDetLocal, SumaAsegDetMoneda, PrimaDetLocal,
                PrimaDetMoneda, IndModifReglas, IndEdadPromedio, IndCuotaPromedio, IndPrimaPromedio)
         VALUES(nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion,
                X.CodSubgrupo, X.DescSubgrupo, X.EdadLimite, X.CantAsegurados, X.SalarioMensual, 
                X.VecesSalario, X.PorcExtraPrimaDet, X.MontoExtraPrimaDet, X.PrimaAsegurado, 
                X.SumaAsegurado, X.SumaAsegDetLocal, X.SumaAsegDetMoneda, X.PrimaDetLocal,
                X.PrimaDetMoneda, X.IndModifReglas, X.IndEdadPromedio, X.IndCuotaPromedio, X.IndPrimaPromedio);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error al Insertar el SubGrupo de la Cotizaci�n a Certificado de la P�liza');
      END;
   END LOOP;
END INSERTA;

END GT_DETALLE_POLIZA_COTIZ;
/

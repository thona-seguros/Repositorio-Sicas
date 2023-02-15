CREATE OR REPLACE PACKAGE GT_POLIZAS_TEXTO_COTIZACION IS

  PROCEDURE INSERTA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER);

END GT_POLIZAS_TEXTO_COTIZACION;
/

CREATE OR REPLACE PACKAGE BODY GT_POLIZAS_TEXTO_COTIZACION IS

PROCEDURE INSERTA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER) IS
CURSOR COTIZ_Q IS
   SELECT IdPoliza, CodEmpresa, CodCia, DescPoliticaSumasAseg, DescPoliticaEdades, DescTipoIdentAseg,
          DescGiroNegocio, AsegEnIncapacidad, TextoSuscriptor, DescActividadAseg, DescFormulaDividendos,
          DescCuotasPrimaNiv, DescElegibilidad, DescRiesgosCubiertos
     FROM COTIZACIONES
    WHERE CodEmpresa    = nCodEmpresa
      AND CodCia        = nCodCia
      AND IdCotizacion  = nIdCotizacion;
BEGIN
   FOR X IN COTIZ_Q LOOP
      IF X.IdPoliza IS NULL THEN
         BEGIN
            INSERT INTO POLIZAS_TEXTO_COTIZACION
                  (IdPoliza, CodEmpresa, CodCia, DescPoliticaSumasAseg, DescPoliticaEdades, DescTipoIdentAseg,
                   DescGiroNegocio, AsegEnIncapacidad, TextoSuscriptor, DescActividadAseg, DescFormulaDividendos,
                   DescCuotasPrimaNiv, DescElegibilidad, DescRiesgosCubiertos)
            VALUES(nIdPoliza, X.CodEmpresa, X.CodCia, X.DescPoliticaSumasAseg, X.DescPoliticaEdades, X.DescTipoIdentAseg,
                   X.DescGiroNegocio, X.AsegEnIncapacidad, X.TextoSuscriptor, X.DescActividadAseg, X.DescFormulaDividendos,
                   X.DescCuotasPrimaNiv, X.DescElegibilidad, X.DescRiesgosCubiertos);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20100,'Error al Insertar los Textos de la Cotización a Póliza');
         END;
      END IF;
   END LOOP;
END INSERTA;

END GT_POLIZAS_TEXTO_COTIZACION;

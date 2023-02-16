PROCEDURE avisa_cambio
       (pCcdCia      IN  cambios_polizas.codcia%TYPE      ,
        pIdPoliza    IN  cambios_polizas.idpoliza%TYPE    ,
        pIdSiniestro IN cambios_polizas.idsiniestro%TYPE  ,
        pcertificado IN cambios_polizas.certificado%TYPE  ,
        pAsegurado   IN cambios_polizas.asegurado%TYPE    ,
        pTipoCambio  IN cambios_polizas.tipo_cambio%TYPE  ,
        pOrigen      IN cambios_polizas.dsorigen%TYPE     ,
        pAntes       IN cambios_polizas.Dato_Original%TYPE,
        pDespues     IN cambios_polizas.Dato_Alterado%TYPE ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;

       yUser         VARCHAR2(50);
       yTerminal     VARCHAR2(50);
BEGIN
      SELECT user , userenv('TERMINAL')
        INTO yUser, yTerminal
        FROM dual ;

      INSERT INTO cambios_polizas (
              codcia        , idpoliza      , idsiniestro   , certificado   ,  asegurado     ,
              cduser        , cdterminal    , tipo_cambio   , dsorigen      ,
              dato_original , dato_alterado )
      VALUES
             ( pCcdCia      , pIdPoliza    , pIdSiniestro , pcertificado , pAsegurado   ,
               yUser        , yTerminal    , pTipoCambio  , pOrigen      ,
               pAntes       ,
               pDespues     ) ;
       COMMIT;
END;

--grant execute on avisa_cambio;

--Create public synonym avisa_cambio ON sicas_oc.avisa_cambio;
/*
  pcodcia        NUMBER(4)     , -- Datos de localizaciòn de los registros modificados.
  pidpoliza      NUMBER(18)    , -- Datos de localizaciòn de los registros modificados.
  pidsiniestro   NUMBER(18)    , -- Datos de localizaciòn de los registros modificados.
  pcertificado   NUMBER(18)    , -- Datos de localizaciòn de los registros modificados.
  pasegurado     NUMBER(18)    , -- Datos de localizaciòn de los registros modificados.
  pcduser        VARCHAR2(40)  , -- clave de usuario que realizò la modificaciòn
  pcdterminal    VARCHAR2(40)  , -- Terminal de donde se hizo la modificacion
  femodifi       DATE          , -- fecha en que se realzia la modificacion
  ptipo_cambio   VARCHAR2(30)  , -- cambio sumas aseguradas, nota de credito, facturas, cambio sa x siniestros
  pdsorigen      VARCHAR2(30)  , -- nombre de la forma, reporte, yava, proceso o equis que haga la modificacion
  pDato_Original VARCHAR2(3000), -- Estructura de datos original, antes del cambio
  pDato_Alterado VARCHAR2(3000)  -- Estructura una vez hecho el cambio.
)
*/

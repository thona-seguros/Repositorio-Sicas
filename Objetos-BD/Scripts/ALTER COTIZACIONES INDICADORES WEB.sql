ALTER TABLE COTIZACIONES ADD
(IndCotizacionWeb       VARCHAR2(1),
 IndCotizacionBaseWeb   VARCHAR2(1));
/
COMMENT ON COLUMN COTIZACIONES.IndCotizacionWeb IS 'Indica si la Cotizaci�n es para plataforma WEB';
/
COMMENT ON COLUMN COTIZACIONES.IndCotizacionBaseWeb IS 'Indica si la Cotizaci�n es Base/Plantilla para plataforma WEB';
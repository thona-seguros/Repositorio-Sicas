ALTER TABLE COTIZADOR_CONFIG ADD
(IndCotizadorWeb VARCHAR2(1));
/
COMMENT ON COLUMN COTIZADOR_CONFIG.IndCotizadorWeb IS 'Indica si el cotizador es para plataforma WEB';
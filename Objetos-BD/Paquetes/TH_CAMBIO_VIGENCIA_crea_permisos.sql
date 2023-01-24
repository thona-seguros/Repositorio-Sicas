-- CREA SINONIMOS Y GRANST PARA PAQUETES
-- =============================
-- Genera los permisos
-- =============================
grant EXECUTE on TH_CAMBIO_VIGENCIA to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM TH_CAMBIO_VIGENCIA FOR TH_CAMBIO_VIGENCIA
;

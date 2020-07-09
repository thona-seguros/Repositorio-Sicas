--
-- OC_CONFIG_COMISIONES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_COMISIONES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_COMISIONES IS

  FUNCTION porcentaje_comision(ncodcia NUMBER, ncodempresa NUMBER, cidtiposeg VARCHAR2) RETURN NUMBER;

END OC_config_comisiones;
/

--
-- OC_CONFIG_COMISIONES  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_COMISIONES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_COMISIONES IS

FUNCTION porcentaje_comision(ncodcia NUMBER, ncodempresa NUMBER, cidtiposeg VARCHAR2) RETURN NUMBER IS
nporccomis       CONFIG_COMISIONES.porccomision%TYPE;
BEGIN
   BEGIN
      SELECT porccomision
        INTO nporccomis
        FROM CONFIG_COMISIONES
       WHERE codempresa = ncodempresa
         AND idtiposeg  = cidtiposeg
         AND codcia     = ncodcia; 
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20225,'NO Tiene Configuradas las Comisiones para la Compa?ia '||TO_CHAR(ncodcia)||
                                 ' la Empresa '||TO_CHAR(ncodempresa)|| ' y el Tipo de Seguro '||cidtiposeg);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Configuracion de Comisiones para la Compa?ia '||TO_CHAR(ncodcia)||
                                 ' la Empresa '||TO_CHAR(ncodempresa)|| ' y el Tipo de Seguro '||cidtiposeg);
   END;
   RETURN(nporccomis);
END porcentaje_comision;

END OC_config_comisiones;
/

--
-- OC_CONFIG_COMISIONES  (Synonym) 
--
--  Dependencies: 
--   OC_CONFIG_COMISIONES (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONFIG_COMISIONES FOR SICAS_OC.OC_CONFIG_COMISIONES
/


GRANT EXECUTE ON SICAS_OC.OC_CONFIG_COMISIONES TO PUBLIC
/

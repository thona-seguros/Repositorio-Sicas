--
-- OC_CONFIG_RESERVAS_CONTAB  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_RESERVAS_CONTAB (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_RESERVAS_CONTAB IS
  PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2);
END OC_CONFIG_RESERVAS_CONTAB;
/

--
-- OC_CONFIG_RESERVAS_CONTAB  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_CONTAB (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_RESERVAS_CONTAB IS

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO CONFIG_RESERVAS_CONTAB
                 (CodCia, CodReserva, CodCptoResrva, TipoContab, 
                                           CodCptoRva, TipoPlazo, ValuacionPlazo, ValCortoPlazo)
           SELECT CodCia, cCodReservaDest, CodCptoResRva, TipoContab, 
                                 CodCptoRva, TipoPlazo, ValuacionPlazo, ValCortoPlazo
             FROM CONFIG_RESERVAS_CONTAB
            WHERE CodCia     = nCodCia
                                  AND CodReserva = cCodReservaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia CONFIG_RESERVAS_CONTAB '|| SQLERRM );
   END;
END COPIAR;

END OC_CONFIG_RESERVAS_CONTAB;
/

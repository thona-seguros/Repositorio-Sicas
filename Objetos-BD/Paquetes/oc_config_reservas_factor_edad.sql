--
-- OC_CONFIG_RESERVAS_FACTOR_EDAD  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_RESERVAS_FACTOR_EDAD (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_RESERVAS_FACTOR_EDAD IS
   PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2);
   FUNCTION FACTOR(nCodCia NUMBER, cCodReserva VARCHAR2, nEdad NUMBER, cTipoFactor VARCHAR2 ) RETURN NUMBER;
   PROCEDURE ELIMINAR (nCodCia NUMBER, cCodReserva VARCHAR2);
END OC_CONFIG_RESERVAS_FACTOR_EDAD; -- Package spec
/

--
-- OC_CONFIG_RESERVAS_FACTOR_EDAD  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_FACTOR_EDAD (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_RESERVAS_FACTOR_EDAD IS

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2) IS
BEGIN
   INSERT INTO CONFIG_RESERVAS_FACTOR_EDAD
         (CodCia, CodReserva, Edad, FactorBasica, FactorAdic)
   SELECT nCodCia, cCodReservaDest, Edad, FactorBasica, FactorAdic
     FROM CONFIG_RESERVAS_FACTOR_EDAD
    WHERE CodCia     = nCodCia
           AND CodReserva = cCodReservaOrig;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia CONFIG_RESERVAS_FACTOR_EDAD, '|| SQLERRM );
END COPIAR;

FUNCTION FACTOR(nCodCia NUMBER, cCodReserva VARCHAR2, nEdad NUMBER, cTipoFactor VARCHAR2) RETURN NUMBER IS
nFactorBasica     CONFIG_RESERVAS_FACTOR_EDAD.FactorBasica%TYPE;
nFactorAdic       CONFIG_RESERVAS_FACTOR_EDAD.FactorAdic%TYPE;
BEGIN
   SELECT ROUND(FactorBasica,3) FactorBasica, ROUND(FactorAdic,3) FactorAdic
     INTO nFactorBasica, nFactorAdic
     FROM CONFIG_RESERVAS_FACTOR_EDAD
    WHERE CodCia     = nCodCia
           AND CodReserva = cCodReserva
      AND Edad       = nEdad;

   IF cTipoFactor = 'BA' THEN
      RETURN(nFactorBasica);
   ELSIF cTipoFactor = 'AD' THEN
      RETURN(nFactorAdic);
   ELSE
      RETURN(0);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
END FACTOR;
   
PROCEDURE ELIMINAR (nCodCia NUMBER, cCodReserva VARCHAR2) IS
BEGIN
   BEGIN
      DELETE CONFIG_RESERVAS_FACTOR_EDAD
       WHERE CodCia     = nCodCia
              AND CodReserva = cCodReserva;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar Eliminar CONFIG_RESERVAS_FACTOR_EDAD '|| SQLERRM );
   END;
END ELIMINAR;

END OC_CONFIG_RESERVAS_FACTOR_EDAD;
/

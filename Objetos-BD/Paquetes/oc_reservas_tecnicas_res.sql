--
-- OC_RESERVAS_TECNICAS_RES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   RESERVAS_TECNICAS_RES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_RESERVAS_TECNICAS_RES AS
   PROCEDURE INSERTA_RESUMEN(nIdReserva NUMBER, cCodCptoRva VARCHAR2, cIndCobBase VARCHAR2, nMontoRva NUMBER);
   FUNCTION MONTO_RESUMEN(nIdReserva NUMBER, cCodCptoRva VARCHAR2) RETURN NUMBER;
   FUNCTION MONTO_BASICA_ADICIONAL(nIdReserva NUMBER, cCodCptoRva VARCHAR2, cTipoCob VARCHAR2) RETURN NUMBER;
END OC_RESERVAS_TECNICAS_RES;
/

--
-- OC_RESERVAS_TECNICAS_RES  (Package Body) 
--
--  Dependencies: 
--   OC_RESERVAS_TECNICAS_RES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_RESERVAS_TECNICAS_RES AS

PROCEDURE INSERTA_RESUMEN(nIdReserva NUMBER, cCodCptoRva VARCHAR2, cIndCobBase VARCHAR2, nMontoRva NUMBER) IS
nIdResumen    RESERVAS_TECNICAS_RES.IdResumen%TYPE;
BEGIN
   IF cIndCobBase = 'S' THEN
      SELECT NVL(MAX(IdResumen),0)+1
        INTO nIdResumen
        FROM RESERVAS_TECNICAS_RES
       WHERE IdReserva = nIdReserva;
      BEGIN
         INSERT INTO RESERVAS_TECNICAS_RES
               (IdReserva, IdResumen, CodCptoRva, MtoCobBasica, MtoCobAdicionales, MtoTotalCob)
         VALUES(nIdReserva, nIdResumen, cCodCptoRva, nMontoRva, 0, 0);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20220,'Error en Insertar Resumen de Reservas '|| SQLERRM );
      END;
   ELSE
      UPDATE RESERVAS_TECNICAS_RES
         SET MtoCobAdicionales = NVL(nMontoRva,0),
             MtoTotalCob       = NVL(MtoCobBasica,0) + NVL(nMontoRva,0)
       WHERE IdReserva = nIdReserva
         AND IdResumen = (SELECT MAX(IdResumen)
                            FROM RESERVAS_TECNICAS_RES
                           WHERE IdReserva  = nIdReserva
                             AND CodCptoRva = cCodCptoRva);
   END IF;
END INSERTA_RESUMEN;

FUNCTION MONTO_RESUMEN(nIdReserva NUMBER, cCodCptoRva VARCHAR2) RETURN NUMBER IS
nMonto    RESERVAS_TECNICAS_RES.MtoTotalCob%TYPE;
BEGIN
   SELECT NVL(MtoTotalCob,0)
     INTO nMonto
     FROM RESERVAS_TECNICAS_RES
    WHERE IdReserva  = nIdReserva
      AND CodCptoRva = cCodCptoRva;
   RETURN(nMonto);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
END MONTO_RESUMEN;

FUNCTION MONTO_BASICA_ADICIONAL(nIdReserva NUMBER, cCodCptoRva VARCHAR2, cTipoCob VARCHAR2) RETURN NUMBER IS
nMontoBasica     RESERVAS_TECNICAS_RES.MtoCobBasica%TYPE;
nMontoAdicional  RESERVAS_TECNICAS_RES.MtoCobAdicionales%TYPE;
BEGIN
   SELECT NVL(MtoCobBasica,0), NVL(MtoCobAdicionales,0)
     INTO nMontoBasica, nMontoAdicional
     FROM RESERVAS_TECNICAS_RES
    WHERE IdReserva  = nIdReserva
      AND CodCptoRva = cCodCptoRva;
   IF cTipoCob = 'BA' THEN
      RETURN(nMontoBasica);
   ELSIF cTipoCob = 'AD' THEN
      RETURN(nMontoAdicional);
   ELSE
      RETURN(0);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
END MONTO_BASICA_ADICIONAL;

END OC_RESERVAS_TECNICAS_RES;
/

--
-- OC_RESERVAS_TECNICAS_RES  (Synonym) 
--
--  Dependencies: 
--   OC_RESERVAS_TECNICAS_RES (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_RESERVAS_TECNICAS_RES FOR SICAS_OC.OC_RESERVAS_TECNICAS_RES
/


GRANT EXECUTE ON SICAS_OC.OC_RESERVAS_TECNICAS_RES TO PUBLIC
/

--
-- OC_POLIZA_PRORROGAS_CANCEL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   POLIZA_PRORROGAS_CANCEL (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_POLIZA_PRORROGAS_CANCEL IS

  FUNCTION PRORROGA_NO_CANCELACION(nCodCia NUMBER, nIdPoliza NUMBER, dFecValuacion DATE) RETURN VARCHAR2;
  FUNCTION FIN_PRORROGA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN DATE;

END OC_POLIZA_PRORROGAS_CANCEL;
/

--
-- OC_POLIZA_PRORROGAS_CANCEL  (Package Body) 
--
--  Dependencies: 
--   OC_POLIZA_PRORROGAS_CANCEL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_POLIZA_PRORROGAS_CANCEL IS

FUNCTION PRORROGA_NO_CANCELACION(nCodCia NUMBER, nIdPoliza NUMBER, dFecValuacion DATE) RETURN VARCHAR2 IS
cTienProrroga    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cTienProrroga
        FROM POLIZA_PRORROGAS_CANCEL
       WHERE IdPoliza        = nIdPoliza
         AND CodCia          = nCodCia
         AND FecFinProrroga >= dFecValuacion
         AND IdProrroga      IN (SELECT MAX(IdProrroga)
                                   FROM POLIZA_PRORROGAS_CANCEL
                                  WHERE IdPoliza        = nIdPoliza
                                    AND CodCia          = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTienProrroga := 'N';
      WHEN TOO_MANY_ROWS THEN
         cTienProrroga := 'S';
   END;
   RETURN(cTienProrroga);
END PRORROGA_NO_CANCELACION;

FUNCTION FIN_PRORROGA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN DATE IS
dFecFinProrroga    POLIZA_PRORROGAS_CANCEL.FecFinProrroga%TYPE;
BEGIN
   BEGIN
      SELECT MAX(FecFinProrroga)
        INTO dFecFinProrroga
        FROM POLIZA_PRORROGAS_CANCEL
       WHERE IdPoliza        = nIdPoliza
         AND CodCia          = nCodCia
         AND IdProrroga     IN (SELECT MAX(IdProrroga)
                                  FROM POLIZA_PRORROGAS_CANCEL
                                 WHERE IdPoliza        = nIdPoliza
                                   AND CodCia          = nCodCia);
   END;
   RETURN(dFecFinProrroga);
END FIN_PRORROGA;

END OC_POLIZA_PRORROGAS_CANCEL;
/

--
-- OC_POLIZA_PRORROGAS_CANCEL  (Synonym) 
--
--  Dependencies: 
--   OC_POLIZA_PRORROGAS_CANCEL (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_POLIZA_PRORROGAS_CANCEL FOR SICAS_OC.OC_POLIZA_PRORROGAS_CANCEL
/


GRANT EXECUTE ON SICAS_OC.OC_POLIZA_PRORROGAS_CANCEL TO PUBLIC
/
